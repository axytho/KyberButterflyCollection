
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


module two_bit_multiplier(
    input [1:0] a,
    input [1:0] b,
    output [3:0] c
    );
    
wire [2:0] first_stage;
wire second_stage;


assign c[0] = a[0] & b[0];
assign first_stage[0] = a[0] & b[1];
assign first_stage[1] = a[1] & b[0];
assign first_stage[2] = a[1] & b[1];

    
assign {second_stage, c[1]} = first_stage[0] + first_stage[1];
assign c[3:2] = second_stage + first_stage[2];

endmodule
