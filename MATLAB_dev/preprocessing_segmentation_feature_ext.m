close all;
clear all;

for k=2:2

z=['image (',num2str(k),').JPG'];
img1=imread(z);
img1=imresize(img1,[224 224]);
n=size(img1);
img = img1; 
I=double(img);
sR = I(:,:,1);
sG = I(:,:,2);
sB = I(:,:,3);
LAB1 = rgb2lab(img,'WhitePoint','d65');

var_R = sR ./255; 
var_G = sG ./255;
var_B = sB ./255;
img(:,:,1) = var_R;
img(:,:,2) = var_G;
img(:,:,3) = var_B;
n=size(sR);

for i=1:n(1,1)
    for j=1:n(1,2)
        temp1= var_R(i,j);
        temp2= var_G(i,j);
        temp3= var_B(i,j);

        if ( temp1 >= 0.04045 ) 
            temp1 = (( ( temp1 + 0.055 ) / 1.055 ) ^ 2.4) ;
        else
            temp1 = temp1 / 12.92;
        end
        if ( temp2 >= 0.04045 ) 
            temp2 = ( ( temp2 + 0.055 ) / 1.055 ) ^ 2.4 ;
        else
            temp2 = temp2 / 12.92;
        end
        if ( temp3 >= 0.04045 ) 
            temp3 = ( ( temp3 + 0.055 ) / 1.055 ) ^ 2.4 ;
        else
            temp3 = temp3 / 12.92;
        end
        
        temp1 = temp1 * 100;
        temp2 = temp2 * 100;
        temp3 = temp3 * 100;


        temp4 = (temp1 *  0.4124564)  + (temp2 * 0.3575761) + (temp3 *  0.1804375);
        temp5 = (temp1 *  0.2126729)  + (temp2 * 0.7151522) + (temp3 *  0.0721750);
        temp6 = (temp1 *  0.0193339)  + (temp2 * 0.1191920) + (temp3 *  0.9503041);

        temp7_sec = temp4 / 95.04;		%0.3636 0.3737 0.3993
        temp8_sec = temp5 / 100.000;
        temp9_sec = temp6 / 108.888;

        if ( temp7_sec > 0.008856 ) 
            x_sec = temp7_sec;   
            if(temp7_sec > 0.35 && temp7_sec <= 1)
                y7_sec = 1 + (0.333333 * (x_sec-1)) - (0.111111*((x_sec-1).^2)) + (0.06172839 * ((x_sec-1).^3)) - (0.0411522 * ((x_sec-1).^4));
            %0.2  --> 0.08 to 0.35
            elseif(temp7_sec > 0.08 && temp7_sec <= 0.35)
                y7_sec = 0.5848 + (0.97466 * (x_sec-0.2))- (1.6244*((x_sec-0.2).^2)) + (4.5123 * ((x_sec-0.2).^3)) - (15.0410 * ((x_sec-0.2).^4));
            %0.05  --> 0.01 to 0.08
            elseif(temp7_sec > 0.01 && temp7_sec <= 0.08)
                y7_sec = 0.3684 + (2.45602 *(x_sec-0.05))- (16.3734*((x_sec-0.05).^2)) + (181.927 * ((x_sec-0.05).^3)) - (2425.699 * ((x_sec-0.05).^4)); 
            %0.005  --> 0 to 0.01
            elseif(temp7_sec > 0 && temp7_sec <= 0.01)
                y7_sec = 0.1709 + (11.399725243 * (x_sec-0.005)) - (759.962*((x_sec-0.005).^2)) + (84442.9 * ((x_sec-0.005).^3)) - (11259061 * ((x_sec-0.005).^4));
            end
        else
            temp7_sec = ((16 + ( 7.787 * temp7_sec)) / 116 );
            y7_sec = temp7_sec;
        end
        
        if (temp8_sec > 0.008856 ) 
        x_sec = temp8_sec;
            if(temp8_sec > 0.35 && temp8_sec <= 1)
                y8_sec = 1 + (0.333333 * (x_sec-1)) - (0.111111*((x_sec-1).^2)) + (0.06172839 * ((x_sec-1).^3)) - (0.0411522 * ((x_sec-1).^4));
            %0.2  --> 0.08 to 0.35
            elseif(temp8_sec > 0.08 && temp8_sec <= 0.35)
                y8_sec = 0.5848 + (0.97466 * (x_sec-0.2))- (1.6244*((x_sec-0.2).^2)) + (4.5123 * ((x_sec-0.2).^3)) - (15.0410 * ((x_sec-0.2).^4));
            %0.05  --> 0.01 to 0.08
            elseif(temp8_sec > 0.01 && temp8_sec <= 0.08)
                y8_sec = 0.3684 + (2.45602 *(x_sec-0.05))- (16.3734*((x_sec-0.05).^2)) + (181.927 * ((x_sec-0.05).^3)) - (2425.699 * ((x_sec-0.05).^4)); 
            %0.005  --> 0 to 0.01
            elseif(temp8_sec > 0 && temp8_sec <= 0.01)
                y8_sec = 0.1709 + (11.399725243 * (x_sec-0.005)) - (759.962*((x_sec-0.005).^2)) + (84442.9 * ((x_sec-0.005).^3)) - (11259061 * ((x_sec-0.005).^4));
            end
        else
            temp8_sec = ((( 7.787 * temp8_sec)+ 16) / 116 );
            y8_sec = temp8_sec;
        end
        
        if (temp9_sec > 0.008856 )
            x_sec = temp9_sec;
            if(temp9_sec > 0.35 && temp9_sec <= 1)
                y9_sec = 1 + (0.333333 * (x_sec-1)) - (0.111111*((x_sec-1).^2)) + (0.06172839 * ((x_sec-1).^3)) - (0.0411522 * ((x_sec-1).^4));
            %0.2  --> 0.08 to 0.35
            elseif(temp9_sec > 0.08 && temp9_sec <= 0.35)
                y9_sec = 0.5848 + (0.97466 * (x_sec-0.2))- (1.6244*((x_sec-0.2).^2)) + (4.5123 * ((x_sec-0.2).^3)) - (15.0410 * ((x_sec-0.2).^4));
            %0.05  --> 0.01 to 0.08
            elseif(temp9_sec > 0.01 && temp9_sec <= 0.08)
                y9_sec = 0.3684 + (2.45602 *(x_sec-0.05))- (16.3734*((x_sec-0.05).^2)) + (181.927 * ((x_sec-0.05).^3)) - (2425.699 * ((x_sec-0.05).^4)); 
            %0.005  --> 0 to 0.01
            elseif(temp9_sec > 0 && temp9_sec <= 0.01)
                y9_sec = 0.1709 + (11.399725243 * (x_sec-0.005)) - (759.962*((x_sec-0.005).^2)) + (84442.9 * ((x_sec-0.005).^3)) - (11259061 * ((x_sec-0.005).^4));
            end
        else
            temp9_sec = ((( 7.787 * temp9_sec)+ 16) / 116 );
            y9_sec = temp9_sec;
        end
        
        CIE_L_y_sec(i,j) = ( 116 * y8_sec) - 16;
        CIE_a_y_sec(i,j) = 500 * ( y7_sec - y8_sec);
        CIE_b_y_sec(i,j) = 200 * ( y8_sec - y9_sec);
end
end

LAB(:,:,1) = CIE_L_y_sec;
LAB(:,:,2) = CIE_a_y_sec;
LAB(:,:,3) = CIE_b_y_sec;
cov = LAB;

%store CIE_a in a block ram for k-means
CIE_a  = double(cov(:,:,2));
nrows = size(CIE_a,1);
ncols = size(CIE_a,2);
CIE_a = reshape(CIE_a,nrows*ncols,1);
nColors = 2;

%threashold results in a block ram
for i=1:n(1,1)
    for j=1:n(1,2)
        if( (cov(i,j,3) <= 6) || (I(i,j,1)< 50 && I(i,j,2)< 50 && I(i,j,3)< 50) )
              final_threshold(i,j) = 0;
        else
              final_threshold(i,j) = 1;
        end
    end
end


%save color bins of CIE_a and CIE_b in a block ram
L = LAB(:,:,1);
a = LAB(:,:,2);
b = LAB(:,:,3);
for i=1:n(1,1)
    for j=1:n(1,2)
        if(a(i,j) <= -32.0166228)
             abin_number(i,j) = 1;
            %a(i,j) = -32.0166228;
        elseif(a(i,j) <= -27.15591882)	
            abin_number(i,j) = 2;
            %a(i,j) = -27.15591882;
        elseif(a(i,j) <= -22.29521484)	
            abin_number(i,j) = 3;
            %a(i,j) = -22.29521484;
        elseif(a(i,j) <= -17.43451086)
            abin_number(i,j) = 4;
            %a(i,j) = -17.4345108;
        elseif(a(i,j) <= -12.57380687)	
            abin_number(i,j) = 5;
            %a(i,j) = -12.57380687;
        elseif(a(i,j) <= -7.713102891)
            abin_number(i,j) = 6;
            %a(i,j) = -7.713102891;
        elseif(a(i,j) <= -2.852398908)
            abin_number(i,j) = 7;
            %a(i,j) = -2.852398908;
        elseif(a(i,j) <= 2.008305074)	
            abin_number(i,j) = 8;
            %a(i,j) = 2.008305074;
        elseif(a(i,j) <= 6.869009057)	
            abin_number(i,j) = 9;
            %a(i,j) = 6.869009057;
        elseif(a(i,j) <= 11.72971304)	
            abin_number(i,j) = 10;
            %a(i,j)  = 11.72971304;
        elseif(a(i,j) <= 16.59041702)	
            abin_number(i,j) = 11;
            %a(i,j)  = 16.59041702;
        elseif(a(i,j) <= 21.451121)
            abin_number(i,j) = 12;
            %a(i,j)  = 21.451121;
        elseif(a(i,j) <= 26.31182499)
            abin_number(i,j) = 13;
            %a(i,j)  = 26.31182499;
        end
    end
end


for i=1:n(1,1)
    for j=1:n(1,2)
        if(b(i,j) <= -24.88760366)
            bbin_number(i,j) = 1;
            %b(i,j) = -24.88760366;
        elseif(b(i,j) <= -15.99008883)	
            bbin_number(i,j) = 2;
            %b(i,j) = -15.99008883;
        elseif(b(i,j) <= -7.092574008)	
            bbin_number(i,j) = 3;
            %b(i,j) = -7.092574008;
        elseif(b(i,j) <= 1.804940815)
            bbin_number(i,j) = 4;
            %b(i,j) = 1.804940815;
        elseif(b(i,j) <= 10.70245564)	
            bbin_number(i,j) = 5;
            %b(i,j) = 10.70245564;
        elseif(b(i,j) <= 19.59997046)
            bbin_number(i,j) = 6;
            %b(i,j) = 19.59997046;
        elseif(b(i,j) <= 28.49748529)
            bbin_number(i,j) = 7;
            %b(i,j) = 28.49748529;
        elseif(b(i,j) <= 37.39500011)	
            bbin_number(i,j) = 8;
            %b(i,j) = 37.39500011;
        elseif(b(i,j) <= 46.29251493)	
            bbin_number(i,j) = 9;
            %b(i,j) = 46.29251493;
        elseif(b(i,j) <= 55.19002976)	
            bbin_number(i,j) = 10;
            %b(i,j)  = 55.19002976;
        elseif(b(i,j) <= 64.08754458)	
            bbin_number(i,j) = 11;
            %b(i,j)  = 64.08754458;
        elseif(b(i,j) <= 72.9850594)
            bbin_number(i,j) = 12;
            %b(i,j)  = 72.9850594;
        elseif(b(i,j) <= 81.88257423)
            bbin_number(i,j) = 13;
            %b(i,j)  = 81.88257423;
        end
    end
end

%save 3 bits of LAB in a block ram
for i=1:n(1,1)
    for j=1:n(1,2)
        if(L(i,j) > 0)
            L(i,j) = 1;
        else
            L(i,j) = 0;
        end
        
        if(a(i,j) > 0)
            a(i,j) = 1;
        else
            a(i,j) = 0;
        end
        
        if(b(i,j) > 0)
            b(i,j) = 1;
        else
            b(i,j) = 0;
        end
    end
end



%step 2 k-means
[cluster_idx, cluster_center] = kmeans(CIE_a,nColors,'distance','sqEuclidean','Replicates',5);
pixel_labels = reshape(cluster_idx,nrows,ncols);
for i=1:n(1,1)
for j=1:n(1,2)
    if(pixel_labels(i,j)==1)
        m1(i,j)=1;
        m2(i,j)=0;
    else
        m2(i,j)=1;
        m1(i,j)=0;
    end
end
end
%seg1(:,:,1)=immultiply(cov(:,:,1),m1);
seg1 = immultiply(cov(:,:,2),m1);
%seg1(:,:,3)=immultiply(cov(:,:,3),m1);
%rgb_seg1(:,:,1)=immultiply(img(:,:,1),uint8(m1));
%rgb_seg1 =immultiply(img(:,:,2),uint8(m1));
%rgb_seg1(:,:,3)=immultiply(img(:,:,3),uint8(m1));

%seg2(:,:,1)=immultiply(cov(:,:,1),m2);
seg2 = immultiply(cov(:,:,2),m2);
%seg2(:,:,3)=immultiply(cov(:,:,3),m2);
%rgb_seg2(:,:,1)=immultiply(img(:,:,1),uint8(m2));
%rgb_seg2(:,:,2)=immultiply(img(:,:,2),uint8(m2));
%rgb_seg2(:,:,3)=immultiply(img(:,:,3),uint8(m2));
 
tot_s2=0;
tot_s1=0;

for i=1:n(1,1)
    for j=1:n(1,2)
        if(seg2(i,j) <=-10)
            tot_s2=tot_s2+1;
        end
        if(seg1(i,j) <=-10)
            tot_s1=tot_s1+1;
        end
    end
end

if(tot_s1<tot_s2)
    cluster_id = m1;
else
    cluster_id = m2;
end

newlab = cov;
for i=1:n(1,1)
    for j=1:n(1,2)
        if(cluster_id(i,j) == 0)
            newlab(i,j,1) =0;
            newlab(i,j,2) =0;
            newlab(i,j,3) =0; 
            L(i,j) =0;
            a(i,j) =0;
            b(i,j) =0;
            abin_number(i,j) = 8;
            bbin_number(i,j) = 4;
        elseif(final_threshold(i,j) == 0 && cluster_id(i,j) == 1)
            newlab(i,j,1) =0;
            newlab(i,j,2) =0;
            newlab(i,j,3) =0;
            L(i,j) =0;
            a(i,j) =0;
            b(i,j) =0;
            abin_number(i,j) = 8;
            bbin_number(i,j) = 4;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%k-means end, step 2 end %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%step 3, feature extract%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a_bin1_v=0; a_bin2_v=0; a_bin3_v=0; a_bin4_v=0; a_bin5_v=0; a_bin6_v=0; 
a_bin7_v = 0; a_bin8_v=0; a_bin9_v=0; a_bin10_v=0; a_bin11_v=0; a_bin12_v=0; a_bin13_v=0;
b_bin1_v=0; b_bin2_v=0; b_bin3_v=0; b_bin4_v=0; b_bin5_v=0; b_bin6_v=0; 
b_bin7_v=0; b_bin8_v=0; b_bin9_v=0; b_bin10_v=0; b_bin11_v=0; b_bin12_v=0; b_bin13_v=0;

abin_number_vec = (reshape(abin_number',1,[])');
bbin_number_vec = (reshape(bbin_number',1,[])');
lab_vec = [num2str(reshape(L',1,[])'), num2str(reshape(a',1,[])'), num2str(reshape(b',1,[])')];

for i=1:n(1,1)*n(1,2)
    if(abin_number_vec(i) == 1)
            a_bin1_v = a_bin1_v + 1;
    elseif(abin_number_vec(i) == 2)
            a_bin2_v = a_bin2_v + 1;
    elseif(abin_number_vec(i) == 3)
            a_bin3_v = a_bin3_v + 1;
    elseif(abin_number_vec(i) == 4)
            a_bin4_v = a_bin4_v + 1;
    elseif(abin_number_vec(i) == 5)	
            a_bin5_v = a_bin5_v + 1;
    elseif(abin_number_vec(i) == 6)
            a_bin6_v = a_bin6_v + 1;
    elseif(abin_number_vec(i) == 7)
            a_bin7_v = a_bin7_v + 1;
    elseif(abin_number_vec(i) == 8)	
            a_bin8_v = a_bin8_v + 1;
    elseif(abin_number_vec(i) == 9)	
            a_bin9_v = a_bin9_v + 1;
    elseif(abin_number_vec(i) == 10)	
            a_bin10_v = a_bin10_v + 1;
    elseif(abin_number_vec(i) == 11)	
            a_bin11_v = a_bin11_v + 1;
    elseif(abin_number_vec(i) == 12)
            a_bin12_v = a_bin12_v + 1;
    elseif(abin_number_vec(i) == 13)
            a_bin13_v = a_bin13_v + 1;
    end
    
    if(bbin_number_vec(i) == 1)
            b_bin1_v = b_bin1_v + 1;
    elseif(bbin_number_vec(i) == 2)
            b_bin2_v = b_bin2_v + 1;
    elseif(bbin_number_vec(i) == 3)
            b_bin3_v = b_bin3_v + 1;
    elseif(bbin_number_vec(i) == 4)
            b_bin4_v = b_bin4_v + 1;
    elseif(bbin_number_vec(i) == 5)	
            b_bin5_v = b_bin5_v + 1;
    elseif(bbin_number_vec(i) == 6)
            b_bin6_v = b_bin6_v + 1;
    elseif(bbin_number_vec(i) == 7)
            b_bin7_v = b_bin7_v + 1;
    elseif(bbin_number_vec(i) == 8)	
            b_bin8_v = b_bin8_v + 1;
    elseif(bbin_number_vec(i) == 9)	
            b_bin9_v = b_bin9_v + 1;
    elseif(bbin_number_vec(i) == 10)	
            b_bin10_v = b_bin10_v + 1;
    elseif(bbin_number_vec(i) == 11)	
            b_bin11_v = b_bin11_v + 1;
    elseif(bbin_number_vec(i) == 12)
            b_bin12_v = b_bin12_v + 1;
    elseif(bbin_number_vec(i) == 13)
            b_bin13_v = b_bin13_v + 1;
    end
end
a_bin_v = [a_bin1_v a_bin2_v a_bin3_v a_bin4_v a_bin5_v a_bin6_v a_bin7_v a_bin8_v a_bin9_v a_bin10_v a_bin11_v a_bin12_v a_bin13_v];
b_bin_v = [b_bin1_v b_bin2_v b_bin3_v b_bin4_v b_bin5_v b_bin6_v b_bin7_v b_bin8_v b_bin9_v b_bin10_v b_bin11_v b_bin12_v b_bin13_v];

a_bin_norm = a_bin_v/ sqrt(sum(a_bin_v.^2));
b_bin_norm = b_bin_v/ sqrt(sum(b_bin_v.^2));
L_bin_norm = ones([1,13]);

Lab_bins_norm = [L_bin_norm a_bin_norm b_bin_norm];

n = size(L);
pattern_0_count  = 0; pattern_62_count  = 0; pattern_207_count = 0;                        
pattern_1_count  = 0; pattern_63_count  = 0; pattern_199_count = 0;
pattern_2_count  = 0; pattern_64_count  = 0; pattern_223_count = 0; 
pattern_3_count  = 0; pattern_96_count  = 0; pattern_224_count = 0; 
pattern_4_count  = 0; pattern_112_count = 0; pattern_225_count = 0; 
pattern_6_count  = 0; pattern_120_count = 0; pattern_227_count = 0; 
pattern_7_count  = 0; pattern_124_count = 0; pattern_231_count = 0; 
pattern_8_count  = 0; pattern_126_count = 0; pattern_239_count = 0; 
pattern_12_count = 0; pattern_127_count = 0; pattern_240_count = 0; 
pattern_14_count = 0; pattern_128_count = 0; pattern_241_count = 0; 
pattern_15_count = 0; pattern_129_count = 0; pattern_243_count = 0; 
pattern_16_count = 0; pattern_131_count = 0; pattern_247_count = 0; 
pattern_24_count = 0; pattern_135_count = 0; pattern_248_count = 0; 
pattern_28_count = 0; pattern_143_count = 0; pattern_249_count = 0; 
pattern_30_count = 0; pattern_159_count = 0; pattern_251_count = 0; 
pattern_31_count = 0; pattern_191_count = 0; pattern_252_count = 0; 
pattern_32_count = 0; pattern_192_count = 0; pattern_253_count = 0; 
pattern_48_count = 0; pattern_193_count = 0; pattern_254_count = 0; 
pattern_56_count = 0; pattern_195_count = 0; pattern_255_count = 0;
pattern_60_count = 0;  
pattern_non_uniform_count = 0;



for i=6:n(1,1)-5
    for j=6:n(1,2)-5
       g0_L = L(i,j+5);
       g1_L = L(i-4,j+4);
       g2_L = L(i-5,j);
       g3_L = L(i-4,j-4);
       g4_L = L(i  ,j-5);
       g5_L = L(i+4,j-4);
       g6_L = L(i+5,j);
       g7_L = L(i+4,j+4);
       gc_L = L(i,j);
       
       if(g0_L >= gc_L) g0_L = 1; else g0_L = 0; end
       if(g1_L >= gc_L) g1_L = 1; else g1_L = 0; end
       if(g2_L >= gc_L) g2_L = 1; else g2_L = 0; end
       if(g3_L >= gc_L) g3_L = 1; else g3_L = 0; end
       if(g4_L >= gc_L) g4_L = 1; else g4_L = 0; end
       if(g5_L >= gc_L) g5_L = 1; else g5_L = 0; end
       if(g6_L >= gc_L) g6_L = 1; else g6_L = 0; end
       if(g7_L >= gc_L) g7_L = 1; else g7_L = 0; end
       pattern_L = [g7_L g6_L g5_L g4_L g3_L g2_L g1_L g0_L];

if(pattern_L == [0 0 0 0 0 0 0 0]) pattern_0_count       = pattern_0_count   + 1;
elseif(pattern_L == [0 0 0 0 0 0 0 1]) pattern_1_count   = pattern_1_count   + 1;
elseif(pattern_L == [0 0 0 0 0 0 1 0]) pattern_2_count   = pattern_2_count   + 1;
elseif(pattern_L == [0 0 0 0 0 0 1 1]) pattern_3_count   = pattern_3_count   + 1;
elseif(pattern_L == [0 0 0 0 0 1 0 0]) pattern_4_count   = pattern_4_count   + 1;
elseif(pattern_L == [0 0 0 0 0 1 1 0]) pattern_6_count   = pattern_6_count   + 1;
elseif(pattern_L == [0 0 0 0 0 1 1 1]) pattern_7_count   = pattern_7_count   + 1;
elseif(pattern_L == [0 0 0 0 1 0 0 0]) pattern_8_count   = pattern_8_count   + 1;
elseif(pattern_L == [0 0 0 0 1 1 0 0]) pattern_12_count  = pattern_12_count  + 1;
elseif(pattern_L == [0 0 0 0 1 1 1 0]) pattern_14_count  = pattern_14_count  + 1;
elseif(pattern_L == [0 0 0 0 1 1 1 1]) pattern_15_count  = pattern_15_count  + 1;
elseif(pattern_L == [0 0 0 1 0 0 0 0]) pattern_16_count  = pattern_16_count  + 1;
elseif(pattern_L == [0 0 0 1 1 0 0 0]) pattern_24_count  = pattern_24_count  + 1;
elseif(pattern_L == [0 0 0 1 1 1 0 0]) pattern_28_count  = pattern_28_count  + 1;
elseif(pattern_L == [0 0 0 1 1 1 1 0]) pattern_30_count  = pattern_30_count  + 1;
elseif(pattern_L == [0 0 0 1 1 1 1 1]) pattern_31_count  = pattern_31_count  + 1;
elseif(pattern_L == [0 0 1 0 0 0 0 0]) pattern_32_count  = pattern_32_count  + 1;
elseif(pattern_L == [0 0 1 1 0 0 0 0]) pattern_48_count  = pattern_48_count  + 1;
elseif(pattern_L == [0 0 1 1 1 0 0 0]) pattern_56_count  = pattern_56_count  + 1;
elseif(pattern_L == [0 0 1 1 1 1 0 0]) pattern_60_count  = pattern_60_count  + 1;
elseif(pattern_L == [0 0 1 1 1 1 1 0]) pattern_62_count  = pattern_62_count  + 1;
elseif(pattern_L == [0 0 1 1 1 1 1 1]) pattern_63_count  = pattern_63_count  + 1;
elseif(pattern_L == [0 1 0 0 0 0 0 0]) pattern_64_count  = pattern_64_count  + 1;
elseif(pattern_L == [0 1 1 0 0 0 0 0]) pattern_96_count  = pattern_96_count  + 1;
elseif(pattern_L == [0 1 1 1 0 0 0 0]) pattern_112_count = pattern_112_count + 1;
elseif(pattern_L == [0 1 1 1 1 0 0 0]) pattern_120_count = pattern_120_count + 1;
elseif(pattern_L == [0 1 1 1 1 1 0 0]) pattern_124_count = pattern_124_count + 1;
elseif(pattern_L == [0 1 1 1 1 1 1 0]) pattern_126_count = pattern_126_count + 1;
elseif(pattern_L == [0 1 1 1 1 1 1 1]) pattern_127_count = pattern_127_count + 1;
elseif(pattern_L == [1 0 0 0 0 0 0 0]) pattern_128_count = pattern_128_count + 1;
elseif(pattern_L == [0 0 0 0 0 0 0 1]) pattern_129_count = pattern_129_count + 1;
elseif(pattern_L == [1 0 0 0 0 0 1 1]) pattern_131_count = pattern_131_count + 1;
elseif(pattern_L == [1 0 0 0 0 1 1 1]) pattern_135_count = pattern_135_count + 1;
elseif(pattern_L == [1 0 0 0 1 1 1 1]) pattern_143_count = pattern_143_count + 1;
elseif(pattern_L == [1 0 0 1 1 1 1 1]) pattern_159_count = pattern_159_count + 1;
elseif(pattern_L == [1 0 1 1 1 1 1 1]) pattern_191_count = pattern_191_count + 1;
elseif(pattern_L == [1 1 0 0 0 0 0 0]) pattern_192_count = pattern_192_count + 1;
elseif(pattern_L == [1 1 0 0 0 0 0 1]) pattern_193_count = pattern_193_count + 1;
elseif(pattern_L == [1 1 0 0 0 0 1 1]) pattern_195_count = pattern_195_count + 1;
elseif(pattern_L == [1 1 0 0 0 1 1 1]) pattern_199_count = pattern_199_count + 1;
elseif(pattern_L == [1 1 0 0 1 1 1 1]) pattern_207_count = pattern_207_count + 1;
elseif(pattern_L == [1 1 0 1 1 1 1 1]) pattern_223_count = pattern_223_count + 1;
elseif(pattern_L == [1 1 1 0 0 0 0 0]) pattern_224_count = pattern_224_count + 1;
elseif(pattern_L == [1 1 1 0 0 0 0 1]) pattern_225_count = pattern_225_count + 1;
elseif(pattern_L == [1 1 1 0 0 0 1 1]) pattern_227_count = pattern_227_count + 1;
elseif(pattern_L == [1 1 1 0 0 1 1 1]) pattern_231_count = pattern_231_count + 1;
elseif(pattern_L == [1 1 1 0 1 1 1 1]) pattern_239_count = pattern_239_count + 1;
elseif(pattern_L == [1 1 1 1 0 0 0 0]) pattern_240_count = pattern_240_count + 1;
elseif(pattern_L == [1 1 1 1 0 0 0 1]) pattern_241_count = pattern_241_count + 1;
elseif(pattern_L == [1 1 1 1 0 0 1 1]) pattern_243_count = pattern_243_count + 1;
elseif(pattern_L == [1 1 1 1 0 1 1 1]) pattern_247_count = pattern_247_count + 1;
elseif(pattern_L == [1 1 1 1 1 0 0 0]) pattern_248_count = pattern_248_count + 1;
elseif(pattern_L == [1 1 1 1 1 0 0 1]) pattern_249_count = pattern_249_count + 1;
elseif(pattern_L == [1 1 1 1 1 0 1 1]) pattern_251_count = pattern_251_count + 1;
elseif(pattern_L == [1 1 1 1 1 1 0 0]) pattern_252_count = pattern_252_count + 1;
elseif(pattern_L == [1 1 1 1 1 1 0 1]) pattern_253_count = pattern_253_count + 1;
elseif(pattern_L == [1 1 1 1 1 1 1 0]) pattern_254_count = pattern_254_count + 1;
elseif(pattern_L == [1 1 1 1 1 1 1 1]) pattern_255_count = pattern_255_count + 1;
else pattern_non_uniform_count = pattern_non_uniform_count + 1;
end
end
end


Data_L = [pattern_0_count pattern_1_count pattern_2_count pattern_3_count pattern_4_count pattern_6_count ...  
pattern_7_count  pattern_8_count  pattern_12_count pattern_14_count pattern_15_count pattern_16_count ...
pattern_24_count pattern_28_count pattern_30_count pattern_31_count pattern_32_count pattern_48_count ...
pattern_56_count pattern_60_count pattern_62_count pattern_63_count pattern_64_count pattern_96_count ...
pattern_112_count pattern_120_count pattern_124_count pattern_126_count pattern_127_count ...
pattern_128_count pattern_129_count pattern_131_count pattern_135_count pattern_143_count ...
pattern_159_count pattern_191_count pattern_192_count pattern_193_count pattern_195_count ...
pattern_199_count pattern_207_count pattern_223_count pattern_224_count pattern_225_count ...
pattern_227_count pattern_231_count pattern_239_count pattern_240_count pattern_241_count ...
pattern_243_count pattern_247_count pattern_248_count pattern_249_count pattern_251_count ...
pattern_252_count pattern_253_count pattern_254_count pattern_255_count pattern_non_uniform_count];

Data_L_norm = Data_L/sqrt(sum(Data_L.^2));
%{
L_LBP = extractLBPFeatures(L,'radius',5,'Normalization','None','numNeighbors',8);
L_LBP_nrom = L_LBP/norm(L_LBP);
Final_data = [Data;L_LBP_nrom];
figure
hold on
stem(Data(1:57),'-g','filled');
stem(L_LBP_nrom(1:57),'-r','filled');
legend('Custom','Data','L_LBP');
hold off
%}
n = size(a);
pattern_0_count  = 0; pattern_62_count  = 0; pattern_207_count = 0;                        
pattern_1_count  = 0; pattern_63_count  = 0; pattern_199_count = 0;
pattern_2_count  = 0; pattern_64_count  = 0; pattern_223_count = 0; 
pattern_3_count  = 0; pattern_96_count  = 0; pattern_224_count = 0; 
pattern_4_count  = 0; pattern_112_count = 0; pattern_225_count = 0; 
pattern_6_count  = 0; pattern_120_count = 0; pattern_227_count = 0; 
pattern_7_count  = 0; pattern_124_count = 0; pattern_231_count = 0; 
pattern_8_count  = 0; pattern_126_count = 0; pattern_239_count = 0; 
pattern_12_count = 0; pattern_127_count = 0; pattern_240_count = 0; 
pattern_14_count = 0; pattern_128_count = 0; pattern_241_count = 0; 
pattern_15_count = 0; pattern_129_count = 0; pattern_243_count = 0; 
pattern_16_count = 0; pattern_131_count = 0; pattern_247_count = 0; 
pattern_24_count = 0; pattern_135_count = 0; pattern_248_count = 0; 
pattern_28_count = 0; pattern_143_count = 0; pattern_249_count = 0; 
pattern_30_count = 0; pattern_159_count = 0; pattern_251_count = 0; 
pattern_31_count = 0; pattern_191_count = 0; pattern_252_count = 0; 
pattern_32_count = 0; pattern_192_count = 0; pattern_253_count = 0; 
pattern_48_count = 0; pattern_193_count = 0; pattern_254_count = 0; 
pattern_56_count = 0; pattern_195_count = 0; pattern_255_count = 0;
pattern_60_count = 0;  
pattern_non_uniform_count = 0;


for i=6:n(1,1)-5
    for j=6:n(1,2)-5
       g0_a = a(i,j+5);
       g1_a = a(i-4,j+4);
       g2_a = a(i-5,j);
       g3_a = a(i-4,j-4);
       g4_a = a(i  ,j-5);
       g5_a = a(i+4,j-4);
       g6_a = a(i+5,j);
       g7_a = a(i+4,j+4);
       gc_a = a(i,j);
       
       if(g0_a >= gc_a) g0_a = 1; else g0_a = 0; end
       if(g1_a >= gc_a) g1_a = 1; else g1_a = 0; end
       if(g2_a >= gc_a) g2_a = 1; else g2_a = 0; end
       if(g3_a >= gc_a) g3_a = 1; else g3_a = 0; end
       if(g4_a >= gc_a) g4_a = 1; else g4_a = 0; end
       if(g5_a >= gc_a) g5_a = 1; else g5_a = 0; end
       if(g6_a >= gc_a) g6_a = 1; else g6_a = 0; end
       if(g7_a >= gc_a) g7_a = 1; else g7_a = 0; end
       pattern_a = [g7_a g6_a g5_a g4_a g3_a g2_a g1_a g0_a];

if(pattern_a == [0 0 0 0 0 0 0 0]) pattern_0_count   = pattern_0_count   + 1;
elseif(pattern_a == [0 0 0 0 0 0 0 1]) pattern_1_count   = pattern_1_count   + 1;
elseif(pattern_a == [0 0 0 0 0 0 1 0]) pattern_2_count   = pattern_2_count   + 1;
elseif(pattern_a == [0 0 0 0 0 0 1 1]) pattern_3_count   = pattern_3_count   + 1;
elseif(pattern_a == [0 0 0 0 0 1 0 0]) pattern_4_count   = pattern_4_count   + 1;
elseif(pattern_a == [0 0 0 0 0 1 1 0]) pattern_6_count   = pattern_6_count   + 1;
elseif(pattern_a == [0 0 0 0 0 1 1 1]) pattern_7_count   = pattern_7_count   + 1;
elseif(pattern_a == [0 0 0 0 1 0 0 0]) pattern_8_count   = pattern_8_count   + 1;
elseif(pattern_a == [0 0 0 0 1 1 0 0]) pattern_12_count  = pattern_12_count  + 1;
elseif(pattern_a == [0 0 0 0 1 1 1 0]) pattern_14_count  = pattern_14_count  + 1;
elseif(pattern_a == [0 0 0 0 1 1 1 1]) pattern_15_count  = pattern_15_count  + 1;
elseif(pattern_a == [0 0 0 1 0 0 0 0]) pattern_16_count  = pattern_16_count  + 1;
elseif(pattern_a == [0 0 0 1 1 0 0 0]) pattern_24_count  = pattern_24_count  + 1;
elseif(pattern_a == [0 0 0 1 1 1 0 0]) pattern_28_count  = pattern_28_count  + 1;
elseif(pattern_a == [0 0 0 1 1 1 1 0]) pattern_30_count  = pattern_30_count  + 1;
elseif(pattern_a == [0 0 0 1 1 1 1 1]) pattern_31_count  = pattern_31_count  + 1;
elseif(pattern_a == [0 0 1 0 0 0 0 0]) pattern_32_count  = pattern_32_count  + 1;
elseif(pattern_a == [0 0 1 1 0 0 0 0]) pattern_48_count  = pattern_48_count  + 1;
elseif(pattern_a == [0 0 1 1 1 0 0 0]) pattern_56_count  = pattern_56_count  + 1;
elseif(pattern_a == [0 0 1 1 1 1 0 0]) pattern_60_count  = pattern_60_count  + 1;
elseif(pattern_a == [0 0 1 1 1 1 1 0]) pattern_62_count  = pattern_62_count  + 1;
elseif(pattern_a == [0 0 1 1 1 1 1 1]) pattern_63_count  = pattern_63_count  + 1;
elseif(pattern_a == [0 1 0 0 0 0 0 0]) pattern_64_count  = pattern_64_count  + 1;
elseif(pattern_a == [0 1 1 0 0 0 0 0]) pattern_96_count  = pattern_96_count  + 1;
elseif(pattern_a == [0 1 1 1 0 0 0 0]) pattern_112_count = pattern_112_count + 1;
elseif(pattern_a == [0 1 1 1 1 0 0 0]) pattern_120_count = pattern_120_count + 1;
elseif(pattern_a == [0 1 1 1 1 1 0 0]) pattern_124_count = pattern_124_count + 1;
elseif(pattern_a == [0 1 1 1 1 1 1 0]) pattern_126_count = pattern_126_count + 1;
elseif(pattern_a == [0 1 1 1 1 1 1 1]) pattern_127_count = pattern_127_count + 1;
elseif(pattern_a == [1 0 0 0 0 0 0 0]) pattern_128_count = pattern_128_count + 1;
elseif(pattern_a == [0 0 0 0 0 0 0 1]) pattern_129_count = pattern_129_count + 1;
elseif(pattern_a == [1 0 0 0 0 0 1 1]) pattern_131_count = pattern_131_count + 1;
elseif(pattern_a == [1 0 0 0 0 1 1 1]) pattern_135_count = pattern_135_count + 1;
elseif(pattern_a == [1 0 0 0 1 1 1 1]) pattern_143_count = pattern_143_count + 1;
elseif(pattern_a == [1 0 0 1 1 1 1 1]) pattern_159_count = pattern_159_count + 1;
elseif(pattern_a == [1 0 1 1 1 1 1 1]) pattern_191_count = pattern_191_count + 1;
elseif(pattern_a == [1 1 0 0 0 0 0 0]) pattern_192_count = pattern_192_count + 1;
elseif(pattern_a == [1 1 0 0 0 0 0 1]) pattern_193_count = pattern_193_count + 1;
elseif(pattern_a == [1 1 0 0 0 0 1 1]) pattern_195_count = pattern_195_count + 1;
elseif(pattern_a == [1 1 0 0 0 1 1 1]) pattern_199_count = pattern_199_count + 1;
elseif(pattern_a == [1 1 0 0 1 1 1 1]) pattern_207_count = pattern_207_count + 1;
elseif(pattern_a == [1 1 0 1 1 1 1 1]) pattern_223_count = pattern_223_count + 1;
elseif(pattern_a == [1 1 1 0 0 0 0 0]) pattern_224_count = pattern_224_count + 1;
elseif(pattern_a == [1 1 1 0 0 0 0 1]) pattern_225_count = pattern_225_count + 1;
elseif(pattern_a == [1 1 1 0 0 0 1 1]) pattern_227_count = pattern_227_count + 1;
elseif(pattern_a == [1 1 1 0 0 1 1 1]) pattern_231_count = pattern_231_count + 1;
elseif(pattern_a == [1 1 1 0 1 1 1 1]) pattern_239_count = pattern_239_count + 1;
elseif(pattern_a == [1 1 1 1 0 0 0 0]) pattern_240_count = pattern_240_count + 1;
elseif(pattern_a == [1 1 1 1 0 0 0 1]) pattern_241_count = pattern_241_count + 1;
elseif(pattern_a == [1 1 1 1 0 0 1 1]) pattern_243_count = pattern_243_count + 1;
elseif(pattern_a == [1 1 1 1 0 1 1 1]) pattern_247_count = pattern_247_count + 1;
elseif(pattern_a == [1 1 1 1 1 0 0 0]) pattern_248_count = pattern_248_count + 1;
elseif(pattern_a == [1 1 1 1 1 0 0 1]) pattern_249_count = pattern_249_count + 1;
elseif(pattern_a == [1 1 1 1 1 0 1 1]) pattern_251_count = pattern_251_count + 1;
elseif(pattern_a == [1 1 1 1 1 1 0 0]) pattern_252_count = pattern_252_count + 1;
elseif(pattern_a == [1 1 1 1 1 1 0 1]) pattern_253_count = pattern_253_count + 1;
elseif(pattern_a == [1 1 1 1 1 1 1 0]) pattern_254_count = pattern_254_count + 1;
elseif(pattern_a == [1 1 1 1 1 1 1 1]) pattern_255_count = pattern_255_count + 1;
else pattern_non_uniform_count = pattern_non_uniform_count + 1;
end
end
end


Data_a = [pattern_0_count pattern_1_count pattern_2_count pattern_3_count pattern_4_count pattern_6_count ...  
pattern_7_count  pattern_8_count  pattern_12_count pattern_14_count pattern_15_count pattern_16_count ...
pattern_24_count pattern_28_count pattern_30_count pattern_31_count pattern_32_count pattern_48_count ...
pattern_56_count pattern_60_count pattern_62_count pattern_63_count pattern_64_count pattern_96_count ...
pattern_112_count pattern_120_count pattern_124_count pattern_126_count pattern_127_count ...
pattern_128_count pattern_129_count pattern_131_count pattern_135_count pattern_143_count ...
pattern_159_count pattern_191_count pattern_192_count pattern_193_count pattern_195_count ...
pattern_199_count pattern_207_count pattern_223_count pattern_224_count pattern_225_count ...
pattern_227_count pattern_231_count pattern_239_count pattern_240_count pattern_241_count ...
pattern_243_count pattern_247_count pattern_248_count pattern_249_count pattern_251_count ...
pattern_252_count pattern_253_count pattern_254_count pattern_255_count pattern_non_uniform_count];

Data_a_norm = Data_a/sqrt(sum(Data_a.^2));


n = size(b);
pattern_0_count  = 0; pattern_62_count  = 0; pattern_207_count = 0;                        
pattern_1_count  = 0; pattern_63_count  = 0; pattern_199_count = 0;
pattern_2_count  = 0; pattern_64_count  = 0; pattern_223_count = 0; 
pattern_3_count  = 0; pattern_96_count  = 0; pattern_224_count = 0; 
pattern_4_count  = 0; pattern_112_count = 0; pattern_225_count = 0; 
pattern_6_count  = 0; pattern_120_count = 0; pattern_227_count = 0; 
pattern_7_count  = 0; pattern_124_count = 0; pattern_231_count = 0; 
pattern_8_count  = 0; pattern_126_count = 0; pattern_239_count = 0; 
pattern_12_count = 0; pattern_127_count = 0; pattern_240_count = 0; 
pattern_14_count = 0; pattern_128_count = 0; pattern_241_count = 0; 
pattern_15_count = 0; pattern_129_count = 0; pattern_243_count = 0; 
pattern_16_count = 0; pattern_131_count = 0; pattern_247_count = 0; 
pattern_24_count = 0; pattern_135_count = 0; pattern_248_count = 0; 
pattern_28_count = 0; pattern_143_count = 0; pattern_249_count = 0; 
pattern_30_count = 0; pattern_159_count = 0; pattern_251_count = 0; 
pattern_31_count = 0; pattern_191_count = 0; pattern_252_count = 0; 
pattern_32_count = 0; pattern_192_count = 0; pattern_253_count = 0; 
pattern_48_count = 0; pattern_193_count = 0; pattern_254_count = 0; 
pattern_56_count = 0; pattern_195_count = 0; pattern_255_count = 0;
pattern_60_count = 0;  
pattern_non_uniform_count = 0;


for i=6:n(1,1)-5
    for j=6:n(1,2)-5
       g0_b = b(i,j+5);
       g1_b = b(i-4,j+4);
       g2_b = b(i-5,j);
       g3_b = b(i-4,j-4);
       g4_b = b(i  ,j-5);
       g5_b = b(i+4,j-4);
       g6_b = b(i+5,j);
       g7_b = b(i+4,j+4);
       gc_b = b(i,j);
       
       if(g0_b >= gc_b) g0_b = 1; else g0_b = 0; end
       if(g1_b >= gc_b) g1_b = 1; else g1_b = 0; end
       if(g2_b >= gc_b) g2_b = 1; else g2_b = 0; end
       if(g3_b >= gc_b) g3_b = 1; else g3_b = 0; end
       if(g4_b >= gc_b) g4_b = 1; else g4_b = 0; end
       if(g5_b >= gc_b) g5_b = 1; else g5_b = 0; end
       if(g6_b >= gc_b) g6_b = 1; else g6_b = 0; end
       if(g7_b >= gc_b) g7_b = 1; else g7_b = 0; end
       pattern_b = [g7_b g6_b g5_b g4_b g3_b g2_b g1_b g0_b];

if(pattern_b == [0 0 0 0 0 0 0 0]) pattern_0_count   = pattern_0_count   + 1;
elseif(pattern_b == [0 0 0 0 0 0 0 1]) pattern_1_count   = pattern_1_count   + 1;
elseif(pattern_b == [0 0 0 0 0 0 1 0]) pattern_2_count   = pattern_2_count   + 1;
elseif(pattern_b == [0 0 0 0 0 0 1 1]) pattern_3_count   = pattern_3_count   + 1;
elseif(pattern_b == [0 0 0 0 0 1 0 0]) pattern_4_count   = pattern_4_count   + 1;
elseif(pattern_b == [0 0 0 0 0 1 1 0]) pattern_6_count   = pattern_6_count   + 1;
elseif(pattern_b == [0 0 0 0 0 1 1 1]) pattern_7_count   = pattern_7_count   + 1;
elseif(pattern_b == [0 0 0 0 1 0 0 0]) pattern_8_count   = pattern_8_count   + 1;
elseif(pattern_b == [0 0 0 0 1 1 0 0]) pattern_12_count  = pattern_12_count  + 1;
elseif(pattern_b == [0 0 0 0 1 1 1 0]) pattern_14_count  = pattern_14_count  + 1;
elseif(pattern_b == [0 0 0 0 1 1 1 1]) pattern_15_count  = pattern_15_count  + 1;
elseif(pattern_b == [0 0 0 1 0 0 0 0]) pattern_16_count  = pattern_16_count  + 1;
elseif(pattern_b == [0 0 0 1 1 0 0 0]) pattern_24_count  = pattern_24_count  + 1;
elseif(pattern_b == [0 0 0 1 1 1 0 0]) pattern_28_count  = pattern_28_count  + 1;
elseif(pattern_b == [0 0 0 1 1 1 1 0]) pattern_30_count  = pattern_30_count  + 1;
elseif(pattern_b == [0 0 0 1 1 1 1 1]) pattern_31_count  = pattern_31_count  + 1;
elseif(pattern_b == [0 0 1 0 0 0 0 0]) pattern_32_count  = pattern_32_count  + 1;
elseif(pattern_b == [0 0 1 1 0 0 0 0]) pattern_48_count  = pattern_48_count  + 1;
elseif(pattern_b == [0 0 1 1 1 0 0 0]) pattern_56_count  = pattern_56_count  + 1;
elseif(pattern_b == [0 0 1 1 1 1 0 0]) pattern_60_count  = pattern_60_count  + 1;
elseif(pattern_b == [0 0 1 1 1 1 1 0]) pattern_62_count  = pattern_62_count  + 1;
elseif(pattern_b == [0 0 1 1 1 1 1 1]) pattern_63_count  = pattern_63_count  + 1;
elseif(pattern_b == [0 1 0 0 0 0 0 0]) pattern_64_count  = pattern_64_count  + 1;
elseif(pattern_b == [0 1 1 0 0 0 0 0]) pattern_96_count  = pattern_96_count  + 1;
elseif(pattern_b == [0 1 1 1 0 0 0 0]) pattern_112_count = pattern_112_count + 1;
elseif(pattern_b == [0 1 1 1 1 0 0 0]) pattern_120_count = pattern_120_count + 1;
elseif(pattern_b == [0 1 1 1 1 1 0 0]) pattern_124_count = pattern_124_count + 1;
elseif(pattern_b == [0 1 1 1 1 1 1 0]) pattern_126_count = pattern_126_count + 1;
elseif(pattern_b == [0 1 1 1 1 1 1 1]) pattern_127_count = pattern_127_count + 1;
elseif(pattern_b == [1 0 0 0 0 0 0 0]) pattern_128_count = pattern_128_count + 1;
elseif(pattern_b == [0 0 0 0 0 0 0 1]) pattern_129_count = pattern_129_count + 1;
elseif(pattern_b == [1 0 0 0 0 0 1 1]) pattern_131_count = pattern_131_count + 1;
elseif(pattern_b == [1 0 0 0 0 1 1 1]) pattern_135_count = pattern_135_count + 1;
elseif(pattern_b == [1 0 0 0 1 1 1 1]) pattern_143_count = pattern_143_count + 1;
elseif(pattern_b == [1 0 0 1 1 1 1 1]) pattern_159_count = pattern_159_count + 1;
elseif(pattern_b == [1 0 1 1 1 1 1 1]) pattern_191_count = pattern_191_count + 1;
elseif(pattern_b == [1 1 0 0 0 0 0 0]) pattern_192_count = pattern_192_count + 1;
elseif(pattern_b == [1 1 0 0 0 0 0 1]) pattern_193_count = pattern_193_count + 1;
elseif(pattern_b == [1 1 0 0 0 0 1 1]) pattern_195_count = pattern_195_count + 1;
elseif(pattern_b == [1 1 0 0 0 1 1 1]) pattern_199_count = pattern_199_count + 1;
elseif(pattern_b == [1 1 0 0 1 1 1 1]) pattern_207_count = pattern_207_count + 1;
elseif(pattern_b == [1 1 0 1 1 1 1 1]) pattern_223_count = pattern_223_count + 1;
elseif(pattern_b == [1 1 1 0 0 0 0 0]) pattern_224_count = pattern_224_count + 1;
elseif(pattern_b == [1 1 1 0 0 0 0 1]) pattern_225_count = pattern_225_count + 1;
elseif(pattern_b == [1 1 1 0 0 0 1 1]) pattern_227_count = pattern_227_count + 1;
elseif(pattern_b == [1 1 1 0 0 1 1 1]) pattern_231_count = pattern_231_count + 1;
elseif(pattern_b == [1 1 1 0 1 1 1 1]) pattern_239_count = pattern_239_count + 1;
elseif(pattern_b == [1 1 1 1 0 0 0 0]) pattern_240_count = pattern_240_count + 1;
elseif(pattern_b == [1 1 1 1 0 0 0 1]) pattern_241_count = pattern_241_count + 1;
elseif(pattern_b == [1 1 1 1 0 0 1 1]) pattern_243_count = pattern_243_count + 1;
elseif(pattern_b == [1 1 1 1 0 1 1 1]) pattern_247_count = pattern_247_count + 1;
elseif(pattern_b == [1 1 1 1 1 0 0 0]) pattern_248_count = pattern_248_count + 1;
elseif(pattern_b == [1 1 1 1 1 0 0 1]) pattern_249_count = pattern_249_count + 1;
elseif(pattern_b == [1 1 1 1 1 0 1 1]) pattern_251_count = pattern_251_count + 1;
elseif(pattern_b == [1 1 1 1 1 1 0 0]) pattern_252_count = pattern_252_count + 1;
elseif(pattern_b == [1 1 1 1 1 1 0 1]) pattern_253_count = pattern_253_count + 1;
elseif(pattern_b == [1 1 1 1 1 1 1 0]) pattern_254_count = pattern_254_count + 1;
elseif(pattern_b == [1 1 1 1 1 1 1 1]) pattern_255_count = pattern_255_count + 1;
else pattern_non_uniform_count = pattern_non_uniform_count + 1;
end
end
end


Data_b = [pattern_0_count pattern_1_count pattern_2_count pattern_3_count pattern_4_count pattern_6_count ...  
pattern_7_count  pattern_8_count  pattern_12_count pattern_14_count pattern_15_count pattern_16_count ...
pattern_24_count pattern_28_count pattern_30_count pattern_31_count pattern_32_count pattern_48_count ...
pattern_56_count pattern_60_count pattern_62_count pattern_63_count pattern_64_count pattern_96_count ...
pattern_112_count pattern_120_count pattern_124_count pattern_126_count pattern_127_count ...
pattern_128_count pattern_129_count pattern_131_count pattern_135_count pattern_143_count ...
pattern_159_count pattern_191_count pattern_192_count pattern_193_count pattern_195_count ...
pattern_199_count pattern_207_count pattern_223_count pattern_224_count pattern_225_count ...
pattern_227_count pattern_231_count pattern_239_count pattern_240_count pattern_241_count ...
pattern_243_count pattern_247_count pattern_248_count pattern_249_count pattern_251_count ...
pattern_252_count pattern_253_count pattern_254_count pattern_255_count pattern_non_uniform_count];

Data_b_norm = Data_b/ sqrt(sum(Data_b.^2));

Data_Lab_norm = [Data_L_norm Data_a_norm Data_b_norm Lab_bins_norm k];


features = Data_Lab_norm(:,[208 199 198 161 156 137 136 132 128 125 43 38 32 25 19 14 7]);
%clear all;
%pause(1);
end
 
 


