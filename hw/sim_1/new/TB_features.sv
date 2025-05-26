`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2022 10:34:25 PM
// Design Name: 
// Module Name: TB_features
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


module TB_features( );
reg clk_100=0;
reg reset=0;
reg feature_start=0;
wire done_features;
wire [31:0]LPB_125,LPB_128,LPB_132,LPB_136,LPB_137,LPB_14,LPB_156,LPB_161,LPB_19,LPB_25,LPB_32,
    LPB_38,LPB_43,LPB_7,a_bin198,a_bin199,b_bin208;
    
 design_features_wrapper uut
   (.clk_100(clk_100),
    .done_features(done_features),
    .feature_start(feature_start),
    .reset(reset),
    .LPB_125(LPB_125),
    .LPB_128(LPB_128),
    .LPB_132(LPB_132),
    .LPB_136(LPB_136),
    .LPB_137(LPB_137),
    .LPB_14(LPB_14),
    .LPB_156(LPB_156),
    .LPB_161(LPB_161),
    .LPB_19(LPB_19),
    .LPB_25(LPB_25),
    .LPB_32(LPB_32),
    .LPB_38(LPB_38),
    .LPB_43(LPB_43),
    .LPB_7(LPB_7),
    .a_bin198(a_bin198),
    .a_bin199(a_bin199),
    .b_bin208(b_bin208)
  );

initial begin
clk_100 = 0;
feature_start = 0;
reset = 1;
#20;
reset = 0;
#20;
feature_start = 1;
#100;
#20;
feature_start = 0;
#1000;
end

always begin
#5 clk_100 = ~clk_100;
end


endmodule
