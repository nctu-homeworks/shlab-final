module face (
  Bus2IP_Clk,
  face_data,
  group_data,
  sad
);

  input wire                                Bus2IP_Clk;
  input wire [8*32*32-1 : 0]                face_data, group_data;
  output wire[31 : 0]                       sad;

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
  
  // f_pixel, g_pixel, diff
  genvar pixel_index;
  generate
    for ( pixel_index = 0; pixel_index <= 255; pixel_index = pixel_index+1 )
	    begin: g0
        assign f_pixel[{pixel_index, 2'b00}] = {1'b0, face_data[{pixel_index, 2'b0000} +: 8]};
        assign f_pixel[{pixel_index, 2'b01}] = {1'b0, face_data[{pixel_index, 2'b0100} +: 8]};
        assign f_pixel[{pixel_index, 2'b10}] = {1'b0, face_data[{pixel_index, 2'b1000} +: 8]};
        assign f_pixel[{pixel_index, 2'b11}] = {1'b0, face_data[{pixel_index, 2'b1100} +: 8]};
        
        assign g_pixel[{pixel_index, 2'b00}] = {1'b0, group_data[{pixel_index, 2'b0000} +: 8]};
        assign g_pixel[{pixel_index, 2'b01}] = {1'b0, group_data[{pixel_index, 2'b0100} +: 8]};
        assign g_pixel[{pixel_index, 2'b10}] = {1'b0, group_data[{pixel_index, 2'b1000} +: 8]};
        assign g_pixel[{pixel_index, 2'b11}] = {1'b0, group_data[{pixel_index, 2'b1100} +: 8]};
        
        assign diff[{pixel_index, 2'b00}] = f_pixel[{pixel_index, 2'b00}] - g_pixel[{pixel_index, 2'b00}];
        assign diff[{pixel_index, 2'b01}] = f_pixel[{pixel_index, 2'b01}] - g_pixel[{pixel_index, 2'b01}];
        assign diff[{pixel_index, 2'b10}] = f_pixel[{pixel_index, 2'b10}] - g_pixel[{pixel_index, 2'b10}];
        assign diff[{pixel_index, 2'b11}] = f_pixel[{pixel_index, 2'b11}] - g_pixel[{pixel_index, 2'b11}];
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
   
endmodule
