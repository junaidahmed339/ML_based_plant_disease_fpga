`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2022 01:11:56 AM
// Design Name: 
// Module Name: Control_logic
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


module Control_logic(

//R (PORT B connection)
output     reg [15:0]R_PORTB_addr,
output     R_PORTB_clk,
input      [7:0]R_PORTB_din,
output     reg [7:0]R_PORTB_dout,
output     reg R_PORTB_wea = 0,
//G (PORT B connection)
output     reg [15:0]G_PORTB_addr,
output     G_PORTB_clk,
input      [7:0]G_PORTB_din,
output     reg [7:0]G_PORTB_dout,
output     reg G_PORTB_wea = 0,
//B (PORT B connection)
output     reg [15:0]B_PORTB_addr,
output     B_PORTB_clk,
input      [7:0]B_PORTB_din,
output     reg [7:0]B_PORTB_dout,
output     reg B_PORTB_wea = 0,

//Cluster ID (PORT B connection)
output     [15:0]Cluster_ID_PORTB_addr,
output     Cluster_ID_PORTB_clk,
input      Cluster_ID_PORTB_din,
output     Cluster_ID_PORTB_dout,
output     Cluster_ID_PORTB_wea,

input clk,reset,
input [10:0]x,y,
output [3:0]r,g,b);


assign R_PORTB_clk = clk;
assign G_PORTB_clk = clk;
assign B_PORTB_clk = clk;
assign Cluster_ID_PORTB_clk = clk;

reg [7:0]w1,w2,w3;
reg [15:0]Cluster_addr;

always@(*)
begin
    w1=0;
    w2=0;
    w3=0;
    if(y<'d200 && x<='d200)
    begin
        R_PORTB_addr = (y*('d200))+x;
        G_PORTB_addr = (y*('d200))+x;
        B_PORTB_addr = (y*('d200))+x;
        Cluster_addr = (y*('d200))+x;
        w1 = R_PORTB_din & {32{Cluster_ID_PORTB_din}};
        w2 = G_PORTB_din & {32{Cluster_ID_PORTB_din}};
        w3 = B_PORTB_din & {32{Cluster_ID_PORTB_din}};
    end
end

assign r=w1[7:4];
assign g=w2[7:4];
assign b=w3[7:4];



//reset logic
localparam [2:0]s0=0,s1=1,s2=2;
reg [2:0]rst_state=0,rst_n_state=0;
reg [15:0]rst_counter = 0;

always@(posedge clk)
rst_state <= rst_n_state;

always@(*)
case(rst_state)
s0:
begin
    if(reset)
    rst_n_state = s1;
    else
    rst_n_state = s0;
end
s1:
begin
    if(rst_counter == 100)
    rst_n_state = s2;
    else
    rst_n_state = s1;
end
s2:
begin
    rst_n_state = s0;
end
endcase

always@(posedge clk)
case(rst_state)
s0:
begin
    rst_counter <= 0;
end
s1:
begin
    if(rst_counter < 100)
     rst_counter <= rst_counter + 1;
    else
     rst_counter <= rst_counter;
end
endcase

assign Cluster_ID_PORTB_addr = (rst_state == s1)? rst_counter : Cluster_addr;
assign Cluster_ID_PORTB_dout = 1'b1;
assign Cluster_ID_PORTB_wea  = (rst_state == s1)? 1'b1: 1'b0;


endmodule
