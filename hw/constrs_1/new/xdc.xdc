#set_property IOSTANDARD LVCMOS33 [get_ports peripheral_reset]
set_property IOSTANDARD LVCMOS33 [get_ports done]
set_property IOSTANDARD LVCMOS33 [get_ports finish_lab]
set_property IOSTANDARD LVCMOS33 [get_ports done_kmeans]
set_property IOSTANDARD LVCMOS33 [get_ports done_features]
set_property IOSTANDARD LVCMOS33 [get_ports NN_done]
set_property IOSTANDARD LVCMOS33 [get_ports {EB_LB_HD[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {EB_LB_HD[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {EB_LB_HD[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports debug_lab_state[0]]
#set_property IOSTANDARD LVCMOS33 [get_ports debug_lab_state[1]]
#set_property IOSTANDARD LVCMOS33 [get_ports debug_lab_state[2]]
#set_property IOSTANDARD LVCMOS33 [get_ports debug_lab_state[3]]

set_property PACKAGE_PIN T22 [get_ports done]
set_property PACKAGE_PIN T21 [get_ports finish_lab]
set_property PACKAGE_PIN U22 [get_ports done_kmeans]
set_property PACKAGE_PIN U21 [get_ports done_features]
set_property PACKAGE_PIN V22 [get_ports NN_done]
set_property PACKAGE_PIN W22 [get_ports {EB_LB_HD[0]}]
set_property PACKAGE_PIN U19 [get_ports {EB_LB_HD[1]}]
set_property PACKAGE_PIN U14 [get_ports {EB_LB_HD[2]}]

#set_property PACKAGE_PIN T22 [get_ports {LD0}];  # "LD0"
#set_property PACKAGE_PIN T21 [get_ports {LD1}];  # "LD1"
#set_property PACKAGE_PIN U22 [get_ports {LD2}];  # "LD2"
#set_property PACKAGE_PIN U21 [get_ports {LD3}];  # "LD3"
#set_property PACKAGE_PIN V22 [get_ports {LD4}];  # "LD4"
#set_property PACKAGE_PIN W22 [get_ports {LD5}];  # "LD5"
#set_property PACKAGE_PIN U19 [get_ports {LD6}];  # "LD6"
#set_property PACKAGE_PIN U14 [get_ports {LD7}];  # "LD7"


set_false_path -from [get_clocks clk_fpga_1] -to [get_clocks clk_fpga_0]
set_false_path -from [get_clocks clk_fpga_0] -to [get_clocks clk_fpga_1]
