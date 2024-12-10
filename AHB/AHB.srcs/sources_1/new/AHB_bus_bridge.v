`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2024 06:57:19 PM
// Design Name: 
// Module Name: AHB_bus_bridge
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


module AHB_bus_bridge(
    input hclk,
    input hresetn,
    //from uart
    input [15:0] uart_data,   // 1 valid  1 bit slave sel 8 bit data 5 bit adress  1 hwrite
    input  tx_ready,
    
    // from slave4 interface
    


    input [31:0] haddr_ss, //address from the master module
    input [1:0] slv_sel_ss, //slave identifier given to the master interface
    input [31:0] hwdata_ss,   //data to the master interface from the master
    input hwrite_ss,   
    input [31:0] hrdata_ss,
    input valid_tx,
    
    //from master interface
    input [31:0] hrdata,    //data from slave to master
    input  tx_hready,
    //from arbiter
    input hgrant,   //grant signal from arbiter
    
    
    output rx_en,
    output reg [15:0]uart_tx_ss
    
    );
    
    reg valid ;
    reg [1:0]slave_sel_uart ;
    reg [31:0]hwrite_data_uart;
    reg hwrite_uart ;
    reg [31:0]hadress_uart ;
    
    
    reg [31:0] hwrite_data_tx;
    reg [31:0] hread_data_tx;
    reg [5:0] haddr_tx ;
   
    reg hwrite;
    reg [1:0]slave_sel_tx;
    reg [31:0] final_data_tx;
    
    always @(posedge hclk)
    begin
        if (!hresetn) begin
            valid <= 1'b0;
            slave_sel_uart <= 2'b00;
            hwrite_data_uart <= 32'd0;
            hwrite_uart<= 1'b0;
            hadress_uart <= 32'd0;
            hwrite_data_tx <=7'd0;
            hread_data_tx <= 8'd0;
            haddr_tx<= 6'd0;
            
            hwrite<= 1'b0;
            slave_sel_tx <= 2'b00;
        end else begin
             
            hwrite_data_tx <=  hwdata_ss;
            hread_data_tx <= hrdata_ss;
            haddr_tx <= haddr_ss [2:0];
            hwrite <=  hwrite_ss;
            slave_sel_tx <= slv_sel_ss;
             
            if (tx_ready & uart_data[15])
            begin
                hadress_uart <= {27'd0,uart_data[5:1]};
                hwrite_uart <= uart_data[0];
                hwrite_data_uart <= {24'd0,uart_data[13:6]};
                slave_sel_uart <=  {1'b0,uart_data[14]};
            end
            
            else if (tx_hready)
            begin
                uart_tx_ss <= {8'd0,hrdata[7:0]};
            end
            
            else if (valid_tx)
            begin 
                if (hwrite)
                begin 
                    final_data_tx <=  hwrite_data_tx;    
                end
                
                else 
                begin
                    final_data_tx <=  hread_data_tx;   
                end
                
                uart_tx_ss <= {final_data_tx[7:0], slave_sel_tx, hwrite_data_tx[2:0], 1'b0, hwrite};
        
            end
        end
   end
    
    
endmodule
