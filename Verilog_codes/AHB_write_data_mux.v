`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2024 06:14:38 PM
// Design Name: 
// Module Name: AHB_write_data_mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// `timescale 1ns / 1ps
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


module AHB_write_data_mux #(
    parameter master1 = 2'b00,
    parameter master2 = 2'b01,
    parameter master3 = 2'b10
    )(
    input hclk,
    input hresetn,
    input [31:0] mast1,
    input [31:0] mast2,
    input [31:0] mast3,
    input [1:0] mux_sel,
    output reg [31:0] write_mux_out
    );
    
    always@(*) begin
        if (!hresetn)
            write_mux_out = 32'b0;
        else begin
            case(mux_sel)
                master1:
                    write_mux_out = mast1;
                master2:
                    write_mux_out = mast2;
                master3:
                    write_mux_out = mast3;
                default:
                    write_mux_out = mast1;
            endcase
        end
    end
endmodule