`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2024 05:48:15 PM
// Design Name: 
// Module Name: AHB_top_module
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


module AHB_top_module(
    input hclk, //master clock
    input hresetn,  //master reset, active LOW
    input [31:0] ext_addr,
    input [1:0] ext_slv_sel_in,
    input [31:0] ext_mast_din,
    input ext_wr,
    input ext_enable,
    input ext_hbusreq_in,
    input [31:0] ext_slave_din,
    
    output [31:0] ext_mast_dout,
    output [31:0] ext_addr_out,
    output [31:0] ext_slave_dout,
    output ext_hwrite_out
    );
    
    wire hbusreq1;
    wire hbusreq2;
    wire hbusreq3;
    
    wire hready;    //high -> transfer finished, low -> extend the transfer
    wire hready1;
    wire hready2;
    wire hready3;
    wire hready4;
    wire [1:0] hresp;    //00 -> OK, 01 -> ERROR, 10 -> RETRY, 11 -> SPLIT
    
    wire [31:0] haddr_mux_out;
    wire [31:0] hwdata_mux_out;
    
    wire hwrite; //high -> write transfer, low -> read transfer (remains same during burst)
    wire hwrite1;
    wire hwrite2;
    wire hwrite3;
    
    wire [31:0] hrdata1;
    wire [31:0] hrdata2;
    wire [31:0] hrdata3;
    wire [31:0] hrdata4;
    
    wire [15:0] hsplit1;
    wire [15:0] hsplit2;
    wire [15:0] hsplit3;
    wire [15:0] hsplit4;
    
    wire hsel1;
    wire hsel2;
    wire hsel3;
    wire hsel4;
    
    wire hgrant1;
    wire hgrant2;
    wire hgrant3;
    
    wire [1:0] htrans1;
    wire [1:0] htrans2;
    wire [1:0] htrans3;
    
    wire [1:0] slv_sel_out;
    
    wire [31:0] hwdata1;
    wire [31:0] hwdata2;
    wire [31:0] hwdata3;
    
    wire [31:0] haddr1;
    wire [31:0] haddr2;
    wire [31:0] haddr3;
    
    wire [1:0] hmaster;
    
    wire [31:0] hrdata_mux_out;
    
//    wire hmastlock;
    
    AHB_master1_top AHB_master1_top_d(
        .hclk(hclk),
        .hresetn(hresetn),
        .hrdata(hrdata_mux_out),
        .hready(hready),
        .hresp(hresp),  
        .hgrant(hgrant1),
   
        .haddr(haddr1),
        .hwrite(hwrite1),

        .htrans(htrans1),
        .hwdata(hwdata1),
        .slv_sel_out(slv_sel_out1),
        .hbusreq(hbusreq1)
        );
        
    AHB_master2_top AHB_master2_top_d(
        .hclk(hclk),
        .hresetn(hresetn),
        .hrdata(hrdata_mux_out),
        .hready(hready),
        .hresp(hresp), 
        .hgrant(hgrant2),
   
        .haddr(haddr2),
        .hwrite(hwrite2),
        .htrans(htrans2),
        .hwdata(hwdata2),
        .slv_sel_out(slv_sel_out2),
        .hbusreq(hbusreq2)
        );
        
    AHB_master3_interface AHB_master3_interface_d(
        .hclk(hclk),
        .hresetn(hresetn),
        .hrdata(hrdata_mux_out),
        .hready(hready),
        .hresp(hresp),      
        .hgrant(hgrant3),
        .addr(ext_addr),            
        .slv_sel_in(ext_slv_sel_in),
        .din(ext_mast_din),              
        .wr(ext_wr),                
        .enable(ext_enable),        
        .hbusreq_in(ext_hbusreq_in),
        
        .dout(ext_mast_dout),
        .haddr(haddr3),
        .hwrite(hwrite3),
        .htrans(htrans3),
        .hwdata(hwdata3),
        .slv_sel_out(slv_sel_out3)
//        .hbusreq(hbusreq3)
        );
        
    AHB_arbiter AHB_arbiter_d(
        .hclk(hclk),
        .hresetn(hresetn),
        .hbusreq1(hbusreq1),
        .hbusreq2(hbusreq2),
        .hbusreq3(ext_hbusreq_in),
        .htrans1(htrans1),
        .htrans2(htrans2),
        .htrans3(htrans3),
        .hsplit1(hsplit1),
        .hsplit2(hsplit2),
        .hsplit3(hsplit3),
        .hsplit4(hsplit4),
        .hgrant1(hgrant1),
        .hgrant2(hgrant2),
        .hgrant3(hgrant3),
        .hmaster(hmaster)
        );
        
    AHB_decoder AHB_decoder_d(
        .hclk(hclk),
        .hresetn(hresetn),
        .slv_sel_out1(slv_sel_out1),
        .slv_sel_out2(slv_sel_out2),
        .slv_sel_out3(slv_sel_out3),
        .hsel1(hsel1),
        .hsel2(hsel2),
        .hsel3(hsel3),
        .hmaster(hmaster)
        );
        
    AHB_addr_mux AHB_addr_mux_d(
        .hclk(hclk),
        .hresetn(hresetn),
        .mast1(haddr1),
        .mast2(haddr2),
        .mast3(haddr3),
        .hwrite1(hwrite1),
        .hwrite2(hwrite2),
        .hwrite3(hwrite3),
        .mux_sel(hmaster),
        .addr_mux_out(haddr_mux_out),
        .hwrite(hwrite)
        );
    
    AHB_write_data_mux AHB_write_data_mux_d(
        .hclk(hclk),
        .hresetn(hresetn),
        .mast1(hwdata1),
        .mast2(hwdata2),
        .mast3(hwdata3),
        .mux_sel(hmaster),
        .write_mux_out(hwdata_mux_out)
        );
    
    AHB_read_data_mux AHB_read_data_mux_d(
        .hclk(hclk),
        .hresetn(hresetn),
        .slv1(hrdata1),
        .slv2(hrdata2),
        .slv3(hrdata3),
        .slv4(hrdata4),
        .red1(hready1),
        .red2(hready2),
        .red3(hready3),
        .red4(hready4),
        .mux_sel(slv_sel_out),
        .hready_mux_out(hready),
        .read_mux_out(hrdata_mux_out)
        );
        
    AHB_slave1_top AHB_slave1_top(
        .hclk(hclk),
        .hresetn(hresetn), 
        .hsel(hsel1),
        .hwrite(hwrite),  
        .haddr_mux_out(haddr_mux_out),
        .hwdata_mux_out(hwdata_mux_out),
        .hrdata(hrdata1),  
        .hready(hready1),    
        .hresp(hresp),  
        .hsplit(hsplit1)
        );
        
    AHB_slave2_top AHB_slave2_top(
        .hclk(hclk),
        .hresetn(hresetn), 
        .hsel(hsel2),
        .hwrite(hwrite),     
        .haddr_mux_out(haddr_mux_out),
        .hwdata_mux_out(hwdata_mux_out),
        .hrdata(hrdata2),  
        .hready(hready2),    
        .hresp(hresp),
        .hsplit(hsplit2)
        );
    
    AHB_slave3_top AHB_slave3_top(
        .hclk(hclk),
        .hresetn(hresetn), 
        .hsel(hsel3),
        .hwrite(hwrite),    
        .haddr_mux_out(haddr_mux_out),
        .hwdata_mux_out(hwdata_mux_out),
        .hrdata(hrdata3),  
        .hready(hready3),    
        .hresp(hresp),
        .hsplit(hsplit3)
        );
    
   /* AHB_slave4_interface AHB_slave4_interface_d(
        .hclk(hclk),
        .hresetn(hresetn),
        .din(ext_slave_din),
        .hsel(hsel4),
        .hwrite(hwrite),   
        .haddr_mux_out(haddr_mux_out),
        .hwdata_mux_out(hwdata_mux_out), 
        .addr_out(ext_addr_out),
        .hwrite_out(ext_hwrite_out),
        .dout(ext_slave_dout),
        .hrdata(hrdata4),  
        .hready(hready4),    
        .hresp(hresp),
        .hsplit(hsplit4)
        );
        
        */
endmodule
