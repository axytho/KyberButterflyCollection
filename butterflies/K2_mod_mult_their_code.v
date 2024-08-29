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


module K2_mod_mult_their_code(
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


  wire [7:0] kred_c0_tmp;
  wire [16:0] kred_c1_tmp;
  wire [12:0] kred_mul_tmp;
  wire [16:0] kred_mul_tmp1;
  wire [16:0] kred_c_tmp;
  wire [3:0] kred_c0;
  wire [12:0] kred_c1;
  //wire [8:0] kred_mul_kc0_tmp;
  wire [12:0] kred_mul_kc0;
  wire [12:0] kred_res_tmp;


  assign kred_c0_tmp = high_reg[7:0];
  assign kred_c1_tmp = high_reg[23:8];
  assign kred_mul_tmp = kred_c0_tmp * (-13);
  assign kred_mul_tmp1 = {{4{kred_mul_tmp[12]}},kred_mul_tmp};
  assign kred_c_tmp = kred_mul_tmp1 + kred_c1_tmp;
  assign kred_c0 = kred_c_tmp[3:0];
  assign kred_c1 = kred_c_tmp[16:4];
  //assign kred_mul_kc0_tmp = kred_c0 * (-13);
  //assign kred_mul_kc0 = {kred_mul_kc0_tmp,4'b0};
  assign kred_mul_kc0 = kred_c0 * (-208);
  assign kred_res_tmp = kred_mul_kc0 + kred_c1;
  
  
  wire [12:0] kred_res;
  wire [12:0] ibf_c_cmp;
  assign kred_res = kred_res_tmp[12:0];
  

  assign ibf_c_cmp = kred_res + 3329;
  assign c_mod_q = kred_res[12] ? ibf_c_cmp[11:0] : kred_res[11:0];


endmodule