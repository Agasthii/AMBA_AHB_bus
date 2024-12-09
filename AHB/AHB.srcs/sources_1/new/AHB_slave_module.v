`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2024 10:47:18 PM
// Design Name: 
// Module Name: AHB_slave_module
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


module AHB_slave_module(
    input hclk,
    input hresetn,
    input [31:0] haddr,
    input hwrite,
    input [1:0] htrans,
    input [31:0] hwdata,
    input hsel,
    
    
    output reg hready_out,
    output reg hresp,
    output reg [31:0] hrdata,
    output reg error,
    output reg split_in,
    output reg valid_aft_split_in
    );
    
    reg [31:0] memory [31:0];
    reg [4:0] waddr;
    reg [4:0] raddr;
    
    reg [1:0] present_state;
    reg [1:0] next_state;
    
    parameter idle = 2'b00;
    parameter read   = 2'b01;
    parameter write   = 2'b10;
    parameter validity   = 2'b11;
    
    always @(posedge hclk)
        begin
        
            // Initialize memory during reset
            memory[0] <= 32'd1;
            memory[1] <= 32'd2;
            memory[2] <= 32'd3;
            memory[3] <= 32'd4;
            memory[4] <= 32'd5;
            
            waddr <= haddr[4:0];
            raddr<=haddr[4:0];
            present_state <= next_state;
            split_in <= 1'b0;
            valid_aft_split_in <= 1'b0;
            if (!hresetn)
            begin
               
                waddr <= 5'b0;
                raddr <= 5'b0;
                hready_out <= 1'b1;
                next_state <= idle;
            end
            else 
            begin
                case(present_state)
                    idle:begin
                        hready_out <= 1'b1;
                        waddr <= 5'b0;
                        raddr <= 5'b0;
                        if (hwrite && hsel)
                        begin 
                            next_state<= write;
                        end
                        else if (!hwrite && hsel)
                            next_state <= read; 
                        end
                        
                    read: begin
                            hrdata <= memory[raddr] ;
                            next_state <= idle;  
                        end
                    
                    write : begin
                            
                            next_state <= validity;  
                            end
                    validity: 
                            begin 
                                if (waddr < 5'd4)
                                begin
                                    error<=1'b1;
                                end
                                else
                                begin 
                                    memory[waddr] <= hwdata;
                                    error <= 1'b0;
                                end
                                    
                            end    
               
                        
                endcase
            end
            
        end
endmodule
