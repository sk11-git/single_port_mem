/**
 * Single Port Memory UVM Monitor
 * Collects transactions from interface
 */

class single_port_mem_monitor_uvm extends uvm_monitor;
    `uvm_component_utils(single_port_mem_monitor_uvm)
    
    virtual single_port_mem_if vif;
    uvm_analysis_port #(single_port_mem_transaction) item_collected_port;
    
    single_port_mem_transaction collected_item;
    int num_collected = 0;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), "Monitor built", UVM_MEDIUM)
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Monitor run_phase started", UVM_MEDIUM)
        
        forever begin
            collect_transaction();
        end
    endtask
    
    virtual task collect_transaction();
        @(posedge vif.clk);
        
        collected_item = single_port_mem_transaction::type_id::create("collected_item");
        collected_item.wr_en = vif.wr_en;
        collected_item.addr = vif.addr;
        collected_item.wr_data = vif.wr_data;
        collected_item.rd_data = vif.rd_data;
        collected_item.timestamp = $time;
        
        item_collected_port.write(collected_item);
        num_collected++;
        
        `uvm_info(get_type_name(), $sformatf("Collected %0d: %s", num_collected, collected_item.convert2string()), UVM_LOW)
    endtask
    
endclass
