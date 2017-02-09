`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2016 03:38:25 PM
// Design Name: 
// Module Name: z_flag_selector
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


module z_flag_selector(
    input logic [2:0]opsel,
    input logic [127:0]result,
    input logic mode,
    output logic z_flag
    );
    
    wire comp_opsel1;
    wire comp_mode;
    wire net1;
    wire net2;
    wire net3;
    wire net4;
    wire net5;
    wire net6;
    
    logic [127:0]temp;
    wire o_checker;
    wire o_checker_comp;
    
    assign temp[0] = result[0];
    
    genvar i;
    generate
        for(i = 1; i < 128; i++) begin: inst
            assign temp[i] = temp[i-1] || result[i];
        end
    endgenerate
    
    assign o_checker = temp[127];
    
    complementer compSel1(
        .A(opsel[1]),
        .Y(comp_opsel1)
    );
    
    complementer compMode(
        .A(mode),
        .Y(comp_mode)
    );
    
    complementer compOChecker(
        .A(o_checker),
        .Y(o_checker_comp)
    );
    
    mux2to1 OneLevel1(
        .A(opsel[0]),
        .B(o_checker_comp), 
        .sel(opsel[0]),
        .Y(net1)
    );
    
    mux2to1 TwoLevel1(
        .A(opsel[0]),
        .B(o_checker_comp),
        .sel(opsel[0]),
        .Y(net2)
    );
    
    mux2to1 ThreeLevel1(
        .A(opsel[0]),
        .B(o_checker_comp), 
        .sel(opsel[0]),
        .Y(net3)
    );
    
    mux2to1 OneLevel2(
        .A(net1),
        .B(net2),
        .sel(opsel[1]),
        .Y(net4)
    );
    
    mux2to1 TwoLevel2(
        .A(net3),
        .B(comp_opsel1),
        .sel(opsel[1]),
        .Y(net5)
    );
    
    mux2to1 OneLevel3(
        .A(net4),
        .B(net5),
        .sel(opsel[2]),
        .Y(net6)
    );
    
    mux2to1 OneLevel4(
        .A(net6),
        .B(comp_mode),
        .sel(mode),
        .Y(z_flag)
    );
    
endmodule
