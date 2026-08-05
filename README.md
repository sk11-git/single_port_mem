# Single Port Memory Verification Environment

A comprehensive UVM-inspired verification environment for a single-port memory module implemented in SystemVerilog.

## 🚀 Quick Start

To run the verification immediately, just execute these commands:

```bash
# Clone the repository
git clone https://github.com/sk11-git/single_port_mem.git
cd single_port_mem

# Navigate to simulation directory
cd sim/

# Run tests (choose one)
make all TEST=random      # Run 500 random operations
make all TEST=write       # Run 256 write operations
make all TEST=read        # Run 128 writes + 256 reads
make all TEST=stress      # Run 1000 stress operations

# Optional: View waveforms
make sim-dump TEST=random
```

That's it! The simulation will run and display results.

---

## Directory Structure

```
single_port_mem/
├── rtl/
│   └── single_port_mem.v          # RTL: Single port memory module
├── tb/
│   ├── top_tb.sv                  # Top-level testbench
│   ├── env/
│   │   ├── single_port_mem_if.sv           # Interface definition
│   │   ├── single_port_mem_config.sv       # Test configuration
│   │   ├── single_port_mem_transaction.sv  # Transaction class
│   │   ├── single_port_mem_driver.sv       # Driver component
│   │   ├── single_port_mem_monitor.sv      # Monitor component
│   │   ├── single_port_mem_scoreboard.sv   # Scoreboard component
│   │   ├── single_port_mem_generator.sv    # Generator component
│   │   └── single_port_mem_env.sv          # Environment class
│   └── tests/
│       ├── single_port_mem_base_test.sv    # Base test class
│       ├── single_port_mem_random_test.sv  # Random test
│       ├── single_port_mem_write_test.sv   # Write test
│       ├── single_port_mem_read_test.sv    # Read test
│       └── single_port_mem_stress_test.sv  # Stress test
├── sim/
│   └── Makefile                   # Simulation makefile
└── README.md                      # This file
```

## RTL Specifications

### Module: `single_port_mem`

**Parameters:**
- `ADDR_WIDTH` (default: 10) - Address bus width (2^10 = 1K locations)
- `DATA_WIDTH` (default: 32) - Data bus width in bits

**Ports:**
- `clk` - Clock input
- `rst_n` - Active-low asynchronous reset
- `wr_en` - Write enable (high = write, low = read)
- `addr[ADDR_WIDTH-1:0]` - Address bus
- `wr_data[DATA_WIDTH-1:0]` - Write data input
- `rd_data[DATA_WIDTH-1:0]` - Read data output (combinational)

**Behavior:**
- **Write:** Synchronous write on `wr_en` high and rising edge of `clk`
- **Read:** Asynchronous combinational read of addressed location

## Verification Environment Components

### 1. **Interface** (`single_port_mem_if.sv`)
- Defines the interface between testbench and DUT
- Includes modports for testbench and DUT
- Provides clocking blocks for synchronized access

### 2. **Transaction** (`single_port_mem_transaction.sv`)
- Basic transaction class with randomizable fields
- Constraints for address and data width
- Copy, print, and convert-to-string methods

### 3. **Generator** (`single_port_mem_generator.sv`)
- Generates random transactions
- Sends transactions to driver via mailbox

### 4. **Driver** (`single_port_mem_driver.sv`)
- Receives transactions from generator
- Drives stimulus to DUT via interface
- Provides detailed logging

### 5. **Monitor** (`single_port_mem_monitor.sv`)
- Observes all transactions on the interface
- Collects transactions for scoreboard analysis
- Provides transaction statistics

### 6. **Scoreboard** (`single_port_mem_scoreboard.sv`)
- Maintains expected memory model
- Verifies read data against model
- Reports mismatches and statistics

### 7. **Configuration** (`single_port_mem_config.sv`)
- Centralizes test configuration
- Parameterizes memory size and test stimulus
- Provides configuration print function

### 8. **Environment** (`single_port_mem_env.sv`)
- Instantiates all components
- Manages mailbox connections
- Coordinates component execution

## Test Cases

### 1. **Random Test** (`single_port_mem_random_test.sv`)
- Executes 500 random read/write transactions
- Good for general coverage and stress testing
- Run: `make all TEST=random`

### 2. **Write Test** (`single_port_mem_write_test.sv`)
- Executes 256 sequential write operations
- Verifies write functionality with address and data variations
- Run: `make all TEST=write`

### 3. **Read Test** (`single_port_mem_read_test.sv`)
- Executes 128 writes followed by 256 reads
- Verifies correct read-back of written data
- Run: `make all TEST=read`

### 4. **Stress Test** (`single_port_mem_stress_test.sv`)
- Executes 1000 random operations
- Tests memory under high transaction rates
- Run: `make all TEST=stress`

## Running Simulations

### Prerequisites
- SystemVerilog simulator (ModelSim, QuestaSim, VCS, or Xsim)
- Verilog compiler

### All Available Commands

```bash
cd sim/

# Show help menu
make help

# Run default (random) test
make all

# Run specific test - CHOOSE ONE:
make all TEST=random      # 500 random operations
make all TEST=write       # 256 write operations
make all TEST=read        # 128 writes + 256 reads
make all TEST=stress      # 1000 stress operations

# Compile only (without running)
make compile

# Run simulation with already compiled files
make sim TEST=random

# Run with waveform dump (creates spm_sim.vcd)
make sim-dump TEST=random

# Clean all generated files
make clean
```

### Quick Examples

**Example 1: Run Random Test**
```bash
cd sim/
make all TEST=random
```

**Example 2: Run Write Test with Waveform**
```bash
cd sim/
make sim-dump TEST=write
gtkwave spm_sim.vcd &
```

**Example 3: Run All Tests Sequentially**
```bash
cd sim/
make all TEST=random
make all TEST=write
make all TEST=read
make all TEST=stress
```

**Example 4: Clean and Re-run**
```bash
cd sim/
make clean
make all TEST=random
```

## Waveform Viewing

After running `make sim-dump`, view the generated waveform:

```bash
# With ModelSim
vsim -view spm_sim.vcd

# Or use your preferred waveform viewer
gtkwave spm_sim.vcd &
```

## Expected Output

Each test produces detailed output showing:

1. **Configuration**: Memory parameters and test settings
2. **Transactions**: Driver stimulus and Monitor observations
3. **Scoreboard Results**: Read data verification and error reporting
4. **Statistics**: Total writes, reads, matches, and any mismatches

Example output:
```
===================== SPM Configuration =====================
Address Width    : 10 bits (Memory size: 1024)
Data Width       : 32 bits
Number of Writes : 100
Number of Reads  : 100
Random Operations: 200
===========================================================

[GENERATOR] Starting generator...
[GENERATOR] Generating 200 transactions
[DRIVER] Starting driver...
[MONITOR] Starting monitor...
[SCOREBOARD] Starting scoreboard...

[DRIVER] Writing to addr=0x1a2, data=0x5d4c3f12
[MONITOR] Transaction #1: wr_en=1, addr=0x1a2, wr_data=0x5d4c3f12, rd_data=0x00000000

[SCOREBOARD] WRITE  >> addr=0x1a2 data=0x5d4c3f12
[SCOREBOARD] READ OK >> addr=0x15f expected=0x3c2a1b0d got=0x3c2a1b0d

=========== SCOREBOARD STATISTICS ===========
Total Writes    : 100
Total Reads     : 100
Matched Reads   : 100
Mismatched Reads: 0
============================================
           *** TEST PASSED ***
```

## Customization

### Adding New Tests

Create a new test class in `tb/tests/`:

```systemverilog
class single_port_mem_custom_test extends single_port_mem_base_test;
    
    function new(virtual single_port_mem_if vif);
        super.new(vif);
        cfg.num_random_ops = 300;
        // Set other configuration parameters
    endfunction
    
    task setup();
        $display("\n========== CUSTOM TEST SETUP ==========");
        super.setup();
        // Additional setup
    endtask
    
    task run();
        $display("\n========== CUSTOM TEST RUN ==========");
        super.run();
    endtask
    
endclass
```

Then update `tb/top_tb.sv` to include and instantiate the new test.

### Modifying Memory Parameters

Edit the localparam values in `tb/top_tb.sv`:

```systemverilog
localparam ADDR_WIDTH = 12;  // 4K locations instead of 1K
localparam DATA_WIDTH = 64;  // 64-bit data instead of 32-bit
```

## Verification Coverage

Current environment provides:

- ✓ Directed write operations
- ✓ Directed read operations
- ✓ Random read/write mix
- ✓ Address space coverage
- ✓ Data pattern coverage
- ✓ Synchronization verification
- ✓ Stress testing
- ✓ Error detection via scoreboard

## Known Limitations

1. Current environment does not implement formal property-based verification
2. Coverage collection is not implemented (can be added via simulator-specific code)
3. Protocol checking is basic (can be extended with more assertions)

## Future Enhancements

- [ ] Add coverage collection
- [ ] Add constrained-random generation with coverage-driven tests
- [ ] Add assertion-based verification
- [ ] Add power consumption monitoring
- [ ] Add performance analysis
- [ ] Integration with formal verification tools
- [ ] Add regression test suite
- [ ] Add mixed-language (Verilog/SystemVerilog/VHDL) support

## License

This verification environment is provided as-is for educational and development purposes.

## Contact & Support

For issues, questions, or suggestions, please open an issue in the repository.
