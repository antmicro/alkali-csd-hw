puts "barsize: $bar_size"
puts "barsize: $bar_unit"

create_ip -name pcie4_uscale_plus -vendor xilinx.com -library ip -module_name pcie4_uscale_plus_0

set_property -dict [list \
    CONFIG.PL_LINK_CAP_MAX_LINK_SPEED {8.0_GT/s} \
    CONFIG.PL_LINK_CAP_MAX_LINK_WIDTH {X4} \
    CONFIG.AXISTEN_IF_RC_STRADDLE {false} \
    CONFIG.axisten_if_enable_client_tag {true} \
    CONFIG.axisten_if_width {128_bit} \
    CONFIG.axisten_freq {250} \
    CONFIG.TL_PF_ENABLE_REG {2}\
    CONFIG.PF0_CLASS_CODE {010802} \
    CONFIG.PF0_DEVICE_ID {0001} \
    CONFIG.PF0_MSI_CAP_MULTIMSGCAP {32_vectors} \
    CONFIG.PF0_SUBSYSTEM_ID {0001} \
    CONFIG.PF0_SUBSYSTEM_VENDOR_ID {1b96} \
    CONFIG.PF0_Use_Class_Code_Lookup_Assistant {false} \
    CONFIG.pf0_class_code_base {01} \
    CONFIG.pf0_class_code_sub {08} \
    CONFIG.pf0_class_code_interface {02} \
    CONFIG.pf0_bar0_scale $bar_unit \
    CONFIG.pf0_bar0_size $bar_size \
    CONFIG.pf0_bar1_enabled {true} \
    CONFIG.pf0_bar1_type {Memory} \
    CONFIG.pf0_bar1_scale $bar_unit \
    CONFIG.pf0_bar1_size $bar_size \
    CONFIG.pf0_bar2_enabled {true} \
    CONFIG.pf0_bar2_type {Memory} \
    CONFIG.pf0_bar2_scale $bar_unit \
    CONFIG.pf0_bar2_size $bar_size \
    CONFIG.vendor_id {1b96} \
    CONFIG.en_msi_per_vec_masking {true} \
    CONFIG.PF1_CLASS_CODE {070001} \
    CONFIG.PF1_DEVICE_ID {1234} \
    CONFIG.PF1_MSI_CAP_MULTIMSGCAP {32_vectors} \
    CONFIG.PF1_SUBSYSTEM_ID {0007} \
    CONFIG.PF1_SUBSYSTEM_VENDOR_ID {1b96} \
    CONFIG.PF1_Use_Class_Code_Lookup_Assistant {false} \
    CONFIG.pf1_class_code_base {07} \
    CONFIG.pf1_class_code_sub {00} \
    CONFIG.pf1_class_code_interface {01} \
    CONFIG.pf1_base_class_menu {Simple_communication_controllers} \
    CONFIG.pf1_sub_class_interface_menu {16450_compatible_serial_controller} \
    CONFIG.pf1_msi_enabled {true} \
    CONFIG.pf1_bar0_scale $bar_unit \
    CONFIG.pf1_bar0_size $bar_size \
    CONFIG.pf1_bar1_enabled {true} \
    CONFIG.pf1_bar1_type {Memory} \
    CONFIG.pf1_bar1_scale $bar_unit \
    CONFIG.pf1_bar1_size $bar_size \
    CONFIG.pf1_bar2_enabled {true} \
    CONFIG.pf1_bar2_type {Memory} \
    CONFIG.pf1_bar2_scale $bar_unit \
    CONFIG.pf1_bar2_size $bar_size \
] [get_ips pcie4_uscale_plus_0]
