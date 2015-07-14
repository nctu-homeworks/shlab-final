`uselib lib=unisims_ver
`uselib lib=proc_common_v3_00_a
`include "get_mem.v"
`include "bram2p.v"

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
parameter  LOAD_GROUP = 4'd5;
parameter  LOAD_NEXT_GROUP = 4'd6;
parameter  BRAM_EXTRACT = 4'd7;
parameter  MATCHING_COMPUTE = 4'd8;

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
  
  reg      [31 : 0]                          group[255 : 0];
  reg      [31 : 0]                          group_preload[31:0];
  wire     [11 : 0]                          mem_count;
  wire     [31 : 0]                          mem_data;
  reg      [31 : 0]                          mem_addr;
  reg      [11 : 0]                          mem_length;
  reg                                        mem_trig;
  wire                                       mem_data_trig, mem_complete;
  reg      [31 : 0]                          min_x1, min_x2, min_x3, min_x4;
  reg      [31 : 0]                          min_y1, min_y2, min_y3, min_y4;
  reg      [31 : 0]                          min_sad1, min_sad2, min_sad3, min_sad4;
  wire     [31 : 0]                          sad;
  
  wire     [31 : 0]                          bram_out[63:0];
  wire                                       bram_we[63:0];
  wire     [31 : 0]                          bram_addr[63:0];
  
  reg      [1  : 0]                          run;
  reg      [3  : 0]                          state, next_state;
  reg      [12 : 0]                          group_row, group_col, group_row_count;
  reg      [10 : 0]                          group_col_count;
  reg      [3  : 0]                          count_tick;
  
	assign dbg_trig = 0;
	assign dbg_data = 0;
  
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
  bram2p bram0 (Bus2IP_Clk, bram_we[0 ], 1'b1, bram_addr[0 ], mem_data, bram_out[0 ], Bus2IP_Clk, bram_we[32+0 ], 1'b1, bram_addr[32+0 ], mem_data, bram_out[32+0 ]);
  bram2p bram1 (Bus2IP_Clk, bram_we[1 ], 1'b1, bram_addr[1 ], mem_data, bram_out[1 ], Bus2IP_Clk, bram_we[32+1 ], 1'b1, bram_addr[32+1 ], mem_data, bram_out[32+1 ]);
  bram2p bram2 (Bus2IP_Clk, bram_we[2 ], 1'b1, bram_addr[2 ], mem_data, bram_out[2 ], Bus2IP_Clk, bram_we[32+2 ], 1'b1, bram_addr[32+2 ], mem_data, bram_out[32+2 ]);
  bram2p bram3 (Bus2IP_Clk, bram_we[3 ], 1'b1, bram_addr[3 ], mem_data, bram_out[3 ], Bus2IP_Clk, bram_we[32+3 ], 1'b1, bram_addr[32+3 ], mem_data, bram_out[32+3 ]);
  bram2p bram4 (Bus2IP_Clk, bram_we[4 ], 1'b1, bram_addr[4 ], mem_data, bram_out[4 ], Bus2IP_Clk, bram_we[32+4 ], 1'b1, bram_addr[32+4 ], mem_data, bram_out[32+4 ]);
  bram2p bram5 (Bus2IP_Clk, bram_we[5 ], 1'b1, bram_addr[5 ], mem_data, bram_out[5 ], Bus2IP_Clk, bram_we[32+5 ], 1'b1, bram_addr[32+5 ], mem_data, bram_out[32+5 ]);
  bram2p bram6 (Bus2IP_Clk, bram_we[6 ], 1'b1, bram_addr[6 ], mem_data, bram_out[6 ], Bus2IP_Clk, bram_we[32+6 ], 1'b1, bram_addr[32+6 ], mem_data, bram_out[32+6 ]);
  bram2p bram7 (Bus2IP_Clk, bram_we[7 ], 1'b1, bram_addr[7 ], mem_data, bram_out[7 ], Bus2IP_Clk, bram_we[32+7 ], 1'b1, bram_addr[32+7 ], mem_data, bram_out[32+7 ]);
  bram2p bram8 (Bus2IP_Clk, bram_we[8 ], 1'b1, bram_addr[8 ], mem_data, bram_out[8 ], Bus2IP_Clk, bram_we[32+8 ], 1'b1, bram_addr[32+8 ], mem_data, bram_out[32+8 ]);
  bram2p bram9 (Bus2IP_Clk, bram_we[9 ], 1'b1, bram_addr[9 ], mem_data, bram_out[9 ], Bus2IP_Clk, bram_we[32+9 ], 1'b1, bram_addr[32+9 ], mem_data, bram_out[32+9 ]);
  bram2p bram10(Bus2IP_Clk, bram_we[10], 1'b1, bram_addr[10], mem_data, bram_out[10], Bus2IP_Clk, bram_we[32+10], 1'b1, bram_addr[32+10], mem_data, bram_out[32+10]);
  bram2p bram11(Bus2IP_Clk, bram_we[11], 1'b1, bram_addr[11], mem_data, bram_out[11], Bus2IP_Clk, bram_we[32+11], 1'b1, bram_addr[32+11], mem_data, bram_out[32+11]);
  bram2p bram12(Bus2IP_Clk, bram_we[12], 1'b1, bram_addr[12], mem_data, bram_out[12], Bus2IP_Clk, bram_we[32+12], 1'b1, bram_addr[32+12], mem_data, bram_out[32+12]);
  bram2p bram13(Bus2IP_Clk, bram_we[13], 1'b1, bram_addr[13], mem_data, bram_out[13], Bus2IP_Clk, bram_we[32+13], 1'b1, bram_addr[32+13], mem_data, bram_out[32+13]);
  bram2p bram14(Bus2IP_Clk, bram_we[14], 1'b1, bram_addr[14], mem_data, bram_out[14], Bus2IP_Clk, bram_we[32+14], 1'b1, bram_addr[32+14], mem_data, bram_out[32+14]);
  bram2p bram15(Bus2IP_Clk, bram_we[15], 1'b1, bram_addr[15], mem_data, bram_out[15], Bus2IP_Clk, bram_we[32+15], 1'b1, bram_addr[32+15], mem_data, bram_out[32+15]);
  bram2p bram16(Bus2IP_Clk, bram_we[16], 1'b1, bram_addr[16], mem_data, bram_out[16], Bus2IP_Clk, bram_we[32+16], 1'b1, bram_addr[32+16], mem_data, bram_out[32+16]);
  bram2p bram17(Bus2IP_Clk, bram_we[17], 1'b1, bram_addr[17], mem_data, bram_out[17], Bus2IP_Clk, bram_we[32+17], 1'b1, bram_addr[32+17], mem_data, bram_out[32+17]);
  bram2p bram18(Bus2IP_Clk, bram_we[18], 1'b1, bram_addr[18], mem_data, bram_out[18], Bus2IP_Clk, bram_we[32+18], 1'b1, bram_addr[32+18], mem_data, bram_out[32+18]);
  bram2p bram19(Bus2IP_Clk, bram_we[19], 1'b1, bram_addr[19], mem_data, bram_out[19], Bus2IP_Clk, bram_we[32+19], 1'b1, bram_addr[32+19], mem_data, bram_out[32+19]);
  bram2p bram20(Bus2IP_Clk, bram_we[20], 1'b1, bram_addr[20], mem_data, bram_out[20], Bus2IP_Clk, bram_we[32+20], 1'b1, bram_addr[32+20], mem_data, bram_out[32+20]);
  bram2p bram21(Bus2IP_Clk, bram_we[21], 1'b1, bram_addr[21], mem_data, bram_out[21], Bus2IP_Clk, bram_we[32+21], 1'b1, bram_addr[32+21], mem_data, bram_out[32+21]);
  bram2p bram22(Bus2IP_Clk, bram_we[22], 1'b1, bram_addr[22], mem_data, bram_out[22], Bus2IP_Clk, bram_we[32+22], 1'b1, bram_addr[32+22], mem_data, bram_out[32+22]);
  bram2p bram23(Bus2IP_Clk, bram_we[23], 1'b1, bram_addr[23], mem_data, bram_out[23], Bus2IP_Clk, bram_we[32+23], 1'b1, bram_addr[32+23], mem_data, bram_out[32+23]);
  bram2p bram24(Bus2IP_Clk, bram_we[24], 1'b1, bram_addr[24], mem_data, bram_out[24], Bus2IP_Clk, bram_we[32+24], 1'b1, bram_addr[32+24], mem_data, bram_out[32+24]);
  bram2p bram25(Bus2IP_Clk, bram_we[25], 1'b1, bram_addr[25], mem_data, bram_out[25], Bus2IP_Clk, bram_we[32+25], 1'b1, bram_addr[32+25], mem_data, bram_out[32+25]);
  bram2p bram26(Bus2IP_Clk, bram_we[26], 1'b1, bram_addr[26], mem_data, bram_out[26], Bus2IP_Clk, bram_we[32+26], 1'b1, bram_addr[32+26], mem_data, bram_out[32+26]);
  bram2p bram27(Bus2IP_Clk, bram_we[27], 1'b1, bram_addr[27], mem_data, bram_out[27], Bus2IP_Clk, bram_we[32+27], 1'b1, bram_addr[32+27], mem_data, bram_out[32+27]);
  bram2p bram28(Bus2IP_Clk, bram_we[28], 1'b1, bram_addr[28], mem_data, bram_out[28], Bus2IP_Clk, bram_we[32+28], 1'b1, bram_addr[32+28], mem_data, bram_out[32+28]);
  bram2p bram29(Bus2IP_Clk, bram_we[29], 1'b1, bram_addr[29], mem_data, bram_out[29], Bus2IP_Clk, bram_we[32+29], 1'b1, bram_addr[32+29], mem_data, bram_out[32+29]);
  bram2p bram30(Bus2IP_Clk, bram_we[30], 1'b1, bram_addr[30], mem_data, bram_out[30], Bus2IP_Clk, bram_we[32+30], 1'b1, bram_addr[32+30], mem_data, bram_out[32+30]);
  bram2p bram31(Bus2IP_Clk, bram_we[31], 1'b1, bram_addr[31], mem_data, bram_out[31], Bus2IP_Clk, bram_we[32+31], 1'b1, bram_addr[32+31], mem_data, bram_out[32+31]);
  
  // min_sad for face1
  always @(posedge Bus2IP_Clk)
    begin
      if (!Bus2IP_Resetn || state == IDLE && next_state == LOAD_FACE1)
        begin
          min_sad1 <= 999999;
          min_x1 <= 0;
          min_y1 <= 0;
        end
      else if (run == 0 && group_col >= 4 && sad < min_sad1)
        begin
          min_sad1 <= sad;
          min_x1 <= group_col - 4;
          min_y1 <= group_row;
        end
      else
        begin
          min_sad1 <= min_sad1;
          min_x1 <= min_x1;
          min_y1 <= min_y1;
        end
    end
    
  // min_sad for face2
  always @(posedge Bus2IP_Clk)
    begin
      if (!Bus2IP_Resetn || state == IDLE && next_state == LOAD_FACE1)
        begin
          min_sad2 <= 999999;
          min_x2 <= 0;
          min_y2 <= 0;
        end
      else if (run == 1 && group_col >= 4 && sad < min_sad2)
        begin
          min_sad2 <= sad;
          min_x2 <= group_col - 4;
          min_y2 <= group_row;
        end
      else
        begin
          min_sad2 <= min_sad2;
          min_x2 <= min_x2;
          min_y2 <= min_y2;
        end
    end
    
  // min_sad for face3
  always @(posedge Bus2IP_Clk)
    begin
      if (!Bus2IP_Resetn || state == IDLE && next_state == LOAD_FACE1)
        begin
          min_sad3 <= 999999;
          min_x3 <= 0;
          min_y3 <= 0;
        end
      else if (run == 2 && group_col >= 4 && sad < min_sad3)
        begin
          min_sad3 <= sad;
          min_x3 <= group_col - 4;
          min_y3 <= group_row;
        end
      else
        begin
          min_sad3 <= min_sad3;
          min_x3 <= min_x3;
          min_y3 <= min_y3;
        end
    end
    
  // min_sad for face4
  always @(posedge Bus2IP_Clk)
    begin
      if (!Bus2IP_Resetn || state == IDLE && next_state == LOAD_FACE1)
        begin
          min_sad4 <= 999999;
          min_x4 <= 0;
          min_y4 <= 0;
        end
      else if (run == 3 && group_col >= 4 && sad < min_sad4)
        begin
          min_sad4 <= sad;
          min_x4 <= group_col - 4;
          min_y4 <= group_row;
        end
      else
        begin
          min_sad4 <= min_sad4;
          min_x4 <= min_x4;
          min_y4 <= min_y4;
        end
    end
  
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
            if (mem_complete && !mem_trig)
              next_state = LOAD_GROUP;
            else
              next_state = LOAD_FACE1;
          end
        LOAD_GROUP:
          begin
            if (mem_complete && !mem_trig)
              next_state = LOAD_NEXT_GROUP;
            else
              next_state = LOAD_GROUP;
          end
        LOAD_NEXT_GROUP:
          begin
            if (group_row_count >= 32)
              next_state = BRAM_EXTRACT;
            else
              next_state = LOAD_GROUP;
          end
        BRAM_EXTRACT:
          begin
            if (group_col_count > 8)
              next_state = MATCHING_COMPUTE;
            else
              next_state = BRAM_EXTRACT;
          end
        MATCHING_COMPUTE:
          begin
            if (group_col[1:0] != 2'b11 || group_col < GROUP_WIDTH-32-1)
              next_state = MATCHING_COMPUTE;
            else if (group_row_count != GROUP_HEIGHT)
              next_state = BRAM_EXTRACT;
            else if (run == 3)
              next_state = IDLE;
            else
              next_state = LOAD_FACE1;
          end
        default:
          begin
            next_state = IDLE;
          end
      endcase
    end
    
  // run control
  always @(posedge Bus2IP_Clk)
    begin
      if (!Bus2IP_Resetn || state == IDLE)
        run <= 0;
      else if (state == MATCHING_COMPUTE && next_state == LOAD_FACE1)
        run <= run + 1;
      else
        run <= run;
    end
  
  // Group row, col control
  // group_row_count
  always @(posedge Bus2IP_Clk)
    begin
      if (!Bus2IP_Resetn || 
          state != LOAD_GROUP && state != LOAD_NEXT_GROUP && state != MATCHING_COMPUTE && state != BRAM_EXTRACT)
        group_row_count <= 0;
      else if (state == LOAD_GROUP && next_state == LOAD_NEXT_GROUP || 
               state == MATCHING_COMPUTE && next_state == BRAM_EXTRACT)
        group_row_count <= group_row_count + 1;
      else
        group_row_count <= group_row_count;
    end
    
  // group_col_count
  always @(posedge Bus2IP_Clk)
    begin
      if (!Bus2IP_Resetn || 
          next_state != BRAM_EXTRACT && next_state != MATCHING_COMPUTE ||
          group_col[1:0] == 2'b10 && group_col_count >= GROUP_WIDTH/4)
        group_col_count <= 0;
      else if (next_state == BRAM_EXTRACT || group_col[1:0] == 2'b10)
        group_col_count <= group_col_count + 1;
      else
        group_col_count <= group_col_count;
    end
  
  // group_row
  always @(posedge Bus2IP_Clk)
    begin
      if (!Bus2IP_Resetn || next_state != MATCHING_COMPUTE && next_state != BRAM_EXTRACT)
        group_row <= 0;
      else if (state == MATCHING_COMPUTE && next_state == BRAM_EXTRACT)
        group_row <= group_row + 1;
      else
        group_row <= group_row;
    end
  
  // group_col
  always @(posedge Bus2IP_Clk)
    begin
      if (!Bus2IP_Resetn || next_state != MATCHING_COMPUTE)
        group_col <= 0;
      else if (state == MATCHING_COMPUTE)
        group_col <= group_col + 1;
      else
        group_col <= group_col;
    end
  
  // Memory setup
  // mem_addr
  always @(*)
    begin
      case ({state, run})
        {LOAD_FACE1, 2'd0}:
          begin
            mem_addr = slv_reg1;
          end
        {LOAD_FACE1, 2'd1}:
          begin
            mem_addr = slv_reg2;
          end
        {LOAD_FACE1, 2'd2}:
          begin
            mem_addr = slv_reg3;
          end
        {LOAD_FACE1, 2'd3}:
          begin
            mem_addr = slv_reg4;
          end
        default:
          begin
            mem_addr = slv_reg5 + group_row_count * GROUP_WIDTH;
          end
      endcase
		end
  
  // mem_length
  always @(posedge Bus2IP_Clk)
    begin
      if (next_state == MATCHING_COMPUTE || next_state == LOAD_GROUP)
        mem_length <= GROUP_WIDTH;
      else
        mem_length <= FACE_SIZE;
    end
    
  // mem_trig
  always @(posedge Bus2IP_Clk)
    begin
      if (!Bus2IP_Resetn)
        mem_trig <= 0;
      else if (state != next_state && next_state != IDLE && next_state != LOAD_NEXT_GROUP && next_state != BRAM_EXTRACT)
        mem_trig <= 1;
			else if (!mem_complete)
				mem_trig <= 0;
      else
        mem_trig <= mem_trig;
    end
    
  // BRAM Control (we, addr)
  genvar bram_index1;
  generate
    for ( bram_index1 = 0; bram_index1 < 64; bram_index1 = bram_index1+1 )
	    begin: bg1
        assign bram_we[bram_index1] = ((state == LOAD_GROUP || state == MATCHING_COMPUTE) && group_row_count[5:0] == bram_index1 && mem_data_trig) ? 1'b1 : 0;
        assign bram_addr[bram_index1] = {22'd0, bram_index1[5], (bram_we[bram_index1] ? mem_count[8:0] : group_col_count[8:0])};
      end
  endgenerate
        
  // face
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
    
  // group
  integer pixel_index2;
  always @(posedge Bus2IP_Clk)
    begin
      if (state == BRAM_EXTRACT)
        for (pixel_index2 = 0; pixel_index2 < 32; pixel_index2 = pixel_index2 + 1)
          begin
            group[pixel_index2*8  ] <= group[pixel_index2*8+1];
            group[pixel_index2*8+1] <= group[pixel_index2*8+2];
            group[pixel_index2*8+2] <= group[pixel_index2*8+3];
            group[pixel_index2*8+3] <= group[pixel_index2*8+4];
            group[pixel_index2*8+4] <= group[pixel_index2*8+5];
            group[pixel_index2*8+5] <= group[pixel_index2*8+6];
            group[pixel_index2*8+6] <= group[pixel_index2*8+7];
            group[pixel_index2*8+7] <= group_preload[pixel_index2];
          end
      else if (state == MATCHING_COMPUTE)
        for (pixel_index2 = 0; pixel_index2 < 32; pixel_index2 = pixel_index2 + 1)
          begin
            group[pixel_index2*8+0][7:0]   <= group[pixel_index2*8+0][15:8];
            group[pixel_index2*8+0][15:8]  <= group[pixel_index2*8+0][23:16];
            group[pixel_index2*8+0][23:16] <= group[pixel_index2*8+0][31:24];
            group[pixel_index2*8+0][31:24] <= group[pixel_index2*8+0+1][7:0];
            group[pixel_index2*8+1][7:0]   <= group[pixel_index2*8+1][15:8];
            group[pixel_index2*8+1][15:8]  <= group[pixel_index2*8+1][23:16];
            group[pixel_index2*8+1][23:16] <= group[pixel_index2*8+1][31:24];
            group[pixel_index2*8+1][31:24] <= group[pixel_index2*8+1+1][7:0];
            group[pixel_index2*8+2][7:0]   <= group[pixel_index2*8+2][15:8];
            group[pixel_index2*8+2][15:8]  <= group[pixel_index2*8+2][23:16];
            group[pixel_index2*8+2][23:16] <= group[pixel_index2*8+2][31:24];
            group[pixel_index2*8+2][31:24] <= group[pixel_index2*8+2+1][7:0];
            group[pixel_index2*8+3][7:0]   <= group[pixel_index2*8+3][15:8];
            group[pixel_index2*8+3][15:8]  <= group[pixel_index2*8+3][23:16];
            group[pixel_index2*8+3][23:16] <= group[pixel_index2*8+3][31:24];
            group[pixel_index2*8+3][31:24] <= group[pixel_index2*8+3+1][7:0];
            group[pixel_index2*8+4][7:0]   <= group[pixel_index2*8+4][15:8];
            group[pixel_index2*8+4][15:8]  <= group[pixel_index2*8+4][23:16];
            group[pixel_index2*8+4][23:16] <= group[pixel_index2*8+4][31:24];
            group[pixel_index2*8+4][31:24] <= group[pixel_index2*8+4+1][7:0];
            group[pixel_index2*8+5][7:0]   <= group[pixel_index2*8+5][15:8];
            group[pixel_index2*8+5][15:8]  <= group[pixel_index2*8+5][23:16];
            group[pixel_index2*8+5][23:16] <= group[pixel_index2*8+5][31:24];
            group[pixel_index2*8+5][31:24] <= group[pixel_index2*8+5+1][7:0];
            group[pixel_index2*8+6][7:0]   <= group[pixel_index2*8+6][15:8];
            group[pixel_index2*8+6][15:8]  <= group[pixel_index2*8+6][23:16];
            group[pixel_index2*8+6][23:16] <= group[pixel_index2*8+6][31:24];
            group[pixel_index2*8+6][31:24] <= group[pixel_index2*8+6+1][7:0];
            group[pixel_index2*8+7][7:0]   <= group[pixel_index2*8+7][15:8];
            group[pixel_index2*8+7][15:8]  <= group[pixel_index2*8+7][23:16];
            group[pixel_index2*8+7][23:16] <= group[pixel_index2*8+7][31:24];
            group[pixel_index2*8+7][31:24] <= group_preload[pixel_index2][7:0];
          end
      else
        for (pixel_index2 = 0; pixel_index2 < 32; pixel_index2 = pixel_index2 + 1)
          begin
            group[pixel_index2*8]   <= group[pixel_index2*8]  ;
            group[pixel_index2*8+1] <= group[pixel_index2*8+1];
            group[pixel_index2*8+2] <= group[pixel_index2*8+2];
            group[pixel_index2*8+3] <= group[pixel_index2*8+3];
            group[pixel_index2*8+4] <= group[pixel_index2*8+4];
            group[pixel_index2*8+5] <= group[pixel_index2*8+5];
            group[pixel_index2*8+6] <= group[pixel_index2*8+6];
            group[pixel_index2*8+7] <= group[pixel_index2*8+7];
          end
    end
  
  // group_preload
  always @(posedge Bus2IP_Clk)
    begin
      if (state == BRAM_EXTRACT || state == MATCHING_COMPUTE && group_col[1:0] == 2'b11)
        for (pixel_index2 = 0; pixel_index2 < 32; pixel_index2 = pixel_index2 + 1)
          group_preload[pixel_index2] <= bram_out[(pixel_index2 + group_row[5:0]) % 64];
      else if (state == MATCHING_COMPUTE)
        for (pixel_index2 = 0; pixel_index2 < 32; pixel_index2 = pixel_index2 + 1)
          begin
            group_preload[pixel_index2][7:0]   <= group_preload[pixel_index2][15:8];
            group_preload[pixel_index2][15:8]  <= group_preload[pixel_index2][23:16];
            group_preload[pixel_index2][23:16] <= group_preload[pixel_index2][31:24];
            group_preload[pixel_index2][31:24] <= 0;
          end
      else
        for (pixel_index2 = 0; pixel_index2 < 32; pixel_index2 = pixel_index2 + 1)
          group_preload[pixel_index2] <= group_preload[pixel_index2];
    end
    
  begin: Adder_Tree
  
  wire       [8 : 0]                        f_pixel[1023:0];
  wire       [8 : 0]                        g_pixel[1023:0];
  wire       [8 : 0]                        diff[1023:0];
  reg        [8 : 0]                        abs_diff[1023:0];
  wire       [9 : 0]                        part_sum1[511:0];
  wire       [10 : 0]                       part_sum2[255:0];
  reg        [11 : 0]                       part_sum3[127:0];
  wire       [12 : 0]                       part_sum4[63:0];
  wire       [13 : 0]                       part_sum5[31:0];
  reg        [14 : 0]                       part_sum6[15:0];
  wire       [15 : 0]                       part_sum7[7:0];
  wire       [16 : 0]                       part_sum8[3:0];
  reg        [17 : 0]                       part_sum9[1:0];
  
  assign sad = part_sum9[0] + part_sum9[1];
  
  // f_pixel
  genvar fpixel_index;
  generate
    for ( fpixel_index = 0; fpixel_index <= 255; fpixel_index = fpixel_index+1 )
	    begin: g00
        assign f_pixel[{fpixel_index, 2'b00}] = {1'b0, face1[fpixel_index][31:24]};
        assign f_pixel[{fpixel_index, 2'b01}] = {1'b0, face1[fpixel_index][23:16]};
        assign f_pixel[{fpixel_index, 2'b10}] = {1'b0, face1[fpixel_index][15:8]};
        assign f_pixel[{fpixel_index, 2'b11}] = {1'b0, face1[fpixel_index][7:0]};
		end
  endgenerate
  
  // g_pixel
  genvar gpixel_index;
  generate
    for ( gpixel_index = 0; gpixel_index <= 255; gpixel_index = gpixel_index+1 )
	    begin: g01
        assign g_pixel[{gpixel_index, 2'b00}] = {1'b0, group[gpixel_index][31:24]};
        assign g_pixel[{gpixel_index, 2'b01}] = {1'b0, group[gpixel_index][23:16]};
        assign g_pixel[{gpixel_index, 2'b10}] = {1'b0, group[gpixel_index][15:8]};
        assign g_pixel[{gpixel_index, 2'b11}] = {1'b0, group[gpixel_index][7:0]};
		end
  endgenerate
  
  // diff
  genvar diff_index;
  generate
    for ( diff_index = 0; diff_index <= 1023; diff_index = diff_index+1 )
	    begin: g02
        assign diff[diff_index] = f_pixel[diff_index] - g_pixel[diff_index];
      end
  endgenerate
  
  // abs_diff
  integer abs_index;
  always @( posedge Bus2IP_Clk )
    begin
		  for ( abs_index = 0; abs_index <= 1023; abs_index = abs_index+1 )
		    abs_diff[abs_index] <= (diff[abs_index][8] == 1'b1) ? -diff[abs_index] : diff[abs_index];
    end
	 
	 
  // part_sum1
  genvar psum1_index;
  generate
    for ( psum1_index = 0; psum1_index <= 511; psum1_index = psum1_index+1 )
	    begin: g1
		    assign part_sum1[psum1_index] = abs_diff[{psum1_index, 1'b0}] + abs_diff[{psum1_index, 1'b1}];
		end
  endgenerate
	
	
  // part_sum2
  genvar psum2_index;
  generate
    for ( psum2_index = 0; psum2_index <= 255; psum2_index = psum2_index+1 )
	    begin: g2
        assign part_sum2[psum2_index] = part_sum1[{psum2_index, 1'b0}] + part_sum1[{psum2_index, 1'b1}];
		end
  endgenerate	
  
  
  // part_sum3
  integer psum3_index;
  always @( posedge Bus2IP_Clk )
    begin
		  for ( psum3_index = 0; psum3_index <= 127; psum3_index = psum3_index+1 )
        part_sum3[psum3_index] <= part_sum2[{psum3_index, 1'b0}] + part_sum2[{psum3_index, 1'b1}];
    end
	
	
  // part_sum4
  genvar psum4_index;
  generate
    for ( psum4_index = 0; psum4_index <= 63; psum4_index = psum4_index+1 )
      begin: g3
        assign part_sum4[psum4_index] = part_sum3[{psum4_index, 1'b0}] + part_sum3[{psum4_index, 1'b1}];
		end
  endgenerate	
	
	
  // part_sum5
  genvar psum5_index;
  generate
    for ( psum5_index = 0; psum5_index <= 31; psum5_index = psum5_index+1 )
      begin: g4
        assign part_sum5[psum5_index] = part_sum4[{psum5_index, 1'b0}] + part_sum4[{psum5_index, 1'b1}];
		end
  endgenerate	
  
  
  // part_sum6
  integer psum6_index;
  always @( posedge Bus2IP_Clk )
    begin
		  for ( psum6_index = 0; psum6_index <= 15; psum6_index = psum6_index+1 )
        part_sum6[psum6_index] <= part_sum5[{psum6_index, 1'b0}] + part_sum5[{psum6_index, 1'b1}];
    end
	
	
  // part_sum7
  genvar psum7_index;
  generate
    for ( psum7_index = 0; psum7_index <= 7; psum7_index = psum7_index+1 )
      begin: g5
        assign part_sum7[psum7_index] = part_sum6[{psum7_index, 1'b0}] + part_sum6[{psum7_index, 1'b1}];
      end
  endgenerate	
	
	
  // part_sum8
  genvar psum8_index;
  generate
    for ( psum8_index = 0; psum8_index <= 3; psum8_index = psum8_index+1 )
      begin: g6
        assign part_sum8[psum8_index] = part_sum7[{psum8_index, 1'b0}] + part_sum7[{psum8_index, 1'b1}];
		end
  endgenerate	
  
  
  // part_sum9
  integer psum9_index;
  always @( posedge Bus2IP_Clk )
    begin
      for ( psum9_index = 0; psum9_index <= 1; psum9_index = psum9_index+1 )
        part_sum9[psum9_index] <= part_sum8[{psum9_index, 1'b0}] + part_sum8[{psum9_index, 1'b1}];
    end
  
  end

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
              slv_reg9 <= min_sad2;
              slv_reg10 <= min_x2;
              slv_reg11 <= min_y2;
              slv_reg12 <= min_sad3;
              slv_reg13 <= min_x3;
              slv_reg14 <= min_y3;
              slv_reg15 <= min_sad4;
              slv_reg16 <= min_x4;
              slv_reg17 <= min_y4;
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
