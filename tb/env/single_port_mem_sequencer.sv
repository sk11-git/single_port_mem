/**
 * Single Port Memory Sequencer
 * Controls and coordinates sequence execution
 */

class single_port_mem_sequencer extends uvm_sequencer #(single_port_mem_transaction);
    `uvm_component_utils(single_port_mem_sequencer)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), "Sequencer built", UVM_MEDIUM)
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(), "Sequencer connected", UVM_MEDIUM)
    endfunction
    
endclass
