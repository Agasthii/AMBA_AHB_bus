`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2024 05:51:25 PM
// Design Name: 
// Module Name: AHB_arbiter
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


module AHB_arbiter #(
    parameter mast1 = 2'b00,
    parameter mast2 = 2'b01,
    parameter mast3 = 2'b10
    )(
    input hclk, //master clock
    input hresetn,  //master reset, active LOW
    //from master
    input hbusreq1,
    input hbusreq2,
    input hbusreq3,
    input [1:0] htrans1,
    input [1:0] htrans2,
    input [1:0] htrans3,
    //from slave
    input [15:0] hsplit1,
    input [15:0] hsplit2,
    input [15:0] hsplit3,
    input [15:0] hsplit4,
    
    //to master
    output reg hgrant1,
    output reg hgrant2,
    output reg hgrant3,
    //to addr_mux & data_mux
    output reg [1:0] hmaster   //indicates the master which currently utilizes the bus
    );
    
    reg [1:0] present_mast, next_mast;
    
    always@(posedge hclk) begin
        if (!hresetn) begin
            present_mast <= mast1;
            next_mast <= mast1;
            hgrant1 <= 1'b0;
            hgrant2 <= 1'b0;
            hgrant3 <= 1'b0;
            hmaster <= 2'b00;
        end else begin
            present_mast <= next_mast;
            case (present_mast)
                mast1:
                begin
                    if (!hbusreq2 && !hbusreq3) begin
                        next_mast <= mast1;
                        hgrant1 <= 1'b1;
                        hgrant2 <= 1'b0;
                        hgrant3 <= 1'b0;
                        hmaster <= 2'b00;
                    end else begin
                        if (!hbusreq2 && hbusreq3)begin
                            if (htrans1 == 2'b00) begin
                                next_mast <= mast3;
                                hgrant1 <= 1'b0;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b1;
                                hmaster <= 2'b10;
                            end else begin
                                next_mast <= mast1;
                                hgrant1 <= 1'b1;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b0;
                                hmaster <= 2'b00;
                            end
                        end else begin
                            if (htrans1 == 2'b00) begin
                                next_mast <= mast2;
                                hgrant1 <= 1'b0;
                                hgrant2 <= 1'b1;
                                hgrant3 <= 1'b0;
                                hmaster <= 2'b01;
                            end else begin
                                next_mast <= mast1;
                                hgrant1 <= 1'b1;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b0;
                                hmaster <= 2'b00;
                            end
                        end
                    end
                end
                
                mast2:
                begin
                    if (!hbusreq1 && !hbusreq3) begin
                        next_mast <= mast2;
                        hgrant1 <= 1'b0;
                        hgrant2 <= 1'b1;
                        hgrant3 <= 1'b0;
                        hmaster <= 2'b01;
                    end else begin
                        if (!hbusreq1 && hbusreq3)begin
                            if (htrans2 == 2'b00) begin
                                next_mast <= mast3;
                                hgrant1 <= 1'b0;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b1;
                                hmaster <= 2'b10;
                            end else begin
                                next_mast <= mast2;
                                hgrant1 <= 1'b0;
                                hgrant2 <= 1'b1;
                                hgrant3 <= 1'b0;
                                hmaster <= 2'b01;
                            end
                        end else begin
                            if (htrans2 == 2'b00) begin
                                next_mast <= mast1;
                                hgrant1 <= 1'b1;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b0;
                                hmaster <= 2'b00;
                            end else begin
                                next_mast <= mast2;
                                hgrant1 <= 1'b0;
                                hgrant2 <= 1'b1;
                                hgrant3 <= 1'b0;
                                hmaster <= 2'b01;
                            end
                        end
                    end
                end
                
                mast3:
                begin
                    if (!hbusreq1 && !hbusreq2) begin
                        next_mast <= mast3;
                        hgrant1 <= 1'b0;
                        hgrant2 <= 1'b0;
                        hgrant3 <= 1'b1;
                        hmaster <= 2'b10;
                    end else begin
                        if (!hbusreq1 && hbusreq2)begin
                            if (htrans3 == 2'b00) begin
                                next_mast <= mast2;
                                hgrant1 <= 1'b0;
                                hgrant2 <= 1'b1;
                                hgrant3 <= 1'b0;
                                hmaster <= 2'b01;
                            end else begin
                                next_mast <= mast3;
                                hgrant1 <= 1'b0;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b1;
                                hmaster <= 2'b10;
                            end
                        end else begin
                            if (htrans3 == 2'b00) begin
                                next_mast <= mast1;
                                hgrant1 <= 1'b1;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b0;
                                hmaster <= 2'b00;
                            end else begin
                                next_mast <= mast3;
                                hgrant1 <= 1'b0;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b1;
                                hmaster <= 2'b10;
                            end
                        end
                    end
                end
                
                default:
                begin
                    next_mast <= mast1;
                    hgrant1 <= 1'b1;
                    hgrant2 <= 1'b0;
                    hgrant3 <= 1'b0;
                    hmaster <= 2'b00;
                end
            endcase
        end
    end
endmodule
