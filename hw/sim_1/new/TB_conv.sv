`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2022 09:55:32 PM
// Design Name: 
// Module Name: TB_conv
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


module TB_conv();

reg clk_100=0;
reg reset = 0;

Feature_extraction uut
(.clk(clk_100),
 .reset(reset)
 );


always begin
#5 clk_100 = ~clk_100;
end

initial begin
reset = 1;
clk_100 = 0;
# 20;
reset = 0;
# 1000;

end
    
endmodule