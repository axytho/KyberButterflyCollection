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


module KDSP(
    input clk,
    input [11:0] a,
    input [11:0] b,
    output [11:0] c_mod_q
    );
    
wire [11:0] high;
wire [11:0] low;
wire [13:0] med;
wire [6:0] med_a_sum;
wire [6:0] med_b_sum;

reg [11:0] high_reg;
reg [11:0] low_reg;
reg [13:0] med_reg;
    
six_bit_multiplier high_mult(a[11:6], b[11:6], high);

six_bit_multiplier low_mult(a[5:0], b[5:0], low);

assign med_a_sum = a[11:6] + a[5:0];
assign med_b_sum = b[11:6] + b[5:0];
seven_bit_multiplier middle_mult(med_a_sum, med_b_sum, med);

always @(posedge clk) begin
    high_reg <= high;
    low_reg <= low;
    med_reg <= med;
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
   // LUT6: 6-input Look-Up Table with general output
   //       Virtex-7
   // Xilinx HDL Language Template, version 2020.2
    for (i=0; i<12; i=i+1) begin: LUTS
      LUT6 #(
     .INIT(LUT_parameter(i))  // Specify LUT Contents
      ) LUT6_inst (
             .O(LUT_out[i]),   // LUT general output
         .I0(high_reg[6]), // LUT input
         .I1(high_reg[7]), // LUT input
         .I2(high_reg[8]), // LUT input
         .I3(high_reg[9]), // LUT input
         .I4(high_reg[10]), // LUT input
         .I5(high_reg[11])  // LUT input
      );
    end
endgenerate


wire [17:0] concat_out;
wire [12:0] low_plus_high;
wire [18:0] concat_plus_lut;
wire [11:0] c_mod_abs_q;
reg [12:0] low_plus_high_reg;
reg [18:0] concat_plus_lut_reg;
reg [13:0] med_reg_2;
assign low_plus_high = low_reg + high_reg;
assign concat_out = {high_reg[5:0], low_reg[11:0]};
assign concat_plus_lut = concat_out + {6'b0, LUT_out};
always @(posedge clk) begin
    low_plus_high_reg <= low_plus_high;
    concat_plus_lut_reg <= concat_plus_lut;
    med_reg_2 <= med_reg;
end


//stage 2
wire [14:0] middle_terms;
assign middle_terms = med_reg_2 - {1'b0, low_plus_high_reg};
wire [20:0] karatsuba_result;
assign karatsuba_result = {2'b0, concat_plus_lut} + {middle_terms , 6'b0};
reg [20:0] karatsuba_result_reg;
always @(posedge clk) begin
    karatsuba_result_reg <= karatsuba_result;
end

//stage 3
wire [12:0] Kred_upper;
wire [9:0] Kred_lower;

assign Kred_upper = karatsuba_result_reg[19:8] - {5'b0, karatsuba_result_reg[7:0]};
assign Kred_lower = {1'b0, karatsuba_result_reg[7:0]} + {karatsuba_result_reg[7:0], 1'b0};

wire [12:0] Kred_result;
assign Kred_result = {1'b0, Kred_lower, 2'b0} - Kred_upper;

assign c_mod_abs_q = Kred_result[11:0];
assign signed_bit_c = Kred_result[12] ^ karatsuba_result_reg[20];

reg [11:0] c_mod_abs_q_reg, c_mod_abs_q_reg_2;
reg signed_bit_c_reg;
always @(posedge clk) begin
    c_mod_abs_q_reg <= c_mod_abs_q;
    signed_bit_c_reg <= signed_bit_c;
end

always @(posedge clk) begin
    if (signed_bit_c_reg == 1'b1) begin
        c_mod_abs_q_reg_2 <= c_mod_abs_q_reg + 12'd3329;
    end else begin
        c_mod_abs_q_reg_2 <= c_mod_abs_q_reg;
    end
end
assign c_mod_q = c_mod_abs_q_reg_2;
endmodule
