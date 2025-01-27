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


module AHB_decoder #(
    parameter master1 = 2'b00,
    parameter master2 = 2'b01,
    parameter master3 = 2'b10
    )(
    input hclk,
    input hresetn,
    //from master
    input [1:0] slv_sel_out1,
    input [1:0] slv_sel_out2,
    input [1:0] slv_sel_out3,
    //from arbiter
    input [1:0] hmaster,
    //to slave
    output reg hsel1,
    output reg hsel2,
    output reg hsel3,
    output reg hsel4,
    //to read mux
    output reg [1:0] mux_sel_slave
    );
    always@(posedge hclk) begin
        if (!hresetn) begin
            hsel1 <= 1'b0;
            hsel2 <= 1'b0;
            hsel3 <= 1'b0;
            hsel4 <= 1'b0;
        end else begin
            case (hmaster)
                master1:
                begin
                    mux_sel_slave <= slv_sel_out1;
                    if (slv_sel_out1 == 2'b00) begin
                        hsel1 <= 1'b1;
                        hsel2 <= 1'b0;
                        hsel3 <= 1'b0;
                        hsel4 <= 1'b0;
                    end else if (slv_sel_out1 == 2'b01) begin
                        hsel1 <= 1'b0;
                        hsel2 <= 1'b1;
                        hsel3 <= 1'b0;
                        hsel4 <= 1'b0;
                    end else if (slv_sel_out1 == 2'b10) begin
                        hsel1 <= 1'b0;
                        hsel2 <= 1'b0;
                        hsel3 <= 1'b1;
                        hsel4 <= 1'b0;
                    end else if (slv_sel_out1 == 2'b11) begin
                        hsel1 <= 1'b0;
                        hsel2 <= 1'b0;
                        hsel3 <= 1'b0;
                        hsel4 <= 1'b1;
                    end
                end
                master2:
                begin
                    mux_sel_slave <= slv_sel_out2;
                    if (slv_sel_out2 == 2'b00) begin
                        hsel1 <= 1'b1;
                        hsel2 <= 1'b0;
                        hsel3 <= 1'b0;
                        hsel4 <= 1'b0;
                    end else if (slv_sel_out2 == 2'b01) begin
                        hsel1 <= 1'b0;
                        hsel2 <= 1'b1;
                        hsel3 <= 1'b0;
                        hsel4 <= 1'b0;
                    end else if (slv_sel_out2 == 2'b10) begin
                        hsel1 <= 1'b0;
                        hsel2 <= 1'b0;
                        hsel3 <= 1'b1;
                        hsel4 <= 1'b0;
                    end else if (slv_sel_out2 == 2'b11) begin
                        hsel1 <= 1'b0;
                        hsel2 <= 1'b0;
                        hsel3 <= 1'b0;
                        hsel4 <= 1'b1;
                    end
                end
                master3:
                begin
                    mux_sel_slave <= slv_sel_out3;
                    if (slv_sel_out3 == 2'b00) begin
                        hsel1 <= 1'b1;
                        hsel2 <= 1'b0;
                        hsel3 <= 1'b0;
                        hsel4 <= 1'b0;
                    end else if (slv_sel_out3 == 2'b01) begin
                        hsel1 <= 1'b0;
                        hsel2 <= 1'b1;
                        hsel3 <= 1'b0;
                        hsel4 <= 1'b0;
                    end else if (slv_sel_out3 == 2'b10) begin
                        hsel1 <= 1'b0;
                        hsel2 <= 1'b0;
                        hsel3 <= 1'b1;
                        hsel4 <= 1'b0;
                    end else if (slv_sel_out3 == 2'b11) begin
                        hsel1 <= 1'b0;
                        hsel2 <= 1'b0;
                        hsel3 <= 1'b0;
                        hsel4 <= 1'b1;
                    end
                end
                default:
                begin
                    mux_sel_slave <= slv_sel_out1;
                    if (slv_sel_out1 == 2'b00) begin
                        hsel1 <= 1'b1;
                        hsel2 <= 1'b0;
                        hsel3 <= 1'b0;
                        hsel4 <= 1'b0;
                    end else if (slv_sel_out1 == 2'b01) begin
                        hsel1 <= 1'b0;
                        hsel2 <= 1'b1;
                        hsel3 <= 1'b0;
                        hsel4 <= 1'b0;
                    end else if (slv_sel_out1 == 2'b10) begin
                        hsel1 <= 1'b0;
                        hsel2 <= 1'b0;
                        hsel3 <= 1'b1;
                        hsel4 <= 1'b0;
                    end else if (slv_sel_out1 == 2'b11) begin
                        hsel1 <= 1'b0;
                        hsel2 <= 1'b0;
                        hsel3 <= 1'b0;
                        hsel4 <= 1'b1;
                    end
                end
            endcase
        end
    end
endmodule
