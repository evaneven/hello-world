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
    output logic [5:0]counter,
    output logic [31:0]inst_mem,
    output logic [31:0]OperandA,
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

    wire [31:0] RD2_result;
    wire [31:0] ext_imm;
    
    mem_twoport REG_FILE(
        .clk(clk),
        .reset(reset),
        .RA1(rs),
        .RA2(rt),
        .write(WE1),
        .WA(rd),
        .WD(RD_to_reg_file),
        .RD1(OperandA),
        .RD2(RD2_result)
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
    
    data_mem DATA_MEM(
        .Address(ALUresult[6:0]),
        .WE2(WE2),
        .WD(RD2_result),
        .clk(clk),
        .reset(reset),
        .RD(RD_data_mem)
    );

    
    mux_32bit MUX2(
        .a(RD_data_mem),
        .b(ALUresult),
        .sel(Muxsel2),
        .y(RD_to_reg_file)
    );
endmodule

module program_counter(
    input logic clk,
    input logic reset,
    output logic [5:0]counter
    );
    
    logic [5:0]Addr;
    
    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            Addr <= 0;
        end else begin
            Addr <= Addr + 1;
        end
    end    
    
    assign counter = Addr;
endmodule

module instruct_mem(
    input logic [5:0]   Addr,
    input logic clk,
    output logic [31:0] instruction
    );
    
    logic [31:0] inst_mem [63:0];
    
    assign inst_mem[0] = 32'b00000000000001111000000000000000; //NOP
    assign inst_mem[1] = 32'b10000000000010000000000000000001; //R1 = R0 + 1
    assign inst_mem[2] = 32'b10000010000100000000000000000001; //R2 = R1 + 1
    assign inst_mem[3] = 32'b00000010000111010000010000000000; //R3 = R1 XOR R2
    assign inst_mem[4] = 32'b00000110001001101000000000000000; //R4 = SLL R3 by 1
    assign inst_mem[5] = 32'b00001000001111001000011000000000; //R7 = R4 OR R3
    assign inst_mem[6] = 32'b00001110001010011000010000000000; //R5 = R7 - R2
    assign inst_mem[7] = 32'b10000000001100000000000000000110; //R6 = R0 + 6
    assign inst_mem[8] = 32'b00001100000000110000101000000000; //Store DM(R6) <- R5
    assign inst_mem[9] = 32'b00001100001100100000000000000000; //Load R6 <- DM(R6)
    
    always_ff @(posedge clk) begin
        instruction <= inst_mem[Addr];            
    end
    
    //using generate statement assign all other memory addresses to NOP


endmodule

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

module inside_controller(
    input logic [3:0]func,
    output logic Muxsel2,
    output logic WE1,
    output logic WE2
    );
    
    wire func2_comp;
    complementer func2Comp(
        .A(func[2]),
        .Y(func2_comp)
    );
    
    wire OR1;
    assign OR1 = func2_comp || func[3];
    
    wire OR2;
    assign OR2 = func[1] || func[0];
    
    assign Muxsel2 = OR1 || OR2;
    
    
    wire func3_comp;
    complementer func3Comp(
        .A(func[3]),
        .Y(func3_comp)
    );
    
    wire func0_comp;
    complementer func0Comp(
        .A(func[0]),
        .Y(func0_comp)
    );
    
    wire AND1;
    assign AND1 = func3_comp && func0_comp;
    
    wire AND2;
    assign AND2 = func[2] && func[1];
    
    assign WE2 = AND1 && AND2;
    
    
    wire func1_comp;
    complementer func1Comp(
        .A(func[1]),
        .Y(func1_comp)
    );
    
    wire net1;
    mux2to1 OneLevel1(
        .A(func0_comp),
        .B(func0_comp),
        .sel(func[0]),
        .Y(net1)
    );
    
    wire net2;
    mux2to1 TwoLevel1(
        .A(func[0]),
        .B(func[0]),
        .sel(func[0]),
        .Y(net2)
    );
    
    wire net3;
    mux2to1 ThreeLevel1(
        .A(func0_comp),
        .B(func0_comp),
        .sel(func[0]),
        .Y(net3)
    );
    
    wire net4;
    mux2to1 FourLevel1(
        .A(func[0]),
        .B(func[0]),
        .sel(func[0]),
        .Y(net4)
    );
    
    wire net5;
    mux2to1 OneLevel2(
        .A(net1),
        .B(net2),
        .sel(func[1]),
        .Y(net5)
    );
    
    wire net6;
    mux2to1 TwoLevel2(
        .A(net3),
        .B(func1_comp),
        .sel(func[1]),
        .Y(net6)
    );
    
    wire net7;
    mux2to1 ThreeLevel2(
        .A(net4),
        .B(func1_comp),
        .sel(func[1]),
        .Y(net7)
    );
    
    wire net8;
    mux2to1 OneLevel3(
        .A(net5),
        .B(net6),
        .sel(func[2]),
        .Y(net8)
    );
    
    wire net9;
    mux2to1 TwoLevel3(
        .A(func2_comp),
        .B(net7),
        .sel(func[2]),
        .Y(net9)
    );
    
    mux2to1 OneLevel4(
        .A(net8),
        .B(net9),
        .sel(func[3]),
        .Y(WE1)
    );
    
endmodule

module mem_twoport(
    input logic         clk,
    input logic reset,
    input logic [5:0]   RA1,
    input logic [5:0]   RA2,
    input logic [5:0]   WA,
    input logic         write,
    input logic [31:0]  WD,
    output logic [31:0] RD1,    
    output logic [31:0] RD2
    );

    logic [31:0] mem [63:0];
    
    
    
    always_comb begin // doesn't wait for the clk, so no delay
        RD1 = mem[RA1];
        RD2 = mem[RA2];
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            mem[0] <= {32{1'b0}};
            mem[1] <= {32{1'b0}};
            mem[2] <= {32{1'b0}};
            mem[3] <= {32{1'b0}};
            mem[4] <= {32{1'b0}};
            mem[5] <= {32{1'b0}};
            mem[6] <= {32{1'b0}};
            mem[7] <= {32{1'b0}};
            mem[8] <= {32{1'b0}};
            mem[9] <= {32{1'b0}};
            mem[10] <= {32{1'b0}};
            mem[11] <= {32{1'b0}};
            mem[12] <= {32{1'b0}};
            mem[13] <= {32{1'b0}};
            mem[14] <= {32{1'b0}};
            mem[15] <= {32{1'b0}};
            mem[16] <= {32{1'b0}};
            mem[17] <= {32{1'b0}};
            mem[18] <= {32{1'b0}};
            mem[19] <= {32{1'b0}};
            mem[20] <= {32{1'b0}};
        end else if (write)
            mem[WA] <= WD;
            
    end
endmodule

module signext(
    input signed [14:0] A,
    output signed [31:0] EXT_BY_17
    );
    
    wire [17:0] ext_part;
    
    assign ext_part = {17{A[14]}}; // Replicate A[14] by 17 before concatenation
    assign EXT_BY_17 = {ext_part, A}; // Concatenation // check if it's {A, ext_part}
    
endmodule

module mux_32bit( 
    logic [31:0]a,
    logic [31:0]b,
    logic sel,
    output [31:0]y
    );  
    
    assign y = (sel == 1'b0)? a : b;
    
endmodule

module alu_32bit(
    input logic [31:0] op1,
    input logic [31:0] op2,
    input logic [2:0] opsel,
    input logic mode,
    output logic [31:0] result
    );
    
    logic Cin_initial;
    logic [31:0]Cin_final;
    
    c_selector InitialC(
        .opsel(opsel),
        .mode(mode),
        .Cin_initial(Cin_initial)
    );
    
    assign Cin_final[0] = Cin_initial; 
    
    genvar i;
    generate
        for (i = 0; i < 32; i++) begin: inst
            alu_1bit ALU1Bit(op1[i], op2[i], mode, opsel, Cin_final[i], result[i], Cin_final[i+1]);
        end
    endgenerate
    
endmodule

module c_selector(
    input logic [2:0]opsel,
    input logic mode,
    output logic Cin_initial
    );
    
    wire net1;
    wire net2;
    
    wire comp_opsel2;
    wire comp_mode;
    
    complementer comp_two(
        .A(opsel[2]),
        .Y(comp_opsel2)
    );
    
    complementer comp_Mode(
        .A(mode),
        .Y(comp_mode)
    );
    
    mux2to1 OneLevel1(
        .A(opsel[1]),
        .B(opsel[0]),
        .sel(opsel[1]),
        .Y(net1)
    );
    
    mux2to1 OneLevel2(
        .A(net1),
        .B(comp_opsel2),
        .sel(opsel[2]),
        .Y(net2)
    );
    
    mux2to1 OneLevel3(
        .A(net2),
        .B(comp_mode),
        .sel(mode),
        .Y(Cin_initial)
    );

    
endmodule

module alu_1bit(
    input logic op1,
    input logic op2,
    input logic mode,
    input logic [2:0]opsel,
    input logic Cin_final,
    output logic result_final,
    output logic Cout_final
    );
    
    logic arith_result;
    logic arith_Cout;
    logic logic_result;
    logic logic_Cout;
   
    
    arth_unit AU(
        .op1(op1),
        .op2(op2),
        .Cin_final(Cin_final),
        .opsel(opsel),
        .arith_result(arith_result),
        .arith_Cout(arith_Cout)
    );
    
    logic_unit LU(
        .op1(op1),
        .op2(op2),
        .opsel(opsel),
        .Cin_final(Cin_final),
        .logic_result(logic_result),
        .logic_Cout(logic_Cout)
    );
    
    mode_mux ModeMux(
        .arith_result_mux(arith_result),
        .arith_Cout_mux(arith_Cout),
        .logic_result_mux(logic_result),
        .logic_Cout_mux(logic_Cout),
        .mode_mux(mode),
        .result_final(result_final),
        .Cout_final(Cout_final)
    );
    
endmodule

module arth_unit(
    input logic op1,
    input logic op2,
    input logic Cin_final,
    input logic [2:0]opsel,
    output logic arith_result,
    output logic arith_Cout
    );
    
    wire net1;
    wire net2;
    wire net3;
    wire net4;
    
    wire comp_op2;
    wire comp_opsel2;
       
    complementer comp_one(
        .A(op2),
        .Y(comp_op2)
    );   
    
    complementer comp_opselTwo(
        .A(opsel[2]),
        .Y(comp_opsel2)
    );
   
    mux2to1 OneLevel1(
        .A(op2),
        .B(comp_op2),
        .sel(opsel[0]),
        .Y(net1)
    );
    
    mux2to1 TwoLevel1(
        .A(opsel[0]),
        .B(net1),
        .sel(opsel[0]),
        .Y(net2)
    );
    
    mux2to1 OneLevel2(
        .A(net1),
        .B(net2),
        .sel(opsel[1]),
        .Y(net3)
    );
    
    mux2to1 OneLevel3(
        .A(net3),
        .B(comp_opsel2),
        .sel(opsel[2]),
        .Y(net4)
    );
   
    fulladder FA(
        .thing_a(op1),
        .thing_b(net4),
        .thing_cin(Cin_final),
        .arith_result(arith_result),
        .arith_Cout(arith_Cout)
    );
    
endmodule

module logic_unit(
    input logic op1,
    input logic op2,
    input logic [2:0] opsel,
    input logic Cin_final,
    output logic logic_result,
    output logic logic_Cout
    );
    
    wire logic_net1;
    wire logic_net2;
    wire logic_net3;
    
    wire op1_op2_AND;
    wire op1_op2_OR;
    wire op1_op2_XOR;
    
    assign op1_op2_AND = op1 && op2;
    assign op1_op2_OR = op1 || op2;
    assign op1_op2_XOR = op1 ^ op2;
    
    wire comp_op1;
    
    mux2to1 logic_OneLevel1(
        .A(op1_op2_AND),
        .B(op1_op2_OR),
        .sel(opsel[0]),
        .Y(logic_net1)
    );
    
    complementer comp_one(
        .A(op1),
        .Y(comp_op1)
    );
    
    mux2to1 logic_TwoLevel1(
        .A(op1_op2_XOR),
        .B(comp_op1),
        .sel(opsel[0]),
        .Y(logic_net2)
    );
    
    mux2to1 logic_OneLevel2(
        .A(logic_net1),
        .B(logic_net2),
        .sel(opsel[1]),
        .Y(logic_net3)
    );
    
    mux2to1 logic_OneLevel3(
        .A(logic_net3),
        .B(Cin_final),
        .sel(opsel[2]),
        .Y(logic_result)
    );
    
    assign logic_Cout = (op1 && opsel[2]);
      
endmodule

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

module mux2to1(
    logic A,
    logic B,
    logic sel,
    output Y
    );
    
    assign Y = (sel == 1'b0)? A : B;
    
endmodule

module complementer(
    input A,
    output Y
    );
    
    assign Y = ~A; 
endmodule

module fulladder (
		input logic thing_a, thing_b, thing_cin,
		output logic arith_result, arith_Cout);

	assign arith_result = thing_a^thing_b^thing_cin;
	assign arith_Cout = (thing_a&thing_b)|(thing_cin&(thing_a^thing_b));

endmodule

module data_mem(
    input logic [6:0]   Address,
    input logic         WE2,
    input logic [31:0]  WD,
    input logic clk,
    input logic reset,
    output logic [31:0] RD
    );
    
    logic [31:0] mem [127:0];
    
    always_comb begin 
        RD = mem[Address];
              
    end
    
    always_ff @( posedge clk, posedge reset) begin
        if (reset) begin
            mem[0] <= {32{1'b0}};
            mem[1] <= {32{1'b0}};
            mem[2] <= {32{1'b0}};
            mem[3] <= {32{1'b0}};
            mem[4] <= {32{1'b0}};
            mem[5] <= {32{1'b0}};
            mem[6] <= {32{1'b0}};
            mem[7] <= {32{1'b0}};
            mem[8] <= {32{1'b0}};
            mem[9] <= {32{1'b0}};
            mem[10] <= {32{1'b0}};
            mem[11] <= {32{1'b0}};
            mem[12] <= {32{1'b0}};
            mem[13] <= {32{1'b0}};
            mem[14] <= {32{1'b0}};
            mem[15] <= {32{1'b0}};
            mem[16] <= {32{1'b0}};
            mem[17] <= {32{1'b0}};
            mem[18] <= {32{1'b0}};
            mem[19] <= {32{1'b0}};
            mem[20] <= {32{1'b0}};
        end else if (WE2)
            mem[Address] <= WD;  
    end
    
endmodule

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