module get_mem
(
  // -- ADD USER PORTS BELOW THIS LINE ---------------
  // --USER ports added here 
  addr,
  length,
  trig,
  complete,
  data,
  data_trig,
  read_count,
  // -- ADD USER PORTS ABOVE THIS LINE ---------------

  // -- DO NOT EDIT BELOW THIS LINE ------------------
  // -- Bus protocol ports, do not add to or delete 
  Bus2IP_Clk,                     // Bus to IP clock
  Bus2IP_Resetn,                  // Bus to IP reset
  ip2bus_mstrd_req,               // IP to Bus master read request
  ip2bus_mstwr_req,               // IP to Bus master write request
  ip2bus_mst_addr,                // IP to Bus master read/write address
  ip2bus_mst_be,                  // IP to Bus byte enable
  ip2bus_mst_length,              // Ip to Bus master transfer length
  ip2bus_mst_type,                // Ip to Bus burst assertion control
  bus2ip_mst_cmdack,              // Bus to Ip master command ack
  bus2ip_mst_cmplt,               // Bus to Ip master trans complete
  bus2ip_mstrd_d,                 // Bus to Ip master read data
  bus2ip_mstrd_sof_n,             // Bus to Ip master read start of frame
  bus2ip_mstrd_eof_n,             // Bus to Ip master read end of frame
  bus2ip_mstrd_src_rdy_n,         // Bus to Ip master read source ready
  bus2ip_mstrd_src_dsc_n,         // Bus to Ip master read source dsc
  ip2bus_mstrd_dst_rdy_n,         // Ip to Bus master read dest. ready
  ip2bus_mstrd_dst_dsc_n,         // Ip to Bus master read dest. dsc
  ip2bus_mstwr_d,                 // Ip to Bus master write data
  ip2bus_mstwr_rem,               // Ip to Bus master write data rem
  ip2bus_mstwr_src_rdy_n,         // Ip to Bus master write source ready
  ip2bus_mstwr_src_dsc_n,         // Ip to Bus master write source dsc
  ip2bus_mstwr_sof_n,             // Ip to Bus master write start of frame
  ip2bus_mstwr_eof_n,             // Ip to Bus master write end of frame
  bus2ip_mstwr_dst_rdy_n         // Bus to Ip master write dest. ready
  // -- DO NOT EDIT ABOVE THIS LINE ------------------
); // user_logic

// -- ADD USER PARAMETERS BELOW THIS LINE ------------
// --USER parameters added here 
parameter [2 : 0]
          IDLE                           = 3'd0,
          WAIT_READ                      = 3'd1,
          READ                           = 3'd2;

parameter BURST_BYTE                     = 4096;
// -- ADD USER PARAMETERS ABOVE THIS LINE ------------

// -- DO NOT EDIT BELOW THIS LINE --------------------
// -- Bus protocol parameters, do not add to or delete
parameter C_MST_NATIVE_DATA_WIDTH        = 32;
parameter C_LENGTH_WIDTH                 = 12;
parameter C_MST_AWIDTH                   = 32;
parameter C_SLV_DWIDTH                   = 32;
// -- DO NOT EDIT ABOVE THIS LINE --------------------

// -- ADD USER PORTS BELOW THIS LINE -----------------
// --USER ports added here 
input      [C_MST_AWIDTH-1 : 0]           addr;
input      [C_LENGTH_WIDTH-1:0]           length;
input                                     trig;
output                                    complete;
output     [C_MST_NATIVE_DATA_WIDTH-1 : 0]data;
output                                    data_trig;
output reg [C_LENGTH_WIDTH-1 : 0]         read_count;
// -- ADD USER PORTS ABOVE THIS LINE -----------------

// -- DO NOT EDIT BELOW THIS LINE --------------------
// -- Bus protocol ports, do not add to or delete
input                                     Bus2IP_Clk;
input                                     Bus2IP_Resetn;
output                                    ip2bus_mstrd_req;
output                                    ip2bus_mstwr_req;
output     [C_MST_AWIDTH-1 : 0]           ip2bus_mst_addr;
output     [(C_MST_NATIVE_DATA_WIDTH/8)-1 : 0] ip2bus_mst_be;
output     [C_LENGTH_WIDTH-1 : 0]         ip2bus_mst_length;
output                                    ip2bus_mst_type;
input                                     bus2ip_mst_cmdack;
input                                     bus2ip_mst_cmplt;
input      [C_MST_NATIVE_DATA_WIDTH-1 : 0] bus2ip_mstrd_d;
input                                     bus2ip_mstrd_sof_n;
input                                     bus2ip_mstrd_eof_n;
input                                     bus2ip_mstrd_src_rdy_n;
input                                     bus2ip_mstrd_src_dsc_n;
output                                    ip2bus_mstrd_dst_rdy_n;
output                                    ip2bus_mstrd_dst_dsc_n;
output     [C_MST_NATIVE_DATA_WIDTH-1 : 0] ip2bus_mstwr_d;
output     [(C_MST_NATIVE_DATA_WIDTH)/8-1 : 0] ip2bus_mstwr_rem;
output                                    ip2bus_mstwr_src_rdy_n;
output                                    ip2bus_mstwr_src_dsc_n;
output                                    ip2bus_mstwr_sof_n;
output                                    ip2bus_mstwr_eof_n;
input                                     bus2ip_mstwr_dst_rdy_n;
// -- DO NOT EDIT ABOVE THIS LINE --------------------

//----------------------------------------------------------------------------
// Implementation
//----------------------------------------------------------------------------

  // --USER nets declarations added here, as needed for user logic
  reg        [2 : 0]                        state, next_state;
  reg        [C_LENGTH_WIDTH-1:0]           remaining_len;
  reg        [C_MST_AWIDTH-1 : 0]           addr_offset;
  
  wire                                       Bus2IP_Clk;
  wire                                       Bus2IP_Resetn;
  wire                                       ip2bus_mstrd_req;
  wire                                       ip2bus_mstwr_req;
  wire     [C_MST_AWIDTH-1 : 0]              ip2bus_mst_addr;
  wire     [(C_MST_NATIVE_DATA_WIDTH/8)-1:0] ip2bus_mst_be;
  wire     [C_LENGTH_WIDTH-1 : 0]        ip2bus_mst_length;
  wire                                       ip2bus_mst_type;
  wire                                       bus2ip_mst_cmdack;
  wire                                       bus2ip_mst_cmplt;
  wire     [C_MST_NATIVE_DATA_WIDTH-1 : 0]   bus2ip_mstrd_d;
  wire                                       bus2ip_mstrd_sof_n;
  wire                                       bus2ip_mstrd_eof_n;
  wire                                       bus2ip_mstrd_src_rdy_n;
  wire                                       bus2ip_mstrd_src_dsc_n;
  wire                                       ip2bus_mstrd_dst_rdy_n;
  wire                                       ip2bus_mstrd_dst_dsc_n;
  wire     [C_MST_NATIVE_DATA_WIDTH-1 : 0]   ip2bus_mstwr_d;
  wire     [(C_MST_NATIVE_DATA_WIDTH/8)-1:0] ip2bus_mstwr_rem;
  wire                                       ip2bus_mstwr_src_rdy_n;
  wire                                       ip2bus_mstwr_src_dsc_n;
  wire                                       ip2bus_mstwr_sof_n;
  wire                                       ip2bus_mstwr_eof_n;
  wire                                       bus2ip_mstwr_dst_rdy_n;

// signals for master model command interface state machine
  reg                                        mst_cmd_sm_rd_req;
  reg        [C_LENGTH_WIDTH-1 : 0]          mst_cmd_length;

// --USER logic implementation added here
// user logic master command interface assignments
  assign ip2bus_mstrd_req  = mst_cmd_sm_rd_req;
  assign ip2bus_mstwr_req  = 0;
  assign ip2bus_mst_addr   = addr + addr_offset;
  assign ip2bus_mst_be     = 4'b1111;  // don't care
  assign ip2bus_mst_type   = mst_cmd_sm_rd_req;     // set to burst transfer
  assign ip2bus_mstrd_dst_dsc_n = 1;
  assign ip2bus_mst_length = mst_cmd_length;

  assign ip2bus_mstwr_sof_n = 1;
  assign ip2bus_mstwr_eof_n = 1;
  assign ip2bus_mstwr_src_rdy_n = 1;
  assign ip2bus_mstwr_src_dsc_n = 1'b1;
  assign ip2bus_mstwr_rem = 0;

  //----------------------------------------------------------------------------
  // The main FSM of memcpy
  //----------------------------------------------------------------------------
  always@(posedge Bus2IP_Clk)
    begin
      if (Bus2IP_Resetn == 1'b0)
        state <= IDLE;
      else
        state <= next_state;
    end

	always@(*)
		begin
			case(state)
				IDLE: 
					begin
						if (trig)
							next_state = WAIT_READ;
						else
							next_state = IDLE;
					end
				WAIT_READ:
					begin
						if (bus2ip_mst_cmdack)
							next_state = READ;
						else
							next_state = WAIT_READ;
					end
				READ:
					begin
						if (!bus2ip_mst_cmplt)
							next_state = READ;
						else if (remaining_len > 0)
							next_state = WAIT_READ;
						else
							next_state = IDLE;
					end
				default:
					begin
						next_state = IDLE;
					end
			endcase
		end
  
  //----------------------------------------------------------------------------
  // The interface of this module
  //----------------------------------------------------------------------------
  assign data = bus2ip_mstrd_d;
  assign data_trig = (state == READ && bus2ip_mstrd_src_rdy_n == 1'b0) ? 1'b1 : 0;
  assign complete = (state == IDLE ? 1'b1 : 0);

  always@(posedge Bus2IP_Clk)
    begin
      if (state == IDLE)
        addr_offset <= 0;
      else if (state == READ && bus2ip_mst_cmplt == 1)
        addr_offset <= addr_offset + BURST_BYTE;
      else
        addr_offset <= addr_offset;
    end

  //----------------------------------------------------------------------------
  // remaining_len control - each transfer reduces the counter by 4 bytes
  // read/write length
  //----------------------------------------------------------------------------
  always@(posedge Bus2IP_Clk)
    begin
      if (state == IDLE)
	      if (length > BURST_BYTE)
		      remaining_len <= length - BURST_BYTE; // copy transfer length (in bytes)
        else
		      remaining_len <= 0;
      else if (state == READ && bus2ip_mst_cmplt == 1)
	      if (remaining_len > BURST_BYTE)
          remaining_len <= remaining_len - BURST_BYTE;
        else
		      remaining_len <= 0;
      else
        remaining_len <= remaining_len;
    end
  
  always@(posedge Bus2IP_Clk)
    begin
	    if (state == IDLE)
        if (length <= BURST_BYTE)
          mst_cmd_length <= length;
        else
          mst_cmd_length <= BURST_BYTE;
      else if (state == READ && bus2ip_mst_cmplt == 1)
        if (remaining_len <= BURST_BYTE)
          mst_cmd_length <= remaining_len;
        else
          mst_cmd_length <= BURST_BYTE;
      else
          mst_cmd_length <= mst_cmd_length;
	 end

  // ***************************************************************************
  // read word begin
  // ***************************************************************************
  //----------------------------------------------------------------------------
  // mst_cmd_sm_rd_req control - drop request as soon as one bus access is granted
  //----------------------------------------------------------------------------
  always@(posedge Bus2IP_Clk)
    begin
      if (Bus2IP_Resetn == 1'b0 || next_state == READ)
        mst_cmd_sm_rd_req <= 0;
	    else if (state == WAIT_READ)
        mst_cmd_sm_rd_req <= 1;
			else
				mst_cmd_sm_rd_req <= mst_cmd_sm_rd_req;
    end
	 
  //----------------------------------------------------------------------------
  // mstrd_dst_rdy_n control
  //----------------------------------------------------------------------------
  assign ip2bus_mstrd_dst_rdy_n = (state == WAIT_READ || state == READ) ? 1'b0 : 1'b1;

  // ***************************************************************************
  // read single-word end
  // ***************************************************************************

  //----------------------------------------------------------------------------
  // read_count control
  //----------------------------------------------------------------------------
  always@(posedge Bus2IP_Clk)
    begin
	    if (data_trig)
        read_count <= read_count + 1;
      else if(state == WAIT_READ)
        read_count <= 0;
      else
        read_count <= read_count;
    end

endmodule
