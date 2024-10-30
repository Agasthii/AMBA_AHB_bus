`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2024 12:01:05 AM
// Design Name: 
// Module Name: decoder
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


module decoder(
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
    parameter slave1 = 2'b00, 
              slave2 = 2'b01, 
              slave3 = 2'b10, 
              slave4 = 2'b11;  

    always@(posedge hclk) begin
        if (!hresetn) begin
                hsel1 <= 1'b0;
                hsel2 <= 1'b0;
                hsel3 <= 1'b0;
                hsel4 <= 1'b0;
         end 
         else 
         begin
            case (slv_sel_out)       
            slave1:
                begin
                hsel1 <= 1'b1;
                hsel2 <= 1'b0;
                hsel3 <= 1'b0;
                hsel4 <= 1'b0;
                end
            slave2:
                begin
                hsel1 <= 1'b0;
                hsel2 <= 1'b1;
                hsel3 <= 1'b0;
                hsel4 <= 1'b0;
                end
           slave3:
                begin
                hsel1 <= 1'b0;
                hsel2 <= 1'b0;
                hsel3 <= 1'b1;
                hsel4 <= 1'b0;
                end
           slave4:
                begin
                hsel1 <= 1'b0;
                hsel2 <= 1'b0;
                hsel3 <= 1'b0;
                hsel4 <= 1'b1;
                end
            default:
                begin
                hsel1 <= 1'b0;
                hsel2 <= 1'b0;
                hsel3 <= 1'b0;
                hsel4 <= 1'b0;
                end 
            endcase
       end            
    end
endmodule

