`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2016 08:30:13 PM
// Design Name: 
// Module Name: comparator_parallel
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


module comparator_parallel(
    input [127:0] A,
    input [127:0] B,
    output LT  // A < B
    );
    
    assign LT = (A < B)? 1'b1 : 1'b0;
    
endmodule
