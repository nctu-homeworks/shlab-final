`uselib lib=unisims_ver
`uselib lib=proc_common_v3_00_a
`include "get_mem.v"
`include "face.v"

module user_logic
(
  // -- ADD USER PORTS BELOW THIS LINE ---------------
  // --USER ports added here 
	dbg_trig,
	dbg_data,
  // -- ADD USER PORTS ABOVE THIS LINE ---------------

  // -- DO NOT EDIT BELOW THIS LINE ------------------
  // -- Bus protocol ports, do not add to or delete 
  Bus2IP_Clk,                     // Bus to IP clock
  Bus2IP_Resetn,                  // Bus to IP reset
  Bus2IP_Data,                    // Bus to IP data bus
  Bus2IP_BE,                      // Bus to IP byte enables
  Bus2IP_RdCE,                    // Bus to IP read chip enable
  Bus2IP_WrCE,                    // Bus to IP write chip enable
  IP2Bus_Data,                    // IP to Bus data bus
  IP2Bus_RdAck,                   // IP to Bus read transfer acknowledgement
  IP2Bus_WrAck,                   // IP to Bus write transfer acknowledgement
  IP2Bus_Error,                   // IP to Bus error response
  ip2bus_mstrd_req,               // IP to Bus master read request
  ip2bus_mstwr_req,               // IP to Bus master write request
  ip2bus_mst_addr,                // IP to Bus master read/write address
  ip2bus_mst_be,                  // IP to Bus byte enable
  ip2bus_mst_length,              // Ip to Bus master transfer length
  ip2bus_mst_type,                // Ip to Bus burst assertion control
  ip2bus_mst_lock,                // Ip to Bus bus lock
  ip2bus_mst_reset,               // Ip to Bus master reset
  bus2ip_mst_cmdack,              // Bus to Ip master command ack
  bus2ip_mst_cmplt,               // Bus to Ip master trans complete
  bus2ip_mst_error,               // Bus to Ip master error
  bus2ip_mst_rearbitrate,         // Bus to Ip master re-arbitrate for bus ownership
  bus2ip_mst_cmd_timeout,         // Bus to Ip master command time out
  bus2ip_mstrd_d,                 // Bus to Ip master read data
  bus2ip_mstrd_rem,               // Bus to Ip master read data rem
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
  bus2ip_mstwr_dst_rdy_n,         // Bus to Ip master write dest. ready
  bus2ip_mstwr_dst_dsc_n          // Bus to Ip master write dest. ready
  // -- DO NOT EDIT ABOVE THIS LINE ------------------
); // user_logic

// -- ADD USER PARAMETERS BELOW THIS LINE ------------
// --USER parameters added here 
parameter  IDLE = 4'd0;
parameter  LOAD_FACE1 = 4'd1;
parameter  LOAD_FACE2 = 4'd2;
parameter  LOAD_FACE3 = 4'd3;
parameter  LOAD_FACE4 = 4'd4;
parameter  LOAD_GROUP = 4'd5;
parameter  MATCHING_COMPUTE = 4'd6;
parameter  MATCHING_LOAD = 4'd7;

parameter  FACE_SIZE = 1024;
parameter  GROUP_WIDTH = 1920;
parameter  GROUP_HEIGHT = 1080;
// -- ADD USER PARAMETERS ABOVE THIS LINE ------------

// -- DO NOT EDIT BELOW THIS LINE --------------------
// -- Bus protocol parameters, do not add to or delete
parameter C_MST_NATIVE_DATA_WIDTH        = 32;
parameter C_LENGTH_WIDTH                 = 12;
parameter C_MST_AWIDTH                   = 32;
parameter C_NUM_REG                      = 32;
parameter C_SLV_DWIDTH                   = 32;
// -- DO NOT EDIT ABOVE THIS LINE --------------------

// -- ADD USER PORTS BELOW THIS LINE -----------------
// --USER ports added here 
output     [7 : 0]                        dbg_trig;
output     [31: 0]                        dbg_data;
// -- ADD USER PORTS ABOVE THIS LINE -----------------

// -- DO NOT EDIT BELOW THIS LINE --------------------
// -- Bus protocol ports, do not add to or delete
input                                     Bus2IP_Clk;
input                                     Bus2IP_Resetn;
input      [C_SLV_DWIDTH-1 : 0]           Bus2IP_Data;
input      [C_SLV_DWIDTH/8-1 : 0]         Bus2IP_BE;
input      [C_NUM_REG-1 : 0]              Bus2IP_RdCE;
input      [C_NUM_REG-1 : 0]              Bus2IP_WrCE;
output     [C_SLV_DWIDTH-1 : 0]           IP2Bus_Data;
output                                    IP2Bus_RdAck;
output                                    IP2Bus_WrAck;
output                                    IP2Bus_Error;
output                                    ip2bus_mstrd_req;
output                                    ip2bus_mstwr_req;
output     [C_MST_AWIDTH-1 : 0]           ip2bus_mst_addr;
output     [(C_MST_NATIVE_DATA_WIDTH/8)-1 : 0] ip2bus_mst_be;
output     [C_LENGTH_WIDTH-1 : 0]         ip2bus_mst_length;
output                                    ip2bus_mst_type;
output                                    ip2bus_mst_lock;
output                                    ip2bus_mst_reset;
input                                     bus2ip_mst_cmdack;
input                                     bus2ip_mst_cmplt;
input                                     bus2ip_mst_error;
input                                     bus2ip_mst_rearbitrate;
input                                     bus2ip_mst_cmd_timeout;
input      [C_MST_NATIVE_DATA_WIDTH-1 : 0] bus2ip_mstrd_d;
input      [(C_MST_NATIVE_DATA_WIDTH)/8-1 : 0] bus2ip_mstrd_rem;
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
input                                     bus2ip_mstwr_dst_dsc_n;
// -- DO NOT EDIT ABOVE THIS LINE --------------------

//----------------------------------------------------------------------------
// Implementation
//----------------------------------------------------------------------------

  // --USER nets declarations added here, as needed for user logic

  // Nets for user logic slave model s/w accessible register example
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg0;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg1;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg2;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg3;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg4;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg5;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg6;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg7;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg8;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg9;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg10;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg11;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg12;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg13;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg14;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg15;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg16;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg17;
  /*
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg18;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg19;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg20;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg21;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg22;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg23;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg24;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg25;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg26;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg27;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg28;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg29;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg30;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg31;
  */
  wire       [31 : 0]                       slv_reg_write_sel;
  wire       [31 : 0]                       slv_reg_read_sel;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_ip2bus_data;
  wire                                      slv_read_ack;
  wire                                      slv_write_ack;
  integer                                   byte_index, bit_index;


  wire                                       Bus2IP_Clk;
  wire                                       Bus2IP_Resetn;
  wire      [C_SLV_DWIDTH-1 : 0]             Bus2IP_Data;
  wire      [C_SLV_DWIDTH/8-1 : 0]           Bus2IP_BE;
  wire      [C_NUM_REG-1 : 0]                Bus2IP_RdCE;
  wire      [C_NUM_REG-1 : 0]                Bus2IP_WrCE;
  wire      [C_SLV_DWIDTH-1 : 0]             IP2Bus_Data;
  wire                                       IP2Bus_RdAck;
  wire                                       IP2Bus_WrAck;
  wire                                       IP2Bus_Error;
  wire                                       ip2bus_mstrd_req;
  wire                                       ip2bus_mstwr_req;
  wire     [C_MST_AWIDTH-1 : 0]              ip2bus_mst_addr;
  wire     [(C_MST_NATIVE_DATA_WIDTH/8)-1:0] ip2bus_mst_be;
  wire     [C_LENGTH_WIDTH-1 : 0]        ip2bus_mst_length;
  wire                                       ip2bus_mst_type;
  wire                                       ip2bus_mst_lock;
  wire                                       ip2bus_mst_reset;
  wire                                       bus2ip_mst_cmdack;
  wire                                       bus2ip_mst_cmplt;
  wire                                       bus2ip_mst_error;
  wire                                       bus2ip_mst_rearbitrate;
  wire                                       bus2ip_mst_cmd_timeout;
  wire     [C_MST_NATIVE_DATA_WIDTH-1 : 0]   bus2ip_mstrd_d;
  wire     [(C_MST_NATIVE_DATA_WIDTH/8)-1:0] bus2ip_mstrd_rem; 
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
  wire                                       bus2ip_mstwr_dst_dsc_n;

// signals for master model control/status registers write/read
  reg      [C_SLV_DWIDTH-1 : 0]              mst_ip2bus_data;
  wire                                       mst_write_ack;
  wire                                       mst_read_ack;

// --USER logic implementation added here
// user logic master command interface assignments
  wire     [7  : 0]                          dbg_trig;
	wire     [31 : 0]                          dbg_data;

  reg      [31 : 0]                          face1[255 : 0];
	/*
  reg      [31 : 0]                          face2[255 : 0];
  reg      [31 : 0]                          face3[255 : 0];
  reg      [31 : 0]                          face4[255 : 0];
	*/
  reg      [31 : 0]                          group[255 : 0];
  wire     [32*32*8-1 : 0]                   g_pixel, f_pixel;
  wire     [11 : 0]                          mem_count;
  wire     [31 : 0]                          mem_data;
  reg      [31 : 0]                          mem_addr;
  reg      [11 : 0]                          mem_length;
  reg                                        mem_trig;
  wire                                       mem_data_trig, mem_complete;
  reg      [31 : 0]                          min_x1; //, min_x2, min_x3, min_x4;
  reg      [31 : 0]                          min_y1; //, min_y2, min_y3, min_y4;
  reg      [31 : 0]                          min_sad1; //, min_sad2, min_sad3, min_sad4;
  wire     [31 : 0]                          sad;
  wire                                       clear;
  
  reg      [3  : 0]                          state, next_state;
  reg      [12 : 0]                          group_row, group_col, group_row_count;
  reg      [3  : 0]                          count_tick;

	assign dbg_trig = {7'b0000000, slv_reg0[0]};
	assign dbg_data = {group_col[11:0], group_row_count[11:0], mem_complete, mem_data_trig, mem_trig, state[2:0], slv_reg0[0], Bus2IP_Clk};
  
  get_mem getmem(mem_addr, mem_length, mem_trig, mem_complete, mem_data, mem_data_trig, mem_count,
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
  );
  face ff(
    Bus2IP_Clk,
    f_pixel, g_pixel,
    sad
  );
  
  // Remember min_sad
  always @(posedge Bus2IP_Clk)
    begin
      if (!Bus2IP_Resetn || clear)
        begin
          min_sad1 <= 999999;
          min_x1 <= 0;
          min_y1 <= 0;
        end
      else if (count_tick == 8 && sad < min_sad1)
        begin
          min_sad1 <= sad;
          min_x1 <= group_col;
          min_y1 <= group_row;
        end
      else
        begin
          min_sad1 <= min_sad1;
          min_x1 <= min_x1;
          min_y1 <= min_y1;
        end
    end
    
	/*
  always @(posedge Bus2IP_Clk)
    begin
      if (!Bus2IP_Resetn || clear)
        begin
          min_sad2 <= 999999;
          min_x2 <= 0;
          min_y2 <= 0;
        end
      else if (count_tick == 8 && sad2 < min_sad2)
        begin
          min_sad2 <= sad2;
          min_x2 <= group_col;
          min_y2 <= group_row;
        end
      else
        begin
          min_sad2 <= min_sad2;
          min_x2 <= min_x2;
          min_y2 <= min_y2;
        end
    end
    
  always @(posedge Bus2IP_Clk)
    begin
      if (!Bus2IP_Resetn || clear)
        begin
          min_sad3 <= 999999;
          min_x3 <= 0;
          min_y3 <= 0;
        end
      else if (count_tick == 8 && sad3 < min_sad3)
        begin
          min_sad3 <= sad3;
          min_x3 <= group_col;
          min_y3 <= group_row;
        end
      else
        begin
          min_sad3 <= min_sad3;
          min_x3 <= min_x3;
          min_y3 <= min_y3;
        end
    end
    
  always @(posedge Bus2IP_Clk)
    begin
      if (!Bus2IP_Resetn || clear)
        begin
          min_sad4 <= 999999;
          min_x4 <= 0;
          min_y4 <= 0;
        end
      else if (count_tick == 8 && sad4 < min_sad4)
        begin
          min_sad4 <= sad4;
          min_x4 <= group_col;
          min_y4 <= group_row;
        end
      else
        begin
          min_sad4 <= min_sad4;
          min_x4 <= min_x4;
          min_y4 <= min_y4;
        end
    end
  */

  assign clear = (state != IDLE && state != MATCHING_COMPUTE && state != MATCHING_LOAD && state != LOAD_GROUP) ? 1'b1 : 0;
  
  // FSM
  always @(posedge Bus2IP_Clk)
    begin
      if (!Bus2IP_Resetn)
        state <= IDLE;
      else
        state <= next_state;
    end
  
  always @(*)
    begin
      case (state)
        IDLE:
          begin
            if (slv_reg0 == 1)
              next_state = LOAD_FACE1;
            else
              next_state = IDLE;
          end
        LOAD_FACE1:
          begin
            if (mem_complete)
              next_state = LOAD_GROUP; //LOAD_FACE2;
            else
              next_state = LOAD_FACE1;
          end
				/*
        LOAD_FACE2:
          begin
            if (mem_complete)
              next_state = LOAD_FACE3;
            else
              next_state = LOAD_FACE2;
          end
        LOAD_FACE3:
          begin
            if (mem_complete)
              next_state = LOAD_FACE4;
            else
              next_state = LOAD_FACE3;
          end
        LOAD_FACE4:
          begin
            if (mem_complete)
              next_state = LOAD_GROUP;
            else
              next_state = LOAD_FACE4;
          end
				*/
        LOAD_GROUP:
          begin
            if (mem_complete && group_row_count >= 31)
              next_state = MATCHING_COMPUTE;
            else
              next_state = LOAD_GROUP;
          end
        MATCHING_COMPUTE:
          begin
            if (count_tick < 8)
              next_state = MATCHING_COMPUTE;
            else if (group_row_count != GROUP_HEIGHT)
              next_state = MATCHING_LOAD;
            else if (group_col < GROUP_WIDTH - 32)
              next_state = LOAD_GROUP;
            else
              next_state = IDLE;
          end
        MATCHING_LOAD:
          begin
            if (mem_complete)
              next_state = MATCHING_COMPUTE;
            else
              next_state = MATCHING_LOAD;
          end
        default:
          begin
            next_state = IDLE;
          end
      endcase
    end
    
  // count_tick control
  always @(posedge Bus2IP_Clk)
    begin
      if (!Bus2IP_Resetn || next_state != MATCHING_COMPUTE)
        count_tick <= 0;
      else
        count_tick <= count_tick + 1;
    end
  
  // Group row, col control
  always @(posedge Bus2IP_Clk)
    begin
      if (!Bus2IP_Resetn || 
          state != LOAD_GROUP && state != MATCHING_COMPUTE && state != MATCHING_LOAD || 
          state == MATCHING_COMPUTE && next_state == LOAD_GROUP)
        group_row_count <= 0;
      else if (mem_complete)
        group_row_count <= group_row_count + 1;
      else
        group_row_count <= group_row_count;
    end
  
  always @(posedge Bus2IP_Clk)
    begin
      if (!Bus2IP_Resetn || next_state != MATCHING_COMPUTE && next_state != MATCHING_LOAD)
        group_row <= 0;
      else if (state == MATCHING_COMPUTE && next_state == MATCHING_LOAD)
        group_row <= group_row + 1;
      else
        group_row <= group_row;
    end
  
  always @(posedge Bus2IP_Clk)
    begin
      if (!Bus2IP_Resetn || next_state != MATCHING_COMPUTE && next_state != MATCHING_LOAD && next_state != LOAD_GROUP)
        group_col <= 0;
      else if (state == MATCHING_COMPUTE && next_state == LOAD_GROUP)
        group_col <= group_col + 1;
      else
        group_col <= group_col;
    end
  
  // Memory setup
  always @(*)
    begin
      case (state)
        LOAD_FACE1:
          begin
            mem_addr = slv_reg1;
          end
	  			/*
        LOAD_FACE2:
          begin
            mem_addr = slv_reg2;
          end
        LOAD_FACE3:
          begin
            mem_addr = slv_reg3;
          end
        LOAD_FACE4:
          begin
            mem_addr = slv_reg4;
          end
	  			*/
        default:
          begin
            mem_addr = slv_reg5 + group_col + group_row_count * GROUP_WIDTH;
          end
      endcase
		end
  
  always @(posedge Bus2IP_Clk)
    begin
      if (next_state == MATCHING_LOAD || next_state == LOAD_GROUP)
        mem_length <= 32;
      else
        mem_length <= FACE_SIZE;
    end
    
  always @(posedge Bus2IP_Clk)
    begin
      if (!Bus2IP_Resetn)
        mem_trig <= 0;
      else if (state != next_state && next_state != IDLE && next_state != MATCHING_COMPUTE)
        mem_trig <= 1;
			else if (!mem_complete)
				mem_trig <= 0;
      else
        mem_trig <= mem_trig;
    end
        
  
  // Faces and group
  integer pixel_index;
  always @(posedge Bus2IP_Clk)
    begin
      if (state == LOAD_FACE1 && mem_data_trig)
        begin
          for (pixel_index = 0; pixel_index < 255; pixel_index = pixel_index + 1)
            face1[pixel_index] <= face1[pixel_index+1];
          face1[255] <= mem_data;
        end
      else
        for (pixel_index = 0; pixel_index < 256; pixel_index = pixel_index + 1)
          face1[pixel_index] <= face1[pixel_index];
    end
    
	/*
  always @(posedge Bus2IP_Clk)
    begin
      if (state == LOAD_FACE2 && mem_data_trig)
        begin
          for (pixel_index = 0; pixel_index < 255; pixel_index = pixel_index + 1)
            face2[pixel_index] <= face2[pixel_index+1];
          face2[255] <= mem_data;
        end
      else
        for (pixel_index = 0; pixel_index < 256; pixel_index = pixel_index + 1)
          face2[pixel_index] <= face2[pixel_index];
    end
    
  always @(posedge Bus2IP_Clk)
    begin
      if (state == LOAD_FACE3 && mem_data_trig)
        begin
          for (pixel_index = 0; pixel_index < 255; pixel_index = pixel_index + 1)
            face3[pixel_index] <= face3[pixel_index+1];
          face3[255] <= mem_data;
        end
      else
        for (pixel_index = 0; pixel_index < 256; pixel_index = pixel_index + 1)
          face3[pixel_index] <= face3[pixel_index];
    end
    
  always @(posedge Bus2IP_Clk)
    begin
      if (state == LOAD_FACE4 && mem_data_trig)
        begin
          for (pixel_index = 0; pixel_index < 255; pixel_index = pixel_index + 1)
            face4[pixel_index] <= face4[pixel_index+1];
          face4[255] <= mem_data;
        end
      else
        for (pixel_index = 0; pixel_index < 256; pixel_index = pixel_index + 1)
          face4[pixel_index] <= face4[pixel_index];
    end
	*/
    
  always @(posedge Bus2IP_Clk)
    begin
      if ((state == LOAD_GROUP || state == MATCHING_LOAD) && mem_data_trig)
        begin
          for (pixel_index = 0; pixel_index < 255; pixel_index = pixel_index + 1)
            group[pixel_index] <= group[pixel_index+1];
          group[255] <= mem_data;
        end
      else
        for (pixel_index = 0; pixel_index < 256; pixel_index = pixel_index + 1)
          group[pixel_index] <= group[pixel_index];
    end
  
  genvar p_index;
  generate
    for ( p_index = 0; p_index <= 255; p_index = p_index+1 )
      begin: g0
        assign g_pixel[p_index*32+31 : p_index*32] = group[p_index];
        assign f_pixel[p_index*32+31 : p_index*32] = face1[p_index];
      end
  endgenerate
  
  


  // ------------------------------------------------------
  // Example code to read/write user logic slave model s/w accessible registers
  // 
  // Note:
  // The example code presented here is to show you one way of reading/writing
  // software accessible registers implemented in the user logic slave model.
  // Each bit of the Bus2IP_WrCE/Bus2IP_RdCE signals is configured to correspond
  // to one software accessible register by the top level template. For example,
  // if you have four 32 bit software accessible registers in the user logic,
  // you are basically operating on the following memory mapped registers:
  // 
  //    Bus2IP_WrCE/Bus2IP_RdCE   Memory Mapped Register
  //                     "1000"   C_BASEADDR + 0x0
  //                     "0100"   C_BASEADDR + 0x4
  //                     "0010"   C_BASEADDR + 0x8
  //                     "0001"   C_BASEADDR + 0xC
  // 
  // ------------------------------------------------------

    assign
    slv_reg_write_sel = Bus2IP_WrCE[31:0],
    slv_reg_read_sel  = Bus2IP_RdCE[31:0],
    slv_write_ack     = Bus2IP_WrCE[0] || Bus2IP_WrCE[1] || Bus2IP_WrCE[2] || Bus2IP_WrCE[3] || Bus2IP_WrCE[4] || Bus2IP_WrCE[5] || Bus2IP_WrCE[6] || Bus2IP_WrCE[7] || Bus2IP_WrCE[8] || Bus2IP_WrCE[9] || Bus2IP_WrCE[10] || Bus2IP_WrCE[11] || Bus2IP_WrCE[12] || Bus2IP_WrCE[13] || Bus2IP_WrCE[14] || Bus2IP_WrCE[15] || Bus2IP_WrCE[16] || Bus2IP_WrCE[17] || Bus2IP_WrCE[18] || Bus2IP_WrCE[19] || Bus2IP_WrCE[20] || Bus2IP_WrCE[21] || Bus2IP_WrCE[22] || Bus2IP_WrCE[23] || Bus2IP_WrCE[24] || Bus2IP_WrCE[25] || Bus2IP_WrCE[26] || Bus2IP_WrCE[27] || Bus2IP_WrCE[28] || Bus2IP_WrCE[29] || Bus2IP_WrCE[30] || Bus2IP_WrCE[31],
    slv_read_ack      = Bus2IP_RdCE[0] || Bus2IP_RdCE[1] || Bus2IP_RdCE[2] || Bus2IP_RdCE[3] || Bus2IP_RdCE[4] || Bus2IP_RdCE[5] || Bus2IP_RdCE[6] || Bus2IP_RdCE[7] || Bus2IP_RdCE[8] || Bus2IP_RdCE[9] || Bus2IP_RdCE[10] || Bus2IP_RdCE[11] || Bus2IP_RdCE[12] || Bus2IP_RdCE[13] || Bus2IP_RdCE[14] || Bus2IP_RdCE[15] || Bus2IP_RdCE[16] || Bus2IP_RdCE[17] || Bus2IP_RdCE[18] || Bus2IP_RdCE[19] || Bus2IP_RdCE[20] || Bus2IP_RdCE[21] || Bus2IP_RdCE[22] || Bus2IP_RdCE[23] || Bus2IP_RdCE[24] || Bus2IP_RdCE[25] || Bus2IP_RdCE[26] || Bus2IP_RdCE[27] || Bus2IP_RdCE[28] || Bus2IP_RdCE[29] || Bus2IP_RdCE[30] || Bus2IP_RdCE[31];

  // implement slave model register(s)
  always @( posedge Bus2IP_Clk )
    begin: SLAVE_REG_WRITE_PROC

      if ( Bus2IP_Resetn == 0 )
        begin
          slv_reg0 <= 0;
          slv_reg1 <= 0;
          slv_reg2 <= 0;
          slv_reg3 <= 0;
          slv_reg4 <= 0;
          slv_reg5 <= 0;
          slv_reg6 <= 0;
          slv_reg7 <= 0;
          slv_reg8 <= 0;
          slv_reg9 <= 0;
          slv_reg10 <= 0;
          slv_reg11 <= 0;
          slv_reg12 <= 0;
          slv_reg13 <= 0;
          slv_reg14 <= 0;
          slv_reg15 <= 0;
          slv_reg16 <= 0;
          slv_reg17 <= 0;
		  /*
          slv_reg18 <= 0;
          slv_reg19 <= 0;
          slv_reg20 <= 0;
          slv_reg21 <= 0;
          slv_reg22 <= 0;
          slv_reg23 <= 0;
          slv_reg24 <= 0;
          slv_reg25 <= 0;
          slv_reg26 <= 0;
          slv_reg27 <= 0;
          slv_reg28 <= 0;
          slv_reg29 <= 0;
          slv_reg30 <= 0;
          slv_reg31 <= 0;
		  */
        end
      else
        case ( slv_reg_write_sel )
          32'b10000000000000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg0[bit_index] <= Bus2IP_Data[bit_index];
          32'b01000000000000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg1[bit_index] <= Bus2IP_Data[bit_index];
          32'b00100000000000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg2[bit_index] <= Bus2IP_Data[bit_index];
          32'b00010000000000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg3[bit_index] <= Bus2IP_Data[bit_index];
          32'b00001000000000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg4[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000100000000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg5[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000010000000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg6[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000001000000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg7[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000100000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg8[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000010000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg9[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000001000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg10[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000100000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg11[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000010000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg12[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000001000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg13[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000100000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg14[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000010000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg15[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000001000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg16[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000100000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg17[bit_index] <= Bus2IP_Data[bit_index];
		  /*
          32'b00000000000000000010000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg18[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000001000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg19[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000100000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg20[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000010000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg21[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000001000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg22[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000000100000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg23[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000000010000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg24[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000000001000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg25[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000000000100000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg26[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000000000010000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg27[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000000000001000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg28[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000000000000100 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg29[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000000000000010 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg30[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000000000000001 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg31[bit_index] <= Bus2IP_Data[bit_index];
		  */
          default : 
            begin
              slv_reg0 <= (next_state == IDLE ? 0 : slv_reg0);
              slv_reg6 <= min_sad1;
              slv_reg7 <= min_x1;
              slv_reg8 <= min_y1;
			  /*
              slv_reg9 <= min_sad2;
              slv_reg10 <= min_x2;
              slv_reg11 <= min_y2;
              slv_reg12 <= min_sad3;
              slv_reg13 <= min_x3;
              slv_reg14 <= min_y3;
              slv_reg15 <= min_sad4;
              slv_reg16 <= min_x4;
              slv_reg17 <= min_y4;
			  */
            end
        endcase

    end // SLAVE_REG_WRITE_PROC

  // implement slave model register read mux
  always @( slv_reg_read_sel or slv_reg0 or slv_reg1 or slv_reg2 or slv_reg3 or slv_reg4 or slv_reg5 or slv_reg6 or slv_reg7 or slv_reg8 or slv_reg9 or slv_reg10 or slv_reg11 or slv_reg12 or slv_reg13 or slv_reg14 or slv_reg15 or slv_reg16 or slv_reg17 /*or slv_reg18 or slv_reg19 or slv_reg20 or slv_reg21 or slv_reg22 or slv_reg23 or slv_reg24 or slv_reg25 or slv_reg26 or slv_reg27 or slv_reg28 or slv_reg29 or slv_reg30 or slv_reg31*/ )
    begin: SLAVE_REG_READ_PROC

      case ( slv_reg_read_sel )
        32'b10000000000000000000000000000000 : slv_ip2bus_data <= slv_reg0;
        32'b01000000000000000000000000000000 : slv_ip2bus_data <= slv_reg1;
        32'b00100000000000000000000000000000 : slv_ip2bus_data <= slv_reg2;
        32'b00010000000000000000000000000000 : slv_ip2bus_data <= slv_reg3;
        32'b00001000000000000000000000000000 : slv_ip2bus_data <= slv_reg4;
        32'b00000100000000000000000000000000 : slv_ip2bus_data <= slv_reg5;
        32'b00000010000000000000000000000000 : slv_ip2bus_data <= slv_reg6;
        32'b00000001000000000000000000000000 : slv_ip2bus_data <= slv_reg7;
        32'b00000000100000000000000000000000 : slv_ip2bus_data <= slv_reg8;
        32'b00000000010000000000000000000000 : slv_ip2bus_data <= slv_reg9;
        32'b00000000001000000000000000000000 : slv_ip2bus_data <= slv_reg10;
        32'b00000000000100000000000000000000 : slv_ip2bus_data <= slv_reg11;
        32'b00000000000010000000000000000000 : slv_ip2bus_data <= slv_reg12;
        32'b00000000000001000000000000000000 : slv_ip2bus_data <= slv_reg13;
        32'b00000000000000100000000000000000 : slv_ip2bus_data <= slv_reg14;
        32'b00000000000000010000000000000000 : slv_ip2bus_data <= slv_reg15;
        32'b00000000000000001000000000000000 : slv_ip2bus_data <= slv_reg16;
        32'b00000000000000000100000000000000 : slv_ip2bus_data <= slv_reg17;
		/*
        32'b00000000000000000010000000000000 : slv_ip2bus_data <= slv_reg18;
        32'b00000000000000000001000000000000 : slv_ip2bus_data <= slv_reg19;
        32'b00000000000000000000100000000000 : slv_ip2bus_data <= slv_reg20;
        32'b00000000000000000000010000000000 : slv_ip2bus_data <= slv_reg21;
        32'b00000000000000000000001000000000 : slv_ip2bus_data <= slv_reg22;
        32'b00000000000000000000000100000000 : slv_ip2bus_data <= slv_reg23;
        32'b00000000000000000000000010000000 : slv_ip2bus_data <= slv_reg24;
        32'b00000000000000000000000001000000 : slv_ip2bus_data <= slv_reg25;
        32'b00000000000000000000000000100000 : slv_ip2bus_data <= slv_reg26;
        32'b00000000000000000000000000010000 : slv_ip2bus_data <= slv_reg27;
        32'b00000000000000000000000000001000 : slv_ip2bus_data <= slv_reg28;
        32'b00000000000000000000000000000100 : slv_ip2bus_data <= slv_reg29;
        32'b00000000000000000000000000000010 : slv_ip2bus_data <= slv_reg30;
        32'b00000000000000000000000000000001 : slv_ip2bus_data <= slv_reg31;
		*/
        default : slv_ip2bus_data <= 0;
      endcase

    end // SLAVE_REG_READ_PROC

  // ------------------------------------------------------------
  // Example code to drive IP to Bus signals
  // ------------------------------------------------------------

  assign IP2Bus_Data = (slv_read_ack == 1'b1) ? slv_ip2bus_data : (mst_read_ack == 1'b1) ? mst_ip2bus_data :  0 ;

  assign IP2Bus_WrAck = slv_write_ack || mst_write_ack;
  assign IP2Bus_RdAck = slv_read_ack || mst_read_ack;
  assign IP2Bus_Error = 0;

endmodule
