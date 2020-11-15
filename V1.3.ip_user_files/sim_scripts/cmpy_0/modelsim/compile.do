vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/mult_gen_v12_0_15
vlib modelsim_lib/msim/cmpy_v6_0_17
vlib modelsim_lib/msim/xil_defaultlib

vmap mult_gen_v12_0_15 modelsim_lib/msim/mult_gen_v12_0_15
vmap cmpy_v6_0_17 modelsim_lib/msim/cmpy_v6_0_17
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vcom -work mult_gen_v12_0_15 -64 -93 \
"../../../ipstatic/hdl/mult_gen_v12_0_vh_rfs.vhd" \

vcom -work cmpy_v6_0_17 -64 -93 \
"../../../ipstatic/hdl/cmpy_v6_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../V1.3.srcs/sources_1/ip/cmpy_0/sim/cmpy_0.vhd" \


