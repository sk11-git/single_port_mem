/**
 * Single Port Memory Random Test
 * Tests random read/write operations
 */

class single_port_mem_random_test extends single_port_mem_base_test;
    
    function new(virtual single_port_mem_if vif);
        super.new(vif);
        cfg.num_random_ops = 500;
    endfunction
    
    task setup();
        $display("\n========== RANDOM TEST SETUP ==========");
        super.setup();
        $display("Configuration:");
        $display("  - Memory Size: %0d locations", 2**cfg.addr_width);
        $display("  - Data Width: %0d bits", cfg.data_width);
        $display("  - Random Operations: %0d", cfg.num_random_ops);
    endtask
    
    task run();
        $display("\n========== RANDOM TEST RUN ==========");
        super.run();
    endtask
    
endclass
