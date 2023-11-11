TB 			:= tbench
# rtl
FILE 		:= $(shell find ../rtl/* | grep -e '\.v' -e '\.sv' | grep -v 'tp.sv' | xargs echo)
# test bench
TBFILE		:= $(shell find ../tb/* ../sva | grep -e '\.v' -e '\.sv' | grep -v 'tp.sv' | xargs echo)
# include directory
INCPATH		:= ../tb


all: xvlog xelab xsim

# Verilog compile : エラーチェック
xvlog:
	xvlog -sv \
		  --uvm_version 1.2 \
		  -L uvm \
		  --include $(INCPATH) \
		  --sourcelibdir ../rtl/ \
		  $(FILE) \
		  $(TBFILE)

# elaboration : 接続を完成
xelab:
	xelab -debug typical \
		  --include $(INCPATH) \
		  --uvm_version 1.2 \
		  -report_assertion_pass \
		  -L uvm \
		  $(TB) \
		  -s $(TB).sim

# シミュレーション -> 波形ファイル(sim.wdb)生成
# tclを用いて必要な箇所のみ観測信号線を選択し、シミュレーション＋波形ファイル作成
xsim:
	xsim --wdb sim.wdb \
	     $(TB).sim \
	     -tclbatch sim.tcl


# 波形ファイル（シミュレーション実行結果）をGUIで開く
wave:
	xsim -gui sim.wdb


# 波形ファイルを生成する前にGUIを開く
# tclファイルを用いず、GUIでシミュレーション＋波形ファイル作成
# 上記xsimとwaveと置き換え可能
xsim_wave:
	xsim -gui $(TB).sim



.PHONY: clean
clean:
	find ./* | grep -v -E 'makefile|sim.sh|xvlog.log|xelab.log|sim.tcl|xsim.log' | xargs rm -rf & rm -rf .Xil