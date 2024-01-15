`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2023 03:20:56 PM
// Design Name: 
// Module Name: Ni et al.'s design
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Area: 6 LUT per 3 bit multiplermm 4 3bit multipliers + 18 LUTs adder
// so 42 LUTs per 6 bit multiplier, 52 LUts for 7 bit multiplier
// mults total: 84+52=136
// adders total: 75=6+6+18+12+14+19 for multiplier total, 
// Kred: LUT: 12
// 10+12+12= 33 LUts
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Kred_mod_mult(
    input clk,
    input [11:0] a,
    input [11:0] b,
    output [11:0] c_mod_q
    );
    
(* use_dsp = "yes" *) reg [23:0] high_reg;


always @(posedge clk) begin
    high_reg <= a*b;

end

// stage 1
function [15:0] LUT_parameter;
 input [3:0] LUT_index;
 integer i;
 integer full_output;
 begin
    for (i=0; i<16; i=i+1) begin
        full_output = (3329-((13*(i << 20)) % 3329)) % 3329;
        LUT_parameter[i] = full_output[LUT_index];
    end
 end
endfunction

wire [11:0] LUT_out;

generate
    genvar i;
   // LUT6: 6-input Look-Up Table with general output
   //       Virtex-7
   // Xilinx HDL Language Template, version 2020.2
    for (i=0; i<12; i=i+1) begin: LUTS
      LUT4 #(
     .INIT(LUT_parameter(i))  // Specify LUT Contents
      ) LUT4_inst (
             .O(LUT_out[i]),   // LUT general output
         .I0(high_reg[20]), // LUT input
         .I1(high_reg[21]), // LUT input
         .I2(high_reg[22]), // LUT input
         .I3(high_reg[23])
        ); // LUT input
    end
endgenerate



//stage 3
wire [13:0] Kred_upper;
wire [10:0] Kred_lower;


assign Kred_upper =  high_reg[19:8] - {2'b0, high_reg[7:0], 3'b0};
assign Kred_lower = {2'b0, high_reg[7:0]} + {high_reg[7:0], 2'b0};
 
wire [13:0] Kred_result;
assign Kred_result = Kred_upper - Kred_lower;

reg [13:0] Kred_result_reg;
reg [11:0] LUT_out_reg;
always @(posedge clk) begin
    Kred_result_reg <= Kred_result;
    LUT_out_reg <= LUT_out;
end

wire [13:0] total_sum;
assign total_sum = Kred_result_reg + LUT_out_reg;

wire [12:0] plus_or_minus_q;
assign plus_or_minus_q = (total_sum[13] ? 12'hd01 : 0);

wire [12:0] thirteen_bit_reduced;

assign thirteen_bit_reduced = total_sum + plus_or_minus_q;

reg [12:0] thirteen_bit_reduced_reg;
always @(posedge clk) begin
    thirteen_bit_reduced_reg <= thirteen_bit_reduced;
end

wire [12:0] subtracted;

assign subtracted = thirteen_bit_reduced_reg - 12'hd01;

wire [11:0] twelve_bit_reduced;
wire [12:0] subtracted_2;
assign twelve_bit_reduced = subtracted[12] ? thirteen_bit_reduced_reg : subtracted;




assign subtracted_2 = {1'b0, twelve_bit_reduced} - 12'hd01;

assign c_mod_q = subtracted_2[12] ? twelve_bit_reduced : subtracted_2;


endmodule