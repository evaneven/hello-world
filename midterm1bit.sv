`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2016 03:19:06 PM
// Design Name: 
// Module Name: midterm1bit
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


module midterm1bit(
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

    
    // move c selector and logic Cin_final to 128 bit when done with 1 bit testing
   
    
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
