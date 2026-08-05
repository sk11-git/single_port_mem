/**
 * Single Port Memory Generator
 * Generates random test transactions
 */

class single_port_mem_generator;
    
    mailbox gen2drv;
    single_port_mem_config cfg;
    
    int num_transactions;
    
    function new(mailbox gen2drv, single_port_mem_config cfg, int num_transactions);
        this.gen2drv = gen2drv;
        this.cfg = cfg;
        this.num_transactions = num_transactions;
    endfunction
    
    // Main generator loop
    task run();
        $display("[GENERATOR] Starting generator...");
        $display("[GENERATOR] Generating %0d transactions", num_transactions);
        
        for (int i = 0; i < num_transactions; i++) begin
            single_port_mem_transaction tr = new();
            
            if (!tr.randomize()) begin
                $display("[GENERATOR] ERROR: Randomization failed!");
            end
            
            gen2drv.put(tr);
        end
        
        $display("[GENERATOR] Finished generating transactions");
    endtask
    
    // Reset generator
    function void reset();
        gen2drv.flush();
    endfunction
    
endclass
