/**
 * Single Port Memory Environment
 * Combines all verification components
 */

class single_port_mem_env;
    
    single_port_mem_config cfg;
    single_port_mem_generator gen;
    single_port_mem_driver drv;
    single_port_mem_monitor mon;
    single_port_mem_scoreboard sb;
    
    virtual single_port_mem_if vif;
    
    mailbox gen2drv;
    mailbox mon2sb;
    
    // Constructor
    function new(virtual single_port_mem_if vif, single_port_mem_config cfg);
        this.vif = vif;
        this.cfg = cfg;
        
        // Create mailboxes
        gen2drv = new();
        mon2sb = new();
        
        // Create components
        gen = new(gen2drv, cfg, cfg.num_random_ops);
        drv = new(vif, gen2drv, cfg.addr_width, cfg.data_width);
        mon = new(vif, mon2sb, cfg.addr_width, cfg.data_width);
        sb = new(mon2sb);
    endfunction
    
    // Build environment
    function void build();
        $display("[ENV] Building environment...");
        cfg.print_config();
    endfunction
    
    // Connect environment
    function void connect();
        $display("[ENV] Connecting components...");
    endfunction
    
    // Run environment
    task run();
        $display("[ENV] Starting environment...");
        
        fork
            gen.run();
            drv.run();
            mon.run();
            sb.run();
        join_none
    endtask
    
    // Wait for all transactions to complete
    task wait_for_completion();
        int timeout = 100000;  // cycles
        int cycles = 0;
        
        $display("[ENV] Waiting for test completion...");
        
        while (cycles < timeout && (gen2drv.num() > 0 || mon2sb.num() > 0)) begin
            @(posedge vif.clk);
            cycles++;
        end
        
        $display("[ENV] Test completed in %0d cycles", cycles);
    endtask
    
    // Cleanup
    task cleanup();
        $display("[ENV] Cleaning up...");
        sb.print_statistics();
    endtask
    
endclass
