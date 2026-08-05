/**
 * Single Port Memory Agent
 * Combines sequencer, driver, and monitor
 */

class single_port_mem_agent extends uvm_agent;
    `uvm_component_utils(single_port_mem_agent)
    
    single_port_mem_sequencer sequencer;
    single_port_mem_driver driver;
    single_port_mem_monitor monitor;
    
    virtual single_port_mem_if vif;
    
    uvm_analysis_port #(single_port_mem_transaction) item_collected_port;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if (!uvm_config_db #(virtual single_port_mem_if)::get(this, "", "vif", vif))
            `uvm_fatal(get_type_name(), "Virtual interface not found")
        
        sequencer = single_port_mem_sequencer::type_id::create("sequencer", this);
        driver = single_port_mem_driver::type_id::create("driver", this);
        monitor = single_port_mem_monitor::type_id::create("monitor", this);
        
        `uvm_info(get_type_name(), "Agent built", UVM_MEDIUM)
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        driver.seq_item_port.connect(sequencer.seq_item_export);
        monitor.item_collected_port.connect(item_collected_port);
        
        driver.vif = vif;
        monitor.vif = vif;
        
        `uvm_info(get_type_name(), "Agent connected", UVM_MEDIUM)
    endfunction
    
endclass
