`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2016 03:38:25 PM
// Design Name: 
// Module Name: s_flag_selector
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


module s_flag_selector(
    input logic [127:0]op1,
    input logic [127:0]op2,
    input logic [2:0]opsel,
    input logic mode,
    output logic s_flag
    );
    
    wire sign_wire;
    wire net1;
    wire net2;
    wire net3;
    wire net4;
    wire comp_opsel2;
    wire comp_mode;
    
    comparator_parallel compPara(
        .A(op1),
        .B(op2),
        .LT(sign_wire)
    );
    
    complementer compSel2(
        .A(opsel[2]),
        .Y(comp_opsel2)
    );
    
    complementer compMode(
        .A(mode),
        .Y(comp_mode)
    );
    
    mux2to1 OneLevel1(
        .A(opsel[0]),
        .B(sign_wire),
        .sel(opsel[0]),
        .Y(net1)
    );
    
    mux2to1 TwoLevel1(
        .A(opsel[0]),
        .B(sign_wire),
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
    
    mux2to1 OneLevel4(
        .A(net4),
        .B(comp_mode),
        .sel(mode),
        .Y(s_flag)
    );
    
endmodule
