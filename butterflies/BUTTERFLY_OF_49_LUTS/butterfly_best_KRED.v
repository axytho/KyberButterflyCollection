`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2023 03:20:56 PM
// Design Name: 
// Module Name: KRED design similar to Ni et al., adapted to minimize area more effectively
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module butterfly_best_KRED(
    input clk,
    input [11:0] a,
    input [11:0] b,
    output [11:0] c_mod_q
    );   
//stage 0    
reg [23:0] high_reg;
always @(posedge clk) begin
    high_reg <= a*b;
end
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
wire [18:0] LUT_reduced;
assign LUT_reduced = high_reg[17:0] + LUT_out;
reg [18:0] LUT_reduced_reg;
always @(posedge clk) begin
    LUT_reduced_reg <= LUT_reduced;
end
//stage 2
wire [13:0] Kred_upper;
wire [10:0] Kred_lower;
assign Kred_upper =  LUT_reduced_reg[18:8] - {2'b0, LUT_reduced_reg[7:0], 3'b0};
assign Kred_lower = {2'b0, LUT_reduced_reg[7:0]} + {LUT_reduced_reg[7:0], 2'b0};
wire [12:0] Kred_result;
assign Kred_result = Kred_upper - Kred_lower;
reg [12:0] Kred_result_reg;
always @(posedge clk) begin
    Kred_result_reg <= Kred_result;
end
//stage 3
wire [12:0] total_sum;
assign total_sum = Kred_result_reg;
wire [12:0] plus_or_zero_q;
assign plus_or_zero_q = (total_sum[12] ? 12'hd01 : 0);
assign c_mod_q = total_sum + plus_or_zero_q;
endmodule