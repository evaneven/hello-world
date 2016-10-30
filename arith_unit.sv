`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2016 03:23:03 PM
// Design Name: 
// Module Name: arth_unit
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
    wire net5;
    
    wire comp_op2;
       
    complementer comp_one(
        .A(op2),
        .Y(comp_op2)
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
    
    mux2to1 TwoLevel2(
        .A(opsel[0]),
        .B(op2),
        .sel(opsel[1]),
        .Y(net4)
    );
    
    mux2to1 OneLevel3(
        .A(net3),
        .B(net4),
        .sel(opsel[2]),
        .Y(net5)
    );
    
    
    
    // CIN PART
    
    
    
    fulladder FA(
        .thing_a(op1),
        .thing_b(net5),
        .thing_cin(Cin_final),
        .arith_result(arith_result),
        .arith_Cout(arith_Cout)
    );
   
    
endmodule
