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


module AHB_addr_mux #(
    parameter master1 = 2'b00,
    parameter master2 = 2'b01,
    parameter master3 = 2'b10
    )(
    input hclk,
    input hresetn,
    input [31:0] mast1,
    input [31:0] mast2,
    input [31:0] mast3,
    input hwrite1,
    input hwrite2,
    input hwrite3,
    input [1:0] mux_sel,
    output reg [31:0] addr_mux_out,
    output reg hwrite
    );
    
    always@(*) begin
        if (!hresetn)
            addr_mux_out = 32'b0;
        else begin
            case(mux_sel)
                master1:
                begin
                    addr_mux_out = mast1;
                    hwrite = hwrite1;
                end
                master2:
                begin
                    addr_mux_out = mast2;
                    hwrite = hwrite2;
                end
                master3:
                begin
                    addr_mux_out = mast3;
                    hwrite = hwrite3;
                end
                default:
                begin
                    addr_mux_out = mast1;
                    hwrite = hwrite1;
                end
            endcase
        end
    end
endmodule
