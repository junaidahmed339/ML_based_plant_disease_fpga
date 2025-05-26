close all
clear all
load Data_LBP_LB_Custom_FPGA;
load Data_LBP_HD_Custom_FPGA;
load Data_LBP_EB_Custom_FPGA;
Data_LBP_HD_Custom = Data_LBP_HD_Custom_FPGA(1:950,:);
Data_LBP_EB_Custom = Data_LBP_EB_Custom_FPGA(1:700,:);
Data_LBP_LB_Custom = Data_LBP_LB_Custom_FPGA(1:400,:);

%Data_L_norm 1:59
%Data_a_norm 60:118  % have some difference in LB and EB
%Data_b_norm 119:177
%Data_binary_norm 178:236  --- 237:295   
%L_bins_norm 296:308
%a_bins_norm 309:321
%b_bins_norm 322:334

for i=208:208 %length(feature_index)
figure
hold on
%j = feature_index(i);
stem(Data_LBP_HD_Custom(:,i),'-g','filled');
stem(Data_LBP_EB_Custom(:,i),'-r','filled');
stem(Data_LBP_LB_Custom(:,i),'-o','filled');
legend('custom_healthy','custom_EB','custom_LB');
title(i);
hold off
end
