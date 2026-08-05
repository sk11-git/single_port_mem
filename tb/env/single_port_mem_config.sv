/**
 * Single Port Memory Test Configuration
 * Parameterizes the test environment with address/data widths
 */

class single_port_mem_config;
    
    // Memory parameters
    int unsigned addr_width = 10;
    int unsigned data_width = 32;
    
    // Test parameters
    int unsigned num_writes = 100;
    int unsigned num_reads = 100;
    int unsigned num_random_ops = 200;
    
    // Print configuration
    function void print_config();
        $display("\n===================== SPM Configuration =====================");
        $display("Address Width    : %0d bits (Memory size: %0d)", addr_width, 2**addr_width);
        $display("Data Width       : %0d bits", data_width);
        $display("Number of Writes : %0d", num_writes);
        $display("Number of Reads  : %0d", num_reads);
        $display("Random Operations: %0d", num_random_ops);
        $display("===========================================================");
    endfunction
    
endclass
