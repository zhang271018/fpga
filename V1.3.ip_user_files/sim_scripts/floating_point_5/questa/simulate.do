onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib floating_point_5_opt

do {wave.do}

view wave
view structure
view signals

do {floating_point_5.udo}

run -all

quit -force
