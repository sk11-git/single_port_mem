/**
 * Single Port Memory Driver
 * Drives transactions to DUT
 */

class single_port_mem_driver extends uvm_driver #(single_port_mem_transaction);
    `uvm_component_utils(single_port_mem_driver)
    
    virtual single_port_mem_if vif;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), "Driver built", UVM_MEDIUM)
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Driver run_phase started", UVM_MEDIUM)
        
        forever begin
            seq_item_port.get_next_item(req);
            drive_transaction(req);
            seq_item_port.item_done();
        end
    endtask
    
    virtual task drive_transaction(single_port_mem_transaction tr);
        @(posedge vif.clk);
        
        vif.wr_en <= tr.wr_en;
        vif.addr <= tr.addr;
        vif.wr_data <= tr.wr_data;
        
        if (tr.wr_en) begin
            `uvm_info(get_type_name(), $sformatf("WRITE: addr=0x%0h data=0x%0h", tr.addr, tr.wr_data), UVM_LOW)
        end else begin
            `uvm_info(get_type_name(), $sformatf("READ: addr=0x%0h", tr.addr), UVM_LOW)
        end
    endtask
    
endclass
