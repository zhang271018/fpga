onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xbip_utils_v3_0_10 -L axi_utils_v2_0_6 -L xbip_pipe_v3_0_6 -L xbip_bram18k_v3_0_6 -L mult_gen_v12_0_15 -L cmpy_v6_0_17 -L xil_defaultlib -L secureip -L xpm -lib xil_defaultlib xil_defaultlib.cmpy_0

do {wave.do}

view wave
view structure
view signals

do {cmpy_0.udo}

run -all

quit -force
