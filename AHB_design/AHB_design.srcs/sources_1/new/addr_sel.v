`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2024 12:20:47 AM
// Design Name: 
// Module Name: addr_sel
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


module addr_sel #(
    parameter master1 = 2'b00,
              master2 = 2'b01,
              master3 = 2'b10
    )(
    input hclk,
    input hresetn,
    input [31:0] mast1,
    input [31:0] mast2,
    input [31:0] mast3,
    input [1:0] hmaster,
    output reg [31:0] addr_mux_out
    );
    
    always@(*) begin
        if (!hresetn)
            addr_mux_out = 32'b0;
        else begin
            case(hmaster)
                master1:
                    addr_mux_out = mast1;
                master2:
                    addr_mux_out = mast2;
                master3:
                    addr_mux_out = mast3;
                default:
                    addr_mux_out = mast1;
            endcase
        end
    end
endmodule

