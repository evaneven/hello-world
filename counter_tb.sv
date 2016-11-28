`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2016 01:12:49 PM
// Design Name: 
// Module Name: counter_tb
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

module counter_tb;

    logic clk;
    logic reset;
    logic [5:0]counter;
    logic [31:0]instruction;
    logic [31:0]OperandA;
    logic [31:0]OperandB;
    logic [31:0]ALUresult;
    logic [31:0]RD_data_mem;
    logic [31:0]result;
    
    final_project DUT(
        .clk(clk),
        .reset(reset),
        .counter(counter),
        .inst_mem(instruction),
        .OperandA(OperandA),
        .OperandB(OperandB),
        .ALUresult(ALUresult),
        .RD_data_mem(RD_data_mem),
        .RD_to_reg_file(result)
    );
    
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;
    end
    
    initial begin
        reset = 1'b1;
        #30 reset = 1'b0;
    end

endmodule    