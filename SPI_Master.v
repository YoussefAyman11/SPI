`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2023 12:34:34 PM
// Design Name: 
// Module Name: SPI_Master
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


module SPI_Master
    #(parameter mode = 2'b00,bits_num = 8)(
    input clk,
    input reset,
    input tx_start,
    input [bits_num - 1:0] data_in,
    input miso,
    output reg sclk,
    output reg ss,
    output reg mosi,
    output reg tx_end,
    output reg [bits_num - 1:0] data_out
    );
    
    wire CPOL,CPHA;
    reg sclk_reg;
    wire neg_edge,pos_edge;
    reg [$clog2(bits_num) - 1:0] n;
    reg [3:0] counts;
    reg start;
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
            mosi <= 'b0;
            n <= 'b0;
            flag <= 'b0;
            counts <= 'b0;
            tx_end <= 'b0;
            sclk <= CPOL;
            ss <= 'b1;
            start <= 'b0;
            data <= 8'b0;
        end
        
        else if(tx_start) begin
			counts <= 'b1;
			sclk <= ~sclk;
			ss <= 'b0;
			start <= 'b1;
			tx_end <= 'b0;
			data <= 8'b0;
        end
        
        else if(start) begin
            counts <= counts + 1;
            ss <= 'b0;
			
            if(counts % 2 != 0) begin
                sclk <= ~sclk;
            end
            else begin
                sclk <= ~sclk;
            end
			
            if(counts == 0) begin
                tx_end <= 'b1;
                ss <= 'b1;
                sclk <= CPOL;
                start <= 'b0;
            end
            
            n <= (CPOL)?((sclk)?(n):(n + 1)):((sclk)?(n + 1):(n));
			
            if(flag == 0) begin
                mosi <= data_in[bits_num - 1];
                data <= (CPHA)?(data):({miso,7'b0});
                flag <= 'b1;
            end
			
            else begin
                case(mode)
                    'b00: begin
                        mosi <= (neg_edge)?(data_in[7-n]):(mosi);
                        data[7-n] <= (pos_edge)?(miso):(data[7-n]);
                    end
                    'b01: begin
                        mosi <= (pos_edge)?(data_in[7-n]):(mosi);
                        if(n == 0)
                            data[0] <= (neg_edge)?(miso):(data[0]);
                        else
                            data[7-n+1] <= (neg_edge)?(miso):(data[7-n+1]);
                    end
                    'b10: begin
                        mosi <= (pos_edge)?(data_in[7-n]):(mosi);
                        data[7-n] <= (neg_edge)?(miso):(data[7-n]);
                    end
                    'b11: begin
                        mosi <= (neg_edge)?(data_in[7-n]):(mosi);
                        if(n == 0) begin
                            data[0] <= (pos_edge)?(miso):(data[0]);
                        end
                        else begin
                            data[7-n+1] <= (pos_edge)?(miso):(data[7-n+1]);
                        end
                    end
                endcase
            end
        end
		
        else if(tx_end) begin
            data_out <= data;
            flag <= 'b0;
        end
		
        else
            mosi <= data_in[bits_num - 1];
    end
endmodule
