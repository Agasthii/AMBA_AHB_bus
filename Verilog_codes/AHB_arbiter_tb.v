`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2024 05:39:22 PM
// Design Name: 
// Module Name: AHB_arbiter_tb
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


module AHB_arbiter_tb();

reg hclk; //master clock
reg hresetn;  //master reset, active LOW
reg hbusreq1;
reg hbusreq2;
reg hbusreq3;
reg [1:0] htrans1;
reg [1:0] htrans2;
reg [1:0] htrans3;
reg [15:0] hsplit1;
reg [15:0] hsplit2;
reg [15:0] hsplit3;

wire hgrant1;
wire hgrant2;
wire hgrant3;
wire [1:0] hmaster;

AHB_arbiter AHB_arbiter_dut(
    .hclk(hclk),
    .hresetn(hresetn),
    .hbusreq1(hbusreq1),
    .hbusreq2(hbusreq2),
    .hbusreq3(hbusreq3),
    .htrans1(htrans1),
    .htrans2(htrans2),
    .hsplit1(hsplit1),
    .hsplit2(hsplit2),
    .hsplit3(hsplit3),
    
    .hgrant1(hgrant1),
    .hgrant2(hgrant2),
    .hgrant3(hgrant3),
    .hmaster(hmaster)
    );
    
    initial begin
        hclk=1'b0;
        hresetn=1'b0;
        hbusreq1=1'b0;
        hbusreq2=1'b0;
        hbusreq3=1'b0;
        htrans1=2'b0;
        htrans2=2'b0;
        htrans3=2'b0;
        hsplit1=16'b0;
        hsplit2=16'b0;
        hsplit3=16'b0;
        #20
        hresetn=1'b1;
        hbusreq1=1'b1;
        #160
        hresetn=1'b1;
        hbusreq1=1'b1;
        hbusreq2=1'b1;
        htrans1=2'b01;
        #160
        hresetn=1'b1;
        hbusreq1=1'b1;
        hbusreq2=1'b1;
        htrans1=2'b00;
        #160
        hresetn=1'b1;
        hbusreq1=1'b0;
        hbusreq2=1'b1;
        hbusreq3=1'b0;
        htrans1=2'b00;
        #160
        hresetn=1'b1;
        hbusreq1=1'b0;
        hbusreq2=1'b1;
        hbusreq3=1'b1;
        htrans1=2'b00;
        #160
        hresetn=1'b1;
        hbusreq1=1'b0;
        hbusreq2=1'b0;
        hbusreq3=1'b1;
        htrans1=2'b00;
        #160
        hresetn=1'b1;
        hbusreq1=1'b1;
        hbusreq2=1'b1;
        htrans1=2'b00;
    end
    
    always #10 hclk = ~hclk;
    
endmodule
