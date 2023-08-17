`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2023 09:39:08 PM
// Design Name: 
// Module Name: mux_4x1
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


module mux_4x1(
    input in1,
    input in2,
    input in3,
    input in4,
    input [1:0] sel,
    output reg out
    );
    
    always @(*) begin
        out = 'b0;
        case(sel)
            'b00: out = in1;
            'b01: out = in2;
            'b10: out = in3;
            'b11: out = in4;
        endcase
    end
    
endmodule
