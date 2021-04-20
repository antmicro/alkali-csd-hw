
create_ip -name pcie4_uscale_plus -vendor xilinx.com -library ip -module_name pcie4_uscale_plus_0

set_property -dict [list \
    CONFIG.PL_LINK_CAP_MAX_LINK_SPEED {8.0_GT/s} \
    CONFIG.PL_LINK_CAP_MAX_LINK_WIDTH {X4} \
    CONFIG.AXISTEN_IF_RC_STRADDLE {false} \
    CONFIG.axisten_if_enable_client_tag {true} \
    CONFIG.axisten_if_width {128_bit} \
    CONFIG.axisten_freq {250} \
    CONFIG.PF0_CLASS_CODE {010802} \
    CONFIG.PF0_DEVICE_ID {0001} \
    CONFIG.PF0_MSI_CAP_MULTIMSGCAP {32_vectors} \
    CONFIG.PF0_SUBSYSTEM_ID {0001} \
    CONFIG.PF0_SUBSYSTEM_VENDOR_ID {1b96} \
    CONFIG.PF0_Use_Class_Code_Lookup_Assistant {false} \
    CONFIG.pf0_class_code_base {01} \
    CONFIG.pf0_class_code_sub {08} \
    CONFIG.pf0_class_code_interface {02} \
    CONFIG.pf0_bar0_scale {Megabytes} \
    CONFIG.pf0_bar0_size {1} \
    CONFIG.pf0_bar1_enabled {true} \
    CONFIG.pf0_bar1_type {Memory} \
    CONFIG.pf0_bar1_scale {Megabytes} \
    CONFIG.pf0_bar1_size {1} \
    CONFIG.vendor_id {1b96} \
    CONFIG.en_msi_per_vec_masking {true} \
] [get_ips pcie4_uscale_plus_0]
