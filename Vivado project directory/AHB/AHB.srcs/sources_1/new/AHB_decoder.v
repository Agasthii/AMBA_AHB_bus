`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2024 04:50:53 PM
// Design Name: 
// Module Name: AHB_decoder
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


module AHB_decoder(
    input hclk,
    input hresetn,
    //from master
    input [1:0] slv_sel_out,
    //to slave
    output reg hsel1,
    output reg hsel2,
    output reg hsel3,
    output reg hsel4
    );
    always@(posedge hclk) begin
        if (!hresetn) begin
            hsel1 <= 1'b0;
            hsel2 <= 1'b0;
            hsel3 <= 1'b0;
            hsel4 <= 1'b0;
        end else begin
            if (slv_sel_out == 2'b00) begin
                hsel1 <= 1'b1;
                hsel2 <= 1'b0;
                hsel3 <= 1'b0;
                hsel4 <= 1'b0;
            end else if (slv_sel_out == 2'b01) begin
                hsel1 <= 1'b0;
                hsel2 <= 1'b1;
                hsel3 <= 1'b0;
                hsel4 <= 1'b0;
            end else if (slv_sel_out == 2'b10) begin
                hsel1 <= 1'b0;
                hsel2 <= 1'b0;
                hsel3 <= 1'b1;
                hsel4 <= 1'b0;
            end else if (slv_sel_out == 2'b11) begin
                hsel1 <= 1'b0;
                hsel2 <= 1'b0;
                hsel3 <= 1'b0;
                hsel4 <= 1'b1;
            end
        end
    end
endmodule
