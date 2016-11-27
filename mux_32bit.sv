`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2016 04:27:50 PM
// Design Name: 
// Module Name: mux_32bit
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


module mux_32bit( //Ports declaration inside the brackets.
    logic [31:0]a,
    logic [31:0]b,
    logic sel,
    output [31:0]y
    );  //  Don't forget semi-colon
    
    assign y = (sel == 1'b0)? a : b;
    // Means that if sel == 0, Y = A, if sel == 1, Y = B
    // 1'b0 means 1 bit with binary value of 0
    // 2'b10 would mean 2 bit with binary value of 10
    // 3'o3 would mean 3 bit with octal value of 3
    // 8'd9 would mean 8 bit with decimal value of 9
    // 4'hF would mean 4 bit with hexadecimal value of F. Same as 4'b1111
    
endmodule