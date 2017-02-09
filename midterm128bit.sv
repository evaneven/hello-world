`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2016 12:27:51 AM
// Design Name: 
// Module Name: midterm128bit
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


module midterm128bit(
    input logic [127:0] op1,
    input logic [127:0] op2,
    input logic [2:0] opsel,
    input logic mode,
    output logic [127:0] result,
    output logic c_flag,
    output logic z_flag,
    output logic o_flag,
    output logic s_flag
    );
    
    logic Cin_initial;
    logic [128:0]Cin_final;
    logic very_last_Cout;
    
    c_selector InitialC(
        .opsel(opsel),
        .mode(mode),
        .Cin_initial(Cin_initial)
    );
    
    assign Cin_final[0] = Cin_initial;
    
    genvar i;
    generate
        for (i = 0; i < 128; i++) begin: inst
            midterm1bit M1Bit(op1[i], op2[i], mode, opsel, Cin_final[i], result[i], Cin_final[i+1]);
        end
    endgenerate
    
    assign very_last_Cout = Cin_final[128];
    
    flag_selector flagSel(
        .op1(op1),
        .op2(op2),
        .opsel(opsel),
        .mode(mode),
        .Cout(very_last_Cout),
        .result(result),
        .c_flag(c_flag),
        .z_flag(z_flag),
        .o_flag(o_flag),
        .s_flag(s_flag)
    );
    
endmodule
