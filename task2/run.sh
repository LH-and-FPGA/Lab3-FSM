#!/bin/sh

rm -rf obj_dir
rm -f waveform.vcd

~/Documents/iac/lab0-devtools/tools/attach_usb.sh
verilator -Wall --cc --trace f1_fsm.sv --exe f1_fsm_tb.cpp

make -j -C obj_dir/ -f Vf1_fsm.mk Vf1_fsm

obj_dir/Vf1_fsm