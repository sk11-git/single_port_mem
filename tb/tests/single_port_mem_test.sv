/**
 * Single Port Memory UVM Test Base
 * Base test class for all UVM tests
 */

class single_port_mem_test extends uvm_test;
    `uvm_component_utils(single_port_mem_test)
    
    single_port_mem_env_uvm env;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        env = single_port_mem_env_uvm::type_id::create("env", this);
        
        `uvm_info(get_type_name(), "Test built", UVM_MEDIUM)
    endfunction
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info(get_type_name(), $sformatf("\n========== Test: %s ==========", get_type_name()), UVM_MEDIUM)
        uvm_top.print_topology();
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Test run_phase started", UVM_MEDIUM)
    endtask
    
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_type_name(), "Test completed", UVM_MEDIUM)
    endfunction
    
endclass
