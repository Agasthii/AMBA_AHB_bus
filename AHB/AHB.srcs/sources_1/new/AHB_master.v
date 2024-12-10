`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2024 07:10:52 PM
// Design Name: 
// Module Name: master_interface
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


module AHB_master #(
    parameter busy = 1'b1,
    
    parameter idle = 3'b000,
    parameter req_phase = 3'b001,
    parameter addr_phase = 3'b010,
    parameter data_phase = 3'b011,
    parameter wait_phase = 3'b100
    )(
    input hclk, //master clock
    input hresetn,  //master reset, active LOW
    //from slave
    input [31:0] hrdata,    //data from slave to master
    input hready,    //high -> transfer finished, low -> extend the transfer
    input [1:0] hresp,    //00 -> OK, 01 -> ERROR, 10 -> RETRY, 11 -> SPLIT
    //from master module
    input [31:0] addr, //address from the master module
    input [1:0] slv_sel_in, //slave identifier given to the master interface
    input [31:0] din,   //data to the master interface from the master
    input wr,   //from the master module to the master interface; high -> write transfer, low -> read transfer
    input enable,   //enable the master interface. This is sent from the master
    input hbusreq_in,   //bus request from the master module
    //from arbiter
    input hgrant,   //grant signal from arbiter
    
    //to slave
    output reg [31:0] haddr,    //32-bit system address bus
    output reg hwrite, //high -> write transfer, low -> read transfer (remains same during burst)
    output reg htrans,    //type of current transfer -> IDLE, BUSY, NONSEQ, SEQ
    output reg [31:0] hwdata,    //write data
    //to master
    output reg [31:0] dout,  //data out of the master interface to the master
    //to arbiter
//    output reg hbusreq, //bus request to the arbiter
    // to decoder
    output reg [1:0] slv_sel_out    //slave identifier given out of the master interface
    );
    
    //parameters in state machine
    reg [2:0] present_state, next_state;
    
//    always@(posedge hclk) begin
//        if (!hresetn) begin
//            present_state <= idle;
//        end else
//            present_state <= next_state;
//    end
    
    always@(posedge hclk) begin
        if (!hresetn) begin
            present_state <= idle;
            haddr <= 32'b0;
            hwrite <= 1'b0;
            htrans <= idle;
            hwdata <= 32'b0;
            slv_sel_out <= 2'b0;
            dout <= 32'b0;
//            hbusreq <= 1'b0;
        end else begin
    
            case (present_state)
                idle:
                begin
                    haddr <= 32'b0;
                    hwrite <= wr;
                    htrans <= idle;
                    hwdata <= din;
                    slv_sel_out <= 2'b0;
                    dout <= 32'b0;
//                    hbusreq <= hbusreq_in;
    //                hlock <= 1'b0;
                    if (!enable)
                        present_state <= idle;
                    else if (hbusreq_in)
                        present_state <= req_phase;
                    else
                        present_state <= idle;
                end
                    
                req_phase:
                begin
                    haddr <= addr;
                    hwrite <= wr;
                    hwdata <= din;
                    slv_sel_out <= slv_sel_in;
                    dout <= hrdata;
//                    hbusreq <= hbusreq_in;
    //                hlock <= 1'b1;
                    
                    if (!enable) begin
                        present_state <= idle;
                        htrans <= idle;
                    end else if (hgrant) begin  //if  grant is given master will access the bus
                        present_state <= addr_phase;
                        htrans <= busy;
                    end else begin
                        present_state <= req_phase;
                        htrans <= idle;
                    end
                end
                
                addr_phase:
                begin
                    haddr <= addr;
                    hwrite <= wr;
                    htrans <= busy;
                    hwdata <= din;
                    slv_sel_out <= slv_sel_in;
                    dout <= hrdata;
//                    hbusreq <= hbusreq_in;
    //                hlock <= 1'b1;
                    
                    if (!enable)
                        present_state <= idle;
                    else if (hready)
                        present_state <= data_phase;
                    else
                        present_state <= wait_phase;
                end
                
                data_phase:
                begin
                    haddr <= addr;
                    hwrite <= wr;
                    htrans <= busy;
                    hwdata <= din;
                    slv_sel_out <= slv_sel_in;
                    dout <= hrdata;
//                    hbusreq <= hbusreq_in;
    //                hlock <= 1'b1;
                    
                    if (!enable)
                        present_state <= idle;
                    else if (hready && hgrant)
                        present_state <= data_phase;
                    else
                        present_state <= wait_phase;
                end
                
                wait_phase:
                begin
                    haddr <= haddr;
                    hwrite <= hwrite;
                    htrans <= idle;
                    hwdata <= hwdata;
                    slv_sel_out <= slv_sel_out;
                    dout <= dout;
//                    hbusreq <= hbusreq_in;
    //                hlock <= 1'b1;
                    
                    if (!enable)
                        present_state <= idle;
                    else if (hready && hgrant)
                        present_state <= data_phase;
                    else
                        present_state <= wait_phase;
                end
            endcase
        end
    end    
endmodule
