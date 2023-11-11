#!/bin/bash

source /tools/Xilinx/Vivado/20*/settings64.sh

# テストパターンの指定＆移動
cp ../tp/$1.* ../tb/tp.sv

make