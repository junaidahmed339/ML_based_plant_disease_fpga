`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2022 11:56:03 AM
// Design Name: 
// Module Name: Feature_extraction
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


module Feature_extraction(
input clk,reset,feature_start,
//CIE_LAB (PORT A connection)
output     [15:0]CIE_LAB_PORTA_addr,
output     CIE_LAB_PORTA_clk,
input      [2:0]CIE_LAB_PORTA_din,
output     reg [2:0]CIE_LAB_PORTA_dout,
output     reg CIE_LAB_PORTA_wea = 0,

output reg [31:0] LPB_161, LPB_156, 
LPB_137, LPB_136, LPB_132, LPB_128, LPB_125, LPB_43, LPB_38, 
LPB_32, LPB_25, LPB_19, LPB_14, LPB_7,

output reg [31:0]a_bin198, a_bin199, b_bin208,

output reg done_features = 0,

//this use to read A for bin calculation
output     [15:0]CIE_AB_PORTA_addr,
output     CIE_AB_PORTA_clk,
input      [7:0]CIE_AB_PORTA_din,
output     reg CIE_AB_PORTA_wea = 0
);

reg gc_L,g0_L,g1_L,g2_L,g3_L,g4_L,g5_L,g6_L,g7_L;
reg [15:0]x,y,row,col;
reg [7:0]pattern_L;
reg [31:0]pattern_0_count  = 0, pattern_62_count  = 0, pattern_207_count = 0,                        
pattern_1_count  = 0, pattern_63_count  = 0, pattern_199_count = 0,
pattern_2_count  = 0, pattern_64_count  = 0, pattern_223_count = 0, 
pattern_3_count  = 0, pattern_96_count  = 0, pattern_224_count = 0, 
pattern_4_count  = 0, pattern_112_count = 0, pattern_225_count = 0, 
pattern_6_count  = 0, pattern_120_count = 0, pattern_227_count = 0, 
pattern_7_count  = 0, pattern_124_count = 0, pattern_231_count = 0, 
pattern_8_count  = 0, pattern_126_count = 0, pattern_239_count = 0, 
pattern_12_count = 0, pattern_127_count = 0, pattern_240_count = 0, 
pattern_14_count = 0, pattern_128_count = 0, pattern_241_count = 0, 
pattern_15_count = 0, pattern_129_count = 0, pattern_243_count = 0, 
pattern_16_count = 0, pattern_131_count = 0, pattern_247_count = 0, 
pattern_24_count = 0, pattern_135_count = 0, pattern_248_count = 0, 
pattern_28_count = 0, pattern_143_count = 0, pattern_249_count = 0, 
pattern_30_count = 0, pattern_159_count = 0, pattern_251_count = 0, 
pattern_31_count = 0, pattern_191_count = 0, pattern_252_count = 0, 
pattern_32_count = 0, pattern_192_count = 0, pattern_253_count = 0,
pattern_48_count = 0, pattern_193_count = 0, pattern_254_count = 0, 
pattern_56_count = 0, pattern_195_count = 0, pattern_255_count = 0,
pattern_60_count = 0, pattern_non_uniform_count = 0;

wire [31:0]mul_out1,mul_out2,mul_out3,mul_out4,mul_out5,mul_out6,mul_out7,mul_out8,mul_out9,mul_out10;
reg  [31:0]mul_in1,mul_in2,mul_in3,mul_in4,mul_in5,mul_in6,mul_in7,mul_in8,mul_in9,mul_in10;

reg [31:0]sum_p0,sum_p1,sum_p2,sum_p3,sum_p4,sum_p5,sum_p6,sum_p7,sum_p8; 
reg [31:0]sum_p9,sum_p10,sum_p11,sum_p12,sum_p13,sum_p14, sum_p15, sum_p16, sum_p17, sum_p18;
reg [31:0]sum, L_sum, A_sum, B_sum;
reg [1:0]seg_count;

reg [31:0] L_count_7, L_count_28, L_count_56, L_count_112, L_count_131,
L_count_193, L_count_224, B_count_7, B_count_14, B_count_28, B_count_48,
B_count_56, B_count_193, B_count_224;

reg [31:0] a_bin1=0, a_bin2=0, a_bin3=0, a_bin4=0, a_bin5=0, a_bin6=0, 
a_bin7 = 0, a_bin8=0, a_bin9=0, a_bin10=0, a_bin11=0, a_bin12=0, a_bin13=0;
reg [31:0]sum_a_bins_123=0, sum_a_bins_4567=0, sum_a_bins_891011=0, sum_a_bins_1213=0, sum_a_bins;
reg [31:0]a_bin_norm;

reg [31:0] b_bin1=0, b_bin2=0, b_bin3=0, b_bin4=0, b_bin5=0, b_bin6=0, 
b_bin7 = 0, b_bin8=0, b_bin9=0, b_bin10=0, b_bin11=0, b_bin12=0, b_bin13=0;
reg [31:0]sum_b_bins_123=0, sum_b_bins_4567=0, sum_b_bins_891011=0, sum_b_bins_1213=0, sum_b_bins;
reg [31:0]b_bin_norm;
            
//assign LPB_166 = B_count_240;
//assign LPB_162 = B_count_225;
//assign LPB_161 = B_count_224;
//assign LPB_156 = B_count_193; 
//assign LPB_150 = B_count_131;
//assign LPB_143 = B_count_112; 
//assign LPB_137 = B_count_56; 
//assign LPB_136 = B_count_48;
//assign LPB_132 = B_count_28;
//assign LPB_131 = B_count_24; 
//assign LPB_125 = B_count_7; 
//assign LPB_84  = A_count_112; 
//assign LPB_66  = A_count_7;
//assign LPB_43  = L_count_224; 
//assign LPB_38  = L_count_193;
//assign LPB_32  = L_count_131; 
//assign LPB_25  = L_count_112; 
//assign LPB_19  = L_count_56;
//assign LPB_18  = L_count_48; 
//assign LPB_14  = L_count_28;
//assign LPB_10  = L_count_14;
//assign LPB_7   = L_count_7;

reg start_conv;
wire sum_float_v, sqrt_v;
wire [31:0]sum_float_d, sqrt_d;
wire [31:0]feat_125_d;
wire feat_125_v;


reg [15:0]total_pix = 50176;
reg [15:0]size     = 224; //224 in original but 0 location has been used here
reg [15:0]size_rad = 218;
 
assign CIE_LAB_PORTA_addr = size*row + col;
assign CIE_LAB_PORTA_clk  = clk;

reg [15:0]pix_count =0;
assign CIE_AB_PORTA_addr = pix_count;
assign CIE_AB_PORTA_clk = clk;

wire data_in;
//assign data_in = (seg_count == 2) ? CIE_LAB_PORTA_din[0] : (seg_count == 1) ? CIE_LAB_PORTA_din[1] : CIE_LAB_PORTA_din[2]; 
assign data_in = (seg_count == 1) ? CIE_LAB_PORTA_din[0] : CIE_LAB_PORTA_din[2]; //b--l
//0------1------2------3--------5-------6-------7-------8-------------------------223
//224----225----226----227------228-----229-----230-----231-----------------------447
//448----449----450----451------452-----453-----454-----455-----------------------671
//672----673----674----675------676-----677-----678-----679-----------------------895
//896----897----898----899------900-----901-----902-----903-----------------------1119
//1120---1121---1122---1123-----1124----1125----1126----1127-----------------------------1343

//49952-49953---49954--49955----49956---49957---49958--49959----49960-------------------50175


reg [7:0]mul_counter = 0;
reg [5:0]state=0,n_state=0;
reg [15:0]pixel_count =0 ;

localparam [5:0]
idle_wait = 0,
idle = 1,
pixel_counter = 2,
comp_gc_L = 3,
read_gc_L = 4,
comp_g0_L = 5,
read_g0_L = 6,
comp_g1_L = 7,
read_g1_L = 8,
comp_g2_L = 9,
read_g2_L = 10,
comp_g3_L = 11,
read_g3_L = 12,
comp_g4_L = 13,
read_g4_L = 14,
comp_g5_L = 15,
read_g5_L = 16,
comp_g6_L = 17,
read_g6_L = 18,
comp_g7_L = 19,
read_g7_L = 20,
delay     = 21,
comp      = 22,
pattern   = 23,
count     = 24,
square    = 25,
square_wait = 26,
sum0      = 27,
sum1      = 28,
sum2      = 29,
sum3      = 30,
conv_int2float   = 31,
sqrt      = 32,
frame_check = 33,
done      = 34;


always@(posedge clk or posedge reset)
if(reset) 
    state <= idle_wait;
else
    state <= n_state;
    
    
always@(*) begin
case(state)
idle_wait: if(feature_start) n_state = idle;

idle: n_state = pixel_counter;

pixel_counter: 
    if(x == size_rad && y == size_rad) 
        n_state = square;
    else
        n_state = comp_gc_L;
                    
comp_gc_L:     n_state = read_gc_L;
read_gc_L:     n_state = comp_g0_L;

comp_g0_L:     n_state = read_g0_L;
read_g0_L:     n_state = comp_g1_L;

comp_g1_L:     n_state = read_g1_L;
read_g1_L:     n_state = comp_g2_L;

comp_g2_L:     n_state = read_g2_L;
read_g2_L:     n_state = comp_g3_L;

comp_g3_L:     n_state = read_g3_L;
read_g3_L:     n_state = comp_g4_L;

comp_g4_L:     n_state = read_g4_L;
read_g4_L:     n_state = comp_g5_L;

comp_g5_L:     n_state = read_g5_L;
read_g5_L:     n_state = comp_g6_L;

comp_g6_L:     n_state = read_g6_L;
read_g6_L:     n_state = comp_g7_L;

comp_g7_L:     n_state = read_g7_L;
read_g7_L:     n_state = delay;

delay:         n_state = comp;
comp:          n_state = pattern;
pattern:       n_state = count;
count:         n_state = pixel_counter;
square:        n_state = square_wait;
square_wait:  if(mul_counter == 36) 
                n_state = sum0;
sum0:          n_state = sum1;
sum1:          n_state = sum2;
sum2:          n_state = sum3;
sum3:          n_state = frame_check;
frame_check:   
    if(seg_count < 2) //2
        n_state = idle;
    else
        n_state = done;
endcase
end

always@(posedge clk or posedge reset)
if(reset) begin
    seg_count <= 0;
    x <= 6;
    y <= 5;
    pixel_count <= 0;
    start_conv  <= 0; 
    mul_counter <= 0;
    pattern_0_count  <= 0; pattern_62_count  <= 0; pattern_207_count <= 0;                        
    pattern_1_count  <= 0; pattern_63_count  <= 0; pattern_199_count <= 0;
    pattern_2_count  <= 0; pattern_64_count  <= 0; pattern_223_count <= 0; 
    pattern_3_count  <= 0; pattern_96_count  <= 0; pattern_224_count <= 0; 
    pattern_4_count  <= 0; pattern_112_count <= 0; pattern_225_count <= 0; 
    pattern_6_count  <= 0; pattern_120_count <= 0; pattern_227_count <= 0; 
    pattern_7_count  <= 0; pattern_124_count <= 0; pattern_231_count <= 0; 
    pattern_8_count  <= 0; pattern_126_count <= 0; pattern_239_count <= 0; 
    pattern_12_count <= 0; pattern_127_count <= 0; pattern_240_count <= 0; 
    pattern_14_count <= 0; pattern_128_count <= 0; pattern_241_count <= 0; 
    pattern_15_count <= 0; pattern_129_count <= 0; pattern_243_count <= 0; 
    pattern_16_count <= 0; pattern_131_count <= 0; pattern_247_count <= 0; 
    pattern_24_count <= 0; pattern_135_count <= 0; pattern_248_count <= 0; 
    pattern_28_count <= 0; pattern_143_count <= 0; pattern_249_count <= 0; 
    pattern_30_count <= 0; pattern_159_count <= 0; pattern_251_count <= 0; 
    pattern_31_count <= 0; pattern_191_count <= 0; pattern_252_count <= 0; 
    pattern_32_count <= 0; pattern_192_count <= 0; pattern_253_count <= 0;
    pattern_48_count <= 0; pattern_193_count <= 0; pattern_254_count <= 0; 
    pattern_56_count <= 0; pattern_195_count <= 0; pattern_255_count <= 0;
    pattern_60_count <= 0; pattern_non_uniform_count <= 0;
end
else
case(state)
    idle_wait, idle: begin
        x <= 6;
        y <= 5;
        pixel_count <= 0;
        pattern_0_count  <= 0; pattern_62_count  <= 0; pattern_207_count <= 0;                        
        pattern_1_count  <= 0; pattern_63_count  <= 0; pattern_199_count <= 0;
        pattern_2_count  <= 0; pattern_64_count  <= 0; pattern_223_count <= 0; 
        pattern_3_count  <= 0; pattern_96_count  <= 0; pattern_224_count <= 0; 
        pattern_4_count  <= 0; pattern_112_count <= 0; pattern_225_count <= 0; 
        pattern_6_count  <= 0; pattern_120_count <= 0; pattern_227_count <= 0; 
        pattern_7_count  <= 0; pattern_124_count <= 0; pattern_231_count <= 0; 
        pattern_8_count  <= 0; pattern_126_count <= 0; pattern_239_count <= 0; 
        pattern_12_count <= 0; pattern_127_count <= 0; pattern_240_count <= 0; 
        pattern_14_count <= 0; pattern_128_count <= 0; pattern_241_count <= 0; 
        pattern_15_count <= 0; pattern_129_count <= 0; pattern_243_count <= 0; 
        pattern_16_count <= 0; pattern_131_count <= 0; pattern_247_count <= 0; 
        pattern_24_count <= 0; pattern_135_count <= 0; pattern_248_count <= 0; 
        pattern_28_count <= 0; pattern_143_count <= 0; pattern_249_count <= 0; 
        pattern_30_count <= 0; pattern_159_count <= 0; pattern_251_count <= 0; 
        pattern_31_count <= 0; pattern_191_count <= 0; pattern_252_count <= 0; 
        pattern_32_count <= 0; pattern_192_count <= 0; pattern_253_count <= 0;
        pattern_48_count <= 0; pattern_193_count <= 0; pattern_254_count <= 0; 
        pattern_56_count <= 0; pattern_195_count <= 0; pattern_255_count <= 0;
        pattern_60_count <= 0; pattern_non_uniform_count <= 0;
        

    end
    pixel_counter: begin
        if(x == size_rad && y == size_rad) begin
            x <= x;
            y <= y;
        end
        else begin
            if(y == size_rad) begin
                y <= 6;
                x <= x + 1; 
            end
            else if(y < size_rad)
                y <= y+1;
        end
    end
    comp_gc_L:  begin
        row <= x;   
        col <= y;
    end
    comp_g0_L:  begin
        row  <= x;   
        col  <= y + 5;
        gc_L <= data_in;
    end
    comp_g1_L: begin
        row <= x - 4;
        col <= y + 4;
        g0_L <= data_in;
    end
    comp_g2_L: begin
        row <= x-5;
        col <= y;
        g1_L <= data_in;
    end
    comp_g3_L: begin
        row <= x-4;
        col <= y-4;
        g2_L <= data_in;
    end
    comp_g4_L:  begin
        row <= x;   
        col <= y-5;
        g3_L <= data_in;
    end
    comp_g5_L:  begin
        row <= x+4;
        col <= y-4;
        g4_L <= data_in;
    end
    comp_g6_L: begin
        row <= x+5;
        col <= y;
        g5_L <= data_in;
    end
    comp_g7_L:  begin
        row <= x+4;
        col <= y+4;
        g6_L <= data_in;
    end
    delay: begin
        g7_L <= data_in;
    end
    comp: begin
       if(g0_L >= gc_L) g0_L <= 1; else g0_L <= 0; 
       if(g1_L >= gc_L) g1_L <= 1; else g1_L <= 0; 
       if(g2_L >= gc_L) g2_L <= 1; else g2_L <= 0;
       if(g3_L >= gc_L) g3_L <= 1; else g3_L <= 0;
       if(g4_L >= gc_L) g4_L <= 1; else g4_L <= 0;
       if(g5_L >= gc_L) g5_L <= 1; else g5_L <= 0;
       if(g6_L >= gc_L) g6_L <= 1; else g6_L <= 0;
       if(g7_L >= gc_L) g7_L <= 1; else g7_L <= 0;
    end
    pattern: begin
        pattern_L <= {g7_L, g6_L, g5_L, g4_L, g3_L, g2_L, g1_L, g0_L};
    end
    count: begin
        if(pattern_L == 8'b00000000)      pattern_0_count   <= pattern_0_count   + 1;
        else if(pattern_L == 8'b00000001) pattern_1_count   <= pattern_1_count   + 1;
        else if(pattern_L == 8'b00000010) pattern_2_count   <= pattern_2_count   + 1;
        else if(pattern_L == 8'b00000011) pattern_3_count   <= pattern_3_count   + 1;
        else if(pattern_L == 8'b00000100) pattern_4_count   <= pattern_4_count   + 1;
        else if(pattern_L == 8'b00000110) pattern_6_count   <= pattern_6_count   + 1;
        else if(pattern_L == 8'b00000111) pattern_7_count   <= pattern_7_count   + 1;
        else if(pattern_L == 8'b00001000) pattern_8_count   <= pattern_8_count   + 1;
        else if(pattern_L == 8'b00001100) pattern_12_count  <= pattern_12_count  + 1;
        else if(pattern_L == 8'b00001110) pattern_14_count  <= pattern_14_count  + 1;
        else if(pattern_L == 8'b00001111) pattern_15_count  <= pattern_15_count  + 1;
        else if(pattern_L == 8'b00010000) pattern_16_count  <= pattern_16_count  + 1;
        else if(pattern_L == 8'b00011000) pattern_24_count  <= pattern_24_count  + 1;
        else if(pattern_L == 8'b00011100) pattern_28_count  <= pattern_28_count  + 1;
        else if(pattern_L == 8'b00011110) pattern_30_count  <= pattern_30_count  + 1;
        else if(pattern_L == 8'b00011111) pattern_31_count  <= pattern_31_count  + 1;
        else if(pattern_L == 8'b00100000) pattern_32_count  <= pattern_32_count  + 1;
        else if(pattern_L == 8'b00110000) pattern_48_count  <= pattern_48_count  + 1;
        else if(pattern_L == 8'b00111000) pattern_56_count  <= pattern_56_count  + 1;
        else if(pattern_L == 8'b00111100) pattern_60_count  <= pattern_60_count  + 1;
        else if(pattern_L == 8'b00111110) pattern_62_count  <= pattern_62_count  + 1;
        else if(pattern_L == 8'b00111111) pattern_63_count  <= pattern_63_count  + 1;
        else if(pattern_L == 8'b01000000) pattern_64_count  <= pattern_64_count  + 1;
        else if(pattern_L == 8'b01100000) pattern_96_count  <= pattern_96_count  + 1;
        else if(pattern_L == 8'b01110000) pattern_112_count <= pattern_112_count + 1;
        else if(pattern_L == 8'b01111000) pattern_120_count <= pattern_120_count + 1;
        else if(pattern_L == 8'b01111100) pattern_124_count <= pattern_124_count + 1;
        else if(pattern_L == 8'b01111110) pattern_126_count <= pattern_126_count + 1;
        else if(pattern_L == 8'b01111111) pattern_127_count <= pattern_127_count + 1;
        else if(pattern_L == 8'b10000000) pattern_128_count <= pattern_128_count + 1;
        else if(pattern_L == 8'b00000001) pattern_129_count <= pattern_129_count + 1;
        else if(pattern_L == 8'b10000011) pattern_131_count <= pattern_131_count + 1;
        else if(pattern_L == 8'b10000111) pattern_135_count <= pattern_135_count + 1;
        else if(pattern_L == 8'b10001111) pattern_143_count <= pattern_143_count + 1;
        else if(pattern_L == 8'b10011111) pattern_159_count <= pattern_159_count + 1;
        else if(pattern_L == 8'b10111111) pattern_191_count <= pattern_191_count + 1;
        else if(pattern_L == 8'b11000000) pattern_192_count <= pattern_192_count + 1;
        else if(pattern_L == 8'b11000001) pattern_193_count <= pattern_193_count + 1;
        else if(pattern_L == 8'b11000011) pattern_195_count <= pattern_195_count + 1;
        else if(pattern_L == 8'b11000111) pattern_199_count <= pattern_199_count + 1;
        else if(pattern_L == 8'b11001111) pattern_207_count <= pattern_207_count + 1;
        else if(pattern_L == 8'b11011111) pattern_223_count <= pattern_223_count + 1;
        else if(pattern_L == 8'b11100000) pattern_224_count <= pattern_224_count + 1;
        else if(pattern_L == 8'b11100001) pattern_225_count <= pattern_225_count + 1;
        else if(pattern_L == 8'b11100011) pattern_227_count <= pattern_227_count + 1;
        else if(pattern_L == 8'b11100111) pattern_231_count <= pattern_231_count + 1;
        else if(pattern_L == 8'b11101111) pattern_239_count <= pattern_239_count + 1;
        else if(pattern_L == 8'b11110000) pattern_240_count <= pattern_240_count + 1;
        else if(pattern_L == 8'b11110001) pattern_241_count <= pattern_241_count + 1;
        else if(pattern_L == 8'b11110011) pattern_243_count <= pattern_243_count + 1;
        else if(pattern_L == 8'b11110111) pattern_247_count <= pattern_247_count + 1;
        else if(pattern_L == 8'b11111000) pattern_248_count <= pattern_248_count + 1;
        else if(pattern_L == 8'b11111001) pattern_249_count <= pattern_249_count + 1;
        else if(pattern_L == 8'b11111011) pattern_251_count <= pattern_251_count + 1;
        else if(pattern_L == 8'b11111100) pattern_252_count <= pattern_252_count + 1;
        else if(pattern_L == 8'b11111101) pattern_253_count <= pattern_253_count + 1;
        else if(pattern_L == 8'b11111110) pattern_254_count <= pattern_254_count + 1;
        else if(pattern_L == 8'b11111111) pattern_255_count <= pattern_255_count + 1;
        else pattern_non_uniform_count <= pattern_non_uniform_count + 1;
        pixel_count <= pixel_count + 1;
    end   
     
    square: begin
         if(seg_count == 0) begin
            L_count_7   <= pattern_7_count;   //7
            L_count_28  <= pattern_28_count;  //14
            L_count_56  <= pattern_56_count;  //19
            L_count_112 <= pattern_112_count; //25
            L_count_131 <= pattern_131_count; //32
            L_count_193 <= pattern_193_count; //38
            L_count_224 <= pattern_224_count; //43
            L_sum      <= sum;
        end 
        else if(seg_count == 1) begin
            B_count_7   <= pattern_7_count;  //7
            B_count_14  <= pattern_14_count; //10
            B_count_28  <= pattern_28_count; //14
            B_count_48  <= pattern_48_count; //18
            B_count_56  <= pattern_56_count; //19
            B_count_193 <= pattern_193_count;//38
            B_count_224 <= pattern_224_count;//43
            B_sum       <= sum;
        end
     end

    square_wait: begin
        if(mul_counter == 0) begin
            mul_in1  <= pattern_0_count;
            mul_in2  <= pattern_1_count;
            mul_in3  <= pattern_2_count;
            mul_in4  <= pattern_3_count;
            mul_in5  <= pattern_4_count;
            mul_in6  <= pattern_6_count;
            mul_in7  <= pattern_7_count;
            mul_in8  <= pattern_8_count;
            mul_in9  <= pattern_12_count;
            mul_in10 <= pattern_14_count;
        end 
        else if(mul_counter == 6) begin
            pattern_0_count   <= mul_out1;
            pattern_1_count   <= mul_out2;
            pattern_2_count   <= mul_out3;
            pattern_3_count   <= mul_out4;
            pattern_4_count   <= mul_out5;
            pattern_6_count   <= mul_out6;
            pattern_7_count   <= mul_out7;
            pattern_8_count   <= mul_out8;
            pattern_12_count  <= mul_out9;
            pattern_14_count  <= mul_out10;
        end
        else if(mul_counter == 7) begin
            mul_in1  <= pattern_15_count;
            mul_in2  <= pattern_16_count;
            mul_in3  <= pattern_24_count;
            mul_in4  <= pattern_28_count;
            mul_in5  <= pattern_30_count;
            mul_in6  <= pattern_31_count;
            mul_in7  <= pattern_32_count;
            mul_in8  <= pattern_48_count;
            mul_in9  <= pattern_56_count;
            mul_in10 <= pattern_60_count;
        end
        else if(mul_counter == 12) begin
            pattern_15_count   <= mul_out1;
            pattern_16_count   <= mul_out2;
            pattern_24_count   <= mul_out3;
            pattern_28_count   <= mul_out4;
            pattern_30_count   <= mul_out5;
            pattern_31_count   <= mul_out6;
            pattern_32_count   <= mul_out7;
            pattern_48_count   <= mul_out8;
            pattern_56_count   <= mul_out9;
            pattern_60_count   <= mul_out10;
        end
        else if(mul_counter == 13) begin
            mul_in1  <= pattern_62_count;
            mul_in2  <= pattern_63_count;
            mul_in3  <= pattern_64_count;
            mul_in4  <= pattern_96_count;
            mul_in5  <= pattern_112_count;
            mul_in6  <= pattern_120_count;
            mul_in7  <= pattern_124_count;
            mul_in8  <= pattern_126_count;
            mul_in9  <= pattern_127_count;
            mul_in10 <= pattern_128_count;
        end
        else if(mul_counter == 18) begin
            pattern_62_count   <= mul_out1;
            pattern_63_count   <= mul_out2;
            pattern_64_count   <= mul_out3;
            pattern_96_count   <= mul_out4;
            pattern_112_count   <= mul_out5;
            pattern_120_count   <= mul_out6;
            pattern_124_count   <= mul_out7;
            pattern_126_count   <= mul_out8;
            pattern_127_count   <= mul_out9;
            pattern_128_count   <= mul_out10;
        end
        else if(mul_counter == 19) begin
            mul_in1  <= pattern_129_count;
            mul_in2  <= pattern_131_count;
            mul_in3  <= pattern_135_count;
            mul_in4  <= pattern_143_count;
            mul_in5  <= pattern_159_count;
            mul_in6  <= pattern_191_count;
            mul_in7  <= pattern_192_count;
            mul_in8  <= pattern_193_count;
            mul_in9  <= pattern_195_count;
            mul_in10 <= pattern_207_count;
        end
        else if(mul_counter == 24) begin
            pattern_129_count   <= mul_out1;
            pattern_131_count   <= mul_out2;
            pattern_135_count   <= mul_out3;
            pattern_143_count   <= mul_out4;
            pattern_159_count   <= mul_out5;
            pattern_191_count   <= mul_out6;
            pattern_192_count   <= mul_out7;
            pattern_193_count   <= mul_out8;
            pattern_195_count   <= mul_out9;
            pattern_207_count   <= mul_out10;
        end
        else if(mul_counter == 25) begin
            mul_in1  <= pattern_199_count;
            mul_in2  <= pattern_223_count;
            mul_in3  <= pattern_224_count;
            mul_in4  <= pattern_225_count;
            mul_in5  <= pattern_227_count;
            mul_in6  <= pattern_231_count;
            mul_in7  <= pattern_239_count;
            mul_in8  <= pattern_240_count;
            mul_in9  <= pattern_241_count;
            mul_in10 <= pattern_243_count;
        end
        else if(mul_counter == 30) begin
            pattern_199_count   <= mul_out1;
            pattern_223_count   <= mul_out2;
            pattern_224_count   <= mul_out3;
            pattern_225_count   <= mul_out4;
            pattern_227_count   <= mul_out5;
            pattern_231_count   <= mul_out6;
            pattern_239_count   <= mul_out7;
            pattern_240_count   <= mul_out8;
            pattern_241_count   <= mul_out9;
            pattern_243_count   <= mul_out10;
        end
        else if(mul_counter == 31) begin
            mul_in1  <= pattern_247_count;
            mul_in2  <= pattern_248_count;
            mul_in3  <= pattern_249_count;
            mul_in4  <= pattern_251_count;
            mul_in5  <= pattern_252_count;
            mul_in6  <= pattern_253_count;
            mul_in7  <= pattern_254_count;
            mul_in8  <= pattern_255_count;
            mul_in9  <= pattern_non_uniform_count;
        end
        else if(mul_counter == 36) begin
            pattern_247_count   <= mul_out1;
            pattern_248_count   <= mul_out2;
            pattern_249_count   <= mul_out3;
            pattern_251_count   <= mul_out4;
            pattern_252_count   <= mul_out5;
            pattern_253_count   <= mul_out6;
            pattern_254_count   <= mul_out7;
            pattern_255_count   <= mul_out8;
            pattern_non_uniform_count   <= mul_out9;
        end 
        mul_counter <= mul_counter + 1;
    end
    sum0: begin
        sum_p0  <= pattern_0_count   + pattern_1_count   + pattern_2_count   + pattern_3_count;          
        sum_p1  <= pattern_4_count   + pattern_6_count   + pattern_7_count   + pattern_8_count;          
        sum_p2  <= pattern_12_count  + pattern_14_count  + pattern_15_count  + pattern_16_count;      
        sum_p3  <= pattern_24_count  + pattern_28_count  + pattern_30_count  + pattern_31_count;         
        sum_p4  <= pattern_32_count  + pattern_48_count  + pattern_56_count  + pattern_60_count;         
        sum_p5  <= pattern_62_count  + pattern_63_count  + pattern_64_count  + pattern_96_count;         
        sum_p6  <= pattern_112_count + pattern_120_count + pattern_124_count + pattern_126_count;        
        sum_p7  <= pattern_127_count + pattern_128_count + pattern_129_count + pattern_131_count;        
        sum_p8  <= pattern_135_count + pattern_143_count + pattern_159_count + pattern_191_count;        
        sum_p9  <= pattern_192_count + pattern_193_count + pattern_195_count + pattern_207_count;        
        sum_p10 <= pattern_199_count + pattern_223_count + pattern_224_count + pattern_225_count;        
        sum_p11 <= pattern_227_count + pattern_231_count + pattern_239_count + pattern_240_count;        
        sum_p12 <= pattern_241_count + pattern_243_count + pattern_247_count + pattern_248_count;        
        sum_p13 <= pattern_249_count + pattern_251_count + pattern_252_count + pattern_253_count;        
        sum_p14 <= pattern_254_count + pattern_255_count + pattern_non_uniform_count;
        
    end
    sum1: begin
        sum_p15 <= sum_p0 + sum_p1 + sum_p2 + sum_p3;
        sum_p16 <= sum_p4 + sum_p5 + sum_p6 + sum_p7;
        sum_p17 <= sum_p8 + sum_p9 + sum_p10 + sum_p11;
        sum_p18 <= sum_p12 + sum_p13 + sum_p14;
        
    end
    sum3: begin
        sum        <= sum_p15 + sum_p16 + sum_p17 + sum_p18;
    end
    frame_check: begin
        seg_count  <= seg_count + 1;
        if(seg_count == 0) begin
            L_sum      <= sum;
        end 
        else if(seg_count == 1) begin
            B_sum      <= sum;
        end 
        //else if(seg_count == 2) begin
          //  B_sum       <= sum;
        //end
    end
    done: begin
        start_conv <= 1;
    end
endcase



unsigned_mull_32 pattern_1_uut    (clk, mul_in1 , mul_in1,  mul_out1);
unsigned_mull_32 pattern_2_uut    (clk, mul_in2 , mul_in2,  mul_out2);
unsigned_mull_32 pattern_3_uut    (clk, mul_in3 , mul_in3,  mul_out3);
unsigned_mull_32 pattern_4_uut    (clk, mul_in4 , mul_in4,  mul_out4);
unsigned_mull_32 pattern_5_uut    (clk, mul_in5 , mul_in5,  mul_out5);
unsigned_mull_32 pattern_6_uut    (clk, mul_in6 , mul_in6,  mul_out6);
unsigned_mull_32 pattern_7_uut    (clk, mul_in7 , mul_in7,  mul_out7);
unsigned_mull_32 pattern_8_uut    (clk, mul_in8 , mul_in8,  mul_out8);
unsigned_mull_32 pattern_9_uut    (clk, mul_in9 , mul_in9,  mul_out9);
unsigned_mull_32 pattern_10_uut   (clk, mul_in10, mul_in10, mul_out10);





reg [7:0]counter_ab;
reg [3:0] state_AB;
localparam [3:0]
idle_AB = 0,
addr_AB = 1,
wait_AB = 3,
samp_AB = 4,
count_bin_AB = 5,
square_wait_AB = 6,
sum0_AB = 7,
sum1_AB = 8,
done_AB = 9;

wire [31:0]mul_out_1,mul_out_2,mul_out_3,mul_out_4,mul_out_5,mul_out_6,mul_out_7,mul_out_8,mul_out_9,mul_out_10;
reg  [31:0]mul_in_1,mul_in_2,mul_in_3,mul_in_4,mul_in_5,mul_in_6,mul_in_7,mul_in_8,mul_in_9,mul_in_10;

reg  [31:0]a_bin1_sq , a_bin2_sq , a_bin3_sq, a_bin4_sq , a_bin5_sq ,a_bin6_sq , a_bin7_sq, a_bin8_sq ;
reg  [31:0]a_bin9_sq , a_bin10_sq , a_bin11_sq, a_bin12_sq , a_bin13_sq;                        
                                                
reg  [31:0]b_bin1_sq , b_bin2_sq  , b_bin3_sq, b_bin4_sq , b_bin5_sq , b_bin6_sq  , b_bin7_sq;
reg  [31:0]b_bin8_sq , b_bin9_sq , b_bin10_sq , b_bin11_sq, b_bin12_sq , b_bin13_sq;

always@(posedge clk or posedge reset)
if(reset) begin
    state_AB <= idle_AB;
    pix_count <= 0;
    counter_ab <= 0;
    a_bin1 <=0; a_bin2 <=0; a_bin3 <=0; a_bin4 <=0; 
    a_bin5 <=0; a_bin6 <=0; a_bin7 <=0; a_bin8 <=0; a_bin9 <=0; 
    a_bin10<=0; a_bin11<=0; a_bin12<=0; a_bin13<=0;
        
    b_bin1 <=0; b_bin2 <=0; b_bin3 <=0; b_bin4 <=0; 
    b_bin5 <=0; b_bin6 <=0; b_bin7 <=0; b_bin8 <=0; b_bin9 <=0; 
    b_bin10<=0; b_bin11<=0; b_bin12<=0; b_bin13<=0;
end
else 
    case(state_AB)
    idle_AB: begin
        if(feature_start) 
            state_AB <= addr_AB;
        else 
            state_AB <= idle_AB;
     end
     addr_AB: begin
        if(pix_count < total_pix) begin
            pix_count <= pix_count + 1;
            state_AB <= wait_AB;
        end
        else begin
            pix_count <= pix_count;
            state_AB <= square_wait_AB;
        end
     end
    wait_AB: state_AB <= samp_AB;
    samp_AB: state_AB <= count_bin_AB;
    count_bin_AB: begin
        state_AB <= addr_AB;
        case(CIE_AB_PORTA_din[7:4])
            1:   a_bin1 <= a_bin1+1;
            2:   a_bin2 <= a_bin2+1;
            3:   a_bin3 <= a_bin3+1;
            4:   a_bin4 <= a_bin4+1;
            5:   a_bin5 <= a_bin5+1;
            6:   a_bin6 <= a_bin6+1; 
            7:   a_bin7 <= a_bin7+1;
            8:   a_bin8 <= a_bin8+1;
            9:   a_bin9 <= a_bin9+1;
            10:  a_bin10 <= a_bin10+1;
            11:  a_bin11 <= a_bin11+1;
            12:  a_bin12 <= a_bin12+1; 
            13:  a_bin13 <= a_bin13+1; 
        endcase
        case(CIE_AB_PORTA_din[3:0])
            1:   b_bin1  <= b_bin1+1;
            2:   b_bin2  <= b_bin2+1;
            3:   b_bin3  <= b_bin3+1;
            4:   b_bin4  <= b_bin4+1;
            5:   b_bin5  <= b_bin5+1;
            6:   b_bin6  <= b_bin6+1; 
            7:   b_bin7  <= b_bin7+1;
            8:   b_bin8  <= b_bin8+1;
            9:   b_bin9  <= b_bin9+1;
            10:  b_bin10 <= b_bin10+1;
            11:  b_bin11 <= b_bin11+1;
            12:  b_bin12 <= b_bin12+1; 
            13:  b_bin13 <= b_bin13+1; 
        endcase
        end
        
        square_wait_AB: begin
        if(counter_ab < 22) begin
            counter_ab <= counter_ab+1; 
            state_AB <= square_wait_AB;
        end 
        else begin
            counter_ab <= counter_ab; 
            state_AB <= sum0_AB;
        end
        
        if(counter_ab == 0) begin
            mul_in_1  <= a_bin1 ;
            mul_in_2  <= a_bin2 ;
            mul_in_3  <= a_bin3 ;
            mul_in_4  <= a_bin4 ;
            mul_in_5  <= a_bin5 ;
            mul_in_6  <= a_bin6 ;
            mul_in_7  <= a_bin7 ;
            mul_in_8  <= a_bin8 ;
            mul_in_9  <= a_bin9 ;
            mul_in_10 <= a_bin10;
        end 
        else if(counter_ab == 6) begin
            a_bin1_sq   <= mul_out_1;
            a_bin2_sq   <= mul_out_2;
            a_bin3_sq   <= mul_out_3;
            a_bin4_sq   <= mul_out_4;
            a_bin5_sq   <= mul_out_5;
            a_bin6_sq   <= mul_out_6;
            a_bin7_sq   <= mul_out_7;
            a_bin8_sq   <= mul_out_8;
            a_bin9_sq   <= mul_out_9;
            a_bin10_sq  <= mul_out_10;
        end
        else if(counter_ab == 7) begin
            mul_in_1  <= a_bin11 ;
            mul_in_2  <= a_bin12 ;
            mul_in_3  <= a_bin13 ;
            mul_in_4  <= b_bin1 ;
            mul_in_5  <= b_bin2 ;
            mul_in_6  <= b_bin3 ;
            mul_in_7  <= b_bin4 ;
            mul_in_8  <= b_bin5 ;
            mul_in_9  <= b_bin6 ;
            mul_in_10 <= b_bin7 ;
        end
        else if(counter_ab == 13) begin
            a_bin11_sq  <= mul_out_1;
            a_bin12_sq  <= mul_out_2;
            a_bin13_sq  <= mul_out_3;
            b_bin1_sq   <= mul_out_4;
            b_bin2_sq   <= mul_out_5;
            b_bin3_sq   <= mul_out_6;
            b_bin4_sq   <= mul_out_7;
            b_bin5_sq   <= mul_out_8;
            b_bin6_sq   <= mul_out_9;
            b_bin7_sq   <= mul_out_10;
        end
        else if(counter_ab == 14) begin
            mul_in_1  <= b_bin8;
            mul_in_2  <= b_bin9;
            mul_in_3  <= b_bin10;
            mul_in_4  <= b_bin11;
            mul_in_5  <= b_bin12;
            mul_in_6  <= b_bin13;
        end
        else if(counter_ab == 21) begin
            b_bin8_sq   <= mul_out_1;
            b_bin9_sq   <= mul_out_2;
            b_bin10_sq  <= mul_out_3;
            b_bin11_sq  <= mul_out_4;
            b_bin12_sq  <= mul_out_5;
            b_bin13_sq  <= mul_out_6;
        end
        end
        sum0_AB: begin
            state_AB <= sum1_AB;
            sum_a_bins_123    <= a_bin1_sq + a_bin2_sq  + a_bin3_sq;
            sum_a_bins_4567   <= a_bin4_sq + a_bin5_sq + a_bin6_sq  + a_bin7_sq;
            sum_a_bins_891011 <= a_bin8_sq + a_bin9_sq + a_bin10_sq + a_bin11_sq;
            sum_a_bins_1213   <= a_bin12_sq + a_bin13_sq;
    
            sum_b_bins_123    <= b_bin1_sq + b_bin2_sq  + b_bin3_sq;
            sum_b_bins_4567   <= b_bin4_sq + b_bin5_sq + b_bin6_sq  + b_bin7_sq;
            sum_b_bins_891011 <= b_bin8_sq + b_bin9_sq + b_bin10_sq + b_bin11_sq;
            sum_b_bins_1213   <= b_bin12_sq + b_bin13_sq;
        end
        sum1_AB: begin
            state_AB <= done_AB;
            sum_a_bins <= sum_a_bins_123 + sum_a_bins_4567 + sum_a_bins_891011 + sum_a_bins_1213;
            sum_b_bins <= sum_b_bins_123 + sum_b_bins_4567 + sum_b_bins_891011 + sum_b_bins_1213;
        end
        done_AB: begin
            state_AB <= idle_AB;
        end
    endcase
        
unsigned_mull_32 pattern_11_uut    (clk, mul_in_1 , mul_in_1,  mul_out_1);
unsigned_mull_32 pattern_12_uut    (clk, mul_in_2 , mul_in_2,  mul_out_2);
unsigned_mull_32 pattern_13_uut    (clk, mul_in_3 , mul_in_3,  mul_out_3);
unsigned_mull_32 pattern_14_uut    (clk, mul_in_4 , mul_in_4,  mul_out_4);
unsigned_mull_32 pattern_15_uut    (clk, mul_in_5 , mul_in_5,  mul_out_5);
unsigned_mull_32 pattern_16_uut    (clk, mul_in_6 , mul_in_6,  mul_out_6);
unsigned_mull_32 pattern_17_uut    (clk, mul_in_7 , mul_in_7,  mul_out_7);
unsigned_mull_32 pattern_18_uut    (clk, mul_in_8 , mul_in_8,  mul_out_8);
unsigned_mull_32 pattern_19_uut    (clk, mul_in_9 , mul_in_9,  mul_out_9);
unsigned_mull_32 pattern_20_uut    (clk,  mul_in_10, mul_in_10, mul_out_10);
        
reg [31:0]int_to_f_data_in_d;
reg int_to_f_data_in_v;
wire [31:0]int_to_f_data_out_d;
wire int_to_f_data_out_v;


int_to_float conv_int_to_float_L (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(int_to_f_data_in_v),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(int_to_f_data_in_d),              // input wire [31 : 0] s_axis_a_tdata
  .m_axis_result_tvalid(int_to_f_data_out_v),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(int_to_f_data_out_d)    // output wire [31 : 0] m_axis_result_tdata
);

reg [31:0]sqrt_data_in_d;
reg sqrt_data_in_v;
wire [31:0]sqrt_data_out_d;
wire sqrt_data_out_v;

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
sqrt sqrt_L (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(sqrt_data_in_v),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(sqrt_data_in_d),              // input wire [31 : 0] s_axis_a_tdata
  .m_axis_result_tvalid(sqrt_data_out_v),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(sqrt_data_out_d)    // output wire [31 : 0] m_axis_result_tdata
);

reg  [31:0]div_data_in_a_d, div_data_in_b_d;
reg  div_data_in_a_v, div_data_in_b_v;
wire [31:0]div_data_out_d;
wire div_data_out_v;

matrix_divider uut_125 (
  .aclk(clk),                                   // input wire aclk
  .s_axis_a_tvalid(div_data_in_a_v),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(div_data_in_a_d),             // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(div_data_in_b_v),            // input wire s_axis_b_tvalid
  .s_axis_b_tdata(div_data_in_b_d),             // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(div_data_out_v),       // output wire m_axis_result_tvalid
  .m_axis_result_tdata(div_data_out_d)         // output wire [31 : 0] m_axis_result_tdata
);


reg [6:0]state_conv;
reg [31:0]L_norm,A_norm,B_norm;

localparam [6:0]
conv_to_float_L    = 0,
taking_sqrt_L      = 1,
delay_st_L         = 2,
conv_to_float_A    = 3,
taking_sqrt_A      = 4,
delay_st_A         = 5,
conv_to_float_B    = 6,
taking_sqrt_B      = 7,
delay_st_B         = 8,
L_count_7_to_f     = 9,
L_count_7_div      = 10,
L_count_7_ready    = 11,
L_count_28_to_f    = 12,
L_count_28_div     = 13,
L_count_28_ready   = 14,
L_count_56_to_f    = 15,
L_count_56_div     = 16,
L_count_56_ready   = 17,
L_count_112_to_f   = 18,
L_count_112_div    = 19,
L_count_112_ready  = 20,
L_count_131_to_f   = 21,
L_count_131_div    = 22,
L_count_131_ready  = 23,
L_count_193_to_f   = 24,
L_count_193_div    = 25,
L_count_193_ready  = 26,
L_count_224_to_f   = 27,
L_count_224_div    = 28,
L_count_224_ready  = 29,
B_count_7_to_f     = 30, 
B_count_7_div      = 31,
B_count_7_ready    = 32,
B_count_14_to_f    = 33, 
B_count_14_div     = 34,
B_count_14_ready   = 35,
B_count_28_to_f    = 36,
B_count_28_div     = 37,
B_count_28_ready   = 38,
B_count_48_to_f    = 39,
B_count_48_div     = 40,
B_count_48_ready   = 41,
B_count_56_to_f    = 42,
B_count_56_div     = 43,
B_count_56_ready   = 44,
B_count_193_to_f   = 45,
B_count_193_div    = 46,
B_count_193_ready  = 47,
B_count_224_to_f   = 48,
B_count_224_div    = 49,
B_count_224_ready  = 50,

conv_to_float_a_bins = 51,
taking_sqrt_a_bins   = 52,
delay_st_a_bins      = 53,

conv_to_float_b_bins = 54,
taking_sqrt_b_bins   = 55,
delay_st_b_bins      = 56,

a_bin_198_to_f       = 57,
a_bins_198_div       = 58,
a_bins_198_ready     = 59,
a_bin_199_to_f       = 60,
a_bins_199_div       = 61,
a_bins_199_ready     = 62,
b_bin_208_to_f       = 63,
b_bins_208_div       = 64,
b_bins_208_ready     = 65,

feature_done       = 66;


always@(posedge clk or posedge reset) 
if(reset) begin
    state_conv <= 0;
    done_features <=0;
end
else begin
    case(state_conv)
        conv_to_float_L: begin
            if(start_conv) begin
                int_to_f_data_in_v <= 1;
                int_to_f_data_in_d <= L_sum;
                state_conv <= taking_sqrt_L;
            end
        end
    
        taking_sqrt_L: begin
            int_to_f_data_in_v <= 0;
            int_to_f_data_in_d <= 0;
        
            if(int_to_f_data_out_v) begin
                sqrt_data_in_v  <= 1;
                sqrt_data_in_d  <= int_to_f_data_out_d;
                state_conv      <= delay_st_L;
            end 
        end
    
        delay_st_L: begin
            sqrt_data_in_v  <= 0;
            sqrt_data_in_d  <= 0;
            if(sqrt_data_out_v) begin
                L_norm     <= sqrt_data_out_d;
                state_conv <= conv_to_float_A;
            end
        end
        
        conv_to_float_A: begin
            int_to_f_data_in_v <= 1;
            int_to_f_data_in_d <= A_sum;
            state_conv <= taking_sqrt_A;
        end
    
        taking_sqrt_A: begin
            int_to_f_data_in_v <= 0;
            int_to_f_data_in_d <= 0;
        
            if(int_to_f_data_out_v) begin
                sqrt_data_in_v  <= 1;
                sqrt_data_in_d  <= int_to_f_data_out_d;
                state_conv      <= delay_st_A;
            end 
        end
    
        delay_st_A: begin
            sqrt_data_in_v  <= 0;
            sqrt_data_in_d  <= 0;
            if(sqrt_data_out_v) begin
                A_norm     <= sqrt_data_out_d;
                state_conv <= conv_to_float_B;
            end
        end
        
        conv_to_float_B: begin
            int_to_f_data_in_v <= 1;
            int_to_f_data_in_d <= B_sum;
            state_conv <= taking_sqrt_B;
        end
    
        taking_sqrt_B: begin
            int_to_f_data_in_v <= 0;
            int_to_f_data_in_d <= 0;
        
            if(int_to_f_data_out_v) begin
                sqrt_data_in_v  <= 1;
                sqrt_data_in_d  <= int_to_f_data_out_d;
                state_conv      <= delay_st_B;
            end 
        end
    
        delay_st_B: begin
            sqrt_data_in_v  <= 0;
            sqrt_data_in_d  <= 0;
            if(sqrt_data_out_v) begin
                B_norm     <= sqrt_data_out_d;
                state_conv <= L_count_7_to_f;
            end
        end

        L_count_7_to_f: begin
            int_to_f_data_in_v <= 1;
            int_to_f_data_in_d <= L_count_7;
            state_conv <= L_count_7_div;
        end
        
        L_count_7_div: begin
            int_to_f_data_in_v <= 0;
            int_to_f_data_in_d <= 0;
                if(int_to_f_data_out_v) begin
                    div_data_in_a_v  <= 1;
                    div_data_in_a_d  <= int_to_f_data_out_d;
                    div_data_in_b_v  <= 1;
                    div_data_in_b_d  <= L_norm;
                    state_conv       <= L_count_7_ready;
                end 
        end
        
        L_count_7_ready: begin
            div_data_in_a_v  <= 0;
            div_data_in_a_d  <= 0;
            div_data_in_b_v  <= 0;
            div_data_in_b_d  <= 0;
            if(div_data_out_v) begin
                LPB_7        <= div_data_out_d;
                state_conv   <= L_count_28_to_f;
            end
        end
        
        L_count_28_to_f: begin
            int_to_f_data_in_v <= 1;
            int_to_f_data_in_d <= L_count_28;
            state_conv <= L_count_28_div;
        end
        
        L_count_28_div: begin
            int_to_f_data_in_v <= 0;
            int_to_f_data_in_d <= 0;
                if(int_to_f_data_out_v) begin
                    div_data_in_a_v  <= 1;
                    div_data_in_a_d  <= int_to_f_data_out_d;
                    div_data_in_b_v  <= 1;
                    div_data_in_b_d  <= L_norm;
                    state_conv       <= L_count_28_ready;
                end 
        end
        
        L_count_28_ready: begin
            div_data_in_a_v  <= 0;
            div_data_in_a_d  <= 0;
            div_data_in_b_v  <= 0;
            div_data_in_b_d  <= 0;
            if(div_data_out_v) begin
                LPB_14        <= div_data_out_d;
                state_conv    <= L_count_56_to_f;
            end
        end
        

        L_count_56_to_f: begin
            int_to_f_data_in_v <= 1;
            int_to_f_data_in_d <= L_count_56;
            state_conv <= L_count_56_div;
        end
        
        L_count_56_div: begin
            int_to_f_data_in_v <= 0;
            int_to_f_data_in_d <= 0;
                if(int_to_f_data_out_v) begin
                    div_data_in_a_v  <= 1;
                    div_data_in_a_d  <= int_to_f_data_out_d;
                    div_data_in_b_v  <= 1;
                    div_data_in_b_d  <= L_norm;
                    state_conv       <= L_count_56_ready;
                end 
        end
        
        L_count_56_ready: begin
            div_data_in_a_v  <= 0;
            div_data_in_a_d  <= 0;
            div_data_in_b_v  <= 0;
            div_data_in_b_d  <= 0;
            if(div_data_out_v) begin
                LPB_19       <= div_data_out_d;
                state_conv   <= L_count_112_to_f;
            end
        end
        
        L_count_112_to_f: begin
            int_to_f_data_in_v <= 1;
            int_to_f_data_in_d <= L_count_112;
            state_conv <= L_count_112_div;
        end
        
        L_count_112_div: begin
            int_to_f_data_in_v <= 0;
            int_to_f_data_in_d <= 0;
                if(int_to_f_data_out_v) begin
                    div_data_in_a_v  <= 1;
                    div_data_in_a_d  <= int_to_f_data_out_d;
                    div_data_in_b_v  <= 1;
                    div_data_in_b_d  <= L_norm;
                    state_conv       <= L_count_112_ready;
                end 
        end
        
        L_count_112_ready: begin
            div_data_in_a_v  <= 0;
            div_data_in_a_d  <= 0;
            div_data_in_b_v  <= 0;
            div_data_in_b_d  <= 0;
            if(div_data_out_v) begin
                LPB_25         <= div_data_out_d;
                state_conv     <= L_count_131_to_f;
            end
        end
        
        
        L_count_131_to_f: begin
            int_to_f_data_in_v <= 1;
            int_to_f_data_in_d <= L_count_131;
            state_conv <= L_count_131_div;
        end
        
        L_count_131_div: begin
            int_to_f_data_in_v <= 0;
            int_to_f_data_in_d <= 0;
                if(int_to_f_data_out_v) begin
                    div_data_in_a_v  <= 1;
                    div_data_in_a_d  <= int_to_f_data_out_d;
                    div_data_in_b_v  <= 1;
                    div_data_in_b_d  <= L_norm;
                    state_conv       <= L_count_131_ready;
                end 
        end
        
        L_count_131_ready: begin
            div_data_in_a_v  <= 0;
            div_data_in_a_d  <= 0;
            div_data_in_b_v  <= 0;
            div_data_in_b_d  <= 0;
            if(div_data_out_v) begin
                LPB_32         <= div_data_out_d;
                state_conv     <= L_count_193_to_f;
            end
        end
        
        L_count_193_to_f: begin
            int_to_f_data_in_v <= 1;
            int_to_f_data_in_d <= L_count_193;
            state_conv <= L_count_193_div;
        end
        
        L_count_193_div: begin
            int_to_f_data_in_v <= 0;
            int_to_f_data_in_d <= 0;
                if(int_to_f_data_out_v) begin
                    div_data_in_a_v  <= 1;
                    div_data_in_a_d  <= int_to_f_data_out_d;
                    div_data_in_b_v  <= 1;
                    div_data_in_b_d  <= L_norm;
                    state_conv       <= L_count_193_ready;
                end 
        end
        
        L_count_193_ready: begin
            div_data_in_a_v  <= 0;
            div_data_in_a_d  <= 0;
            div_data_in_b_v  <= 0;
            div_data_in_b_d  <= 0;
            if(div_data_out_v) begin
                LPB_38       <= div_data_out_d;
                state_conv   <= L_count_224_to_f;
            end
        end
        
        L_count_224_to_f: begin
            int_to_f_data_in_v <= 1;
            int_to_f_data_in_d <= L_count_224;
            state_conv <= L_count_224_div;
        end
        
        L_count_224_div: begin
            int_to_f_data_in_v <= 0;
            int_to_f_data_in_d <= 0;
                if(int_to_f_data_out_v) begin
                    div_data_in_a_v  <= 1;
                    div_data_in_a_d  <= int_to_f_data_out_d;
                    div_data_in_b_v  <= 1;
                    div_data_in_b_d  <= L_norm;
                    state_conv       <= L_count_224_ready;
                end 
        end
        
        L_count_224_ready: begin
            div_data_in_a_v  <= 0;
            div_data_in_a_d  <= 0;
            div_data_in_b_v  <= 0;
            div_data_in_b_d  <= 0;
            if(div_data_out_v) begin
                LPB_43        <= div_data_out_d;
                state_conv    <= B_count_7_to_f;
            end
        end
        
        B_count_7_to_f: begin
            int_to_f_data_in_v <= 1;
            int_to_f_data_in_d <= B_count_7;
            state_conv         <= B_count_7_div;
        end
          
        B_count_7_div: begin
            int_to_f_data_in_v <= 0;
            int_to_f_data_in_d <= 0;
                if(int_to_f_data_out_v) begin
                    div_data_in_a_v  <= 1;
                    div_data_in_a_d  <= int_to_f_data_out_d;
                    div_data_in_b_v  <= 1;
                    div_data_in_b_d  <= B_norm;
                    state_conv       <= B_count_7_ready;
                end 
        end
        
        B_count_7_ready: begin
            div_data_in_a_v  <= 0;
            div_data_in_a_d  <= 0;
            div_data_in_b_v  <= 0;
            div_data_in_b_d  <= 0;
            if(div_data_out_v) begin
                LPB_125       <= div_data_out_d;
                state_conv    <= B_count_14_to_f;
            end
        end
        
        
        B_count_14_to_f: begin
            int_to_f_data_in_v <= 1;
            int_to_f_data_in_d <= B_count_14;
            state_conv         <= B_count_14_div;
        end
          
        B_count_14_div: begin
            int_to_f_data_in_v <= 0;
            int_to_f_data_in_d <= 0;
                if(int_to_f_data_out_v) begin
                    div_data_in_a_v  <= 1;
                    div_data_in_a_d  <= int_to_f_data_out_d;
                    div_data_in_b_v  <= 1;
                    div_data_in_b_d  <= B_norm;
                    state_conv       <= B_count_14_ready;
                end 
        end
        
        B_count_14_ready: begin
            div_data_in_a_v  <= 0;
            div_data_in_a_d  <= 0;
            div_data_in_b_v  <= 0;
            div_data_in_b_d  <= 0;
            if(div_data_out_v) begin
                LPB_128      <= div_data_out_d;
                state_conv   <= B_count_28_to_f;
            end
        end
        
        
        B_count_28_to_f: begin
            int_to_f_data_in_v <= 1;
            int_to_f_data_in_d <= B_count_28;
            state_conv         <= B_count_28_div;
        end
          
        B_count_28_div: begin
            int_to_f_data_in_v <= 0;
            int_to_f_data_in_d <= 0;
                if(int_to_f_data_out_v) begin
                    div_data_in_a_v  <= 1;
                    div_data_in_a_d  <= int_to_f_data_out_d;
                    div_data_in_b_v  <= 1;
                    div_data_in_b_d  <= B_norm;
                    state_conv       <= B_count_28_ready;
                end 
        end
        
        B_count_28_ready: begin
            div_data_in_a_v  <= 0;
            div_data_in_a_d  <= 0;
            div_data_in_b_v  <= 0;
            div_data_in_b_d  <= 0;
            if(div_data_out_v) begin
                LPB_132       <= div_data_out_d;
                state_conv    <= B_count_48_to_f;
            end
        end
        
        B_count_48_to_f: begin
            int_to_f_data_in_v <= 1;
            int_to_f_data_in_d <= B_count_48;
            state_conv         <= B_count_48_div;
        end
          
        B_count_48_div: begin
            int_to_f_data_in_v <= 0;
            int_to_f_data_in_d <= 0;
                if(int_to_f_data_out_v) begin
                    div_data_in_a_v  <= 1;
                    div_data_in_a_d  <= int_to_f_data_out_d;
                    div_data_in_b_v  <= 1;
                    div_data_in_b_d  <= B_norm;
                    state_conv       <= B_count_48_ready;
                end 
        end
        
        B_count_48_ready: begin
            div_data_in_a_v  <= 0;
            div_data_in_a_d  <= 0;
            div_data_in_b_v  <= 0;
            div_data_in_b_d  <= 0;
            if(div_data_out_v) begin
                LPB_136       <= div_data_out_d;
                state_conv    <= B_count_56_to_f;
            end
        end
        
        
        B_count_56_to_f: begin
            int_to_f_data_in_v <= 1;
            int_to_f_data_in_d <= B_count_56;
            state_conv         <= B_count_56_div;
        end
          
        B_count_56_div: begin
            int_to_f_data_in_v <= 0;
            int_to_f_data_in_d <= 0;
                if(int_to_f_data_out_v) begin
                    div_data_in_a_v  <= 1;
                    div_data_in_a_d  <= int_to_f_data_out_d;
                    div_data_in_b_v  <= 1;
                    div_data_in_b_d  <= B_norm;
                    state_conv       <= B_count_56_ready;
                end 
        end
        
        B_count_56_ready: begin
            div_data_in_a_v  <= 0;
            div_data_in_a_d  <= 0;
            div_data_in_b_v  <= 0;
            div_data_in_b_d  <= 0;
            if(div_data_out_v) begin
                LPB_137       <= div_data_out_d;
                state_conv    <= B_count_193_to_f;
            end
        end
        
        
        B_count_193_to_f: begin
            int_to_f_data_in_v <= 1;
            int_to_f_data_in_d <= B_count_193;
            state_conv         <= B_count_193_div;
        end
          
        B_count_193_div: begin
            int_to_f_data_in_v <= 0;
            int_to_f_data_in_d <= 0;
                if(int_to_f_data_out_v) begin
                    div_data_in_a_v  <= 1;
                    div_data_in_a_d  <= int_to_f_data_out_d;
                    div_data_in_b_v  <= 1;
                    div_data_in_b_d  <= B_norm;
                    state_conv       <= B_count_193_ready;
                end 
        end
        
        B_count_193_ready: begin
            div_data_in_a_v  <= 0;
            div_data_in_a_d  <= 0;
            div_data_in_b_v  <= 0;
            div_data_in_b_d  <= 0;
            if(div_data_out_v) begin
                LPB_156       <= div_data_out_d;
                state_conv    <= B_count_224_to_f;
            end
        end
        
        
        B_count_224_to_f: begin
            int_to_f_data_in_v <= 1;
            int_to_f_data_in_d <= B_count_224;
            state_conv         <= B_count_224_div;
        end
          
        B_count_224_div: begin
            int_to_f_data_in_v <= 0;
            int_to_f_data_in_d <= 0;
                if(int_to_f_data_out_v) begin
                    div_data_in_a_v  <= 1;
                    div_data_in_a_d  <= int_to_f_data_out_d;
                    div_data_in_b_v  <= 1;
                    div_data_in_b_d  <= B_norm;
                    state_conv       <= B_count_224_ready;
                end 
        end
        
        B_count_224_ready: begin
            div_data_in_a_v  <= 0;
            div_data_in_a_d  <= 0;
            div_data_in_b_v  <= 0;
            div_data_in_b_d  <= 0;
            if(div_data_out_v) begin
                LPB_161       <= div_data_out_d;
                state_conv    <= conv_to_float_a_bins;
            end
        end
        
        conv_to_float_a_bins: begin
            int_to_f_data_in_v <= 1;
            int_to_f_data_in_d <= sum_a_bins;
            state_conv <= taking_sqrt_a_bins;
        end
    
        taking_sqrt_a_bins: begin
            int_to_f_data_in_v <= 0;
            int_to_f_data_in_d <= 0;
        
            if(int_to_f_data_out_v) begin
                sqrt_data_in_v  <= 1;
                sqrt_data_in_d  <= int_to_f_data_out_d;
                state_conv      <= delay_st_a_bins;
            end 
        end
    
        delay_st_a_bins: begin
            sqrt_data_in_v  <= 0;
            sqrt_data_in_d  <= 0;
            if(sqrt_data_out_v) begin
                a_bin_norm     <= sqrt_data_out_d;
                state_conv     <= conv_to_float_b_bins;
            end
        end


        conv_to_float_b_bins: begin
            int_to_f_data_in_v <= 1;
            int_to_f_data_in_d <= sum_b_bins;
            state_conv <= taking_sqrt_b_bins;
        end
    
        taking_sqrt_b_bins: begin
            int_to_f_data_in_v <= 0;
            int_to_f_data_in_d <= 0;
        
            if(int_to_f_data_out_v) begin
                sqrt_data_in_v  <= 1;
                sqrt_data_in_d  <= int_to_f_data_out_d;
                state_conv      <= delay_st_b_bins;
            end 
        end
    
        delay_st_b_bins: begin
            sqrt_data_in_v  <= 0;
            sqrt_data_in_d  <= 0;
            if(sqrt_data_out_v) begin
                b_bin_norm     <= sqrt_data_out_d;
                state_conv     <= a_bin_198_to_f;
            end
        end

        a_bin_198_to_f: begin
            int_to_f_data_in_v <= 1;
            int_to_f_data_in_d <= a_bin8; //198
            state_conv         <= a_bins_198_div;
        end
          
        a_bins_198_div: begin
            int_to_f_data_in_v <= 0;
            int_to_f_data_in_d <= 0;
                if(int_to_f_data_out_v) begin
                    div_data_in_a_v  <= 1;
                    div_data_in_a_d  <= int_to_f_data_out_d;
                    div_data_in_b_v  <= 1;
                    div_data_in_b_d  <= a_bin_norm;
                    state_conv       <= a_bins_198_ready;
                end 
        end
        
        a_bins_198_ready: begin
            div_data_in_a_v  <= 0;
            div_data_in_a_d  <= 0;
            div_data_in_b_v  <= 0;
            div_data_in_b_d  <= 0;
            if(div_data_out_v) begin
                a_bin198  <= div_data_out_d;
                state_conv <= a_bin_199_to_f;
            end
        end
        
        a_bin_199_to_f: begin
            int_to_f_data_in_v <= 1;
            int_to_f_data_in_d <= a_bin9; //199
            state_conv         <= a_bins_199_div;
        end
          
        a_bins_199_div: begin
            int_to_f_data_in_v <= 0;
            int_to_f_data_in_d <= 0;
                if(int_to_f_data_out_v) begin
                    div_data_in_a_v  <= 1;
                    div_data_in_a_d  <= int_to_f_data_out_d;
                    div_data_in_b_v  <= 1;
                    div_data_in_b_d  <= a_bin_norm;
                    state_conv       <= a_bins_199_ready;
                end 
        end
        
        a_bins_199_ready: begin
            div_data_in_a_v  <= 0;
            div_data_in_a_d  <= 0;
            div_data_in_b_v  <= 0;
            div_data_in_b_d  <= 0;
            if(div_data_out_v) begin
                a_bin199  <= div_data_out_d;
                state_conv     <= b_bin_208_to_f;
            end
        end

        b_bin_208_to_f: begin
            int_to_f_data_in_v <= 1;
            int_to_f_data_in_d <= b_bin5; //208
            state_conv         <= b_bins_208_div;
        end
          
        b_bins_208_div: begin
            int_to_f_data_in_v <= 0;
            int_to_f_data_in_d <= 0;
                if(int_to_f_data_out_v) begin
                    div_data_in_a_v  <= 1;
                    div_data_in_a_d  <= int_to_f_data_out_d;
                    div_data_in_b_v  <= 1;
                    div_data_in_b_d  <= b_bin_norm;
                    state_conv       <= b_bins_208_ready;
                end 
        end
        
        b_bins_208_ready: begin
            div_data_in_a_v  <= 0;
            div_data_in_a_d  <= 0;
            div_data_in_b_v  <= 0;
            div_data_in_b_d  <= 0;
            if(div_data_out_v) begin
                b_bin208  <= div_data_out_d;
                state_conv     <= feature_done;
            end
        end
        
        feature_done: 
            done_features <= 1;
    endcase
end


endmodule

 