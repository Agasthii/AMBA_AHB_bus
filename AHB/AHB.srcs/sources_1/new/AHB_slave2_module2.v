`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2024 10:21:02 AM
// Design Name: 
// Module Name: AHB_slave2_module2
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


module AHB_slave2_module2(
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
    reg next_state_done;
    reg [1:0] present_state;
    reg [1:0] next_state;
    reg [2:0] counter;
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
            memory[9] <= 32'd0;
            memory[10] <= 32'd0;
            
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
                        /*waddr <= 5'b0;
                        raddr <= 5'b0;*/
                        if (hwrite)
                        begin 
                            next_state<= write;
                        end
                        else if (!hwrite)
                            next_state <= read; 
                             counter <= 3'd0;
                        end
                        
                    read: begin
                            if (counter != 3'b111 )
                                begin 
                                    counter <= counter +1;
                                    split_in <= 1'b1;
                                end
                            else if (counter == 3'b111)
                                begin
                                
                                hrdata <= memory[raddr] ;
                                split_in <= 1'b0;
                                next_state <= write; 
                                next_state_done <=1'b1; 
                                if (hwrite || ~hsel) 
                                    begin
                                    
                                    
                                    
                                    
                                    
                                    end
                                end
                  
                        end
                    
                  
                    write: 
                            begin 
                                if (waddr < 5'd4)
                                begin
                                    error<=1'b1;
                                    next_state <= idle;
                                end
                                else
                                begin 
                                    if (counter==3'b111)
                                    begin
                                        split_in <= 1'b0;
                                        hrdata <= memory[raddr] ;
                                    end
                                    memory[waddr] <= hwdata;
                                    error <= 1'b0;
                                    if  (~hsel || ~hwrite)
                                        begin next_state<=idle;
                                        end
                                end
                                    
                            end    
               
                        
                endcase
            end
            
        end
endmodule
