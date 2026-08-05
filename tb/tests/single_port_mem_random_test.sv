/**
 * Single Port Memory Random Test - UVM
 * Runs random read/write sequences
 */

class single_port_mem_random_test extends single_port_mem_base_test;
    `uvm_component_utils(single_port_mem_random_test)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        single_port_mem_sequence seq;
        
        `uvm_info(get_type_name(), $sformatf("\n========== RANDOM TEST =========="), UVM_MEDIUM)
        
        phase.raise_objection(this);
        
        seq = single_port_mem_sequence::type_id::create("seq");
        seq.num_items = 100;
        seq.start(env.agent.sequencer);
        
        phase.drop_objection(this);
    endtask
    
endclass
