`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
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


module six_bit_multiplier(
    input [5:0] a,
    input [5:0] b,
    output [11:0] c
    );
    
wire [5:0] high;
wire [5:0] low;
wire [5:0] med_high;
wire [5:0] med_low;

three_bit_multiplier mult0(a[2:0], b[2:0],low);
three_bit_multiplier mult1(a[2:0], b[5:3],med_low);
three_bit_multiplier mult2(a[5:3], b[2:0],med_high);
three_bit_multiplier mult3(a[5:3], b[5:3],high);

wire [6:0] medium_sum;
assign medium_sum = med_low + med_high;
wire [6:0] med_reg;
wire [5:0] high_reg;
assign med_reg = medium_sum[5:0] + {3'b0,low[5:3]};
assign high_reg = high + {2'b0, medium_sum[6]|med_reg[6],med_reg[5:3]};
assign c[2:0] = low[2:0];
assign c[5:3] = med_reg[2:0];
assign c[11:6] = high_reg;


endmodule
