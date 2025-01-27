`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2024 09:50:15 AM
// Design Name: 
// Module Name: AHB_slave_module2
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


module AHB_slave_interfac2(
    input hclk, //master clock
    input hresetn,  //master reset, active LOW
    //from slave module
    input split_in,
    input error,
    input hready_in,
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
    output  hwrite_out,
    //to master
    output reg [31:0] hrdata,    //data from slave to master
    output reg hready,    //high -> transfer finished, low -> extend the transfer
    output reg [1:0] hresp,    //00 -> OK, 01 -> ERROR, 10 -> RETRY, 11 -> SPLIT
    output reg hsplit
    //to arbiter
    );
    reg [31:0]temp_hwdata; //register to store hwdata for busy situation
    reg temp_hwrite;
    assign hwrite_out=hwrite;
    always @(posedge hclk)
    begin
        hready<= hready_in;
        haddr_out <= haddr;
        temp_hwdata <= hwdata;
        haddr_out <= haddr;
        
        if (!hresetn)
        begin
        hrdata <= 32'b0;
        hready <= 1'b1;
        hresp <= 2'b00;
        haddr_out <= 32'b0;
        hwdata_out <= 32'b0;
    
        end
        
        else 
        begin
        
        
        
        if (hsel)
        begin
            if (split_in)
            begin
            hready <= 1'b0;
            hresp <=2'b10;
            hsplit <= 1'b1; 
            end
            else if (hwrite)
            begin
               
                hwdata_out <= temp_hwdata;
                hrdata <= 32'b0;
                hsplit <= 1'b0;
                
            end
            
            else if (!hwrite)
            begin
                hrdata <= hrdata_in;    
                hsplit <= 1'b0;
               

            end
        end
        
        else 
        begin
            hrdata <= 32'b0; 
            haddr_out <= 32'b0;
            hwdata_out <= 32'b0;
        hsplit <= 1'b0;
           
        end
        
    end
    end
endmodule
