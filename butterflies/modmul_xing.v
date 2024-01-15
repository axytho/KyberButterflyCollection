`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ahmet Can Mert <ahmetcanmert@sabanciuniv.edu>, adapted by Jonas Bertels
//  for comparison purposes, utilizing Xing's reduction circuit
// Create Date: 11/21/2023 01:41:48 PM
// Design Name: 
// Module Name: modmul_xing
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: To the extent possible under law, the implementer has waived all copyright
// and related or neighboring rights to the source code in this file.
// http://creativecommons.org/publicdomain/zero/1.0/
// 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module modmul_xing(input         clk,rst,
              input  [11:0] A,B,
              output [11:0] R);

wire [23:0] P;
reg  [23:0] P_R;

intmul im0(A,B,P);

always @(posedge clk or posedge rst) begin
    if(rst) begin
        P_R <= 0;
    end
    else begin
        P_R <= P;
    end
end

// ---------------------------------------

reduction_xing mr0(P_R,R);

endmodule
