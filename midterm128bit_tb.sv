`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2016 02:11:54 AM
// Design Name: 
// Module Name: midterm128bit_tb
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


module midterm128bit_tb;

logic [127:0]A;
logic [127:0]B;
logic [2:0]sel;
logic mode_tb;
logic [127:0]result;
logic flag_c;
logic flag_z;
logic flag_o;
logic flag_s;

midterm128bit M128Bit(
    .op1(A),
    .op2(B),
    .opsel(sel),
    .mode(mode_tb),
    .result(result),
    .c_flag(flag_c),
    .z_flag(flag_z),
    .o_flag(flag_o),
    .s_flag(flag_s)
);

initial begin
    A = 128'b10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101;
    B = 128'b10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001001;
    
    sel = 3'b000;
    mode_tb = 1'b0;
    #10;
    sel = 3'b001;
    mode_tb = 1'b0;
    #10;
    sel = 3'b010;
    mode_tb = 1'b0;
    #10;
    sel = 3'b011;
    mode_tb = 1'b0;
    #10;   
    sel = 3'b100;
    mode_tb = 1'b0;
    #10;
    sel = 3'b101;
    mode_tb = 1'b0;
    #10;
    sel = 3'b110;
    mode_tb = 1'b0;
    #10;
    
    //logic testing
    sel = 3'b000;
    mode_tb = 1'b1;
    #10;
    sel = 3'b001;
    mode_tb = 1'b1;
    #10;  
    sel = 3'b010;
    mode_tb = 1'b1;
    #10;
    sel = 3'b011;
    mode_tb = 1'b1;
    #10;
    sel = 3'b100;
    mode_tb = 1'b1;
    #10;    
    
end
    
endmodule
