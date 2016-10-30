`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2016 03:59:28 PM
// Design Name: 
// Module Name: mode_mux
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
