/**
 * Single Port Memory Write Test - UVM
 * Runs write-only sequences
 */

class single_port_mem_write_test_uvm extends single_port_mem_test;
    `uvm_component_utils(single_port_mem_write_test_uvm)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        single_port_mem_write_sequence seq;
        
        `uvm_info(get_type_name(), $sformatf("\n========== WRITE TEST =========="), UVM_MEDIUM)
        
        phase.raise_objection(this);
        
        seq = single_port_mem_write_sequence::type_id::create("seq");
        seq.num_items = 256;
        seq.start(env.agent.sequencer);
        
        phase.drop_objection(this);
    endtask
    
endclass
