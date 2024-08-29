`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2024 02:58:08 PM
// Design Name: 
// Module Name: conditional_add
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


module conditional_add(
    input clk,
    input [12:0] total_sum,
    output [11:0] c_mod_q
    );   
    
//stage 3
wire [12:0] plus_or_zero_q;
assign plus_or_zero_q = (total_sum[12] ? 12'hd01 : 0);
assign c_mod_q = total_sum + plus_or_zero_q;
endmodule 

