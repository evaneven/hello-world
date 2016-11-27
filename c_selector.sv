`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2016 04:20:14 PM
// Design Name: 
// Module Name: c_selector
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


module c_selector(
    input logic [2:0]opsel,
    input logic mode,
    output logic Cin_initial
    );
    
    wire net1;
    wire net2;
    
    wire comp_opsel2;
    wire comp_mode;
    
    complementer comp_two(
        .A(opsel[2]),
        .Y(comp_opsel2)
    );
    
    complementer comp_Mode(
        .A(mode),
        .Y(comp_mode)
    );
    
    mux2to1 OneLevel1(
        .A(opsel[1]),
        .B(opsel[0]),
        .sel(opsel[1]),
        .Y(net1)
    );
    
    mux2to1 OneLevel2(
        .A(net1),
        .B(comp_opsel2),
        .sel(opsel[2]),
        .Y(net2)
    );
    
    mux2to1 OneLevel3(
        .A(net2),
        .B(comp_mode),
        .sel(mode),
        .Y(Cin_initial)
    );

    
endmodule