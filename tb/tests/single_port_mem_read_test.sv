/**
 * Single Port Memory Read Test - UVM
 * Runs write then read sequences
 */

class single_port_mem_read_test extends single_port_mem_base_test;
    `uvm_component_utils(single_port_mem_read_test)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        single_port_mem_write_sequence write_seq;
        single_port_mem_read_sequence read_seq;
        
        `uvm_info(get_type_name(), $sformatf("\n========== READ TEST =========="), UVM_MEDIUM)
        
        phase.raise_objection(this);
        
        // First: Write data
        write_seq = single_port_mem_write_sequence::type_id::create("write_seq");
        write_seq.num_items = 128;
        write_seq.start(env.agent.sequencer);
        
        // Then: Read data
        read_seq = single_port_mem_read_sequence::type_id::create("read_seq");
        read_seq.num_items = 128;
        read_seq.start(env.agent.sequencer);
        
        phase.drop_objection(this);
    endtask
    
endclass
