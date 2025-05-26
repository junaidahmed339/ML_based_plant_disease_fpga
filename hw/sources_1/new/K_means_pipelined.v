`timescale 1ns / 1ps


module K_means_pipelined(
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
output     Cluster_ID_PORTA_dout,
output     Cluster_ID_PORTA_wea,

//RGB (PORT B connection)
output     [15:0]RGB_PORTB_addr,
//output     RGB_PORTB_clk,
input      RGB_PORTB_din
);


reg [15:0]total_pixels = 50176;
reg [3:0]total_iterations = 5; 
reg Cluster_ID_PORTA_dout_state=0;
reg Cluster_ID_PORTA_wea_state=0;
reg reset_flag = 0;

//////////////////////////////////////K-means start//////////////////////////
wire [31:0]CIE_a_d, CIE_a_d_shifted;
wire CIE_a_v;
reg CIE_a_d_tlast=0;

reg [15:0]pixel_count=0;
reg [15:0]pixel_count_thresh=0;
wire [15:0]pixel_count_shifted;
reg [3:0]iterations_count = 0;
reg [15:0]tot_s2 = 0;
reg [15:0]tot_s1 = 0;
reg start_addition=0;

always@(posedge clk) begin
   if(reset | reset_flag)
       pixel_count  <= 1;
   else if(pixel_count != total_pixels && start_addition) //prev
       pixel_count  <= pixel_count + 1;
   else
       pixel_count  <= pixel_count;
end

assign CIE_a_v = start_addition;
assign CIE_a_d = CIE_A_PORTA_din;

shift_register shift (CIE_a_d,clk,CIE_a_d_shifted);
shift_register pixel_count_shift (pixel_count,clk,pixel_count_shifted);

/////////////////calculating distance///////////////////////////////////////         
reg [31:0]c1_0 = 32'h00000000;
reg [31:0]c2_0 = 32'h40a00000;

wire c1_0_new_v,c2_0_new_v;
wire [31:0]c1_0_new;
wire [31:0]c2_0_new;

//Perform two subtractions for distance 1 calculation
wire dist1_sub_out_CIE_a_c1_v,dist1_sub_out_CIE_b_c1_v;     
wire [31:0]dist1_sub_out_CIE_a_c1_d,dist1_sub_out_CIE_b_c1_d;
subtraction dist1_sub_0(clk,CIE_a_v,CIE_a_d,CIE_a_v,c1_0,dist1_sub_out_CIE_a_c1_v,dist1_sub_out_CIE_a_c1_d);

//Perform two subtractions for distance 2 calculation
wire       dist2_sub_out_CIE_a_c2_v,dist2_sub_out_CIE_b_c2_v;     
wire [31:0]dist2_sub_out_CIE_a_c2_d,dist2_sub_out_CIE_b_c2_d;
subtraction dist2_sub_0(clk,CIE_a_v,CIE_a_d,CIE_a_v,c2_0,dist2_sub_out_CIE_a_c2_v,dist2_sub_out_CIE_a_c2_d);

//abs
wire       abs_dist1_v,abs_dist2_v;
wire [31:0]abs_dist1_d,abs_dist2_d;
abs_IP dist1_abs(dist1_sub_out_CIE_a_c1_v,dist1_sub_out_CIE_a_c1_d,abs_dist1_v,abs_dist1_d);
abs_IP dist2_abs(dist2_sub_out_CIE_a_c2_v,dist2_sub_out_CIE_a_c2_d,abs_dist2_v,abs_dist2_d);

/////////////////calculating distance end///////////////////////////
wire       comparator_out_v;
wire       comparator_out_d;
///dist 2 > dist 1
comparator_greater_than check_distances(clk,abs_dist2_v,abs_dist2_d,abs_dist1_v,abs_dist1_d,comparator_out_v,comparator_out_d);

wire [31:0]sum1,sum3;
wire sum_sel_1, sum_sel_3;
assign  sum_sel_1 = comparator_out_v && comparator_out_d;//   ? sum1:sum3 : 0;
assign  sum_sel_3 = comparator_out_v && ~comparator_out_d;
 
wire       summing_ans_0_v,summing_ans_1_v;
wire [31:0]summing_ans_0_d,summing_ans_1_d;
//matrix_addition summing_0(clk,comparator_out_v,sum_sel_1_3,1'b1,CIE_a_d,summing_ans_0_v,summing_ans_0_d);
wire [31:0] sum_input;
assign sum_input = comparator_out_v ? CIE_a_d_shifted : 32'b0;
Accumulator sum_1(clk,~reset,sum_sel_1,sum_input,CIE_a_d_tlast,summing_ans_0_v,summing_ans_0_d);
Accumulator sum_3(clk,~reset,sum_sel_3,sum_input,CIE_a_d_tlast,summing_ans_1_v,summing_ans_1_d);

assign sum1 = summing_ans_0_d;
assign sum3 = summing_ans_1_d;


//checking CIE_a < -10  //checking greenes, pixel is green if a < -10
wire CIE_a_less_10_v,CIE_a_less_10_d;
comparator_less_than  comp_CIE_a_less_10(comparator_out_v,CIE_a_d_shifted,comparator_out_v,32'hc1200000,CIE_a_less_10_v,CIE_a_less_10_d);

reg cluster_id = 0;
reg [31:0]total = 0;
reg [31:0]total_40000 = 0;

wire total_f_v,total_40000_f_v;
wire [31:0]total_f_d;
wire [31:0]total_40000_f_d;



always@(posedge clk) 
if(reset | reset_flag)
    total  <= 0;
else if(sum_sel_1)
    total  <= total  + 1;
else 
    total  <= total;

always@(*)
if(reset)
    total_40000 <= total_pixels;
else
    total_40000 <= total_pixels - total;

reg int2f_start = 0;
int_to_float  int2f_0(clk,int2f_start,total,total_f_v,total_f_d);
int_to_float  int2f_1(clk,int2f_start,total_40000,total_40000_f_v,total_40000_f_d);

reg div_start = 0;
matrix_divider    final_div_sum1(clk,div_start,sum1,div_start,total_f_d,c1_0_new_v,c1_0_new);
matrix_divider    final_div_sum3(clk,div_start,sum3,div_start,total_40000_f_d,c2_0_new_v,c2_0_new);

wire selected_cluster;
reg sample_cluster_reg = 0;

always@(posedge clk) 
if(reset | reset_flag)
    tot_s1 <= 0;
else if(sum_sel_1 && comparator_out_v && CIE_a_less_10_d)
    tot_s1       <= tot_s1 + 1;
else 
    tot_s1       <= tot_s1;
    
always@(posedge clk) 
if(reset | reset_flag)
    tot_s2 <= 0;
else if(sum_sel_3 && comparator_out_v && CIE_a_less_10_d)
    tot_s2       <= tot_s2 + 1;
else 
    tot_s2       <= tot_s2;



assign selected_cluster = (tot_s1 < tot_s2)? 1'b0 : 1'b1;


assign Cluster_ID_PORTA_wea  = done_kmeans ? Cluster_ID_PORTA_wea_state : comparator_out_v;
assign Cluster_ID_PORTA_dout = done_kmeans ? Cluster_ID_PORTA_dout_state : sum_sel_1 ? 0 : 1;
assign Cluster_ID_PORTA_addr = done_kmeans ? pixel_count_thresh : pixel_count_shifted;

////state machine control/////


reg [7:0]R,G,B;
reg RGB;
reg [2:0]CIE_lab;
reg [5:0]delay_count;

localparam [4:0]
wait_to_start        = 0,
read_data            = 1,
wait_for_comp        = 2,
int2f_conv_start     = 3,
division_start       = 4,
update_cluster_c     = 5,
check_total_iterations = 6,
done                 = 7,
thresholding_start   = 8,
delay                = 9,
thresholding_sample  = 10,
thresholding_check   = 11,
thresholding_comparator_check = 12,
comparison_done = 13,
end_state       = 14;

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
        if(pixel_count == total_pixels-1)
            next_k_state     <= wait_for_comp;
        else
            next_k_state     <= read_data;
    end
    wait_for_comp: //delay of 23 + 2 + 11 cycles
    begin
           if(delay_count == 36)
                next_k_state <= int2f_conv_start;
           else
                next_k_state <= wait_for_comp;
    end
    int2f_conv_start:    //7
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
            next_k_state      <= read_data;
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
       if(pixel_count_thresh != total_pixels)  //-1 prev 
          next_k_state <= thresholding_start;
       else
          next_k_state <= end_state;
    end
    end_state:
    begin
        next_k_state <= end_state;
    end
endcase
end 


always@(posedge clk)
if(reset)
begin
    iterations_count <= 0;
    done_kmeans           <= 0;
    done_cluster_settings <= 0;
    Cluster_ID_PORTA_wea_state <= 0;
    int2f_start        <= 0;
    div_start        <= 0;
    c1_0             <= 32'h00000000;
    c2_0             <= 32'h40a00000;
    R                <= 0;
    G                <= 0;
    B                <= 0;
    delay_count      <= 0;
    pixel_count_thresh <= 0;
end 
else
case(k_state)
    wait_to_start: 
    begin
        start_addition                 <= 0;
        iterations_count      <= 0;
        done_kmeans           <= 0;
        done_cluster_settings <= 0;
        Cluster_ID_PORTA_wea_state <= 0;
        int2f_start        <= 0;
        div_start        <= 0;
        c1_0             <= 32'h00000000;
        c2_0             <= 32'h40a00000;
        R                <= 0;
        G                <= 0;
        B                <= 0;
        delay_count      <= 0;
        pixel_count_thresh <= 0;
    end
    read_data:   //1
    begin
        start_addition <= 1;
        delay_count      <= 0; 
        reset_flag       <= 0; 
    end
    wait_for_comp: 
    begin
        start_addition <= 0; 
        delay_count <= delay_count + 1;
    end
    int2f_conv_start:    //7
    begin
        start_addition          <= 0;
        int2f_start    <= 1;
    end
    division_start:      //8
    begin
        int2f_start    <= 0;
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
        end
    end
    check_total_iterations:
    begin
        if(iterations_count != total_iterations -1)
        begin
             iterations_count  <= iterations_count + 1;
             reset_flag <= 1;
        end
    end
    done:
    begin
        done_kmeans                 <= 1;
        Cluster_ID_PORTA_wea_state  <= 0;
        pixel_count_thresh          <= 1;
    end  
    thresholding_start: //12
    begin
        CIE_LAB_PORTA_wea       <= 0;
        CIE_AB_COLOR_PORTA_wea  <= 0;
        Cluster_ID_PORTA_wea_state    <= 0;
    end 
    delay:
    begin
        CIE_LAB_PORTA_wea       <= 0;
        CIE_AB_COLOR_PORTA_wea  <= 0;
        Cluster_ID_PORTA_wea_state    <= 0;
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
            Cluster_ID_PORTA_wea_state  <= 1;
            Cluster_ID_PORTA_dout_state <= 0;
            CIE_LAB_PORTA_wea     <= 1;
            CIE_LAB_PORTA_dout    <= 3'h0;
            CIE_AB_COLOR_PORTA_wea   <= 1;
            CIE_AB_COLOR_PORTA_dout  <= 8'b1000_0100;  //abin = 8 bbin=4  
        end 
        else
        begin
            Cluster_ID_PORTA_wea_state  <= 1;
            Cluster_ID_PORTA_dout_state <= 1;        
        end
    end
    thresholding_comparator_check: //15 
    begin
    Cluster_ID_PORTA_wea_state  <= 0;
    Cluster_ID_PORTA_dout_state <= 0;  
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
       Cluster_ID_PORTA_wea_state  <= 0;
       Cluster_ID_PORTA_dout_state <= 0; 
       CIE_LAB_PORTA_wea        <= 0;
       CIE_LAB_PORTA_dout       <= 0;
       CIE_AB_COLOR_PORTA_wea   <= 0;
       CIE_AB_COLOR_PORTA_dout  <= 0;    
       if(pixel_count_thresh != total_pixels) //prev -1 
             pixel_count_thresh  <= pixel_count_thresh + 1;
    end
    end_state:
    begin 
        done_cluster_settings <= 1;
    end
endcase

assign CIE_A_PORTA_addr   = pixel_count;
assign RGB_PORTB_addr     = pixel_count_thresh; //thresholding from CIE-Lab
assign CIE_LAB_PORTA_addr = pixel_count_thresh;
assign CIE_AB_COLOR_PORTA_addr  = pixel_count_thresh;

assign CIE_LAB_PORTA_clk = clk;
assign CIE_A_PORTA_clk   = clk;
assign Cluster_ID_PORTA_clk  = clk;
assign CIE_AB_COLOR_PORT_clk = clk;

////////////////////////////////////////////////k-means end////////////////////////////////////////////

endmodule
