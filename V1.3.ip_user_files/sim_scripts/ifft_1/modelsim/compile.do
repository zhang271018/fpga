vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/c_addsub_v12_0_13
vlib modelsim_lib/msim/c_shift_ram_v12_0_13
vlib modelsim_lib/msim/mult_gen_v12_0_15
vlib modelsim_lib/msim/cmpy_v6_0_17
vlib modelsim_lib/msim/floating_point_v7_0_16
vlib modelsim_lib/msim/xfft_v9_1_2
vlib modelsim_lib/msim/xil_defaultlib

vmap c_addsub_v12_0_13 modelsim_lib/msim/c_addsub_v12_0_13
vmap c_shift_ram_v12_0_13 modelsim_lib/msim/c_shift_ram_v12_0_13
vmap mult_gen_v12_0_15 modelsim_lib/msim/mult_gen_v12_0_15
vmap cmpy_v6_0_17 modelsim_lib/msim/cmpy_v6_0_17
vmap floating_point_v7_0_16 modelsim_lib/msim/floating_point_v7_0_16
vmap xfft_v9_1_2 modelsim_lib/msim/xfft_v9_1_2
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vcom -work c_addsub_v12_0_13 -64 -93 \
"../../../ipstatic/hdl/c_addsub_v12_0_vh_rfs.vhd" \

vcom -work c_shift_ram_v12_0_13 -64 -93 \
"../../../ipstatic/hdl/c_shift_ram_v12_0_vh_rfs.vhd" \

vcom -work mult_gen_v12_0_15 -64 -93 \
"../../../ipstatic/hdl/mult_gen_v12_0_vh_rfs.vhd" \

vcom -work cmpy_v6_0_17 -64 -93 \
"../../../ipstatic/hdl/cmpy_v6_0_vh_rfs.vhd" \

vcom -work floating_point_v7_0_16 -64 -93 \
"../../../ipstatic/hdl/floating_point_v7_0_vh_rfs.vhd" \

vcom -work xfft_v9_1_2 -64 -93 \
"../../../ipstatic/hdl/xfft_v9_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../V1.3.srcs/sources_1/ip/ifft_1/sim/ifft_1.vhd" \


