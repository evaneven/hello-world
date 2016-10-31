`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2016 03:38:25 PM
// Design Name: 
// Module Name: o_flag_selector
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


module o_flag_selector(
    input logic opsel,
    input logic Cout,
    input logic mode,
    output logic o_flag
    );
    
    wire net1;
    
    mux2to1 OneLevel1(
        .A(opsel),
        .B(Cout),
        .sel(opsel),
        .Y(net1)
    );
    
    mux2to1 TwoLevel1(
        .A(mode),
        .B(net1),
        .sel(mode),
        .Y(o_flag)
    );
    
endmodule
