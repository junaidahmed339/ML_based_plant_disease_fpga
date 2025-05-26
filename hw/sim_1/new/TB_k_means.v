`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/17/2022 09:48:21 PM
// Design Name: 
// Module Name: TB_k_means
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


module TB_k_means();

reg clk;
reg start_kmeans;
reg reset;
reg [31:0]CIE_A_PORTA_din;
wire [15:0]CIE_A_PORTA_addr;
reg Cluster_ID_PORTA_din;
K_means_pipelined dut(.start_kmeans(start_kmeans),.CIE_A_PORTA_addr(CIE_A_PORTA_addr),.CIE_A_PORTA_din(CIE_A_PORTA_din),.Cluster_ID_PORTA_din(Cluster_ID_PORTA_din),.clk(clk),.reset(reset));


initial begin
clk = 0;
reset =0;
repeat(20) begin
@(posedge clk);
reset =1;
end
@(posedge clk);
reset =0;
@(posedge clk);
CIE_A_PORTA_din = 32'hc1a00000; //-20
start_kmeans = 1;
@(posedge clk);
CIE_A_PORTA_din = 32'h42c80000; //100
start_kmeans = 0;
repeat(1000) begin
@(posedge clk);
CIE_A_PORTA_din = 32'h42c80000; //100
@(posedge clk);
CIE_A_PORTA_din = 32'hc1a00000; //-20
end

end

initial begin

Cluster_ID_PORTA_din =0;
repeat(2000) begin
@(posedge clk);
Cluster_ID_PORTA_din <= ~Cluster_ID_PORTA_din;
end
end


always begin
#4 clk = ~clk;
end

reg [15:0] clk_counter = 0;
always@ (posedge clk)
clk_counter <= clk_counter + 1;
       
endmodule
