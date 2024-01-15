module FA_logic(
input a,
input b,
input c,
output c_0,
output c_1
);

assign c_0 = a ^ b ^ c;
assign c_1 = a | b | c;

endmodule