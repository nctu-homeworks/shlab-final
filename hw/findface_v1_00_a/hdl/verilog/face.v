module face (
  clk,
  rst,
  clr,
  load_data,
  group_data,
  min_x,
  min_y,
  min_sad
);

input wire                               clk, rst, clr;
input wire    [8*32*32-1 : 0]            load_data, group_data;
output reg    [31 : 0]                   min_x, min_y, min_sad;


endmodule
