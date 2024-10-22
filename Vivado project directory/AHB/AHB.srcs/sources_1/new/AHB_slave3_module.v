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


module AHB_slave3_module(
    input hclk, //master clock
    input hresetn,  //master reset, active LOW
    //from slave interface
    input [31:0] addr_out,
    input [31:0] dout,
    input hwrite_out,
    output reg [31:0] din   //data to the slave interface from the slave
    );
    
    always@(posedge hclk) begin
        if (!hresetn)
            din <= 32'b0;
        else
            din <= 32'b0;
    end
endmodule
