
module HA_logic(
input a,
input b,
output c_0,
output c_1
);

assign c_0 = a ^ b;
assign c_1 = a | b;

endmodule