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


module K2_mod_mult(
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



wire [10:0] eleven_bit_temp_sum;
assign eleven_bit_temp_sum = {high_reg[7:0], 2'b0} + high_reg[7:0];

wire [11:0] twelve_bit_temp_sum = eleven_bit_temp_sum + {high_reg[7:0], 3'b0};

wire [16:0] t1 = high_reg[23:8] - twelve_bit_temp_sum;

wire [6:0] seven_bit_temp_sum;
assign seven_bit_temp_sum = {t1[3:0], 2'b0} + t1[3:0];

wire [11:0] eight_bit_temp_sum = seven_bit_temp_sum + {t1[3:0], 3'b0};

wire [12:0] raw_result = t1[16:4] - {eight_bit_temp_sum, 4'b0};

wire [12:0] t1_plus_q =  raw_result + 12'hd01;
assign c_mod_q = raw_result[12] ? t1_plus_q[11:0] : raw_result[11:0];


endmodule