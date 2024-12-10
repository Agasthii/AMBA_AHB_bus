`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2024 06:15:42 PM
// Design Name: 
// Module Name: uart
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


module uart(
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
    output ext_hwrite_out,
    );
endmodule
