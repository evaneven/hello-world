`timescale 1ns / 1ps
module fulladder (
		input logic thing_a, thing_b, thing_cin,
		output logic arith_result, arith_Cout);

	assign arith_result = thing_a^thing_b^thing_cin;
	assign arith_Cout = (thing_a&thing_b)|(thing_cin&(thing_a^thing_b));

endmodule
