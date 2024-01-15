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


module seven_bit_multiplier(
    input [6:0] a,
    input [6:0] b,
    output [13:0] c
    );
    
wire [7:0] high;
wire [5:0] low;
wire [7:0] med_high;
wire [7:0] med_low;

three_bit_multiplier mult0(a[2:0], b[2:0],low);
four_bit_multiplier mult1({1'b0,a[2:0]}, b[6:3],med_low);
four_bit_multiplier mult2(a[6:3], {1'b0,b[2:0]},med_high);
four_bit_multiplier mult3(a[6:3], b[6:3],high);


wire [8:0] medium_sum;
assign medium_sum = med_low + med_high;
wire [8:0] med_reg;
wire [7:0] high_reg;
assign med_reg = medium_sum[8:0] + {6'b0,low[5:3]};
assign high_reg = high + {2'b0,med_reg[8:3]};
assign c[2:0] = low[2:0];
assign c[5:3] = med_reg[2:0];
assign c[13:6] = high_reg[7:0];


endmodule
