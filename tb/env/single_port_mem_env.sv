/**
 * Single Port Memory Environment
 * Combines all UVM components
 */

class single_port_mem_env extends uvm_env;
    `uvm_component_utils(single_port_mem_env)
    
    single_port_mem_agent agent;
    single_port_mem_scoreboard scoreboard;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        agent = single_port_mem_agent::type_id::create("agent", this);
        scoreboard = single_port_mem_scoreboard::type_id::create("scoreboard", this);
        
        `uvm_info(get_type_name(), "Environment built", UVM_MEDIUM)
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        agent.item_collected_port.connect(scoreboard.analysis_export);
        
        `uvm_info(get_type_name(), "Environment connected", UVM_MEDIUM)
    endfunction
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info(get_type_name(), "Environment elaborated", UVM_MEDIUM)
    endfunction
    
endclass
