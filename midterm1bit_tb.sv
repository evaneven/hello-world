`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2016 03:56:52 PM
// Design Name: 
// Module Name: midtermProject_tb
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


module midtermProject_tb;

logic A;
logic B;
logic [2:0]sel;
logic mode_tb;
logic result;
logic Cout;

midterm1bit One_bit_ALU(
    .op1(A),
    .op2(B),
    .opsel(sel),
    .mode(mode_tb),
    .result_final(result),
    .Cout_final(Cout)
);

initial begin
    //arith testing
    A = 1'b1;
    B = 1'b1;
    sel = 3'b000;
    mode_tb = 1'b0;
    #10;
    A = 1'b1;
    B = 1'b1;
    sel = 3'b001;
    mode_tb = 1'b0;
    #10;
    A = 1'b1;
    B = 1'b1;
    sel = 3'b010;
    mode_tb = 1'b0;
    #10;
    A = 1'b1;
    B = 1'b1;
    sel = 3'b011;
    mode_tb = 1'b0;
    #10;   
    A = 1'b1;
    B = 1'b1;
    sel = 3'b100;
    mode_tb = 1'b0;
    #10;
    A = 1'b1;
    B = 1'b1;
    sel = 3'b101;
    mode_tb = 1'b0;
    #10;
    A = 1'b1;
    B = 1'b1;
    sel = 3'b110;
    mode_tb = 1'b0;
    #10;
    
    //logic testing
    A = 1'b1;
    B = 1'b1;
    sel = 3'b000;
    mode_tb = 1'b1;
    #10;
    A = 1'b1;
    B = 1'b1;
    sel = 3'b001;
    mode_tb = 1'b1;
    #10;        
    A = 1'b1;
    B = 1'b1;
    sel = 3'b010;
    mode_tb = 1'b1;
    #10;
    A = 1'b1;
    B = 1'b1;
    sel = 3'b011;
    mode_tb = 1'b1;
    #10;
    A = 1'b1;
    B = 1'b1;
    sel = 3'b100;
    mode_tb = 1'b1;
    #10;    
end

endmodule
