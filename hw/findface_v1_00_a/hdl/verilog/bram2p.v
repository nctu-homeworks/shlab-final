//
// This module show you how to infer a two-port 1024x32 BRAM in
// your circuit using the standard Verilog code.
//

module bram2p
#(parameter DATA_WIDTH = 32, RAM_SIZE = 1024)
 (clka, wea, ena, addra, data_ia, data_oa,    // BRAM port A
  clkb, web, enb, addrb, data_ib, data_ob);   // BRAM port B

input  clka, wea, ena;
input  clkb, web, enb;
input  [31:0] addra, addrb;
input  [DATA_WIDTH-1 : 0] data_ia, data_ib;
output [DATA_WIDTH-1 : 0] data_oa, data_ob;
reg    [DATA_WIDTH-1 : 0] data_oa, data_ob;
reg    [DATA_WIDTH-1 : 0] RAM [RAM_SIZE - 1:0];

// ------------------------------------
// BRAM Port-A read operation
// ------------------------------------
always@(posedge clka)
begin
  if (ena & wea)
    data_oa <= data_ia;
  else
    data_oa <= RAM[addra];
end

// ------------------------------------
// BRAM Port-B read operation
// ------------------------------------
always@(posedge clkb)
begin
  if (enb & web)
    data_ob <= data_ib;
  else
    data_ob <= RAM[addrb];
end

// ------------------------------------
// BRAM Port-A write operation
// ------------------------------------
always@(posedge clka)
begin
  if (ena & wea)
    RAM[addra] <= data_ia;
end

// ------------------------------------
// BRAM Port-A write operation
// ------------------------------------
always@(posedge clkb)
begin
  if (enb & web)
    RAM[addrb] <= data_ib;
end

endmodule
