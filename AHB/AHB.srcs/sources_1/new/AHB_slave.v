`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2024 04:49:09 PM
// Design Name: 
// Module Name: AHB_slave
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


module AHB_slave(
    input hclk, //master clock
    input hresetn,  //master reset, active LOW
    //from slave module
    input [31:0] din,   //data to the slave interface from the slave
    //from decoder
    input hsel,
    //from master
    input hwrite, //high -> write transfer, low -> read transfer (remains same during burst)
    input [31:0] haddr_mux_out,
    input [31:0] hwdata_mux_out,
    
    //to slave module
    output reg [31:0] addr_out,
    output reg [31:0] dout,
    output reg hwrite_out,
    //to master
    output reg [31:0] hrdata,    //data from slave to master
    output reg hready,    //high -> transfer finished, low -> extend the transfer
    output reg [1:0] hresp,    //00 -> OK, 01 -> ERROR, 10 -> RETRY, 11 -> SPLIT
    //to arbiter
    output reg [15:0] hsplit
    );
    
    reg [31:0] temp_hwdata;
    
    always@(posedge hclk) begin
        if (!hresetn) begin
            hrdata <= 32'b0;
            hready <= 1'b0;
            hresp <= 2'b00;
            hsplit <= 16'b0;
            addr_out <= 32'b0;
            dout <= 32'b0;
            hwrite_out <= 1'b0;
        end else begin
            temp_hwdata <= hwdata_mux_out;
            if (hsel) begin
                if (hwrite) begin
                    addr_out <= haddr_mux_out;
                    dout <= temp_hwdata;
                    hrdata <= 32'b0;
                    hready <= 1'b1;
                    hresp <= 2'b00;
                    hsplit <= 16'b0;
                    hwrite_out <= hwrite;
                end else begin
                    addr_out <= haddr_mux_out;
                    dout <= temp_hwdata;
                    hrdata <= din;
                    hready <= 1'b1;
                    hresp <= 2'b00;
                    hsplit <= 16'b0;
                    hwrite_out <= hwrite;
                end
            end else begin
                hrdata <= 32'b0;
                hready <= 1'b0;
                hresp <= 2'b00;
                hsplit <= 16'b0;
                addr_out <= 32'b0;
                dout <= 32'b0;
                hwrite_out <= hwrite;
            end  
        end              
    end
endmodule
