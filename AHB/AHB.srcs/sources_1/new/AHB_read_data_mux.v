`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2024 07:58:19 PM
// Design Name: 
// Module Name: AHB_addr_mux
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


module AHB_read_data_mux #(
    parameter slave1 = 2'b00,
    parameter slave2 = 2'b01,
    parameter slave3 = 2'b10,
    parameter slave4 = 2'b11
    )(
    input hclk,
    input hresetn,
    input [31:0] slv1,
    input [31:0] slv2,
    input [31:0] slv3,
    input [31:0] slv4,
    input red1,
    input red2,
    input red3,
    input red4,
    input [1:0] mux_sel,
    output reg hready_mux_out,
    output reg [31:0] read_mux_out
    );
    
    always@(*) begin
        if (!hresetn) begin
            read_mux_out = 32'b0;
            hready_mux_out = 1'b0;
        end else begin
            case(mux_sel)
                slave1:
                begin
                    read_mux_out = slv1;
                    hready_mux_out = red1;
                end
                slave2:
                begin
                    read_mux_out = slv2;
                    hready_mux_out = red2;
                end
                slave3:
                begin
                    read_mux_out = slv3;
                    hready_mux_out = red3;
                end
                slave4:
                begin
                    read_mux_out = slv4;
                    hready_mux_out = red4;
                end
                default:
                begin
                    read_mux_out = slv1;
                    hready_mux_out = red1;
                end
            endcase
        end
    end
endmodule
