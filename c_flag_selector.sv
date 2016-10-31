`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2016 03:38:25 PM
// Design Name: 
// Module Name: c_flag_selector
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


module c_flag_selector(
    input logic [2:0]opsel,
    input logic Cout,
    input logic mode,
    output logic c_flag
    );
    
    wire comp_opsel0;
    wire comp_mode;
    wire net1;
    wire net2;
    wire net3;
    wire net4;
    
    complementer compCFlag(
        .A(opsel[0]),
        .Y(comp_opsel0)
    );
    
    complementer compMode(
        .A(mode),
        .Y(comp_mode)
    );
    
    mux2to1 OneLevel1(
        .A(Cout),
        .B(comp_opsel0),
        .sel(opsel[0]),
        .Y(net1)
    );
    
    mux2to1 TwoLevel1(
        .A(Cout),
        .B(comp_opsel0),
        .sel(opsel[0]),
        .Y(net2)
    );
    
    mux2to1 OneLevel2(
        .A(net2),
        .B(Cout),
        .sel(opsel[1]),
        .Y(net3)
    );
    
    mux2to1 OneLevel3(
        .A(net1),
        .B(net3),
        .sel(opsel[2]),
        .Y(net4)
    );
    
    mux2to1 OneLevel4(
        .A(net4),
        .B(comp_mode),
        .sel(mode),
        .Y(c_flag)
    );
    
endmodule
