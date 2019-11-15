SHELL                   := $(shell which bash) -o pipefail
ABS_TOP                 := $(subst /cygdrive/c/,C:/,$(shell pwd))
VIVADO                  ?= vivado
VIVADO_OPTS             ?= -nolog -nojournal -mode batch
FPGA_PART               ?= xc7z020clg400-3
RTL                     += $(subst /cygdrive/c/,C:/,$(shell find $(ABS_TOP)/src -type f -name "*.v"))
CONSTRAINTS             += $(subst /cygdrive/c/,C:/,$(shell find $(ABS_TOP)/src -type f -name "*.xdc"))
TOP                     ?= z1top
VCS                     := vcs -full64
VCS_OPTS                := -notice -PP -line +lint=all,noVCDE +v2k -timescale=1ns/10ps -debug -sverilog +define+ABS_TOP=$(ABS_TOP) +incdir+$(ABS_TOP)/src/riscv_core
SIM_RTL                 += $(subst /cygdrive/c/,C:/,$(shell find $(ABS_TOP)/sim -type f -name "*.v"))
SIM_MODELS              := $(subst /cygdrive/c/,C:/,$(shell find $(ABS_TOP)/sim_models -type f -name "*.v"))
IVERILOG                := iverilog
IVERILOG_OPTS           := -Ttyp -D IVERILOG=1 -D ABS_TOP=$(ABS_TOP) -I $(ABS_TOP)/src/riscv_core
VVP                     := vvp

sim/%.tb: sim/%.v $(RTL)
	cd sim && $(VCS) $(VCS_OPTS) -o $*.tb $(RTL) $(SIM_MODELS) $*.v -top $* -top glbl

sim/%.vpd: sim/%.tb
	cd sim && ./$*.tb +verbose=1 +vpdfile+$*.vpd |& tee $*.log

sim/%.tbi: sim/%.v $(RTL)
	cd sim && $(IVERILOG) $(IVERILOG_OPTS) -o $*.tbi $*.v $(RTL) $(SIM_MODELS)

sim/%.fst: sim/%.tbi
	cd sim && $(VVP) $*.tbi -fst |& tee $*.log

build/target.tcl: $(RTL) $(CONSTRAINTS)
	mkdir -p build
	truncate -s 0 $@
	echo "set ABS_TOP                        $(ABS_TOP)"    >> $@
	echo "set TOP                            $(TOP)"    >> $@
	echo "set FPGA_PART                      $(FPGA_PART)"  >> $@
	echo "set_param general.maxThreads       4"    >> $@
	echo "set_param general.maxBackupLogs    0"    >> $@
	echo -n "set RTL { " >> $@
	FLIST="$(RTL)"; for f in $$FLIST; do echo -n "$$f " ; done >> $@
	echo "}" >> $@
	echo -n "set CONSTRAINTS { " >> $@
	FLIST="$(CONSTRAINTS)"; for f in $$FLIST; do echo -n "$$f " ; done >> $@
	echo "}" >> $@

setup: build/target.tcl

build/synth/$(TOP).dcp: build/target.tcl $(ABS_TOP)/../scripts/synth.tcl
	mkdir -p ./build/synth/
	cd ./build/synth/ && $(VIVADO) $(VIVADO_OPTS) -source $(ABS_TOP)/../scripts/synth.tcl |& tee synth.log

synth: build/synth/$(TOP).dcp

build/impl/$(TOP).bit: build/synth/$(TOP).dcp $(ABS_TOP)/../scripts/impl.tcl
	mkdir -p ./build/impl/
	cd ./build/impl && $(VIVADO) $(VIVADO_OPTS) -source $(ABS_TOP)/../scripts/impl.tcl |& tee impl.log

impl: build/impl/$(TOP).bit
all: build/impl/$(TOP).bit

program: build/impl/$(TOP).bit $(ABS_TOP)/../scripts/program.tcl
	cd build/impl && $(VIVADO) $(VIVADO_OPTS) -source $(ABS_TOP)/../scripts/program.tcl

program-force:
	cd build/impl && $(VIVADO) $(VIVADO_OPTS) -source $(ABS_TOP)/../scripts/program.tcl

vivado: build
	cd build && nohup $(VIVADO) </dev/null >/dev/null 2>&1 &

lint:
	verilator -DABS_TOP=$(ABS_TOP) --lint-only --top-module $(TOP) $(RTL) -I$(ABS_TOP)/src/riscv_core $(ABS_TOP)/stubs/PLLE2_ADV.v $(ABS_TOP)/sim_models/BUFG.v

sim_build/compile_simlib/synopsys_sim.setup:
	mkdir -p sim_build/compile_simlib
	cd build/sim_build/compile_simlib && $(VIVADO) $(VIVADO_OPTS) -source $(ABS_TOP)/../scripts/compile_simlib.tcl

compile_simlib: sim_build/compile_simlib/synopsys_sim.setup

clean:
	rm -rf ./build

clean-sim:
	rm -rf *daidir sim/output.txt \
	sim/*.tb sim/*.daidir sim/csrc \
	sim/ucli.key sim/*.vpd sim/*.vcd \
	sim/*.tbi sim/*.fst sim/*.jou sim/*.log sim/*.out


.PHONY: setup synth impl program program-force vivado all clean %.tb
.PRECIOUS: sim/%.tb sim/%.tbi sim/%.fst sim/%.vpd
