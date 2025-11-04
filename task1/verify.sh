#!/bin/bash

# cleanup
rm -rf obj_dir
rm -f *.vcd

# Translate Verilog -> C++ including testbench
verilator   -Wall --trace \
            -cc lfsr.sv \
            --exe verify.cpp \
            --prefix "Vdut" \
            -o Vdut \
            -CFLAGS "-std=c++17 -isystem /opt/homebrew/Cellar/googletest/1.17.0/include"\
            -LDFLAGS "-L/opt/homebrew/Cellar/googletest/1.17.0/lib -lgtest -lgtest_main -lpthread" \
# verilator：工具本体，用软件（C++）来模拟硬件（Verilog / SystemVerilog）。
# -Wall：打开所有常用的警告（类似 g++ 的 -Wall），比如未连接信号、宽度不匹配之类。
# --trace：让生成的模型支持波形跟踪（生成 .vcd 之类的波形文件的接口）。

make -j -C obj_dir/ -f Vdut.mk

# Run executable simulation file
./obj_dir/Vdut
