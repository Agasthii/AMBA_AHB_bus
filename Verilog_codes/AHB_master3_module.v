`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2024 05:18:11 PM
// Design Name: 
// Module Name: AHB_master_module
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


module AHB_master3_module(
    input hclk, //master clock
    input hresetn,  //master reset, active LOW
    input [31:0] dout,  //data out of the master interface to the master

    output reg [31:0] addr, //address from the master module
    output reg [1:0] slv_sel_in, //slave identifier given to the master interface
    output reg [31:0] din,   //data to the master interface from the master
    output reg wr,   //from the master module to the master interface; high -> write transfer, low -> read transfer
    output reg enable,   //enable the master interface. This is sent from the master
    output reg hbusreq_in   //bus request from the master module
    );
    
    always@(posedge hclk) begin
        addr <= 32'b0;
        slv_sel_in <= 2'b00;
        din <= 32'b0;
        wr <= 1'b1;
        enable <= 1'b1;
        hbusreq_in <= 1'b1;
    end
endmodule
