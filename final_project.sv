`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2016 03:15:09 PM
// Design Name: 
// Module Name: final_project
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

module final_project(
    input logic clk,
    input logic reset,
    output logic [31:0]inst_mem,
    output logic [31:0]OperandA,
//    output logic [31:0]RD2,
//    output logic ext_imm,
    output logic [31:0]OperandB,
    output wire [31:0]ALUresult,
    output wire [31:0]RD_data_mem,
    output logic [31:0]RD_to_reg_file
    );
    
    
    logic [3:0]ALUopsel;
    wire Muxsel1;
    wire Muxsel2;
    logic WE1;
    logic WE2;
    logic [5:0]rs;
    logic [5:0]rd;
    logic [5:0]rt;
    logic [14:0]imm;
    
    logic [5:0]counter;
    
//    logic [31:0]inst_mem;
    
    //assign Muxsel1 = instruction[31];
    
    program_counter PC(
        .clk(clk),
        .reset(reset),
        .counter(counter)
    );
    
    instruct_mem INST_MEM(
        .Addr(counter),
        .clk(clk),
        .instruction(inst_mem)
    );
    
    controller CONTROL(
        .instruction(inst_mem),
        .ALUopsel(ALUopsel),
        .Muxsel1(Muxsel1),
        .Muxsel2(Muxsel2),
        .WE1(WE1),
        .WE2(WE2),
        .rs(rs),
        .rd(rd),
        .rt(rt),
        .immediate_values(imm)
    );
   
    
//    logic [31:0]OperandA;
//    logic [31:0]OperandB;

    wire [31:0] RD2_result;
    wire [31:0] ext_imm;
    
//    wire [31:0] ALUresult;
    
        
//    logic [31:0]RD_to_reg_file;
    
    mem_twoport REG_FILE(
        .clk(clk),
        .reset(reset), // ADDED THIS IN
        .RA1(rs),
        .RA2(rt),
        .write(WE1), // write enable
        .WA(rd),
        .WD(RD_to_reg_file), // check variable name
        .RD1(OperandA),
        .RD2(RD2_result) // check variable name
    );  
    
    signext SE(
        .A(imm),
        .EXT_BY_17(ext_imm)
    );
    
    mux_32bit MUX1(
        .a(RD2_result),
        .b(ext_imm),
        .sel(Muxsel1),
        .y(OperandB)
    );          
    
    alu_32bit ALU32Bit(
        .op1(OperandA),
        .op2(OperandB),
        .opsel(ALUopsel[2:0]),
        .mode(ALUopsel[3]),
        .result(ALUresult)
    );
    
//    wire [31:0] RD_data_mem;
    
    data_mem DATA_MEM(
        .Address(ALUresult[6:0]),
        .WE2(WE2),
        .WD(RD2_result),
        .clk(clk),
        .reset(reset), // ADDED THIS IN
        .RD(RD_data_mem)
    );

    
    mux_32bit MUX2(
        .a(RD_data_mem),
        .b(ALUresult),
        .sel(Muxsel2),
        .y(RD_to_reg_file)
    );
        
        
endmodule
