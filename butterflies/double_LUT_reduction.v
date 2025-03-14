`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2023 03:20:56 PM
// Design Name: 
// Module Name: K-DSP
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


module double_LUT_reduction(
    input clk,
    input [11:0] a,
    input [11:0] b,
    output [11:0] c_mod_q
    );



    
(* use_dsp = "yes" *) reg [23:0] high_reg;


always @(posedge clk) begin
    high_reg <= a*b;

end

wire [23:0] LUT_input;
assign LUT_input = high_reg;

// stage 1
function [63:0] LUT_lower_bits;
 input [3:0] LUT_lower;
 integer k;
 integer full_output_low;
 begin
    for (k=0; k<64; k=k+1) begin
        full_output_low = (k << 12) % 3329;
        LUT_lower_bits[k] = full_output_low[LUT_lower];
    end
 end
endfunction

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
wire [11:0] LUT_out_low;

generate
    genvar k;
   // LUT6: 6-input Look-Up Table with general output
   //       Virtex-7
   // Xilinx HDL Language Template, version 2020.2
    for (k=0; k<12; k=k+1) begin: LUTS_new
     LUT6 #(
     .INIT(LUT_lower_bits(k))  // Specify LUT Contents
      ) LUT6_inst_low (
             .O(LUT_out_low[k]),   // LUT general output
         .I0(LUT_input[12]), // LUT input
         .I1(LUT_input[13]), // LUT input
         .I2(LUT_input[14]), // LUT input
         .I3(LUT_input[15]), // LUT input
         .I4(LUT_input[16]), // LUT input
         .I5(LUT_input[17])  // LUT input
      );
    end
endgenerate


generate
    genvar i;
   // LUT6: 6-input Look-Up Table with general output
   //       Virtex-7
   // Xilinx HDL Language Template, version 2020.2
    for (i=0; i<12; i=i+1) begin: LUTS
      LUT6 #(
     .INIT(LUT_parameter(i))  // Specify LUT Contents
      ) LUT6_inst (
             .O(LUT_out[i]),   // LUT general output
         .I0(LUT_input[18]), // LUT input
         .I1(LUT_input[19]), // LUT input
         .I2(LUT_input[20]), // LUT input
         .I3(LUT_input[21]), // LUT input
         .I4(LUT_input[22]), // LUT input
         .I5(LUT_input[23])  // LUT input
      );
      
    end
endgenerate






wire [13:0] sum;
assign sum = LUT_out + LUT_out_low+high_reg[11:0];



reg [13:0] thirteen_bit_reduced_reg;
always @(posedge clk) begin
    thirteen_bit_reduced_reg <= sum;
end

wire [13:0] subtracted;

assign subtracted = thirteen_bit_reduced_reg - ((12'hd01) << 1);

wire [12:0] twelve_bit_reduced;
wire [13:0] subtracted_2;
assign twelve_bit_reduced = subtracted[13] ? thirteen_bit_reduced_reg : subtracted;




assign subtracted_2 = {1'b0, twelve_bit_reduced} - 13'hd01;

assign c_mod_q = subtracted_2[13] ? twelve_bit_reduced : subtracted_2;


endmodule
