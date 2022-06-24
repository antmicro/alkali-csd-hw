### Scylla RevC1 (Basalat) ------------------
# Host PCIe X4 Connections 
# 
# MGT Bank 226 for Host PCIe Connections 
set_property PACKAGE_PIN AA20 [get_ports {perstn}]
set_property IOSTANDARD LVCMOS18 [get_ports perstn]
#set_property PACKAGE_PIN AE22 [get_ports {perstn_11eg}] ## reset for 11EG support
#set_property PACKAGE_PIN V3 [get_ports {pcie_rxn[0]}]
#set_property PACKAGE_PIN U1 [get_ports {pcie_rxn[1]}]
#set_property PACKAGE_PIN R1 [get_ports {pcie_rxn[2]}]
#set_property PACKAGE_PIN P3 [get_ports {pcie_rxn[3]}]
set_property PACKAGE_PIN V4 [get_ports {pcie_rxp[0]}]
set_property PACKAGE_PIN U2 [get_ports {pcie_rxp[1]}]
set_property PACKAGE_PIN R2 [get_ports {pcie_rxp[2]}]
set_property PACKAGE_PIN P4 [get_ports {pcie_rxp[3]}]
#set_property PACKAGE_PIN U5 [get_ports {pcie_txn[0]}]
#set_property PACKAGE_PIN T3 [get_ports {pcie_txn[1]}]
#set_property PACKAGE_PIN R5 [get_ports {pcie_txn[2]}]
#set_property PACKAGE_PIN N5 [get_ports {pcie_txn[3]}]
set_property PACKAGE_PIN U6 [get_ports {pcie_txp[0]}]
set_property PACKAGE_PIN T4 [get_ports {pcie_txp[1]}]
set_property PACKAGE_PIN R6 [get_ports {pcie_txp[2]}]
set_property PACKAGE_PIN N6 [get_ports {pcie_txp[3]}]
#set_property PACKAGE_PIN V7 [get_ports {pcie_ref_clk_n}]
set_property PACKAGE_PIN V8 [get_ports {pcie_ref_clk_p}]
###----------------- Scylla RevB1 --------------------------####
#set_property IOSTANDARD LVCMOS18 [get_ports perstn]
#set_property IOSTANDARD LVCMOS12 [get_ports perstn]
#set_property PACKAGE_PIN AP3 [get_ports {pcie_rxn[3]}]
#set_property PACKAGE_PIN AN1 [get_ports {pcie_rxn[2]}]
#set_property PACKAGE_PIN AL1 [get_ports {pcie_rxn[1]}]
#set_property PACKAGE_PIN AK3 [get_ports {pcie_rxn[0]}]
#set_property PACKAGE_PIN AP4 [get_ports {pcie_rxp[3]}]
#set_property PACKAGE_PIN AN2 [get_ports {pcie_rxp[2]}]
#set_property PACKAGE_PIN AL2 [get_ports {pcie_rxp[1]}]
#set_property PACKAGE_PIN AK4 [get_ports {pcie_rxp[0]}]
#set_property PACKAGE_PIN AN5 [get_ports {pcie_txn[3]}]
#set_property PACKAGE_PIN AM3 [get_ports {pcie_txn[2]}]
#set_property PACKAGE_PIN AL5 [get_ports {pcie_txn[1]}]
#set_property PACKAGE_PIN AJ5 [get_ports {pcie_txn[0]}]
#set_property PACKAGE_PIN AN6 [get_ports {pcie_txp[3]}]
#set_property PACKAGE_PIN AM4 [get_ports {pcie_txp[2]}]
#set_property PACKAGE_PIN AL6 [get_ports {pcie_txp[1]}]
#set_property PACKAGE_PIN AJ6 [get_ports {pcie_txp[0]}]
#set_property PACKAGE_PIN AD7 [get_ports pcie_ref_clk_n]
#set_property PACKAGE_PIN AD8 [get_ports pcie_ref_clk_p]
#
#
###### PCIE PIN LOCATION ENDS #######################
#-------------------------------------------------------
# 64 bit DDR4 Interface for Scylla RevC1 (basalt)
# RevC1 only support 64Bit DDR4 FlyBy Topology  
# Supported DDR4 Part : MT40A512M16LY-075:E (SDRAM - DDR4 Memory IC 8Gb (512M x 16) Parallel 1.33GHz  96-FBGA (7.5x13.5))
#
#set_property PACKAGE_PIN AH8 [get_ports {ddr4a_adr[0]}]
#set_property PACKAGE_PIN AL8 [get_ports {ddr4a_adr[1]}]
#set_property PACKAGE_PIN AH11 [get_ports {ddr4a_adr[2]}]
#set_property PACKAGE_PIN AK8 [get_ports {ddr4a_adr[3]}]
#set_property PACKAGE_PIN AF8 [get_ports {ddr4a_adr[4]}]
#set_property PACKAGE_PIN AK12 [get_ports {ddr4a_adr[5]}]
#set_property PACKAGE_PIN AH13 [get_ports {ddr4a_adr[6]}]
#set_property PACKAGE_PIN AM11 [get_ports {ddr4a_adr[7]}]
#set_property PACKAGE_PIN AP9 [get_ports {ddr4a_adr[8]}]
#set_property PACKAGE_PIN AP11 [get_ports {ddr4a_adr[9]}]
#set_property PACKAGE_PIN AG11 [get_ports {ddr4a_adr[10]}]
#set_property PACKAGE_PIN AL12 [get_ports {ddr4a_adr[11]}]
#set_property PACKAGE_PIN AM8 [get_ports {ddr4a_adr[12]}]
#set_property PACKAGE_PIN AP10 [get_ports {ddr4a_adr[13]}]
#set_property PACKAGE_PIN AN12 [get_ports {ddr4a_adr[14]}]
#set_property PACKAGE_PIN AG8 [get_ports {ddr4a_adr[15]}]
#set_property PACKAGE_PIN AK13 [get_ports {ddr4a_adr[16]}]
#set_property PACKAGE_PIN AN11 [get_ports {ddr4a_act_n}]
#set_property PACKAGE_PIN AL13 [get_ports {ddr4a_alert_n}]
#set_property PACKAGE_PIN AM9 [get_ports {ddr4a_ba[0]}]
#set_property PACKAGE_PIN AJ10 [get_ports {ddr4a_ba[1]}]
#set_property PACKAGE_PIN AM10 [get_ports {ddr4a_bg[0]}]
#set_property PACKAGE_PIN AL10 [get_ports {ddr4a_bg[1]}]
#set_property PACKAGE_PIN AN8 [get_ports {ddr4a_ck_c[0]}]
#set_property PACKAGE_PIN AN9 [get_ports {ddr4a_ck_t[0]}]
#set_property PACKAGE_PIN AG13 [get_ports {ddr4a_cke[0]}]
#set_property PACKAGE_PIN AJ11 [get_ports {ddr4a_cs_n[0]}]
#set_property PACKAGE_PIN M13 [get_ports {ddr4a_dm_n[0]}]
#set_property PACKAGE_PIN F7 [get_ports {ddr4a_dm_n[1]}]
#set_property PACKAGE_PIN H11 [get_ports {ddr4a_dm_n[2]}]
#set_property PACKAGE_PIN C7 [get_ports {ddr4a_dm_n[3]}]
#set_property PACKAGE_PIN A17 [get_ports {ddr4a_dm_n[4]}]
#set_property PACKAGE_PIN D16 [get_ports {ddr4a_dm_n[5]}]
#set_property PACKAGE_PIN F17 [get_ports {ddr4a_dm_n[6]}]
#set_property PACKAGE_PIN L20 [get_ports {ddr4a_dm_n[7]}]
#set_property PACKAGE_PIN J14 [get_ports {ddr4a_dq[0]}]
#set_property PACKAGE_PIN K10 [get_ports {ddr4a_dq[1]}]
#set_property PACKAGE_PIN L14 [get_ports {ddr4a_dq[2]}]
#set_property PACKAGE_PIN J10 [get_ports {ddr4a_dq[3]}]
#set_property PACKAGE_PIN K14 [get_ports {ddr4a_dq[4]}]
#set_property PACKAGE_PIN L11 [get_ports {ddr4a_dq[5]}]
#set_property PACKAGE_PIN K13 [get_ports {ddr4a_dq[6]}]
#set_property PACKAGE_PIN L12 [get_ports {ddr4a_dq[7]}]
#set_property PACKAGE_PIN G10 [get_ports {ddr4a_dq[8]}]
#set_property PACKAGE_PIN C8 [get_ports {ddr4a_dq[9]}]
#set_property PACKAGE_PIN G9 [get_ports {ddr4a_dq[10]}]
#set_property PACKAGE_PIN E8 [get_ports {ddr4a_dq[11]}]
#set_property PACKAGE_PIN H9 [get_ports {ddr4a_dq[12]}]
#set_property PACKAGE_PIN F8 [get_ports {ddr4a_dq[13]}]
#set_property PACKAGE_PIN C9 [get_ports {ddr4a_dq[14]}]
#set_property PACKAGE_PIN F10 [get_ports {ddr4a_dq[15]}]
#set_property PACKAGE_PIN D12 [get_ports {ddr4a_dq[16]}]
#set_property PACKAGE_PIN F11 [get_ports {ddr4a_dq[17]}]
#set_property PACKAGE_PIN C11 [get_ports {ddr4a_dq[18]}]
#set_property PACKAGE_PIN F12 [get_ports {ddr4a_dq[19]}]
#set_property PACKAGE_PIN H12 [get_ports {ddr4a_dq[20]}]
#set_property PACKAGE_PIN E10 [get_ports {ddr4a_dq[21]}]
#set_property PACKAGE_PIN H13 [get_ports {ddr4a_dq[22]}]
#set_property PACKAGE_PIN E12 [get_ports {ddr4a_dq[23]}]
#set_property PACKAGE_PIN B11 [get_ports {ddr4a_dq[24]}]
#set_property PACKAGE_PIN B9 [get_ports {ddr4a_dq[25]}]
#set_property PACKAGE_PIN A6 [get_ports {ddr4a_dq[26]}]
#set_property PACKAGE_PIN A8 [get_ports {ddr4a_dq[27]}]
#set_property PACKAGE_PIN A11 [get_ports {ddr4a_dq[28]}]
#set_property PACKAGE_PIN B8 [get_ports {ddr4a_dq[29]}]
#set_property PACKAGE_PIN B6 [get_ports {ddr4a_dq[30]}]
#set_property PACKAGE_PIN A7 [get_ports {ddr4a_dq[31]}]
#set_property PACKAGE_PIN B15 [get_ports {ddr4a_dq[32]}]
#set_property PACKAGE_PIN A14 [get_ports {ddr4a_dq[33]}]
#set_property PACKAGE_PIN B16 [get_ports {ddr4a_dq[34]}]
#set_property PACKAGE_PIN A15 [get_ports {ddr4a_dq[35]}]
#set_property PACKAGE_PIN C13 [get_ports {ddr4a_dq[36]}]
#set_property PACKAGE_PIN A12 [get_ports {ddr4a_dq[37]}]
#set_property PACKAGE_PIN C12 [get_ports {ddr4a_dq[38]}]
#set_property PACKAGE_PIN A13 [get_ports {ddr4a_dq[39]}]
#set_property PACKAGE_PIN E17 [get_ports {ddr4a_dq[40]}]
#set_property PACKAGE_PIN E15 [get_ports {ddr4a_dq[41]}]
#set_property PACKAGE_PIN D17 [get_ports {ddr4a_dq[42]}]
#set_property PACKAGE_PIN C17 [get_ports {ddr4a_dq[43]}]
#set_property PACKAGE_PIN E18 [get_ports {ddr4a_dq[44]}]
#set_property PACKAGE_PIN E14 [get_ports {ddr4a_dq[45]}]
#set_property PACKAGE_PIN D14 [get_ports {ddr4a_dq[46]}]
#set_property PACKAGE_PIN D15 [get_ports {ddr4a_dq[47]}]
#set_property PACKAGE_PIN H19 [get_ports {ddr4a_dq[48]}]
#set_property PACKAGE_PIN F18 [get_ports {ddr4a_dq[49]}]
#set_property PACKAGE_PIN G18 [get_ports {ddr4a_dq[50]}]
#set_property PACKAGE_PIN G16 [get_ports {ddr4a_dq[51]}]
#set_property PACKAGE_PIN G19 [get_ports {ddr4a_dq[52]}]
#set_property PACKAGE_PIN G15 [get_ports {ddr4a_dq[53]}]
#set_property PACKAGE_PIN H16 [get_ports {ddr4a_dq[54]}]
#set_property PACKAGE_PIN F15 [get_ports {ddr4a_dq[55]}]
#set_property PACKAGE_PIN L17 [get_ports {ddr4a_dq[56]}]
#set_property PACKAGE_PIN K19 [get_ports {ddr4a_dq[57]}]
#set_property PACKAGE_PIN L16 [get_ports {ddr4a_dq[58]}]
#set_property PACKAGE_PIN J17 [get_ports {ddr4a_dq[59]}]
#set_property PACKAGE_PIN J15 [get_ports {ddr4a_dq[60]}]
#set_property PACKAGE_PIN K17 [get_ports {ddr4a_dq[61]}]
#set_property PACKAGE_PIN K18 [get_ports {ddr4a_dq[62]}]
#set_property PACKAGE_PIN J16 [get_ports {ddr4a_dq[63]}]
#set_property PACKAGE_PIN J11 [get_ports {ddr4a_dqs_c[0]}]
#set_property PACKAGE_PIN D9 [get_ports {ddr4a_dqs_c[1]}]
#set_property PACKAGE_PIN D10 [get_ports {ddr4a_dqs_c[2]}]
#set_property PACKAGE_PIN A10 [get_ports {ddr4a_dqs_c[3]}]
#set_property PACKAGE_PIN B13 [get_ports {ddr4a_dqs_c[4]}]
#set_property PACKAGE_PIN F13 [get_ports {ddr4a_dqs_c[5]}]
#set_property PACKAGE_PIN H17 [get_ports {ddr4a_dqs_c[6]}]
#set_property PACKAGE_PIN K15 [get_ports {ddr4a_dqs_c[7]}]
#set_property PACKAGE_PIN K12 [get_ports {ddr4a_dqs_t[0]}]
#set_property PACKAGE_PIN E9 [get_ports {ddr4a_dqs_t[1]}]
#set_property PACKAGE_PIN D11 [get_ports {ddr4a_dqs_t[2]}]
#set_property PACKAGE_PIN B10 [get_ports {ddr4a_dqs_t[3]}]
#set_property PACKAGE_PIN B14 [get_ports {ddr4a_dqs_t[4]}]
#set_property PACKAGE_PIN G14 [get_ports {ddr4a_dqs_t[5]}]
#set_property PACKAGE_PIN H18 [get_ports {ddr4a_dqs_t[6]}]
#set_property PACKAGE_PIN L15 [get_ports {ddr4a_dqs_t[7]}]
#set_property PACKAGE_PIN AP12 [get_ports {ddr4a_odt}]
#set_property PACKAGE_PIN AL11 [get_ports {ddr4a_par}]
#set_property PACKAGE_PIN AK9 [get_ports {ddr4a_ref_clk_n}]
#set_property PACKAGE_PIN AJ9 [get_ports {ddr4a_ref_clk_p}]
#set_property PACKAGE_PIN AG9 [get_ports {ddr4a_reset_n}]
#----------------DDR4A 64Bit Scylla RevB1 Interface -------------------
#set_property PACKAGE_PIN AH16 [get_ports {ddr4a_act_n}]
#set_property PACKAGE_PIN AL18 [get_ports {ddr4a_adr[0]}]
#set_property PACKAGE_PIN AP17 [get_ports {ddr4a_adr[1]}]
#set_property PACKAGE_PIN AP15 [get_ports {ddr4a_adr[10]}]
#set_property PACKAGE_PIN AP18 [get_ports {ddr4a_adr[11]}]
#set_property PACKAGE_PIN AN17 [get_ports {ddr4a_adr[12]}]
#set_property PACKAGE_PIN AL15 [get_ports {ddr4a_adr[13]}]
#set_property PACKAGE_PIN AM15 [get_ports {ddr4a_adr[14]}]
#set_property PACKAGE_PIN AN16 [get_ports {ddr4a_adr[15]}]
#set_property PACKAGE_PIN AM16 [get_ports {ddr4a_adr[16]}]
#set_property PACKAGE_PIN AK15 [get_ports {ddr4a_adr[2]}]
#set_property PACKAGE_PIN AP13 [get_ports {ddr4a_adr[3]}]
#set_property PACKAGE_PIN AP16 [get_ports {ddr4a_adr[4]}]
#set_property PACKAGE_PIN AN13 [get_ports {ddr4a_adr[5]}]
#set_property PACKAGE_PIN AK18 [get_ports {ddr4a_adr[6]}]
#set_property PACKAGE_PIN AL16 [get_ports {ddr4a_adr[7]}]
#set_property PACKAGE_PIN AM18 [get_ports {ddr4a_adr[8]}]
#set_property PACKAGE_PIN AN18 [get_ports {ddr4a_adr[9]}]
#set_property PACKAGE_PIN AF18 [get_ports {ddr4a_ba[0]}]
#set_property PACKAGE_PIN AG18 [get_ports {ddr4a_ba[1]}]
#set_property PACKAGE_PIN AE17 [get_ports {ddr4a_bg[0]}]
#set_property PACKAGE_PIN AF17 [get_ports {ddr4a_bg[1]}]
#set_property PACKAGE_PIN AN14 [get_ports {ddr4a_ck_c[0]}]
#set_property PACKAGE_PIN AM14 [get_ports {ddr4a_ck_t[0]}]
#set_property PACKAGE_PIN AF16 [get_ports {ddr4a_cke[0]}]
#set_property PACKAGE_PIN AH14 [get_ports {ddr4a_cs_n[0]}]
#set_property PACKAGE_PIN AJ14 [get_ports {ddr4a_cs_n[1]}]
#set_property PACKAGE_PIN AN12 [get_ports {ddr4a_dm_n[0]}]
#set_property PACKAGE_PIN AK13 [get_ports {ddr4a_dm_n[1]}]
#set_property PACKAGE_PIN AH12 [get_ports {ddr4a_dm_n[2]}]
#set_property PACKAGE_PIN AF11 [get_ports {ddr4a_dm_n[3]}]
#set_property PACKAGE_PIN AP19 [get_ports {ddr4a_dm_n[4]}]
#set_property PACKAGE_PIN AL20 [get_ports {ddr4a_dm_n[5]}]
#set_property PACKAGE_PIN AH22 [get_ports {ddr4a_dm_n[6]}]
#set_property PACKAGE_PIN AD15 [get_ports {ddr4a_dm_n[7]}]
#set_property PACKAGE_PIN AP10 [get_ports {ddr4a_dq[0]}]
#set_property PACKAGE_PIN AM8 [get_ports {ddr4a_dq[1]}]
#set_property PACKAGE_PIN AL10 [get_ports {ddr4a_dq[10]}]
#set_property PACKAGE_PIN AK9 [get_ports {ddr4a_dq[11]}]
#set_property PACKAGE_PIN AL12 [get_ports {ddr4a_dq[12]}]
#set_property PACKAGE_PIN AJ9 [get_ports {ddr4a_dq[13]}]
#set_property PACKAGE_PIN AK12 [get_ports {ddr4a_dq[14]}]
#set_property PACKAGE_PIN AK10 [get_ports {ddr4a_dq[15]}]
#set_property PACKAGE_PIN AF8 [get_ports {ddr4a_dq[16]}]
#set_property PACKAGE_PIN AH11 [get_ports {ddr4a_dq[17]}]
#set_property PACKAGE_PIN AJ11 [get_ports {ddr4a_dq[18]}]
#set_property PACKAGE_PIN AH13 [get_ports {ddr4a_dq[19]}]
#set_property PACKAGE_PIN AM9 [get_ports {ddr4a_dq[2]}]
#set_property PACKAGE_PIN AG8 [get_ports {ddr4a_dq[20]}]
#set_property PACKAGE_PIN AG10 [get_ports {ddr4a_dq[21]}]
#set_property PACKAGE_PIN AG13 [get_ports {ddr4a_dq[22]}]
#set_property PACKAGE_PIN AG11 [get_ports {ddr4a_dq[23]}]
#set_property PACKAGE_PIN AB13 [get_ports {ddr4a_dq[24]}]
#set_property PACKAGE_PIN AF12 [get_ports {ddr4a_dq[25]}]
#set_property PACKAGE_PIN AE14 [get_ports {ddr4a_dq[26]}]
#set_property PACKAGE_PIN AE12 [get_ports {ddr4a_dq[27]}]
#set_property PACKAGE_PIN AC13 [get_ports {ddr4a_dq[28]}]
#set_property PACKAGE_PIN AF13 [get_ports {ddr4a_dq[29]}]
#set_property PACKAGE_PIN AP11 [get_ports {ddr4a_dq[3]}]
#set_property PACKAGE_PIN AD14 [get_ports {ddr4a_dq[30]}]
#set_property PACKAGE_PIN AE13 [get_ports {ddr4a_dq[31]}]
#set_property PACKAGE_PIN AP22 [get_ports {ddr4a_dq[32]}]
#set_property PACKAGE_PIN AN19 [get_ports {ddr4a_dq[33]}]
#set_property PACKAGE_PIN AP21 [get_ports {ddr4a_dq[34]}]
#set_property PACKAGE_PIN AP23 [get_ports {ddr4a_dq[35]}]
#set_property PACKAGE_PIN AN22 [get_ports {ddr4a_dq[36]}]
#set_property PACKAGE_PIN AM19 [get_ports {ddr4a_dq[37]}]
#set_property PACKAGE_PIN AM23 [get_ports {ddr4a_dq[38]}]
#set_property PACKAGE_PIN AN23 [get_ports {ddr4a_dq[39]}]
#set_property PACKAGE_PIN AM10 [get_ports {ddr4a_dq[4]}]
#set_property PACKAGE_PIN AL23 [get_ports {ddr4a_dq[40]}]
#set_property PACKAGE_PIN AK19 [get_ports {ddr4a_dq[41]}]
#set_property PACKAGE_PIN AL22 [get_ports {ddr4a_dq[42]}]
#set_property PACKAGE_PIN AK20 [get_ports {ddr4a_dq[43]}]
#set_property PACKAGE_PIN AJ21 [get_ports {ddr4a_dq[44]}]
#set_property PACKAGE_PIN AJ20 [get_ports {ddr4a_dq[45]}]
#set_property PACKAGE_PIN AJ22 [get_ports {ddr4a_dq[46]}]
#set_property PACKAGE_PIN AJ19 [get_ports {ddr4a_dq[47]}]
#set_property PACKAGE_PIN AG21 [get_ports {ddr4a_dq[48]}]
#set_property PACKAGE_PIN AF22 [get_ports {ddr4a_dq[49]}]
#set_property PACKAGE_PIN AN11 [get_ports {ddr4a_dq[5]}]
#set_property PACKAGE_PIN AG20 [get_ports {ddr4a_dq[50]}]
#set_property PACKAGE_PIN AE24 [get_ports {ddr4a_dq[51]}]
#set_property PACKAGE_PIN AF21 [get_ports {ddr4a_dq[52]}]
#set_property PACKAGE_PIN AE23 [get_ports {ddr4a_dq[53]}]
#set_property PACKAGE_PIN AG19 [get_ports {ddr4a_dq[54]}]
#set_property PACKAGE_PIN AH21 [get_ports {ddr4a_dq[55]}]
#set_property PACKAGE_PIN AC16 [get_ports {ddr4a_dq[56]}]
#set_property PACKAGE_PIN AC17 [get_ports {ddr4a_dq[57]}]
#set_property PACKAGE_PIN AD16 [get_ports {ddr4a_dq[58]}]
#set_property PACKAGE_PIN AB16 [get_ports {ddr4a_dq[59]}]
#set_property PACKAGE_PIN AP9 [get_ports {ddr4a_dq[6]}]
#set_property PACKAGE_PIN AA14 [get_ports {ddr4a_dq[60]}]
#set_property PACKAGE_PIN AD17 [get_ports {ddr4a_dq[61]}]
#set_property PACKAGE_PIN AB14 [get_ports {ddr4a_dq[62]}]
#set_property PACKAGE_PIN AB15 [get_ports {ddr4a_dq[63]}]
#set_property PACKAGE_PIN AM11 [get_ports {ddr4a_dq[7]}]
#set_property PACKAGE_PIN AL11 [get_ports {ddr4a_dq[8]}]
#set_property PACKAGE_PIN AJ10 [get_ports {ddr4a_dq[9]}]
#set_property PACKAGE_PIN AN8 [get_ports {ddr4a_dqs_c[0]}]
#set_property PACKAGE_PIN AL8 [get_ports {ddr4a_dqs_c[1]}]
#set_property PACKAGE_PIN AH9 [get_ports {ddr4a_dqs_c[2]}]
#set_property PACKAGE_PIN AD12 [get_ports {ddr4a_dqs_c[3]}]
#set_property PACKAGE_PIN AN21 [get_ports {ddr4a_dqs_c[4]}]
#set_property PACKAGE_PIN AK23 [get_ports {ddr4a_dqs_c[5]}]
#set_property PACKAGE_PIN AG23 [get_ports {ddr4a_dqs_c[6]}]
#set_property PACKAGE_PIN AA15 [get_ports {ddr4a_dqs_c[7]}]
#set_property PACKAGE_PIN AN9 [get_ports {ddr4a_dqs_t[0]}]
#set_property PACKAGE_PIN AK8 [get_ports {ddr4a_dqs_t[1]}]
#set_property PACKAGE_PIN AG9 [get_ports {ddr4a_dqs_t[2]}]
#set_property PACKAGE_PIN AC12 [get_ports {ddr4a_dqs_t[3]}]
#set_property PACKAGE_PIN AM21 [get_ports {ddr4a_dqs_t[4]}]
#set_property PACKAGE_PIN AK22 [get_ports {ddr4a_dqs_t[5]}]
#set_property PACKAGE_PIN AF23 [get_ports {ddr4a_dqs_t[6]}]
#set_property PACKAGE_PIN AA16 [get_ports {ddr4a_dqs_t[7]}]
#set_property PACKAGE_PIN AG15 [get_ports {ddr4a_odt[0]}]
#set_property PACKAGE_PIN AJ15 [get_ports ddr4a_ref_clk_n]
#set_property PACKAGE_PIN AJ16 [get_ports ddr4a_ref_clk_p]
#set_property PACKAGE_PIN AG14 [get_ports ddr4a_reset_n]
#-----------DDR4B 32 Bit Interface---------------------
#set_property PACKAGE_PIN L20 [get_ports ddr4b_act_n]
#set_property PACKAGE_PIN A13 [get_ports {ddr4b_adr[0]}]
#set_property PACKAGE_PIN A14 [get_ports {ddr4b_adr[1]}]
#set_property PACKAGE_PIN C16 [get_ports {ddr4b_adr[10]}]
#set_property PACKAGE_PIN A16 [get_ports {ddr4b_adr[11]}]
#set_property PACKAGE_PIN A17 [get_ports {ddr4b_adr[12]}]
#set_property PACKAGE_PIN C17 [get_ports {ddr4b_adr[13]}]
#set_property PACKAGE_PIN G14 [get_ports {ddr4b_adr[14]}]
#set_property PACKAGE_PIN B16 [get_ports {ddr4b_adr[15]}]
#set_property PACKAGE_PIN C12 [get_ports {ddr4b_adr[16]}]
#set_property PACKAGE_PIN A12 [get_ports {ddr4b_adr[2]}]
#set_property PACKAGE_PIN E17 [get_ports {ddr4b_adr[3]}]
#set_property PACKAGE_PIN E18 [get_ports {ddr4b_adr[4]}]
#set_property PACKAGE_PIN D17 [get_ports {ddr4b_adr[5]}]
#set_property PACKAGE_PIN B15 [get_ports {ddr4b_adr[6]}]
#set_property PACKAGE_PIN D16 [get_ports {ddr4b_adr[7]}]
#set_property PACKAGE_PIN A15 [get_ports {ddr4b_adr[8]}]
#set_property PACKAGE_PIN C13 [get_ports {ddr4b_adr[9]}]
#set_property PACKAGE_PIN G15 [get_ports {ddr4b_ba[0]}]
#set_property PACKAGE_PIN F15 [get_ports {ddr4b_ba[1]}]
#set_property PACKAGE_PIN H19 [get_ports {ddr4b_bg[0]}]
#set_property PACKAGE_PIN G19 [get_ports {ddr4b_bg[1]}]
#set_property PACKAGE_PIN B13 [get_ports {ddr4b_ck_c[0]}]
#set_property PACKAGE_PIN B14 [get_ports {ddr4b_ck_t[0]}]
#set_property PACKAGE_PIN G18 [get_ports {ddr4b_cke[0]}]
#set_property PACKAGE_PIN H18 [get_ports {ddr4b_cs_n[0]}]
#set_property PACKAGE_PIN H17 [get_ports {ddr4b_cs_n[1]}]
#set_property PACKAGE_PIN M13 [get_ports {ddr4b_dm_n[0]}]
#set_property PACKAGE_PIN F7 [get_ports {ddr4b_dm_n[1]}]
#set_property PACKAGE_PIN H11 [get_ports {ddr4b_dm_n[2]}]
#set_property PACKAGE_PIN C7 [get_ports {ddr4b_dm_n[3]}]
#set_property PACKAGE_PIN K10 [get_ports {ddr4b_dq[0]}]
#set_property PACKAGE_PIN L12 [get_ports {ddr4b_dq[1]}]
#set_property PACKAGE_PIN C8 [get_ports {ddr4b_dq[10]}]
#set_property PACKAGE_PIN F10 [get_ports {ddr4b_dq[11]}]
#set_property PACKAGE_PIN C9 [get_ports {ddr4b_dq[12]}]
#set_property PACKAGE_PIN G9 [get_ports {ddr4b_dq[13]}]
#set_property PACKAGE_PIN F8 [get_ports {ddr4b_dq[14]}]
#set_property PACKAGE_PIN G10 [get_ports {ddr4b_dq[15]}]
#set_property PACKAGE_PIN E12 [get_ports {ddr4b_dq[16]}]
#set_property PACKAGE_PIN E10 [get_ports {ddr4b_dq[17]}]
#set_property PACKAGE_PIN F12 [get_ports {ddr4b_dq[18]}]
#set_property PACKAGE_PIN H13 [get_ports {ddr4b_dq[19]}]
#set_property PACKAGE_PIN J10 [get_ports {ddr4b_dq[2]}]
#set_property PACKAGE_PIN C11 [get_ports {ddr4b_dq[20]}]
#set_property PACKAGE_PIN D12 [get_ports {ddr4b_dq[21]}]
#set_property PACKAGE_PIN H12 [get_ports {ddr4b_dq[22]}]
#set_property PACKAGE_PIN F11 [get_ports {ddr4b_dq[23]}]
#set_property PACKAGE_PIN B6 [get_ports {ddr4b_dq[24]}]
#set_property PACKAGE_PIN B8 [get_ports {ddr4b_dq[25]}]
#set_property PACKAGE_PIN A8 [get_ports {ddr4b_dq[26]}]
#set_property PACKAGE_PIN A7 [get_ports {ddr4b_dq[27]}]
#set_property PACKAGE_PIN B9 [get_ports {ddr4b_dq[28]}]
#set_property PACKAGE_PIN A6 [get_ports {ddr4b_dq[29]}]
#set_property PACKAGE_PIN K14 [get_ports {ddr4b_dq[3]}]
#set_property PACKAGE_PIN A11 [get_ports {ddr4b_dq[30]}]
#set_property PACKAGE_PIN B11 [get_ports {ddr4b_dq[31]}]
#set_property PACKAGE_PIN L11 [get_ports {ddr4b_dq[4]}]
#set_property PACKAGE_PIN L14 [get_ports {ddr4b_dq[5]}]
#set_property PACKAGE_PIN J14 [get_ports {ddr4b_dq[6]}]
#set_property PACKAGE_PIN K13 [get_ports {ddr4b_dq[7]}]
#set_property PACKAGE_PIN E8 [get_ports {ddr4b_dq[8]}]
#set_property PACKAGE_PIN H9 [get_ports {ddr4b_dq[9]}]
#set_property PACKAGE_PIN J11 [get_ports {ddr4b_dqs_c[0]}]
#set_property PACKAGE_PIN D9 [get_ports {ddr4b_dqs_c[1]}]
#set_property PACKAGE_PIN D10 [get_ports {ddr4b_dqs_c[2]}]
#set_property PACKAGE_PIN A10 [get_ports {ddr4b_dqs_c[3]}]
#set_property PACKAGE_PIN K12 [get_ports {ddr4b_dqs_t[0]}]
#set_property PACKAGE_PIN E9 [get_ports {ddr4b_dqs_t[1]}]
#set_property PACKAGE_PIN D11 [get_ports {ddr4b_dqs_t[2]}]
#set_property PACKAGE_PIN B10 [get_ports {ddr4b_dqs_t[3]}]
#set_property PACKAGE_PIN H16 [get_ports {ddr4b_odt[0]}]
#set_property PACKAGE_PIN E14 [get_ports ddr4b_ref_clk_n]
#set_property PACKAGE_PIN E15 [get_ports ddr4b_ref_clk_p]
#set_property PACKAGE_PIN J20 [get_ports ddr4b_reset_n]
#
# -------------------------- DDR4 interface Ends ----------------------#
#
# Additional Available IO for Scylla RevC (Basalt)
#set_property PACKAGE_PIN AH23 [get_ports {user_clk_100mhz}]
#set_property PACKAGE_PIN E23 [get_ports {rework_id[0]}]
#set_property PACKAGE_PIN C23 [get_ports {rework_id[1]}]
#set_property PACKAGE_PIN AP17 [get_ports {rework_id[2]}]
#set_property PACKAGE_PIN AP18 [get_ports {rework_id[3]}]
#set_property PACKAGE_PIN AP19 [get_ports {rework_id[4]}]
#set_property PACKAGE_PIN AN19 [get_ports {rework_id[5]}]
#set_property PACKAGE_PIN AN18 [get_ports {rework_id[6]}]
#set_property PACKAGE_PIN AN17 [get_ports {rework_id[7]}]
#set_property PACKAGE_PIN AM18 [get_ports {rework_id[8]}]
#set_property PACKAGE_PIN AM19 [get_ports {rework_id[9]}]
#set_property PACKAGE_PIN K9 [get_ports {alert_12v}]
#set_property PACKAGE_PIN C3 [get_ports {brd_id[0]}]
#set_property PACKAGE_PIN D2 [get_ports {brd_id[0]}]
#set_property PACKAGE_PIN E2 [get_ports {brd_id[0]}]
#set_property PACKAGE_PIN L8 [get_ports {brd_pwr_gd}]
#set_property PACKAGE_PIN C4 [get_ports {user_clk_125mhz}]
#set_property PACKAGE_PIN D1 [get_ports {clk_i2c_data_fpga}]
#set_property PACKAGE_PIN C1 [get_ports {clk_i2c_scl_fpga}]
#set_property PACKAGE_PIN M9 [get_ports {pcie_perst_3v3_n}]
#set_property PACKAGE_PIN M8 [get_ports {pcie_wake_n}]
#set_property PACKAGE_PIN M10 [get_ports {pl_i2c_scl}]
#set_property PACKAGE_PIN L10 [get_ports {pl_i2c_sda}]
#set_property PACKAGE_PIN N9 [get_ports {user_rd_led}]
#set_property PACKAGE_PIN N8 [get_ports {user_wr_led}]
#set_property PACKAGE_PIN J7 [get_ports {host_smb_clock}]
#set_property PACKAGE_PIN K8 [get_ports {host_smb_data}]

#-----------BOARD_ID---------------------
set_property PACKAGE_PIN C3 [get_ports {BOARD_ID[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports {BOARD_ID[0]}]
set_property PULLDOWN true [get_ports {BOARD_ID[0]}]
set_property PACKAGE_PIN D2 [get_ports {BOARD_ID[1]}]
set_property IOSTANDARD LVCMOS12 [get_ports {BOARD_ID[1]}]
set_property PULLDOWN true [get_ports {BOARD_ID[1]}]
set_property PACKAGE_PIN E2 [get_ports {BOARD_ID[2]}]
set_property IOSTANDARD LVCMOS12 [get_ports {BOARD_ID[2]}]
set_property PULLDOWN true [get_ports {BOARD_ID[2]}]

#--------------LED PIN-------------------
#set_property PACKAGE_PIN N8 [get_ports {LED[0]}]
#set_property IOSTANDARD LVCMOS12 [get_ports {LED[0]}]
#set_property PACKAGE_PIN N9 [get_ports {LED[1]}]
#set_property IOSTANDARD LVCMOS12 [get_ports {LED[1]}]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

#used set_max_delay for timing issue resolve
#set_max_delay -from [get_clocks {pcie4_uscale_plus_inst/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/gt_wizard.gtwizard_top_i/pcie4_uscale_plus_0_gt_i/inst/gen_gtwizard_gthe4_top.pcie4_uscale_plus_0_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[3].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK}] -to [get_clocks {pcie4_uscale_plus_inst/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/gt_wizard.gtwizard_top_i/pcie4_uscale_plus_0_gt_i/inst/gen_gtwizard_gthe4_top.pcie4_uscale_plus_0_gt_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_channel_container[3].gen_enabled_channel.gthe4_channel_wrapper_inst/channel_inst/gthe4_channel_gen.gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK}] 10.000

