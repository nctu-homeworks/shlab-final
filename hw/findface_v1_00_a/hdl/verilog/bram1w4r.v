`include "bram2p.v"

module bram1w4r
#(parameter DATA_WIDTH = 32, RAM_SIZE = 1024)
 (clk,
  we, waddr, data_i,
  raddr1, data_o1,
  raddr2, data_o2,
  raddr3, data_o3,
  raddr4, data_o4);

input									clk, we;
input		[31:0]					waddr, raddr1, raddr2, raddr3, raddr4;
input 	[DATA_WIDTH-1 : 0]	data_i;
output 	[DATA_WIDTH-1 : 0]	data_o1, data_o2, data_o3, data_o4;


bram2p bram1(
	.clka(clk), .wea(we), .ena(1'b1), .addra(waddr), .data_ia(data_i), .data_oa(),
	.clkb(clk), .web(1'b0), .enb(1'b1), .addrb(raddr1), .data_ib(32'd0), .data_ob(data_o1)
);

bram2p bram2(
	.clka(clk), .wea(we), .ena(1'b1), .addra(waddr), .data_ia(data_i), .data_oa(),
	.clkb(clk), .web(1'b0), .enb(1'b1), .addrb(raddr2), .data_ib(32'd0), .data_ob(data_o2)
);

bram2p bram3(
	.clka(clk), .wea(we), .ena(1'b1), .addra(waddr), .data_ia(data_i), .data_oa(),
	.clkb(clk), .web(1'b0), .enb(1'b1), .addrb(raddr3), .data_ib(32'd0), .data_ob(data_o3)
);

bram2p bram4(
	.clka(clk), .wea(we), .ena(1'b1), .addra(waddr), .data_ia(data_i), .data_oa(),
	.clkb(clk), .web(1'b0), .enb(1'b1), .addrb(raddr4), .data_ib(32'd0), .data_ob(data_o4)
);

endmodule
