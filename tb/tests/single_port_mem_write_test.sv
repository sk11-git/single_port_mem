/**
 * Single Port Memory Write Test
 * Tests sequential write operations
 */

class single_port_mem_write_test extends single_port_mem_base_test;
    
    function new(virtual single_port_mem_if vif);
        super.new(vif);
        cfg.num_writes = 256;
        cfg.num_random_ops = cfg.num_writes;
    endfunction
    
    task setup();
        $display("\n========== WRITE TEST SETUP ==========");
        super.setup();
        $display("Configuration:");
        $display("  - Memory Size: %0d locations", 2**cfg.addr_width);
        $display("  - Data Width: %0d bits", cfg.data_width);
        $display("  - Write Operations: %0d", cfg.num_writes);
    endtask
    
    task run();
        $display("\n========== WRITE TEST RUN ==========");
        super.run();
    endtask
    
endclass
