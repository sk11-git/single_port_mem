/**
 * Single Port Memory Write Sequence
 * Generates write-only transactions
 */

class single_port_mem_write_sequence extends single_port_mem_sequence;
    `uvm_object_utils(single_port_mem_write_sequence)
    
    function new(string name = "single_port_mem_write_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        `uvm_info(get_type_name(), $sformatf("Starting WRITE sequence with %0d items", num_items), UVM_MEDIUM)
        
        for (int i = 0; i < num_items; i++) begin
            req = single_port_mem_transaction::type_id::create("req");
            start_item(req);
            
            if (!req.randomize() with { wr_en == 1'b1; }) begin
                `uvm_error(get_type_name(), "Randomization failed")
            end
            
            `uvm_info(get_type_name(), req.convert2string(), UVM_LOW)
            finish_item(req);
        end
        
        `uvm_info(get_type_name(), "WRITE sequence completed", UVM_MEDIUM)
    endtask
    
endclass
