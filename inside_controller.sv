`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2016 06:16:49 PM
// Design Name: 
// Module Name: inside_controller
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
