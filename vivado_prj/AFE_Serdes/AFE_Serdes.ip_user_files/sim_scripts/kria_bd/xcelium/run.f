-makelib xcelium_lib/xilinx_vip -sv \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
  "C:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/rst_vip_if.sv" \
-endlib
-makelib xcelium_lib/xpm -sv \
  "C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
  "C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "C:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/axi_lite_ipif_v3_0_4 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/lib_cdc_v1_0_2 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/interrupt_control_v3_1_4 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/a040/hdl/interrupt_control_v3_1_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_gpio_v2_0_29 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/6219/hdl/axi_gpio_v2_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/kria_bd/ip/kria_bd_pmod_2_0/sim/kria_bd_pmod_2_0.vhd" \
  "../../../bd/kria_bd/ip/kria_bd_uf_leds_0/sim/kria_bd_uf_leds_0.vhd" \
  "../../../bd/kria_bd/ip/kria_bd_rpi_gpio_0/sim/kria_bd_rpi_gpio_0.vhd" \
-endlib
-makelib xcelium_lib/dist_mem_gen_v8_0_13 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/0bf5/simulation/dist_mem_gen_v8_0.v" \
-endlib
-makelib xcelium_lib/lib_pkg_v1_0_2 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/0513/hdl/lib_pkg_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/lib_srl_fifo_v1_0_2 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/51ce/hdl/lib_srl_fifo_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_7 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/83df/simulation/fifo_generator_vlog_beh.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_7 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/83df/hdl/fifo_generator_v13_2_rfs.vhd" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_7 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/83df/hdl/fifo_generator_v13_2_rfs.v" \
-endlib
-makelib xcelium_lib/lib_fifo_v1_0_16 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/6c82/hdl/lib_fifo_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_quad_spi_v3_2_26 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/75b9/hdl/axi_quad_spi_v3_2_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/kria_bd/ip/kria_bd_axi_quad_spi_0_0/sim/kria_bd_axi_quad_spi_0_0.vhd" \
-endlib
-makelib xcelium_lib/xlslice_v1_0_2 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/11d0/hdl/xlslice_v1_0_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/kria_bd/ip/kria_bd_xlslice_0_0/sim/kria_bd_xlslice_0_0.v" \
-endlib
-makelib xcelium_lib/xlconcat_v2_1_4 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/4b67/hdl/xlconcat_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/kria_bd/ip/kria_bd_xlconcat_0_0/sim/kria_bd_xlconcat_0_0.v" \
-endlib
-makelib xcelium_lib/axi_intc_v4_1_17 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/802b/hdl/axi_intc_v4_1_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/kria_bd/ip/kria_bd_axi_intc_0_0/sim/kria_bd_axi_intc_0_0.vhd" \
-endlib
-makelib xcelium_lib/proc_sys_reset_v5_0_13 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/kria_bd/ip/kria_bd_proc_sys_reset_1_0/sim/kria_bd_proc_sys_reset_1_0.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/kria_bd/ip/kria_bd_clk_wiz_0_0/kria_bd_clk_wiz_0_0_clk_wiz.v" \
  "../../../bd/kria_bd/ip/kria_bd_clk_wiz_0_0/kria_bd_clk_wiz_0_0.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/kria_bd/ip/kria_bd_proc_sys_reset_2_0/sim/kria_bd_proc_sys_reset_2_0.vhd" \
-endlib
-makelib xcelium_lib/axi_infrastructure_v1_1_0 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_vip_v1_1_13 -sv \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/ffc2/hdl/axi_vip_v1_1_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/zynq_ultra_ps_e_vip_v1_0_13 -sv \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/abef/hdl/zynq_ultra_ps_e_vip_v1_0_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/kria_bd/ip/kria_bd_zynq_ultra_ps_e_0_0/sim/kria_bd_zynq_ultra_ps_e_0_0_vip_wrapper.v" \
-endlib
-makelib xcelium_lib/generic_baseblocks_v2_1_0 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_register_slice_v2_1_27 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/f0b4/hdl/axi_register_slice_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_data_fifo_v2_1_26 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/3111/hdl/axi_data_fifo_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_crossbar_v2_1_28 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/c40e/hdl/axi_crossbar_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/kria_bd/ip/kria_bd_xbar_0/sim/kria_bd_xbar_0.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/kria_bd/ip/kria_bd_sine_wave_gen_0_0/sim/kria_bd_sine_wave_gen_0_0.vhd" \
-endlib
-makelib xcelium_lib/xlconstant_v1_1_7 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/badb/hdl/xlconstant_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/kria_bd/ip/kria_bd_xlconstant_0_0/sim/kria_bd_xlconstant_0_0.v" \
-endlib
-makelib xcelium_lib/axi_datamover_v5_1_29 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/2237/hdl/axi_datamover_v5_1_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_sg_v4_1_15 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/751a/hdl/axi_sg_v4_1_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_dma_v7_1_28 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/70c4/hdl/axi_dma_v7_1_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/kria_bd/ip/kria_bd_axi_dma_0_0/sim/kria_bd_axi_dma_0_0.vhd" \
  "../../../bd/kria_bd/ipshared/6d8f/hdl/ADQ_DataFifo_v1_0_M00_AXIS.vhd" \
  "../../../bd/kria_bd/ipshared/6d8f/hdl/ADQ_DataFifo_v1_0.vhd" \
  "../../../bd/kria_bd/ip/kria_bd_ADQ_DataFifo_0_0/sim/kria_bd_ADQ_DataFifo_0_0.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/sim/bd_5ac1.v" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_0/sim/bd_5ac1_one_0.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_1/sim/bd_5ac1_psr_aclk_0.vhd" \
-endlib
-makelib xcelium_lib/smartconnect_v1_0 -sv \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/f0b6/hdl/sc_util_v1_0_vl_rfs.sv" \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/c012/hdl/sc_switchboard_v1_0_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib -sv \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_2/sim/bd_5ac1_arsw_0.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_3/sim/bd_5ac1_rsw_0.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_4/sim/bd_5ac1_awsw_0.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_5/sim/bd_5ac1_wsw_0.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_6/sim/bd_5ac1_bsw_0.sv" \
-endlib
-makelib xcelium_lib/smartconnect_v1_0 -sv \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/be1f/hdl/sc_mmu_v1_0_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib -sv \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_7/sim/bd_5ac1_s00mmu_0.sv" \
-endlib
-makelib xcelium_lib/smartconnect_v1_0 -sv \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/4fd2/hdl/sc_transaction_regulator_v1_0_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib -sv \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_8/sim/bd_5ac1_s00tr_0.sv" \
-endlib
-makelib xcelium_lib/smartconnect_v1_0 -sv \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/637d/hdl/sc_si_converter_v1_0_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib -sv \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_9/sim/bd_5ac1_s00sic_0.sv" \
-endlib
-makelib xcelium_lib/smartconnect_v1_0 -sv \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/f38e/hdl/sc_axi2sc_v1_0_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib -sv \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_10/sim/bd_5ac1_s00a2s_0.sv" \
-endlib
-makelib xcelium_lib/smartconnect_v1_0 -sv \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/66be/hdl/sc_node_v1_0_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib -sv \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_11/sim/bd_5ac1_sawn_0.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_12/sim/bd_5ac1_swn_0.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_13/sim/bd_5ac1_sbn_0.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_14/sim/bd_5ac1_s01mmu_0.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_15/sim/bd_5ac1_s01tr_0.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_16/sim/bd_5ac1_s01sic_0.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_17/sim/bd_5ac1_s01a2s_0.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_18/sim/bd_5ac1_sawn_1.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_19/sim/bd_5ac1_swn_1.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_20/sim/bd_5ac1_sbn_1.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_21/sim/bd_5ac1_s02mmu_0.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_22/sim/bd_5ac1_s02tr_0.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_23/sim/bd_5ac1_s02sic_0.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_24/sim/bd_5ac1_s02a2s_0.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_25/sim/bd_5ac1_sawn_2.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_26/sim/bd_5ac1_swn_2.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_27/sim/bd_5ac1_sbn_2.sv" \
-endlib
-makelib xcelium_lib/smartconnect_v1_0 -sv \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/9cc5/hdl/sc_sc2axi_v1_0_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib -sv \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_28/sim/bd_5ac1_m00s2a_0.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_29/sim/bd_5ac1_m00awn_0.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_30/sim/bd_5ac1_m00wn_0.sv" \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_31/sim/bd_5ac1_m00bn_0.sv" \
-endlib
-makelib xcelium_lib/smartconnect_v1_0 -sv \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/6bba/hdl/sc_exit_v1_0_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib -sv \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/bd_0/ip/ip_32/sim/bd_5ac1_m00e_0.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/kria_bd/ip/kria_bd_axi_smc_0/sim/kria_bd_axi_smc_0.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/kria_bd/ip/kria_bd_ADQ_DataFifo_Sine_1/sim/kria_bd_ADQ_DataFifo_Sine_1.vhd" \
  "../../../bd/kria_bd/ip/kria_bd_axi_dma_afe_0/sim/kria_bd_axi_dma_afe_0.vhd" \
  "../../../bd/kria_bd/ip/kria_bd_ADC_AFE_interface_0_0/sim/kria_bd_ADC_AFE_interface_0_0.vhd" \
  "../../../bd/kria_bd/sim/kria_bd.vhd" \
  "../../../bd/kria_bd/ip/kria_bd_ADQ_DataFifo_AFE_0/sim/kria_bd_ADQ_DataFifo_AFE_0.vhd" \
  "../../../bd/kria_bd/ip/kria_bd_axi_dma_afe_1/sim/kria_bd_axi_dma_afe_1.vhd" \
  "../../../bd/kria_bd/ip/kria_bd_ADC_AFE_Diff_interfa_0_0/sim/kria_bd_ADC_AFE_Diff_interfa_0_0.vhd" \
-endlib
-makelib xcelium_lib/axi_protocol_converter_v2_1_27 \
  "../../../../AFE_Serdes.gen/sources_1/bd/kria_bd/ipshared/aeb3/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/kria_bd/ip/kria_bd_auto_pc_0/sim/kria_bd_auto_pc_0.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

