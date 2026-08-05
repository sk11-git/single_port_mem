# Single Port Memory Simulation Makefile

# Simulation tool (modelsim/questasim/vcs/xsim)
SIM_TOOL ?= modelsim

# Directories
RTL_DIR = ../rtl
TB_DIR = ../tb
RESULTS_DIR = results

# Source files
RTL_SOURCES = $(RTL_DIR)/single_port_mem.v
TB_SOURCES = $(TB_DIR)/top_tb.sv

# Compilation flags
VLOG_FLAGS = -quiet
VSIM_FLAGS = -quiet -novopt

# Test target
TEST ?= random

# Targets
.PHONY: all clean compile sim help

all: clean compile sim

help:
	@echo "=========================================="
	@echo "  Single Port Memory Simulation           "
	@echo "=========================================="
	@echo ""
	@echo "Available targets:"
	@echo "  make compile      - Compile sources"
	@echo "  make sim          - Run simulation (TEST=random|write|read|stress)"
	@echo "  make all          - Clean, compile, and simulate"
	@echo "  make clean        - Remove generated files"
	@echo "  make help         - Display this help"
	@echo ""
	@echo "Example:"
	@echo "  make all TEST=random"
	@echo "  make sim TEST=write"
	@echo ""

compile:
	@echo "[COMPILE] Compiling sources..."
	@mkdir -p $(RESULTS_DIR)
	vlog $(VLOG_FLAGS) -work $(RESULTS_DIR)/work $(RTL_SOURCES) $(TB_SOURCES)
	@echo "[COMPILE] Compilation complete!"

sim:
	@echo "[SIM] Running $(TEST) test..."
	vsim $(VSIM_FLAGS) -work $(RESULTS_DIR)/work \
		+TEST=$(TEST) \
		top_tb
	@echo "[SIM] Simulation complete!"

sim-dump:
	@echo "[SIM] Running $(TEST) test with waveform dump..."
	vsim $(VSIM_FLAGS) -work $(RESULTS_DIR)/work \
		+TEST=$(TEST) \
		+DUMP \
		top_tb
	@echo "[SIM] Simulation complete! Check spm_sim.vcd"

clean:
	@echo "[CLEAN] Removing simulation files..."
	rm -rf $(RESULTS_DIR)
	rm -f spm_sim.vcd *.log *.history
	@echo "[CLEAN] Done!"
