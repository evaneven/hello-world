`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2016 06:14:51 PM
// Design Name: 
// Module Name: controller
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


module controller(
    input logic [31:0] instruction,
    output logic [3:0] ALUopsel,
    output logic Muxsel1,
    output logic Muxsel2,
    output logic WE1,
    output logic WE2,
    output logic [5:0]rs,
    output logic [5:0]rd,
    output logic [5:0]rt,
    output logic [14:0] immediate_values
    );

    assign Muxsel1 = instruction[31];
    assign rs = instruction[30:25];
    assign rd = instruction[24:19];
    assign rt = instruction[14:9];
    assign ALUopsel = instruction[18:15];
    assign immediate_values[14:0] = instruction[14:0];
    
    inside_controller IN_CONTROL(
        .func(instruction[18:15]),
        .Muxsel2(Muxsel2),
        .WE1(WE1),
        .WE2(WE2)
    );

endmodule