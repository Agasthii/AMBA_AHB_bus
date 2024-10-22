`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2024 10:50:49 PM
// Design Name: 
// Module Name: AHB_slave1_top
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


module AHB_slave2_top(
    input hclk, //master clock
    input hresetn,  //master reset, active LOW
    //from decoder
    input hsel,
    //from master
    input hwrite, //high -> write transfer, low -> read transfer (remains same during burst)
//    input [2:0] hsize, //size of transfer -> byte, halfword, word
//    input [2:0] hburst,    //single transfer, 4, 8, 16
//    input [3:0] hprot, //opcode fetch or data access, privileged mode access or user mode access
//    input [1:0] htrans,    //type of current transfer -> IDLE, BUSY, NONSEQ, SEQ
    input [31:0] haddr_mux_out,
    input [31:0] hwdata_mux_out,
    
    //to master
    output wire [31:0] hrdata,    //data from slave to master
    output wire hready,    //high -> transfer finished, low -> extend the transfer
    output wire [1:0] hresp,    //00 -> OK, 01 -> ERROR, 10 -> RETRY, 11 -> SPLIT
    //to arbiter
    output wire [15:0] hsplit
    );
    
    wire [31:0] din;   //data to the slave interface from the slave
    wire [31:0] addr_out;
    wire [31:0] dout;
    wire hwrite_out;
    
    AHB_slave2_module AHB_slave2_module_d(
        .hclk(hclk),
        .hresetn(hresetn),
        .addr_out(addr_out),
        .hwrite_out(hwrite_out),
        .dout(dout),
        .din(din)
        );
    
    AHB_slave AHB_slave2(
        .hclk(hclk),
        .hresetn(hresetn), 
        .addr_out(addr_out),
        .hwrite_out(hwrite_out),
        .dout(dout),
        .din(din),
        .hsel(hsel),
        .hwrite(hwrite), 
//        .hsize(hsize), 
//        .hburst(hburst),  
//        .hprot(hprot), 
//        .htrans(htrans),    
        .haddr_mux_out(haddr_mux_out),
        .hwdata_mux_out(hwdata_mux_out),
        .hrdata(hrdata),  
        .hready(hready),    
        .hresp(hresp),  
        .hsplit(hsplit)
        );
endmodule
