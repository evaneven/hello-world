`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2016 02:33:59 PM
// Design Name: 
// Module Name: flag_selector
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


module flag_selector(
    input logic [127:0]op1,
    input logic [127:0]op2,
    input logic [2:0]opsel,
    input logic mode,
    input logic Cout,
    input logic [127:0]result,
    output logic c_flag,
    output logic z_flag,
    output logic o_flag,
    output logic s_flag
    );
    
    c_flag_selector cFlagSel(
        .opsel(opsel),
        .Cout(Cout),
        .mode(mode),
        .c_flag(c_flag)
    );
    
    o_flag_selector oFlagSel(
        .opsel(opsel[2]),
        .Cout(Cout),
        .mode(mode),
        .o_flag(o_flag)
    );
    
    z_flag_selector zFlagSel(
        .opsel(opsel),
        .result(result),
        .mode(mode),
        .z_flag(z_flag)
    );
    
    s_flag_selector sFlagSel(
        .op1(op1),
        .op2(op2),
        .opsel(opsel),
        .mode(mode),
        .s_flag(s_flag)
    );
    
endmodule
