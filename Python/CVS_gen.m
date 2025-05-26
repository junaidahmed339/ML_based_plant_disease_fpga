clear all;
close all;
%load Data_Earlyblight;
%load Data_healthy;
%load Data_Lateblight;

%load Data_LBP_LB_Custom;
%load Data_LBP_HA_Custom;
%load Data_LBP_EB_Custom;

load Data_LBP_LB_Custom_FPGA;
load Data_LBP_HD_Custom_FPGA;
load Data_LBP_EB_Custom_FPGA;
%{
Data_healthy = Data_healthy(150:829,:);
Data_Earlyblight = Data_Earlyblight(:,[1,19,21,23,25,141,143]);
%59,57,51,49,48,46,43,41,39,38,37,35,34,33,32,31,30,29,28,27,26,25,23,22,21,20,19,18,17,16,15,14,13,12,11]);
Data_healthy     = Data_healthy(:,[1,19,21,23,25,141,143]);
%59,57,51,49,48,46,43,41,39,38,37,35,34,33,32,31,30,29,28,27,26,25,23,22,21,20,19,18,17,16,15,14,13,12,11]);
Data_Lateblight  = Data_Lateblight(:,[1,19,21,23,25,141,143]);
%59,57,51,49,48,46,43,41,39,38,37,35,34,33,32,31,30,29,28,27,26,25,23,22,21,20,19,18,17,16,15,14,13,12,11]);



Data_LBP_HA_Custom     = Data_LBP_HA_Custom(150:829,:);
Data_Earlyblight = Data_LBP_EB_Custom(:,[1 2 6 9 10 12 13 18 24 32 37 43 60 61 63 65 71 77 94 95 ...
    106 116 122 124 127 128 131 136 142 150 155 156 160 161 165 172 173 174 175]);
    
Data_healthy     = Data_LBP_HA_Custom(:,[1 2 6 9 10 12 13 18 24 32 37 43 60 61 63 65 71 77 94 95 ...
    106 116 122 124 127 128 131 136 142 150 155 156 160 161 165 172 173 174 175]);

Data_Lateblight  = Data_LBP_LB_Custom(:,[1 2 6 9 10 12 13 18 24 32 37 43 60 61 63 65 71 77 94 95 ...
    106 116 122 124 127 128 131 136 142 150 155 156 160 161 165 172 173 174 175]);
%}

%total 17
Data_Earlyblight = Data_LBP_EB_Custom_FPGA(:,[208 199 198 161 156 137 136 132 128 125 43 38 32 25 19 14 7]);
    
Data_healthy     = Data_LBP_HD_Custom_FPGA(:,[208 199 198 161 156 137 136 132 128 125 43 38 32 25 19 14 7]);

Data_Lateblight  = Data_LBP_LB_Custom_FPGA(:,[208 199 198 161 156 137 136 132 128 125 43 38 32 25 19 14 7]);

%{
for i=1:22
figure
hold on
stem(Data_healthy(:,i),'-g','filled');
stem(Data_Earlyblight(:,i),'-r','filled');
stem(Data_Lateblight(:,i),'-o','filled');
legend('custom_healthy','custom_EB','custom_LB');
title(i);
hold off
end
%}


%{
Data_LBP_HA_Custom     = Data_LBP_HA_Custom(150:829,:);
Data_Earlyblight = Data_LBP_EB_Custom(:,[1 2 9 12 24 37 71 122 127 131]);
    
Data_healthy     = Data_LBP_HA_Custom(:,[1 2 9 12 24 37 71 122 127 131]);

Data_Lateblight  = Data_LBP_LB_Custom(:,[1 2 9 12 24 37 71 122 127 131]);
%}

%EB = 555  444/111
%HD = 650  520/130
%LB = 444  355/89
Train_Data_Earlyblight  = Data_Earlyblight(1:480,:);  %(1:550)
Train_Data_healthy      = Data_healthy(1:600,:); %(1:600)
Train_Data_Lateblight   = Data_Lateblight(1:320,:); %(1:320)

Test_Data_Earlyblight = Data_Earlyblight(481:600,:); %(551:700)
Test_Data_healthy     = Data_healthy(601:800,:); %(601:800)
Test_Data_Lateblight  = Data_Lateblight(321:400,:); %(321:400)

size_EB_train = size(Train_Data_Earlyblight);
size_HA_train = size(Train_Data_healthy);
size_LB_train = size(Train_Data_Lateblight);

csv_train_data = ....
   [Train_Data_Earlyblight,0*ones(size_EB_train(1),1);....
    Train_Data_healthy,1*ones(size_HA_train(1),1);.....
    Train_Data_Lateblight,2*ones(size_LB_train(1),1)];
csvwrite('train_file.csv',csv_train_data);

csv_train_data_bin = ....
   [Train_Data_Earlyblight, 1*ones(size_EB_train(1),1), 0*ones(size_EB_train(1),1), 0*ones(size_EB_train(1),1);....
    Train_Data_healthy,     0*ones(size_HA_train(1),1), 1*ones(size_HA_train(1),1), 0*ones(size_HA_train(1),1);.....
    Train_Data_Lateblight,  0*ones(size_LB_train(1),1), 0*ones(size_LB_train(1),1), 1*ones(size_LB_train(1),1)];
csvwrite('train_file_bin.csv',csv_train_data_bin);

size_EB_test = size(Test_Data_Earlyblight);
size_HA_test = size(Test_Data_healthy);
size_LB_test = size(Test_Data_Lateblight);

csv_test_data = ....
   [Test_Data_Earlyblight,0*ones(size_EB_test(1),1);....
    Test_Data_healthy,1*ones(size_HA_test(1),1);.....
    Test_Data_Lateblight,2*ones(size_LB_test(1),1)];
csvwrite('test_file.csv',csv_test_data);

csv_test_data_bin = ....
   [Test_Data_Earlyblight, 1*ones(size_EB_test(1),1), 0*ones(size_EB_test(1),1), 0*ones(size_EB_test(1),1);....
    Test_Data_healthy,     0*ones(size_HA_test(1),1), 1*ones(size_HA_test(1),1), 0*ones(size_HA_test(1),1);.....
    Test_Data_Lateblight,  0*ones(size_LB_test(1),1), 0*ones(size_LB_test(1),1), 1*ones(size_LB_test(1),1)];
csvwrite('test_file_bin.csv',csv_test_data_bin);
