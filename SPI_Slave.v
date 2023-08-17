`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2023 05:27:31 PM
// Design Name: 
// Module Name: SPI_Slave
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


module SPI_Slave
    #(parameter mode = 2'b00,bits_num = 8)(
    input clk,
    input reset,
    input ss,
    input sclk,
    input tx_end,
    input [bits_num - 1:0] data_in,
    input mosi,
    output reg miso,
    output reg [bits_num - 1:0] data_out
    );
    
    wire CPOL,CPHA;
    reg sclk_reg;
    wire neg_edge,pos_edge;
    reg [$clog2(bits_num) - 1:0] n;
    reg flag; 
    reg [bits_num - 1:0] data;
    assign {CPOL,CPHA} = mode;

    always @ (posedge clk) begin
        sclk_reg <= sclk;
    end
    
    assign pos_edge = sclk & !sclk_reg;
    assign neg_edge = !sclk & sclk_reg;
    
    always @(posedge clk,negedge reset) begin
        if(!reset) begin
            miso <= 'b0;
            n <= 'b0;
            flag <= 'b0;
            data <= 'b0;
            data_out <= 'b0;
        end
		
        else if(tx_end) begin
            data_out <= data;
            flag <= 'b0;
        end
		
        else if(!ss) begin
            n <= (CPOL)?((sclk)?(n):(n + 1)):((sclk)?(n + 1):(n));
			
            if(flag == 0) begin
                miso <= data_in[bits_num - 1];
                data <= (CPHA)?(data):({mosi,7'b0});
                flag <= 'b1;
            end
			
            else begin
                case(mode)
                    'b00: begin
                        miso <= (neg_edge)?(data_in[7-n]):(miso);
                        data[7-n] <= (pos_edge)?(mosi):(data[7-n]);
                    end
                    'b01: begin
                        miso <= (pos_edge)?(data_in[7-n]):(miso);
                        if(n == 0)
                            data[0] <= (neg_edge)?(mosi):(data[0]);
                        else
                            data[7-n+1] <= (neg_edge)?(mosi):(data[7-n+1]);
                    end
                    'b10: begin
                        miso <= (pos_edge)?(data_in[7-n]):(miso);
                        data[7-n] <= (neg_edge)?(mosi):(data[7-n]);
                    end
                    'b11: begin
                        miso <= (neg_edge)?(data_in[7-n]):(miso);
                        if(n == 0) begin
                            data[0] <= (pos_edge)?(mosi):(data[0]);
                        end
                        else begin
                            data[7-n+1] <= (pos_edge)?(mosi):(data[7-n+1]);
                        end
                    end
                endcase
                
            end
        end
        else begin
            miso <= data_in[bits_num - 1];
        end
    end

endmodule
