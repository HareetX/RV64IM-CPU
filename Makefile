RTL_CORE_PATH=./rtl/core
RTL_GENERAL_PATH=./rtl/general
RTL_MEMS_PATH=./rtl/mems
RTL_SOC_PATH=./rtl/soc

TESTBENCH_PATH=./tb

DEFINES=./rtl/defines.v

CORE=$(wildcard $(RTL_CORE_PATH)/*.v)
GENERAL=$(wildcard $(RTL_GENERAL_PATH)/gnl_ff_module.v) $(wildcard $(RTL_GENERAL_PATH)/gnl_mux_module.v)
MEMS=$(wildcard $(RTL_MEMS_PATH)/*.v)
SOC=$(wildcard $(RTL_SOC_PATH)/*.v)

TESTBENCH=$(wildcard $(TESTBENCH_PATH)/*.v)

TOP=soc_tb
OUT_FILE=./build/a.out

run: $(DEFINES) $(GENERAL) $(CORE) $(MEMS) $(SOC) $(TESTBENCH)
	-md build
	iverilog -I ./rtl -o $(OUT_FILE) $(DEFINES) $(GENERAL) $(CORE) $(MEMS) $(SOC) $(TESTBENCH)
	vvp -n $(OUT_FILE)

.PHONY: wave clean

wave: build/wave.vcd
	gtkwave build/wave.vcd

clean:
	-$(shell powershell rm -r build)