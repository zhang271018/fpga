onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xbip_utils_v3_0_10 -L axi_utils_v2_0_6 -L c_reg_fd_v12_0_6 -L xbip_dsp48_wrapper_v3_0_4 -L xbip_pipe_v3_0_6 -L xbip_dsp48_addsub_v3_0_6 -L xbip_addsub_v3_0_6 -L c_addsub_v12_0_13 -L c_mux_bit_v12_0_6 -L c_shift_ram_v12_0_13 -L xbip_bram18k_v3_0_6 -L mult_gen_v12_0_15 -L cmpy_v6_0_17 -L floating_point_v7_0_16 -L xfft_v9_1_2 -L xil_defaultlib -L secureip -L xpm -lib xil_defaultlib xil_defaultlib.xfft_0

do {wave.do}

view wave
view structure
view signals

do {xfft_0.udo}

run -all

quit -force