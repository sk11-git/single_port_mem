/**
 * Single Port Memory Base Test
 * Base class for all SPM tests
 */

class single_port_mem_base_test;
    
    single_port_mem_env env;
    single_port_mem_config cfg;
    
    // Virtual interface
    virtual single_port_mem_if vif;
    
    function new(virtual single_port_mem_if vif);
        this.vif = vif;
        cfg = new();
        env = new(vif, cfg);
    endfunction
    
    // Setup test
    virtual task setup();
        $display("\n========== TEST SETUP ==========");
        env.build();
        env.connect();
    endtask
    
    // Run test
    virtual task run();
        $display("\n========== TEST RUN ==========");
        env.run();
        env.wait_for_completion();
    endtask
    
    // Teardown test
    virtual task teardown();
        $display("\n========== TEST TEARDOWN ==========");
        env.cleanup();
    endtask
    
    // Execute test
    task execute();
        setup();
        run();
        teardown();
    endtask
    
endclass
