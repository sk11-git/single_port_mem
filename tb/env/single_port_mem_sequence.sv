/**
 * Single Port Memory Sequence
 * Defines the base sequence for test stimulus generation
 */

class single_port_mem_sequence extends uvm_sequence #(single_port_mem_transaction);
    `uvm_object_utils(single_port_mem_sequence)
    
    // Configuration
    int unsigned num_items = 100;
    
    function new(string name = "single_port_mem_sequence");
        super.new(name);
    endfunction
    
    // Body task - generates transactions
    virtual task body();
        `uvm_info(get_type_name(), $sformatf("Starting sequence with %0d items", num_items), UVM_MEDIUM)
        
        for (int i = 0; i < num_items; i++) begin
            req = single_port_mem_transaction::type_id::create("req");
            start_item(req);
            
            if (!req.randomize()) begin
                `uvm_error(get_type_name(), "Randomization failed")
            end
            
            `uvm_info(get_type_name(), req.convert2string(), UVM_LOW)
            finish_item(req);
        end
        
        `uvm_info(get_type_name(), "Sequence completed", UVM_MEDIUM)
    endtask
    
endclass
