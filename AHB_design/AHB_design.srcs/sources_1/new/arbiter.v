`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2024 08:49:50 PM
// Design Name: 
// Module Name: arbiter
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


module arbiter #(
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
                    if (hsplit1==1'b1)     
                    begin                  
                        hgrant1<=1'b0;     
                        next_mast <= mast1;
                    end
                    if (!hbusreq2 && !hbusreq3) begin     //If non of bus 2 and 3 is request the access it will be granted to the master   1
                        next_mast <= mast1;
                        hgrant1 <= 1'b1;
                        hgrant2 <= 1'b0;
                        hgrant3 <= 1'b0;
                        hmaster <= 2'b00;
                    end else begin
                        if (!hbusreq2 && hbusreq3)begin        //Request from the master 3
                            if (htrans1 == 2'b00) begin         //Check whether master 1 is IDLE as its the priority master
                                next_mast <= mast3;
                                hgrant1 <= 1'b0;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b1;
                                hmaster <= 2'b10;
                            end else begin                     //If master 1 has already doing a transaction
                                next_mast <= mast1;    
                                hgrant1 <= 1'b1;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b0;
                                hmaster <= 2'b00;
                            end
                        end else begin                          //If  reqeust from master 2 is received
                            if (htrans1 == 2'b00) begin         //Check whether master 1 is IDLE
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
                    if (hsplit2==1'b1)     
                    begin                  
                        hgrant2<=1'b0;     
                        next_mast <= mast1;
                    end
                    if (!hbusreq1 && !hbusreq3) begin    //check whether there is any request from master 1 and 3
                        next_mast <= mast2;              
                        hgrant1 <= 1'b0;
                        hgrant2 <= 1'b1;
                        hgrant3 <= 1'b0;
                        hmaster <= 2'b01;
                    end else begin                      //If there is a request from master 1 or 3
                        if (!hbusreq1 && hbusreq3)begin   //Reqeust from master 3
                            if (htrans2 == 2'b00) begin     //if master 3 is not transferring
                                next_mast <= mast3;
                                hgrant1 <= 1'b0;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b1;
                                hmaster <= 2'b10;
                            end else begin                        //if master2 is transferring do not give the grant  to 2
                                next_mast <= mast2;
                                hgrant1 <= 1'b0;
                                hgrant2 <= 1'b1;
                                hgrant3 <= 1'b0;
                                hmaster <= 2'b01;
                            end
                        end else begin                        //Request from master 1
                            if (htrans2 == 2'b00) begin        //If master 2 is idle next master is master1
                                next_mast <= mast1;       
                                hgrant1 <= 1'b1;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b0;
                                hmaster <= 2'b00;
                            end else begin                    //master 2 is tranferrinng
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
                    if (hsplit3==1'b1)     
                    begin                  
                        hgrant1<=1'b0;     
                        next_mast <= mast1;
                    end
                    if (!hbusreq1 && !hbusreq2) begin                //No request from master 1 and 2
                        next_mast <= mast3;
                        hgrant1 <= 1'b0;
                        hgrant2 <= 1'b0;
                        hgrant3 <= 1'b1;
                        hmaster <= 2'b10;
                    end else begin
                        if (!hbusreq1 && hbusreq2)begin               //Req from master 2
                            if (htrans3 == 2'b00) begin      //check 3 is not tranferring
                                next_mast <= mast2;
                                hgrant1 <= 1'b0;
                                hgrant2 <= 1'b1;
                                hgrant3 <= 1'b0;
                                hmaster <= 2'b01;
                            end else begin                 //master3 is transferring
                                next_mast <= mast3;
                                hgrant1 <= 1'b0;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b1;
                                hmaster <= 2'b10;
                            end
                        end else begin                       //Req from master 1
                            if (htrans3 == 2'b00) begin   //Check 3 is not transferring
                                next_mast <= mast1;
                                hgrant1 <= 1'b1;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b0;
                                hmaster <= 2'b00;
                            end else begin             //master 3 is transferring
                                next_mast <= mast3; 
                                hgrant1 <= 1'b0;
                                hgrant2 <= 1'b0;
                                hgrant3 <= 1'b1;
                                hmaster <= 2'b10;
                            end
                        end
                    end
                end
                
                default:              //Master 1 has the priority : Default case
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