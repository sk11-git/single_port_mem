/**
 * Single Port Memory Stress Test
 * Tests memory under high transaction rates
 */

class single_port_mem_stress_test extends single_port_mem_base_test;
    
    function new(virtual single_port_mem_if vif);
        super.new(vif);
        cfg.num_random_ops = 1000;
    endfunction
    
    task setup();
        $display("\n========== STRESS TEST SETUP ==========");
        super.setup();
        $display("Configuration:");
        $display("  - Memory Size: %0d locations", 2**cfg.addr_width);
        $display("  - Data Width: %0d bits", cfg.data_width);
        $display("  - Total Operations: %0d (Stress)", cfg.num_random_ops);
    endtask
    
    task run();
        $display("\n========== STRESS TEST RUN ==========");
        super.run();
    endtask
    
endclass
