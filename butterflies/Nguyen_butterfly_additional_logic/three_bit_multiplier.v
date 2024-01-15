`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jonas Bertels (Based on a design by Trong-Hung Nguyen)
// 
// Create Date: 10/15/2023 03:20:56 PM
// Design Name: 
// Module Name: Nguyen_butterfly
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module three_bit_multiplier(
    input [2:0] a,
    input [2:0] b,
    output [5:0] c
    );
    
wire [7:0] first_stage;
wire [5:0] second_stage;
wire carry_0;
wire carry_1;


assign c[0] = a[0] & b[0];
assign first_stage[0] = a[0] & b[1];
assign first_stage[1] = a[1] & b[0];
assign first_stage[2] = a[0] & b[2];
assign first_stage[3] = a[1] & b[1];
assign first_stage[4] = a[2] & b[0];

assign first_stage[5] = a[1] & b[2];
assign first_stage[6] = a[2] & b[1];
assign first_stage[7] = a[2] & b[2];
assign second_stage[1:0] = first_stage[0] + first_stage[1];
assign second_stage[3:2] = first_stage[2] + first_stage[3]+first_stage[4];
assign second_stage[5:4] = first_stage[6] + first_stage[5];
    
assign c[1] = second_stage[0];
assign {carry_0,c[2]} = second_stage[1] + second_stage[2];
assign {carry_1,c[3]} = second_stage[3] + second_stage[4] + carry_0; 
assign c[5:4] = first_stage[7] + second_stage[5] + carry_1;

endmodule
