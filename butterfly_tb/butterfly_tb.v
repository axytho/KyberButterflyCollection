`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: KU Leuven
// Engineer: Jonas Bertels
// 
// Create Date: 06/28/2022 11:55:54 AM
// Design Name: Butterfly Testbench
// Module Name: butterfly_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Test of butterfly circuits
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: https://creativecommons.org/publicdomain/zero/1.0/
// (Jonas Bertels has dedicated the work to the public domain by waiving all of his or her rights to the work worldwide under copyright law, 
// including all related and neighboring rights, to the extent allowed by law.
// You can copy, modify, distribute and perform the work, even for commercial purposes, 
// all without asking permission. See https://creativecommons.org/publicdomain/zero/1.0/)
// 
//////////////////////////////////////////////////////////////////////////////////

module butterfly_tb( );
`define TESTBENCH_SIZE  3329
`define MODULUS_WIDTH  12
`define STAGE_SIZE 8 
`define NO_OF_TWIDDLES_TESTED 256
reg clk;
reg CT, PWM, rst;
reg [`MODULUS_WIDTH:0] input_a, input_b, expected_output_a, expected_output_b;
wire [`MODULUS_WIDTH-1:0] output_a [0:`NO_OF_TWIDDLES_TESTED-1];
wire [`MODULUS_WIDTH-1:0] output_b [0:`NO_OF_TWIDDLES_TESTED-1]; //so we can test all outputs
wire [`MODULUS_WIDTH-1:0] output_a_XING [0:`NO_OF_TWIDDLES_TESTED-1];
wire [`MODULUS_WIDTH-1:0] output_b_XING [0:`NO_OF_TWIDDLES_TESTED-1];
wire [`MODULUS_WIDTH-1:0] output_a_NGUYEN [0:`NO_OF_TWIDDLES_TESTED-1];
wire [`MODULUS_WIDTH-1:0] output_b_NGUYEN [0:`NO_OF_TWIDDLES_TESTED-1];
wire [`MODULUS_WIDTH-1:0] output_a_NI [0:`NO_OF_TWIDDLES_TESTED-1];
wire [`MODULUS_WIDTH-1:0] output_b_NI [0:`NO_OF_TWIDDLES_TESTED-1];
wire [`MODULUS_WIDTH-1:0] output_a_BEST [0:`NO_OF_TWIDDLES_TESTED-1];
wire [`MODULUS_WIDTH-1:0] output_b_BEST [0:`NO_OF_TWIDDLES_TESTED-1];

always #5 clk=~clk;

function [`MODULUS_WIDTH-1:0] modular_pow;
 input [2*`MODULUS_WIDTH-1:0] base;
 input [`MODULUS_WIDTH-1:0] modulus, exponent;
 begin
     if (modulus == 1) begin
        modular_pow = 0;
     end else begin
        modular_pow = 1;
        while ( exponent > 0) begin
            if (exponent[0] == 1)
                modular_pow = ({20'b0,modular_pow} * base) % modulus;
            exponent = exponent >> 1;
            base = (base * base) % modulus;
        
        end
     end
 end
endfunction
function [`MODULUS_WIDTH-1:0] modular_mult;
 input [2*`MODULUS_WIDTH-1:0] input1;
 input [2*`MODULUS_WIDTH-1:0] input2;
 input [`MODULUS_WIDTH-1:0] modulus;
 begin

     modular_mult = (input1 * input2) % modulus;
 end
endfunction

function [`STAGE_SIZE-1:0] bit_inverse;
 input [`STAGE_SIZE-1:0] normal_order;
 integer index_bitreverse;
 begin
     for(index_bitreverse=0; index_bitreverse<(`STAGE_SIZE); index_bitreverse=index_bitreverse+1) begin
        bit_inverse[index_bitreverse] = normal_order[`STAGE_SIZE - 1-index_bitreverse];
     end
 end
endfunction


generate
    genvar i;
    for(i = 0; i < `NO_OF_TWIDDLES_TESTED; i=i+1) begin: BUTTERFLIES
        butterfly butterfly_mert(.clk(clk),.rst(rst),.CT(CT),.PWM(PWM),.A(input_a[`MODULUS_WIDTH-1:0]), .B(input_b[`MODULUS_WIDTH-1:0]), 
        .W(modular_mult(1,modular_pow(17,3329, i),3329)), 
		.E(output_a[i]),.O(output_b[i]));
		butterfly_xing butterfly_xing(.clk(clk),.rst(rst),.CT(CT),.PWM(PWM),.A(input_a[`MODULUS_WIDTH-1:0]), .B(input_b[`MODULUS_WIDTH-1:0]), 
        .W(modular_mult(1,modular_pow(17,3329, i),3329)), 
		.E(output_a_XING[i]),.O(output_b_XING[i]));
		Nguyen_butterfly butterfly_Nguyen(.clk(clk),.rst(rst),.CT(CT),.PWM(PWM),.A(input_a[`MODULUS_WIDTH-1:0]), .B(input_b[`MODULUS_WIDTH-1:0]), 
        .W(modular_mult(3073,modular_pow(17,3329, i),3329)), 
		.E(output_a_NGUYEN[i]),.O(output_b_NGUYEN[i]));
		butterfly_Ni butterfly_Ni(.clk(clk),.rst(rst),.CT(CT),.PWM(PWM),.A(input_a[`MODULUS_WIDTH-1:0]), .B(input_b[`MODULUS_WIDTH-1:0]), 
        .W(modular_mult(256,modular_pow(17,3329, i),3329)), 
		.E(output_a_NI[i]),.O(output_b_NI[i]));
		butterfly_Best butterfly_Best(.clk(clk),.rst(rst),.CT(CT),.PWM(PWM),.A(input_a[`MODULUS_WIDTH-1:0]), .B(input_b[`MODULUS_WIDTH-1:0]), 
        .W(modular_mult(256,modular_pow(17,3329, i),3329)), 
		.E(output_a_BEST[i]),.O(output_b_BEST[i]));
    end
endgenerate


/*initial begin
    $readmemh("input_a.txt", input_a_python);
    $readmemh("input_b.txt", input_b_python);
end*/
integer m, test_bench;
integer iterator_a, iterator_b;
integer iterator_a_XING, iterator_b_XING;
integer iterator_a_NGUYEN, iterator_b_NGUYEN;
integer iterator_a_NI, iterator_b_NI;
integer iterator_a_BEST, iterator_b_BEST;
initial begin: TEST_BUTTERFLY
    clk       = 0;
    rst = 1;
    PWM = 0;
    #10;
    rst = 0; 
    iterator_a = 0;
    iterator_b = 0;
    iterator_a_XING = 0;
    iterator_b_XING = 0;
    iterator_a_NGUYEN = 0;
    iterator_b_NGUYEN = 0;
    iterator_a_NI = 0;
    iterator_b_NI = 0;
    iterator_a_BEST = 0;
    iterator_b_BEST = 0;
    CT = 1;
    #100
    for(test_bench=0; test_bench<(`TESTBENCH_SIZE); test_bench=test_bench+1) begin
        //input_a = input_a_python[test_bench];
        //input_b = input_b_python[test_bench];
        input_a = 12'd3328;//3328 should trigger most edge cases
        input_b = test_bench;
        #100;
        for(m=0; m<(`NO_OF_TWIDDLES_TESTED); m=m+1) begin
            expected_output_a = (input_a + modular_mult(input_b, modular_mult(1,modular_pow(17,3329, m),3329), 3329)) % 3329;
            expected_output_b = (3329 + input_a - modular_mult(input_b, modular_mult(1,modular_pow(17,3329, m),3329), 3329)) % 3329;
            if(expected_output_a == output_a[m]) begin
                iterator_a = iterator_a+1;
            end
            else begin
                $display("a: Testbench: %d Index-%d --Expected :%d, Calculated:%d",test_bench, m,expected_output_a,output_a[m]);
            end
            if(expected_output_a == output_a_XING[m]) begin
                iterator_a_XING = iterator_a_XING+1;
            end
            else begin
                $display("a: Xing test: %d Index-%d --Expected :%d, Calculated:%d",test_bench, m,expected_output_a,output_a_XING[m]);
            end
            if(expected_output_a == output_a_NGUYEN[m]) begin
                iterator_a_NGUYEN = iterator_a_NGUYEN+1;
            end
            else begin
                $display("a: Nguyen test: %d Index-%d --Expected :%d, Calculated:%d",test_bench, m,expected_output_a,output_a_NGUYEN[m]);
            end
            if(expected_output_a == output_a_NI[m]) begin
                iterator_a_NI = iterator_a_NI+1;
            end
            else begin
                $display("a: Ni test: %d Index-%d --Expected :%d, Calculated:%d",test_bench, m,expected_output_a,output_a_NI[m]);
            end
            if(expected_output_a == output_a_BEST[m]) begin
                iterator_a_BEST = iterator_a_BEST+1;
            end
            else begin
                $display("a: Our test: %d Index-%d --Expected :%d, Calculated:%d",test_bench, m,expected_output_a,output_a_BEST[m]);
            end
            
            if(expected_output_b == output_b[m]) begin
                iterator_b = iterator_b+1;
            end
            else begin
                $display("b: Testbench: %d Index-%d -- Expected :%d, Calculated:%d",test_bench, m,expected_output_b,output_b[m]);
            end
            if(expected_output_b == output_b_XING[m]) begin
                iterator_b_XING = iterator_b_XING+1;
            end
            else begin
                $display("b: Xing test: %d Index-%d -- Expected :%d, Calculated:%d",test_bench, m,expected_output_b,output_b_XING[m]);
            end
            if(expected_output_b == output_b_NGUYEN[m]) begin
                iterator_b_NGUYEN = iterator_b_NGUYEN+1;
            end
            else begin
                $display("b: Nguyen test: %d Index-%d -- Expected :%d, Calculated:%d",test_bench, m,expected_output_b,output_b_NGUYEN[m]);
            end
            if(expected_output_b == output_b_NI[m]) begin
                iterator_b_NI = iterator_b_NI+1;
            end
            else begin
                $display("b: Ni test: %d Index-%d -- Expected :%d, Calculated:%d",test_bench, m,expected_output_b,output_b_NI[m]);
            end
            if(expected_output_b == output_b_BEST[m]) begin
                iterator_b_BEST = iterator_b_BEST+1;
            end
            else begin
                $display("b: Our test: %d Index-%d -- Expected :%d, Calculated:%d",test_bench, m,expected_output_b,output_b_BEST[m]);
            end
        end
        #100;
    end

	if(iterator_a == (`NO_OF_TWIDDLES_TESTED*`TESTBENCH_SIZE))
		$display("a: Mert Correct");
	else
		$display("a: Mert Incorrect");

	if(iterator_b == (`NO_OF_TWIDDLES_TESTED*`TESTBENCH_SIZE))
		$display("b: Mert Correct");
	else
		$display("b: Mert Incorrect");
	if(iterator_a_XING == (`NO_OF_TWIDDLES_TESTED*`TESTBENCH_SIZE))
		$display("a: Xing Correct");
	else
		$display("a: Xing Incorrect");

	if(iterator_b_XING == (`NO_OF_TWIDDLES_TESTED*`TESTBENCH_SIZE))
		$display("b: Xing Correct");
	else
		$display("b: Xing Incorrect");

	if(iterator_a_NGUYEN == (`NO_OF_TWIDDLES_TESTED*`TESTBENCH_SIZE))
		$display("a: Nguyen Correct");
	else
		$display("a: Nguyen Incorrect");

	if(iterator_b_NGUYEN == (`NO_OF_TWIDDLES_TESTED*`TESTBENCH_SIZE))
		$display("b: Nguyen Correct");
	else
		$display("b: Nguyen Incorrect");
	if(iterator_a_NI == (`NO_OF_TWIDDLES_TESTED*`TESTBENCH_SIZE))
		$display("a: Ni Correct");
	else
		$display("a: Ni Incorrect");

	if(iterator_b_NI == (`NO_OF_TWIDDLES_TESTED*`TESTBENCH_SIZE))
		$display("b: Ni Correct");
	else
		$display("b: Ni Incorrect");
		
	if(iterator_a_BEST == (`NO_OF_TWIDDLES_TESTED*`TESTBENCH_SIZE))
		$display("a: Ours is Correct");
	else
		$display("a: Ours is Incorrect");

	if(iterator_b_BEST == (`NO_OF_TWIDDLES_TESTED*`TESTBENCH_SIZE))
		$display("b: Ours is Correct");
	else
		$display("b: Ours is Incorrect");
        

	$stop();
    
end

endmodule
