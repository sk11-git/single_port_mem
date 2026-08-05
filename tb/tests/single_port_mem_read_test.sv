/**
 * Single Port Memory Read Test
 * Tests read operations from memory
 */

class single_port_mem_read_test extends single_port_mem_base_test;
    
    function new(virtual single_port_mem_if vif);
        super.new(vif);
        cfg.num_reads = 256;
        cfg.num_writes = 128;
        cfg.num_random_ops = cfg.num_writes + cfg.num_reads;
    endfunction
    
    task setup();
        $display("\n========== READ TEST SETUP ==========");
        super.setup();
        $display("Configuration:");
        $display("  - Memory Size: %0d locations", 2**cfg.addr_width);
        $display("  - Data Width: %0d bits", cfg.data_width);
        $display("  - Write Operations: %0d", cfg.num_writes);
        $display("  - Read Operations: %0d", cfg.num_reads);
    endtask
    
    task run();
        $display("\n========== READ TEST RUN ==========");
        super.run();
    endtask
    
endclass
