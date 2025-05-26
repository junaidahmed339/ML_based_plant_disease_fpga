`timescale 1ns / 1ps

module vgaProject(clk,VS,HS,red,green,blue,r,g,b,x,y);
input  clk;
input [3:0] r,g,b;
output  VS,HS;
output [10:0]x,y;
//hFree,vFree;
output reg [3:0] red,green,blue;
reg [3:0] free;
always@*
begin
free[0]=hFree&&vFree&&(x<640)&&(x>0)&&(y<480)&&(y>=0);
free[1]=hFree&&vFree&&(x<640)&&(x>0)&&(y<480)&&(y>=0);
free[2]=hFree&&vFree&&(x<640)&&(x>0)&&(y<480)&&(y>=0);
free[3]=hFree&&vFree&&(x<640)&&(x>0)&&(y<480)&&(y>=0);
red=r&free;
green=g&free;
blue=b&free;
end
vgaPulse H(pixelClk,21'd96,21'd144,21'd784,21'd800,HS,hFree,x);
vgaPulse V(HS,21'd2,21'd35,21'd515,21'd525,VS,vFree,y);
clockDiv pixelClock(clk,32'd4,pixelClk);
endmodule