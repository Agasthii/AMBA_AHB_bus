`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2024 11:12:02 AM
// Design Name: 
// Module Name: AHB_slave4_interface
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


module AHB_slave4_interface(
    input hclk, //master clock
    input hresetn,  //master reset, active LOW
    //from slave module
    input split_in,
    input error,
    input valid_aft_split_in,
    input [31:0] hrdata_in,   //data to the slave interface from the slave
    
    //from decoder
    input hsel,
    
    //from master
    input hwrite, //high -> write transfer, low -> read transfer (remains same during burst)
    input [31:0] haddr,
    input [31:0] hwdata,
    input [1:0] htrans,
    
    //from arbiter
    input [1:0]hmaster,
    
    //to slave module
    output reg [31:0] haddr_out,
    output reg [31:0] hwdata_out,
    output reg hwrite_out,
    //to master
    output reg [31:0] hrdata,    //data from slave to master
    output reg hready,    //high -> transfer finished, low -> extend the transfer
    output reg [1:0] hresp,    //00 -> OK, 01 -> ERROR, 10 -> RETRY, 11 -> SPLIT
    output reg hsplit
    //to arbiter
    );
    reg [31:0]temp_hwdata; //register to store hwdata for busy situation
    reg temp_hwrite;
    always @(posedge hclk)
    begin
        if (!hresetn)
        begin
        hrdata <= 32'b0;
        hready <= 1'b0;
        hresp <= 2'b00;
        haddr_out <= 32'b0;
        hwdata_out <= 32'b0;
        hwrite_out <= 1'b0;
        end
        
        else 
        begin
        temp_hwdata <= hwdata;
        temp_hwrite <= hwrite;
        if (hsel)
        begin
            if (split_in)
            begin
            hready <= 1'b0;
            hresp <=2'b10;
            hsplit <= 1'b1; 
            end
            if (error)
            begin 
            hresp <= 2'b10;
            hready <= 1'b1;
            end
            if (temp_hwrite)
            begin
                haddr_out <= haddr;
                hwdata_out <= temp_hwdata;
                hrdata <= 32'b0;
                hwrite_out <= temp_hwrite;
            end
            
            else
            begin
                haddr_out <= haddr;
                hrdata <= hrdata_in;
                hwrite_out <= hwrite; 
            end
        end
        
        else 
        begin
            hrdata <= 32'b0; 
            haddr_out <= 32'b0;
            hwdata_out <= 32'b0;
            hwrite_out <= hwrite;
        end
        
    end
    end
endmodule
