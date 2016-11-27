`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2016 04:17:52 PM
// Design Name: 
// Module Name: program_counter
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


module program_counter(
    input logic clk,
    input logic reset,
    output logic [5:0]counter
    );
    
    logic [5:0]Addr;
    
    always_ff @(posedge clk) begin
        if (reset) begin
            Addr <= 0;
        end else begin
            Addr <= Addr + 1;
        end
    end    
    
    assign counter = Addr;
    
endmodule
