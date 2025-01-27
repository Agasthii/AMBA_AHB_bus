`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2024 05:27:04 PM
// Design Name: 
// Module Name: AHB_master1_top
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


module AHB_master3_top(
    input hclk, //master clock
    input hresetn,  //master reset, active LOW
    //from slave
    input [31:0] hrdata,    //data from slave to master
    input hready,    //high -> transfer finished, low -> extend the transfer
    input [1:0] hresp,    //00 -> OK, 01 -> ERROR, 10 -> RETRY, 11 -> SPLIT
    input hexokay,  //Indicates the success or failure of a exclusive transfer
    //from arbiter
    input hgrant,   //grant signal from arbiter
    
    //to slave
    output wire [31:0] haddr,    //32-bit system address bus
    output wire hwrite, //high -> write transfer, low -> read transfer (remains same during burst)
    output wire [2:0] hsize, //size of transfer -> byte, halfword, word
    output wire [2:0] hburst,    //single transfer, 4, 8, 16
    output wire [3:0] hprot, //opcode fetch or data access, privileged mode access or user mode access
    output wire [1:0] htrans,    //type of current transfer -> IDLE, BUSY, NONSEQ, SEQ
    output wire [31:0] hwdata,    //write data
    //to arbiter
    output wire hbusreq, //bus request to the arbiter
    output wire hlock,
    // to decoder
    output wire [1:0] slv_sel_out    //slave identifier given out of the master interface
    );
    
    wire [31:0] addr; //address from the master module
    wire [1:0] slv_sel_in; //slave identifier given to the master interface
    wire [31:0] din;   //data to the master interface from the master
    wire wr;   //from the master module to the master interface; high -> write transfer, low -> read transfer
    wire enable;   //enable the master interface. This is sent from the master
    wire hbusreq_in;   //bus request from the master module
    
    wire [31:0] dout;  //data out of the master interface to the master
    
    AHB_master3_module AHB_master3_module_d(
        .hclk(hclk),
        .hresetn(hresetn),   
        .addr(addr),
        .slv_sel_in(slv_sel_in),
        .din(din),
        .wr(wr),
        .enable(enable),
        .hbusreq_in(hbusreq_in),
   
        .dout(dout)
        );
    
    AHB_master AHB_master3_d(
        .hclk(hclk),
        .hresetn(hresetn),
        .hrdata(hrdata),
        .hready(hready),
        .hresp(hresp),
        .hexokay(hexokay),   
        .addr(addr),
        .slv_sel_in(slv_sel_in),
        .din(din),
        .wr(wr),
        .enable(enable),
        .hbusreq_in(hbusreq_in),
        .hgrant(hgrant),
   
        .haddr(haddr),
        .hwrite(hwrite),
        .hsize(hsize),
        .hburst(hburst),
        .hprot(hprot),
        .htrans(htrans),
        .hwdata(hwdata),
        .slv_sel_out(slv_sel_out),
        .dout(dout),
        .hbusreq(hbusreq),
        .hlock(hlock)
        );
    
endmodule
