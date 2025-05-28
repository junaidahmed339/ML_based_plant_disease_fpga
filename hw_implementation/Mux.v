`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2022 03:44:02 PM
// Design Name: 
// Module Name: Mux
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


module Mux #(parameter WIDTH=3)(
//Input Port 1
input      [15:0]in_PORT1_addr,
input      in_PORT1_clk,
input      [WIDTH-1:0]in_PORT1_din,
output     [WIDTH-1:0]in_PORT1_dout,
input      in_PORT1_wea,

//Input Port 2
input      [15:0]in_PORT2_addr,
input      in_PORT2_clk,
input      [WIDTH-1:0]in_PORT2_din,
output     [WIDTH-1:0]in_PORT2_dout,
input      in_PORT2_wea,

//output
output     [15:0]out_addr,
output     out_clk,
input      [WIDTH-1:0]out_din,
output     [WIDTH-1:0]out_dout,
output     out_wea,

input      select_line
);

assign out_addr = select_line ? in_PORT2_addr : in_PORT1_addr;
assign out_clk  = select_line ? in_PORT2_clk  : in_PORT1_clk;
assign out_wea  = select_line ? in_PORT2_wea  : in_PORT1_wea;
assign out_dout = select_line ? in_PORT2_din  : in_PORT1_din;
assign in_PORT1_dout  = out_din;
assign in_PORT2_dout  = out_din;

endmodule
