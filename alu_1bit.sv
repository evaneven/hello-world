`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2016 01:22:42 PM
// Design Name: 
// Module Name: alu_1bit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//module c_selector(
//    input logic [2:0]opsel,
//    input logic mode,
//    output logic Cin_initial
//    );
    
//    wire net1;
//    wire net2;
//    wire net3;
    
//    wire comp_opsel0;
//    wire comp_mode;
    
//    mux2to1 OneLevel2(
//        .A(opsel[1]),
//        .B(opsel[0]),
//        .sel(opsel[1]),
//        .Y(net1)
//    );
    
//    complementer comp_one(
//        .A(opsel[0]),
//        .Y(comp_opsel0)
//    );
    
//    mux2to1 TwoLevel2(
//        .A(comp_opsel0),
//        .B(opsel[1]),
//        .sel(opsel[1]),
//        .Y(net2)
//    );
    
//    mux2to1 OneLevel3(
//        .A(net1),
//        .B(net2),
//        .sel(opsel[2]),
//        .Y(net3)
//    );
    
//    complementer comp_two(
//        .A(mode),
//        .Y(comp_mode)
//    );
    
//    mux2to1 OneLevel4(
//        .A(net3),
//        .B(comp_mode),
//        .sel(mode),
//        .Y(Cin_initial)
//    );
    
//endmodule

module alu_1bit(
    input logic op1,
    input logic op2,
    input logic mode,
    input logic [2:0]opsel,
    input logic Cin_final,
    output logic result_final,
    output logic Cout_final
    );
    
    logic arith_result;
    logic arith_Cout;
    logic logic_result;
    logic logic_Cout;
   
    
    arth_unit AU(
        .op1(op1),
        .op2(op2),
        .Cin_final(Cin_final),
        .opsel(opsel),
        .arith_result(arith_result),
        .arith_Cout(arith_Cout)
    );
    
    logic_unit LU(
        .op1(op1),
        .op2(op2),
        .opsel(opsel),
        .Cin_final(Cin_final),
        .logic_result(logic_result),
        .logic_Cout(logic_Cout)
    );
    
    mode_mux ModeMux(
        .arith_result_mux(arith_result),
        .arith_Cout_mux(arith_Cout),
        .logic_result_mux(logic_result),
        .logic_Cout_mux(logic_Cout),
        .mode_mux(mode),
        .result_final(result_final),
        .Cout_final(Cout_final)
    );
    
endmodule

module arth_unit(
    input logic op1,
    input logic op2,
    input logic Cin_final,
    input logic [2:0]opsel,
    output logic arith_result,
    output logic arith_Cout
    );
    
    wire net1;
    wire net2;
    wire net3;
    wire net4;
    
    wire comp_op2;
    wire comp_opsel2;
       
    complementer comp_one(
        .A(op2),
        .Y(comp_op2)
    );   
    
    complementer comp_opselTwo(
        .A(opsel[2]),
        .Y(comp_opsel2)
    );
   
    mux2to1 OneLevel1(
        .A(op2),
        .B(comp_op2),
        .sel(opsel[0]),
        .Y(net1)
    );
    
    mux2to1 TwoLevel1(
        .A(opsel[0]),
        .B(net1),
        .sel(opsel[0]),
        .Y(net2)
    );
    
    mux2to1 OneLevel2(
        .A(net1),
        .B(net2),
        .sel(opsel[1]),
        .Y(net3)
    );
    
    mux2to1 OneLevel3(
        .A(net3),
        .B(comp_opsel2),
        .sel(opsel[2]),
        .Y(net4)
    );
   
    fulladder FA(
        .thing_a(op1),
        .thing_b(net4),
        .thing_cin(Cin_final),
        .arith_result(arith_result),
        .arith_Cout(arith_Cout)
    );
    
endmodule

module logic_unit(
    input logic op1,
    input logic op2,
    input logic [2:0] opsel,
    input logic Cin_final,
    output logic logic_result,
    output logic logic_Cout
    );
    
    wire logic_net1;
    wire logic_net2;
    wire logic_net3;
    
    wire op1_op2_AND;
    wire op1_op2_OR;
    wire op1_op2_XOR;
    
    assign op1_op2_AND = op1 && op2;
    assign op1_op2_OR = op1 || op2;
    assign op1_op2_XOR = op1 ^ op2;
    
    wire comp_op1;
    
    mux2to1 logic_OneLevel1(
        .A(op1_op2_AND),
        .B(op1_op2_OR),
        .sel(opsel[0]),
        .Y(logic_net1)
    );
    
    complementer comp_one(
        .A(op1),
        .Y(comp_op1)
    );
    
    mux2to1 logic_TwoLevel1(
        .A(op1_op2_XOR),
        .B(comp_op1),
        .sel(opsel[0]),
        .Y(logic_net2)
    );
    
    mux2to1 logic_OneLevel2(
        .A(logic_net1),
        .B(logic_net2),
        .sel(opsel[1]),
        .Y(logic_net3)
    );
    
    mux2to1 logic_OneLevel3(
        .A(logic_net3),
        .B(Cin_final),
        .sel(opsel[2]),
        .Y(logic_result)
    );
    
    assign logic_Cout = (op1 && opsel[2]);
      
endmodule

module mode_mux(
    input logic arith_result_mux,
    input logic arith_Cout_mux,
    input logic logic_result_mux,
    input logic logic_Cout_mux,
    input logic mode_mux,
    output logic result_final,
    output logic Cout_final
    );
    
    mux2to1 OneLevel1(
        .A(arith_result_mux),
        .B(logic_result_mux),
        .sel(mode_mux),
        .Y(result_final)
    );
    
    mux2to1 TwoLevel1(
        .A(arith_Cout_mux),
        .B(logic_Cout_mux),
        .sel(mode_mux),
        .Y(Cout_final)
    );
    
endmodule

module mux2to1( //Ports declaration inside the brackets.
    logic A,
    logic B,
    logic sel,
    output Y
    );  //  Don't forget semi-colon
    
    assign Y = (sel == 1'b0)? A : B;
    // Means that if sel == 0, Y = A, if sel == 1, Y = B
    // 1'b0 means 1 bit with binary value of 0
    // 2'b10 would mean 2 bit with binary value of 10
    // 3'o3 would mean 3 bit with octal value of 3
    // 8'd9 would mean 8 bit with decimal value of 9
    // 4'hF would mean 4 bit with hexadecimal value of F. Same as 4'b1111
    
endmodule

module complementer(
    input A,
    output Y
    );
    
    assign Y = ~A; // Bitwise complement
endmodule

module fulladder (
		input logic thing_a, thing_b, thing_cin,
		output logic arith_result, arith_Cout);

	assign arith_result = thing_a^thing_b^thing_cin;
	assign arith_Cout = (thing_a&thing_b)|(thing_cin&(thing_a^thing_b));

endmodule


//module comparator_parallel(
//    input [127:0] A,
//    input [127:0] B,
//    output LT  // A < B
//    );
    
//    assign LT = (A < B)? 1'b1 : 1'b0;
    
//endmodule
