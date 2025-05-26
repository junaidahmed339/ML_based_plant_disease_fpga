`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/17/2022 05:37:55 PM
// Design Name: 
// Module Name: K_means
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


module K_means(
input start_kmeans,
input reset,
input clk,
output reg done_kmeans = 0,
output reg done_cluster_settings = 0,

//CIE_A (PORT A connection)
output     [15:0]CIE_A_PORTA_addr,
output     CIE_A_PORTA_clk,
input      [31:0]CIE_A_PORTA_din,
output     reg [31:0]CIE_A_PORTA_dout,
output     reg CIE_A_PORTA_wea = 0,

//CIE_LAB (PORT A connection)
output     [15:0]CIE_LAB_PORTA_addr,
output     CIE_LAB_PORTA_clk,
input      [2:0]CIE_LAB_PORTA_din,
output     reg [2:0]CIE_LAB_PORTA_dout,
output     reg CIE_LAB_PORTA_wea = 0,

//Color features bins of CIE_ab (PORT A connection)
output     [15:0]CIE_AB_COLOR_PORTA_addr,
output     CIE_AB_COLOR_PORT_clk,
output     reg [7:0]CIE_AB_COLOR_PORTA_dout,
output     reg CIE_AB_COLOR_PORTA_wea =0,

//Cluster ID (PORT A connection)
output     [15:0]Cluster_ID_PORTA_addr,
output     Cluster_ID_PORTA_clk,
input      Cluster_ID_PORTA_din,
output     reg Cluster_ID_PORTA_dout = 0,
output     reg Cluster_ID_PORTA_wea = 0,



//RGB (PORT B connection)
output     [15:0]RGB_PORTB_addr,
//output     RGB_PORTB_clk,
input      RGB_PORTB_din
);


reg [15:0]total_pixels = 100;//50176;
reg [3:0]total_iterations = 3;//5; 
//////////////////////////////////////K-means start//////////////////////////
reg [31:0]CIE_a_d=0,CIE_b_d=0;
reg CIE_a_v=0,CIE_b_v=0;

/////////////////calculating distance///////////////////////////////////////         
reg [31:0]c1_0 = 32'h00000000;
reg [31:0]c2_0 = 32'h40a00000;

wire c1_0_new_v,c2_0_new_v;
wire [31:0]c1_0_new;
wire [31:0]c2_0_new;


//Perform two subtractions for distance 1 calculation
wire dist1_sub_out_CIE_a_c1_v,dist1_sub_out_CIE_b_c1_v;     
wire [31:0]dist1_sub_out_CIE_a_c1_d,dist1_sub_out_CIE_b_c1_d;

subtraction dist1_sub_0(clk,CIE_a_v,CIE_a_d,1'b1,c1_0,dist1_sub_out_CIE_a_c1_v,dist1_sub_out_CIE_a_c1_d);
//subtraction dist1_sub_1(clk,CIE_b_v,CIE_b_d,1'b1,c1_1,dist1_sub_out_CIE_b_c1_v,dist1_sub_out_CIE_b_c1_d);

//Perform two subtractions for distance 2 calculation
wire       dist2_sub_out_CIE_a_c2_v,dist2_sub_out_CIE_b_c2_v;     
wire [31:0]dist2_sub_out_CIE_a_c2_d,dist2_sub_out_CIE_b_c2_d;
subtraction dist2_sub_0(clk,CIE_a_v,CIE_a_d,1'b1,c2_0,dist2_sub_out_CIE_a_c2_v,dist2_sub_out_CIE_a_c2_d);
//subtraction dist2_sub_1(clk,CIE_b_v,CIE_b_d,1'b1,c2_1,dist2_sub_out_CIE_b_c2_v,dist2_sub_out_CIE_b_c2_d);

//Taking squares
wire       sq_dist1_CIE_a_c1_v,sq_dist2_CIE_a_c2_v,sq_dist1_CIE_b_c1_v,sq_dist2_CIE_b_c2_v;
wire [31:0]sq_dist1_CIE_a_c1_d,sq_dist2_CIE_a_c2_d,sq_dist1_CIE_b_c1_d,sq_dist2_CIE_b_c2_d;

matrix_multiplication dist1_CIE_a_c1 (clk,dist1_sub_out_CIE_a_c1_v,dist1_sub_out_CIE_a_c1_d,dist1_sub_out_CIE_a_c1_v,dist1_sub_out_CIE_a_c1_d,sq_dist1_CIE_a_c1_v,sq_dist1_CIE_a_c1_d);
//matrix_multiplication dist1_CIE_b_c1 (clk,dist1_sub_out_CIE_b_c1_v,dist1_sub_out_CIE_b_c1_d,dist1_sub_out_CIE_b_c1_v,dist1_sub_out_CIE_b_c1_d,sq_dist1_CIE_b_c1_v,sq_dist1_CIE_b_c1_d);

matrix_multiplication dist2_CIE_a_c2 (clk,dist2_sub_out_CIE_a_c2_v,dist2_sub_out_CIE_a_c2_d,dist2_sub_out_CIE_a_c2_v,dist2_sub_out_CIE_a_c2_d,sq_dist2_CIE_a_c2_v,sq_dist2_CIE_a_c2_d);
//matrix_multiplication dist2_CIE_b_c2 (clk,dist2_sub_out_CIE_b_c2_v,dist2_sub_out_CIE_b_c2_d,dist2_sub_out_CIE_b_c2_v,dist2_sub_out_CIE_b_c2_d,sq_dist2_CIE_b_c2_v,sq_dist2_CIE_b_c2_d);

//Addition
//wire       add_dist1_v,add_dist2_v;
//wire [31:0]add_dist1_d,add_dist2_d;
//matrix_addition dist1_CIE_a_c1_0_CIE_b_c1_1(clk,sq_dist1_CIE_a_c1_v,sq_dist1_CIE_a_c1_d,sq_dist1_CIE_b_c1_v,sq_dist1_CIE_b_c1_d,add_dist1_v,add_dist1_d);
//matrix_addition dist2_CIE_a_c2_0_CIE_b_c2_1(clk,sq_dist2_CIE_a_c2_v,sq_dist2_CIE_a_c2_d,sq_dist2_CIE_b_c2_v,sq_dist2_CIE_b_c2_d,add_dist2_v,add_dist2_d);

//sqrt
wire       sqrt_dist1_v,sqrt_dist2_v;
wire [31:0]sqrt_dist1_d,sqrt_dist2_d;
sqrt dist1_sqrt(clk,sq_dist1_CIE_a_c1_v,sq_dist1_CIE_a_c1_d,sqrt_dist1_v,sqrt_dist1_d);
sqrt dist2_sqrt(clk,sq_dist2_CIE_a_c2_v,sq_dist2_CIE_a_c2_d,sqrt_dist2_v,sqrt_dist2_d);
/////////////////calculating distance end///////////////////////////

wire       comparator_out_v;
wire       comparator_out_d;
///dist 2 > dist 1
comparator_greater_than check_distances(clk,sqrt_dist2_v,sqrt_dist2_d,sqrt_dist1_v,sqrt_dist1_d,comparator_out_v,comparator_out_d);

reg cluster_id = 0;
reg [31:0]total = 0;
reg [31:0]total_40000 = 0;

wire total_f_v,total_40000_f_v;
wire [31:0]total_f_d;
wire [31:0]total_40000_f_d;

always@(*)
if(reset)
total_40000 <= total_pixels;
else
total_40000 <= total_pixels - total;

reg sub_start = 0;
int_to_float  int2f_0(clk,sub_start,total,total_f_v,total_f_d);
int_to_float  int2f_1(clk,sub_start,total_40000,total_40000_f_v,total_40000_f_d);

reg [31:0]sum1= 0,sum2=0,sum3=0,sum4=0;
wire [31:0]sum_sel_1_3,sum_sel_2_4;
assign  sum_sel_1_3 = comparator_out_v ? comparator_out_d  ? sum1:sum3 : 0;
//assign  sum_sel_2_4 = comparator_out_v ? comparator_out_d  ? sum2:sum4 : 0;
 
wire       summing_ans_0_v,summing_ans_1_v;
wire [31:0]summing_ans_0_d,summing_ans_1_d;
matrix_addition summing_0(clk,comparator_out_v,sum_sel_1_3,1'b1,CIE_a_d,summing_ans_0_v,summing_ans_0_d);
//matrix_addition summing_1(clk,comparator_out_v,sum_sel_2_4,1'b1,CIE_b_d,summing_ans_1_v,summing_ans_1_d);

reg div_start = 0;
matrix_divider    final_div_sum1(clk,div_start,sum1,1'b1,total_f_d,c1_0_new_v,c1_0_new);
//matrix_divider    final_div_sum2(clk,div_start,sum2,1'b1,total_f_d,c1_1_new_v,c1_1_new);
matrix_divider    final_div_sum3(clk,div_start,sum3,1'b1,total_40000_f_d,c2_0_new_v,c2_0_new);
//matrix_divider    final_div_sum4(clk,div_start,sum4,1'b1,total_40000_f_d,c2_1_new_v,c2_1_new);

 

///checking CIE_a < -10
wire CIE_a_less_10_v,CIE_a_less_10_d;
comparator_less_than     comp_CIE_a_less_10(clk,CIE_a_v,CIE_a_d,1'b1,32'hc1200000,CIE_a_less_10_v,CIE_a_less_10_d);


reg selected_cluster = 0;
reg sample_cluster_reg = 0;
////state machine control/////
reg [15:0]pixel_count = 1;
reg [3:0]iterations_count = 0;
reg [15:0]tot_s2 = 0;
reg [15:0]tot_s1 = 0;

reg [7:0]R,G,B;
reg RGB;
reg [2:0]CIE_lab;

localparam [4:0]
wait_to_start        = 0,
read_data            = 1,
wait_for_comp_v      = 2,
store_in_sum1_2      = 3,
store_in_sum3_4      = 4,
check_pixel_count    = 5,
read_data_wait_cycle = 6,
read_data_wait_cycle2 = 7,
subtraction_start    = 8,
division_start       = 9,
update_cluster_c     = 10,
check_total_iterations = 11,
done                 = 12,
thresholding_start   = 13,
delay                = 14,
thresholding_sample  = 15,
thresholding_check   = 16,
thresholding_comparator_check = 17,
thresholding_zero_check_read  = 18,
thresholding_zero_check_delay = 19,
thresholding_zero_check_write = 20,
comparison_done = 21,
End             = 22;

reg [4:0]k_state = 0,next_k_state = 0;

always@(posedge clk)
if(reset)
    k_state  <= wait_to_start;
else
    k_state <= next_k_state;

always@(*)
begin
if(reset)
    next_k_state  <= wait_to_start;
else
case(k_state)
    wait_to_start: //0 
    begin
        if(start_kmeans)
            next_k_state  <= read_data;
        else
            next_k_state  <= wait_to_start;
    end
    read_data:   //1
    begin
        next_k_state     <= wait_for_comp_v;
    end
    wait_for_comp_v: //2
    begin
        if(comparator_out_v && comparator_out_d)
            next_k_state <= store_in_sum1_2;
        else if(comparator_out_v && ~comparator_out_d)
            next_k_state <= store_in_sum3_4;
        else
            next_k_state <= wait_for_comp_v;
    end
    store_in_sum1_2: //3
    begin
        if(summing_ans_0_v)
            next_k_state <= check_pixel_count;
        else
            next_k_state <= store_in_sum1_2;
    end
    store_in_sum3_4://4
    begin 
        if(summing_ans_0_v)
            next_k_state <= check_pixel_count;
        else
            next_k_state <= store_in_sum3_4;
    end
    check_pixel_count: //5
    begin
        if(pixel_count != total_pixels) // -1 prev
            next_k_state <= read_data_wait_cycle;
        else
            next_k_state <= subtraction_start;
    end
    read_data_wait_cycle: //6
    begin
            next_k_state <= read_data_wait_cycle2;
    end
    read_data_wait_cycle2: //6
    begin
            next_k_state <= read_data;
    end
    subtraction_start:    //7
    begin
            next_k_state <= division_start;
    end
    division_start:      //8
    begin
        if(total_f_v)
            next_k_state <= update_cluster_c;
        else
            next_k_state <= division_start;
    end
    update_cluster_c: //9
    begin
        if(c1_0_new_v)
            next_k_state <= check_total_iterations;
        else
            next_k_state <= update_cluster_c;
    end
    check_total_iterations: //10
    begin
        if(iterations_count != total_iterations -1)
            next_k_state      <= read_data_wait_cycle;
        else
            next_k_state      <= done;
    end
    done: //11
    begin
            next_k_state <= thresholding_start;
    end
    thresholding_start: //12
    begin
        next_k_state     <= delay;
    end
    delay:
    begin
        next_k_state     <= thresholding_sample;
    end
    thresholding_sample: //13
    begin
        next_k_state     <= thresholding_check;
    end    
    thresholding_check: //14
    begin
        if(selected_cluster == sample_cluster_reg)
            next_k_state <= thresholding_comparator_check;
        else 
            next_k_state <= comparison_done;
    end
    thresholding_comparator_check: //15 
    begin
           next_k_state <= comparison_done;
    end
    
    comparison_done: //19
    begin
       if(pixel_count != total_pixels)  //-1 prev 
          next_k_state <= thresholding_start;
       else
          next_k_state <= End;
    end
    End:
    begin
        next_k_state <= End;
    end
endcase
end 


always@(posedge clk)
if(reset)
begin
    pixel_count      <= 1;
    iterations_count <= 0;
    total            <= 0;
    tot_s1           <= 0;
    tot_s2           <= 0;
    done_kmeans           <= 0;
    done_cluster_settings <= 0;
    CIE_a_v          <= 0;
    CIE_b_v          <= 0;
    sum1             <= 0;
    sum3             <= 0;
    Cluster_ID_PORTA_wea <= 0;
    sub_start        <= 0;
    div_start        <= 0;
    c1_0             <= 32'h00000000;
    c2_0             <= 32'h40a00000;
    selected_cluster <= 0;
    R                <= 0;
    G                <= 0;
    B                <= 0;
end 
else
case(k_state)
    wait_to_start: 
    begin
        pixel_count      <= 1;
        iterations_count <= 0;
        total            <= 0;
        tot_s1           <= 0;
        tot_s2           <= 0;
        done_kmeans           <= 0;
        done_cluster_settings <= 0;
        CIE_a_v          <= 0;
        CIE_b_v          <= 0;
        sum1             <= 0;
        sum3             <= 0;
        Cluster_ID_PORTA_wea <= 0;
        sub_start        <= 0;
        div_start        <= 0;
        c1_0             <= 32'h00000000;
        c2_0             <= 32'h40a00000;
        selected_cluster <= 0;
        R                <= 0;
        G                <= 0;
        B                <= 0;
    end
    read_data:   //1
    begin
        CIE_a_d          <= CIE_A_PORTA_din;
        CIE_a_v          <= 1;
    end
    wait_for_comp_v: //2
    begin
        CIE_a_v          <= 0;
    end
    store_in_sum1_2: //3
    begin
        if(summing_ans_0_v)
        begin
            sum1                  <= summing_ans_0_d;
            Cluster_ID_PORTA_wea  <= 1;
            Cluster_ID_PORTA_dout <= 0; //change in c code (1 is used there)
            total                 <= total  + 1;
            if(CIE_a_less_10_d)
                tot_s1       <= tot_s1 + 1;
        end
    end
    store_in_sum3_4://4
    begin 
        if(summing_ans_0_v)
        begin
            sum3                  <= summing_ans_0_d;
            Cluster_ID_PORTA_dout <= 1; //change in c code (2 is used there)
            Cluster_ID_PORTA_wea  <= 1;
            if(CIE_a_less_10_d) 
                 tot_s2       <= tot_s2 + 1; //cluster_id <= 1; //change in c code (2 is used there)
        end
    end
    check_pixel_count: //5
    begin
        Cluster_ID_PORTA_wea <= 0;
        if(pixel_count != total_pixels) //prev
            pixel_count  <= pixel_count + 1;
        else
            pixel_count  <= pixel_count;
    end
    subtraction_start:    //7
    begin
        sub_start    <= 1;
    end
    division_start:      //8
    begin
        sub_start    <= 0;
       if(total_f_v)
           div_start    <= 1;
       else
           div_start    <= 0;
    end
    update_cluster_c: //9
    begin
        div_start    <= 0;
        if(c1_0_new_v)
        begin
            c1_0  <= c1_0_new;
            c2_0  <= c2_0_new;
            sum1  <= 0;
            sum3  <= 0;
        end
    end
    check_total_iterations:
    begin
        if(iterations_count != total_iterations -1)
        begin
             iterations_count  <= iterations_count + 1;
             pixel_count       <= 1;
             total             <= 0;
             tot_s1            <= 0;
             tot_s2            <= 0;
        end
    end
    done:
    begin
        pixel_count           <= 1;
        done_kmeans           <= 1;
        Cluster_ID_PORTA_wea  <= 0;
        if(tot_s1 < tot_s2)
             selected_cluster <= 0;
        else
             selected_cluster <= 1; 
    end  
    thresholding_start: //12
    begin
        CIE_LAB_PORTA_wea       <= 0;
        CIE_A_PORTA_wea         <= 0;
        CIE_AB_COLOR_PORTA_wea  <= 0;
        Cluster_ID_PORTA_wea    <= 0;
    end 
    
    delay:
    begin
        CIE_LAB_PORTA_wea       <= 0;
        CIE_A_PORTA_wea         <= 0;
        CIE_AB_COLOR_PORTA_wea  <= 0;
        Cluster_ID_PORTA_wea    <= 0;
    end
    
    thresholding_sample: //13
    begin
        sample_cluster_reg   <= Cluster_ID_PORTA_din;
        RGB                  <= RGB_PORTB_din;
    end    
    thresholding_check: //14
    begin
        if(selected_cluster != sample_cluster_reg)
        begin
            Cluster_ID_PORTA_wea  <= 1;
            Cluster_ID_PORTA_dout <= 0;
            CIE_LAB_PORTA_wea     <= 1;
            CIE_LAB_PORTA_dout    <= 3'h0;
            CIE_AB_COLOR_PORTA_wea   <= 1;
            CIE_AB_COLOR_PORTA_dout  <= 8'b1000_0100;  //abin = 8 bbin=4  
        end 
        else
        begin
            Cluster_ID_PORTA_wea  <= 1;
            Cluster_ID_PORTA_dout <= 1;        
        end
    end
    thresholding_comparator_check: //15 
    begin
    Cluster_ID_PORTA_wea  <= 0;
    Cluster_ID_PORTA_dout <= 0;  
        if(RGB == 0) //if CIE_B is less than 6 and RGB < 50
                begin
                CIE_LAB_PORTA_wea        <= 1;
                CIE_LAB_PORTA_dout       <= 3'h0;
                CIE_AB_COLOR_PORTA_wea   <= 1;
                CIE_AB_COLOR_PORTA_dout  <= 8'b1000_0100;
                end
    end
    
    comparison_done: //17
    begin
       Cluster_ID_PORTA_wea  <= 0;
       Cluster_ID_PORTA_dout <= 0; 
       CIE_LAB_PORTA_wea     <= 0;
       CIE_A_PORTA_wea       <= 0;
       CIE_AB_COLOR_PORTA_wea <= 0;
       CIE_LAB_PORTA_dout    <= 0;
       CIE_AB_COLOR_PORTA_dout <= 0;
       CIE_A_PORTA_dout      <= 0;         
       if(pixel_count != total_pixels) //prev -1 
             pixel_count  <= pixel_count + 1;
    end
    End:
    begin 
        done_cluster_settings <= 1;
    end
endcase

assign CIE_LAB_PORTA_addr = pixel_count;
assign CIE_A_PORTA_addr = pixel_count;
assign RGB_PORTB_addr   = pixel_count;
assign CIE_AB_COLOR_PORTA_addr  = pixel_count;
assign Cluster_ID_PORTA_addr = pixel_count;

assign CIE_LAB_PORTA_clk = clk;
assign CIE_A_PORTA_clk = clk;
assign Cluster_ID_PORTA_clk = clk;
assign CIE_AB_COLOR_PORT_clk = clk;



////////////////////////////////////////////////k-means end////////////////////////////////////////////

endmodule
