`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2016 02:48:12 PM
// Design Name: 
// Module Name: data_mem
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
        end else if (WE2)
            mem[Address] <= WD;  
    end
    
endmodule