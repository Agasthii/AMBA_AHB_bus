`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2024 05:18:11 PM
// Design Name: 
// Module Name: AHB_master_module
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


module AHB_master2_module(
    input hclk, //master clock
    input hresetn,  //master reset, active LOW
    input [31:0] dout,  //data out of the master interface to the master
    input hresp,

    output reg [31:0] addr, //address from the master module
    output reg [1:0] slv_sel_in, //slave identifier given to the master interface
    output reg [31:0] din,   //data to the master interface from the master
    output reg wr,   //from the master module to the master interface; high -> write transfer, low -> read transfer
    output reg enable,   //enable the master interface. This is sent from the master
    output reg hbusreq_in   //bus request from the master module
    );
    
    reg [1:0] counter;
    reg [2:0] counter_id;
    
    always@(posedge hclk) begin
        if (!hresetn) begin
            addr <= 32'b0;
            slv_sel_in <= 2'b00;
            din <= 32'd0;
            wr <= 1'b1;
            hbusreq_in <= 1'b0;
            enable <= 1'b0;
            counter <= 2'b0;
            counter_id <= 3'b0;
        end else begin
            if (counter_id == 3'b111 ) begin
                counter_id <= 3'b0;
                counter <= 2'b0;
            end else begin
                
                if (hresp) begin
                    counter_id <= counter_id + 1;
                end
            end
                
            case (counter_id)
                3'b000:
                begin
                    addr <= 32'd02;
                    slv_sel_in <= 2'b00;
                    din <= 32'd6;
                    wr <= 1'b1;
                    hbusreq_in <= 1'b1;
                    enable <= 1'b0;
                end
                3'b001:
                begin
                    addr <= 32'd7;
                    slv_sel_in <= 2'b00;
                    din <= 32'd7;
                    wr <= 1'b1;
                    hbusreq_in <= 1'b1;
                    enable <= 1'b1;
                end
                3'b010:
                begin
                    addr <= 32'd8;
                    slv_sel_in <= 2'b00;
                    din <= 32'd8;
                    wr <= 1'b1;
                    hbusreq_in <= 1'b1;
                    enable <= 1'b1;
                end
                3'b011:
                begin
                    addr <= 32'd9;
                    slv_sel_in <= 2'b00;
                    din <= 32'd9;
                    wr <= 1'b1;
                    hbusreq_in <= 1'b1;
                    enable <= 1'b1;
                end
                3'b100:
                begin
                    addr <= 32'd10;
                    slv_sel_in <= 2'b00;
                    din <= 32'd10;
                    wr <= 1'b1;
                    hbusreq_in <= 1'b1;
                    enable <= 1'b1;
                end
                3'b101:
                begin
                    addr <= 32'd7;
                    slv_sel_in <= 2'b00;
                    din <= 32'b0;
                    wr <= 1'b0;
                    hbusreq_in <= 1'b1;
                    enable <= 1'b1;
                end
                3'b110:
                begin
                    addr <= 32'd8;
                    slv_sel_in <= 2'b00;
                    din <= 32'b0;
                    wr <= 1'b0;
                    hbusreq_in <= 1'b1;
                    enable <= 1'b1;
                end
                3'b111:
                begin
                    addr <= 32'd9;
                    slv_sel_in <= 2'b00;
                    din <= 32'b0;
                    wr <= 1'b0;
                    hbusreq_in <= 1'b1;
                    enable <= 1'b1;
                    
                end
                default:
                begin
                    addr <= 32'b1;
                    slv_sel_in <= 2'b01;
                    din <= 32'b0;
                    wr <= 1'b0;
                    hbusreq_in <= 1'b1;
                    enable <= 1'b1;
                end
            endcase
        end
    end
endmodule
