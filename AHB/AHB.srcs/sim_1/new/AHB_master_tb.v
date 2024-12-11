`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2024 04:27:49 PM
// Design Name: 
// Module Name: AHB_master_tb
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


module AHB_master_tb();
    
    reg hclk;
    reg hresetn;
    reg [31:0] ext_addr;
    reg [1:0] ext_slv_sel_in;
    reg [31:0] ext_mast_din;
    reg ext_wr;
    reg ext_enable;
    reg ext_hbusreq_in;
    reg [31:0] ext_slave_din;
    
    wire [31:0]ext_mast_dout;
    wire [31:0] ext_addr_out;
    wire [31:0] ext_slave_dout;
    wire ext_hwrite_out;
    
    AHB_top_module AHB_top_module_dut(
        .hclk(hclk),
        .hresetn(hresetn),
        .ext_addr(ext_addr),
        .ext_slv_sel_in(ext_slv_sel_in),
        .ext_mast_din(ext_mast_din),
        .ext_wr(ext_wr),
        .ext_enable(ext_enable),
        .ext_hbusreq_in(ext_hbusreq_in),
        .ext_slave_din(ext_slave_din),
        
        .ext_mast_dout(ext_mast_dout),
        .ext_addr_out(ext_addr_out),
        .ext_slave_dout(ext_slave_dout),
        .ext_hwrite_out(ext_hwrite_out)
        );
   
    initial begin
        hclk = 1'b0;
        hresetn = 1'b0;
        #20
        
        hresetn = 1'b1;
        ext_addr = 32'b0;
        ext_slv_sel_in = 2'b00;
        ext_mast_din = 32'b0;
        ext_wr = 1'b0;
        ext_enable = 1'b0;
        ext_hbusreq_in = 1'b0;
        ext_slave_din = 32'b0;
        #800
        
        hresetn = 1'b1;
        ext_addr = 32'b0;
        ext_slv_sel_in = 2'b00;
        ext_mast_din = 32'b0;
        ext_wr = 1'b0;
        ext_enable = 1'b1;
        ext_hbusreq_in = 1'b1;
        ext_slave_din = 32'b0;
    end
    
    always #10 hclk = ~hclk;
    
endmodule
