`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2024 05:57:16 PM
// Design Name: 
// Module Name: best_LUT6_reduction_only
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module best_LUT6_reduction_only(
    input clk,
    input [23:0] high_reg,
    output [18:0] LUT_reduced
    );

// stage 1
function [63:0] LUT_parameter;
 input [3:0] LUT_index;
 integer i;
 integer full_output;
 begin
    for (i=0; i<64; i=i+1) begin
        full_output = (i << 18) % 3329;
        LUT_parameter[i] = full_output[LUT_index];
    end
 end
endfunction
wire [11:0] LUT_out;
generate
    genvar i;
    for (i=0; i<12; i=i+1) begin: LUTS
      LUT6 #(
     .INIT(LUT_parameter(i))  // Specify LUT Contents
      ) LUT6_inst (
             .O(LUT_out[i]),   // LUT general output
         .I0(high_reg[18]), // LUT input
         .I1(high_reg[19]), // LUT input
         .I2(high_reg[20]), // LUT input
         .I3(high_reg[21]), // LUT input
         .I4(high_reg[22]), // LUT input
         .I5(high_reg[23])  // LUT input
      );
    end
endgenerate
assign LUT_reduced = high_reg[17:0] + LUT_out;
endmodule