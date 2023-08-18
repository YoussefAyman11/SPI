`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2023 12:46:19 PM
// Design Name: 
// Module Name: tb
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


module tb();

parameter mode = 2'b11;
parameter bits_num = 8;
parameter clk_period = 10;

reg clk = 0;
always #(clk_period/2) clk = ~clk;

reg reset,tx_start;
reg [bits_num - 1:0] slave1_data_in,slave2_data_in,slave3_data_in,slave4_data_in;
reg [bits_num - 1:0] master_data_in;
reg [1:0] sel;
wire tx_end;
wire [bits_num - 1:0] master_data_out;
wire [bits_num - 1:0] slave1_data_out,slave2_data_out,slave3_data_out,slave4_data_out;

SPI_Top #(.mode(mode),.bits_num(bits_num)) dut(
    .clk(clk),
    .reset(reset),
    .tx_start(tx_start),
    .sel(sel),
    .master_data_in(master_data_in),
    .slave1_data_in(slave1_data_in),
    .slave2_data_in(slave2_data_in),
    .slave3_data_in(slave3_data_in),
    .slave4_data_in(slave4_data_in),
    .tx_end(tx_end),
    .master_data_out(master_data_out),
    .slave1_data_out(slave1_data_out),
    .slave2_data_out(slave2_data_out),
    .slave3_data_out(slave3_data_out),
    .slave4_data_out(slave4_data_out)
);

initial begin

    reset = 0;
    #(clk_period);
    reset = 1;
    #(10*clk_period);
    
/////////////////////////Test case 1///////////////////
    sel = 'b00;
    master_data_in = 'b10101011;
    slave1_data_in = 'b11001000;
    slave2_data_in = 'b00101010;
    slave3_data_in = 'b11110101;
    slave4_data_in = 'b10111001;
    #(clk_period);
    sel = 'b00;
    tx_start = 1;
    #(clk_period);
    tx_start = 0;
    #(200*clk_period);
    
    sel = 'b01;
    tx_start = 1;
    #(clk_period);
    tx_start = 0;
    #(200*clk_period);
    
    sel = 'b10;
    tx_start = 1;
    #(clk_period);
    tx_start = 0;
    #(200*clk_period);
    
    sel = 'b11;
    tx_start = 1;
    #(clk_period);
    tx_start = 0;
    #(200*clk_period);

/////////////////////////Test case 2///////////////////
    sel = 'b00;
    master_data_in = 'b00101001;
    slave1_data_in = 'b10010010;
    slave2_data_in = 'b00001101;
    slave3_data_in = 'b11111110;
    slave4_data_in = 'b00011110;
    #(clk_period);
    sel = 'b00;
    tx_start = 1;
    #(clk_period);
    tx_start = 0;
    #(200*clk_period);
    
    sel = 'b01;
    tx_start = 1;
    #(clk_period);
    tx_start = 0;
    #(200*clk_period);
    
    sel = 'b10;
    tx_start = 1;
    #(clk_period);
    tx_start = 0;
    #(200*clk_period);
    
    sel = 'b11;
    tx_start = 1;
    #(clk_period);
    tx_start = 0;
    #(200*clk_period);

    $finish();
end


endmodule
