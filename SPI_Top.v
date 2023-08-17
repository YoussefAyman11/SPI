`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2023 06:07:47 PM
// Design Name: 
// Module Name: SPI_Top
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


module SPI_Top
    #(parameter mode = 2'b00,bits_num = 8)(
    input clk,
    input reset,
    input tx_start,
    input [1:0] sel,
    input [bits_num - 1:0] master_data_in,
    input [bits_num - 1:0] slave1_data_in,
    input [bits_num - 1:0] slave2_data_in,
    input [bits_num - 1:0] slave3_data_in,
    input [bits_num - 1:0] slave4_data_in,
    output tx_end,
    output [bits_num - 1:0] master_data_out,
    output [bits_num - 1:0] slave1_data_out,
    output [bits_num - 1:0] slave2_data_out,
    output [bits_num - 1:0] slave3_data_out,
    output [bits_num - 1:0] slave4_data_out
    );
    
    wire ss,sclk,master_out,master_in;
    wire slave1_out,slave2_out,slave3_out,slave4_out;
    wire tx_end_sig;
    assign tx_end_sig = tx_end;
    
    mux_4x1 mux(
        .in1(slave1_out),
        .in2(slave2_out),
        .in3(slave3_out),
        .in4(slave4_out),
        .sel(sel),
        .out(master_in)
    );
    
    SPI_Master #(.mode(mode),.bits_num(bits_num)) master(
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .data_in(master_data_in),
        .miso(master_in),
        .sclk(sclk),
        .ss(ss),
        .mosi(master_out),
        .tx_end(tx_end),
        .data_out(master_data_out)
    );
    
    SPI_Slave #(.mode(mode),.bits_num(bits_num)) slave1(
        .clk(clk),
        .reset(reset),
        .ss((sel == 'b00)?(ss):('b1)),
        .sclk(sclk),
        .data_in(slave1_data_in),
        .mosi(master_out),
        .miso(slave1_out),
        .tx_end(tx_end_sig),
        .data_out(slave1_data_out)
);

    SPI_Slave #(.mode(mode),.bits_num(bits_num)) slave2(
        .clk(clk),
        .reset(reset),
        .ss((sel == 'b01)?(ss):('b1)),
        .sclk(sclk),
        .data_in(slave2_data_in),
        .mosi(master_out),
        .miso(slave2_out),
        .tx_end(tx_end_sig),
        .data_out(slave2_data_out)
);

    SPI_Slave #(.mode(mode),.bits_num(bits_num)) slave3(
        .clk(clk),
        .reset(reset),
        .ss((sel == 'b10)?(ss):('b1)),
        .sclk(sclk),
        .data_in(slave3_data_in),
        .mosi(master_out),
        .miso(slave3_out),
        .tx_end(tx_end_sig),
        .data_out(slave3_data_out)
);

    SPI_Slave #(.mode(mode),.bits_num(bits_num)) slave4(
        .clk(clk),
        .reset(reset),
        .ss((sel == 'b11)?(ss):('b1)),
        .sclk(sclk),
        .data_in(slave4_data_in),
        .mosi(master_out),
        .miso(slave4_out),
        .tx_end(tx_end_sig),
        .data_out(slave4_data_out)
);
    
endmodule
