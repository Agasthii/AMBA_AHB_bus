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
    input htrans1,
    input htrans2,
    input htrans3,
    //from slave
    input  hsplit1,
    input  hsplit2,
    input  hsplit3,
    input  hsplit4,
    
    //to master
    output reg hgrant1,
    output reg hgrant2,
    output reg hgrant3,
    output reg hresp,
    //to addr_mux & data_mux
    output reg [1:0] hmaster   //indicates the master which currently utilizes the bus
    );
    
    reg [1:0] present_mast, next_mast;
    reg mast_changed;
    reg no_bus_req;
    
//    always@(next_mast) begin
//        present_mast <= next_mast;
//    end
    
    always@(posedge hclk) begin
        if (!hresetn) begin
            present_mast <= mast1;
            next_mast <= mast1;
            hgrant1 <= 1'b0;
            hgrant2 <= 1'b0;
            hgrant3 <= 1'b0;
            hmaster <= 2'b00;
            mast_changed <= 1'b0;
            no_bus_req <= 0;
        end   
        else if (hsplit2)
        begin 
            hgrant2<= 1'b0;
            hresp <= 1'b1;
            if (hbusreq1)
            begin 
                hgrant1 <= 1'b1;
                present_mast <= mast1;  
            end
            
            if (hbusreq3)
            begin 
                hgrant3 <= 1'b1;
                present_mast <= mast3;  
            end
            
        else if (!hsplit2)
        begin 
            hgrant2<= 1'b1;
            hresp <= 1'b1;
        end
        
       
        end else begin
//            present_mast <= next_mast;
                
            case (present_mast)
                mast1:
                begin
                    if (!hbusreq1 && !hbusreq2 && !hbusreq3 && hgrant1) begin
                        present_mast <= mast1;
                        hgrant1 <= 1'b1;
                        hgrant2 <= 1'b0;
                        hgrant3 <= 1'b0;
                        hmaster <= 2'b00;
                        mast_changed <= 1'b1;
                        no_bus_req <= 1;
                    end else if (!hbusreq2 && !hbusreq3) begin
                        present_mast <= mast1;
                        hgrant1 <= 1'b1;
                        hgrant2 <= 1'b0;
                        hgrant3 <= 1'b0;
                        hmaster <= 2'b00;
                        if (no_bus_req)
                            mast_changed <= 1'b1;
                        else
                            mast_changed <= 1'b0;
                        no_bus_req <= 0;
                    end else begin
                        if (!hbusreq2 && hbusreq3)begin
                            if (htrans1 == 1'b0 && mast_changed == 1'b0) begin
                                present_mast <= mast3;
                                hgrant1 <= 1'b0;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b1;
                                hmaster <= 2'b10;
                                if (no_bus_req)
                                    mast_changed <= 1'b1;
                                else
                                    mast_changed <= 1'b0;
                                no_bus_req <= 0;
                            end else begin
                                present_mast <= mast1;
                                hgrant1 <= 1'b1;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b0;
                                hmaster <= 2'b00;
                                if (no_bus_req)
                                    mast_changed <= 1'b1;
                                else
                                    mast_changed <= 1'b0;
                                no_bus_req <= 0;
                            end
                        end else begin
                            if (htrans1 == 1'b0 && mast_changed == 1'b0) begin
                                present_mast <= mast2;
                                hgrant1 <= 1'b0;
                                hgrant2 <= 1'b1;
                                hgrant3 <= 1'b0;
                                hmaster <= 2'b01;
                                if (no_bus_req)
                                    mast_changed <= 1'b1;
                                else
                                    mast_changed <= 1'b0;
                                no_bus_req <= 0;
                            end else begin
                                present_mast <= mast1;
                                hgrant1 <= 1'b1;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b0;
                                hmaster <= 2'b00;
                                if (no_bus_req)
                                    mast_changed <= 1'b1;
                                else
                                    mast_changed <= 1'b0;
                                no_bus_req <= 0;
                            end
                        end
                    end
                end
                
                mast2:
                begin
                    if (!hbusreq1 && !hbusreq3) begin
                        present_mast <= mast2;
                        hgrant1 <= 1'b0;
                        hgrant2 <= 1'b1;
                        hgrant3 <= 1'b0;
                        hmaster <= 2'b01;
                        mast_changed <= 1'b0;
                    end else begin
                        if (!hbusreq1 && hbusreq3)begin
                            if (htrans2 == 1'b0 && mast_changed == 1'b0) begin
                                present_mast <= mast3;
                                hgrant1 <= 1'b0;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b1;
                                hmaster <= 2'b10;
                                mast_changed <= 1'b1;
                            end else begin
                                present_mast <= mast2;
                                hgrant1 <= 1'b0;
                                hgrant2 <= 1'b1;
                                hgrant3 <= 1'b0;
                                hmaster <= 2'b01;
                                mast_changed <= 1'b0;
                            end
                        end else begin
                            if (htrans2 == 1'b0 && mast_changed == 1'b0) begin
                                present_mast <= mast1;
                                hgrant1 <= 1'b1;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b0;
                                hmaster <= 2'b00;
                                mast_changed <= 1'b1;
                            end else begin
                                present_mast <= mast2;
                                hgrant1 <= 1'b0;
                                hgrant2 <= 1'b1;
                                hgrant3 <= 1'b0;
                                hmaster <= 2'b01;
                                mast_changed <= 1'b0;
                            end
                        end
                    end
                end
                
                mast3:
                begin
                    if (!hbusreq1 && !hbusreq2) begin
                        present_mast <= mast3;
                        hgrant1 <= 1'b0;
                        hgrant2 <= 1'b0;
                        hgrant3 <= 1'b1;
                        hmaster <= 2'b10;
                        mast_changed <= 1'b0;
                    end else begin
                        if (!hbusreq1 && hbusreq2)begin
                            if (htrans3 == 1'b0 && mast_changed == 1'b0) begin
                                present_mast <= mast2;
                                hgrant1 <= 1'b0;
                                hgrant2 <= 1'b1;
                                hgrant3 <= 1'b0;
                                hmaster <= 2'b01;
                                mast_changed <= 1'b1;
                            end else begin
                                present_mast <= mast3;
                                hgrant1 <= 1'b0;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b1;
                                hmaster <= 2'b10;
                                mast_changed <= 1'b0;
                            end
                        end else begin
                            if (htrans3 == 2'b00 && mast_changed == 1'b0) begin
                                present_mast <= mast1;
                                hgrant1 <= 1'b1;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b0;
                                hmaster <= 2'b00;
                                mast_changed <= 1'b1;
                            end else begin
                                present_mast <= mast3;
                                hgrant1 <= 1'b0;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b1;
                                hmaster <= 2'b10;
                                mast_changed <= 1'b0;
                            end
                        end
                    end
                end
                
                default:
                begin
                    present_mast <= mast1;
                    hgrant1 <= 1'b1;
                    hgrant2 <= 1'b0;
                    hgrant3 <= 1'b0;
                    hmaster <= 2'b00;
                    mast_changed <= 1'b0;
                end
            endcase
        end
    end
endmodule
