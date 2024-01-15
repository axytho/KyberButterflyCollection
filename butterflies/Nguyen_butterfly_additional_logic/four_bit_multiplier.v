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


module four_bit_multiplier(
    input [3:0] a,
    input [3:0] b,
    output [7:0] c
    );
    
two_bit_multiplier mult0(a[1:0], b[1:0], first_stage[3:0]);
two_bit_multiplier mult1(a[1:0], b[3:2], first_stage[7:4]);
two_bit_multiplier mult2(a[3:2], b[1:0], first_stage[11:8]);
two_bit_multiplier mult3(a[3:2], b[3:2], first_stage[15:12]);


wire [15:0] first_stage;
wire [4:0] second_stage;
wire [4:0] third_stage;
wire [4:0] fourth_stage;

assign c[1:0] = first_stage[1:0];
assign second_stage[4:0] = first_stage[7:4] + first_stage[11:8];
assign third_stage[4:0] = second_stage[3:0] + {2'b0,first_stage[3:2]};
assign c[3:2] = third_stage[1:0];
assign fourth_stage = first_stage[15:12] + {1'b0, second_stage[4] | third_stage[4], third_stage[3:2]};
assign c[7:4] = fourth_stage[3:0];

endmodule
