/**
 * Single Port Memory Scoreboard
 * Verifies correctness of memory operations
 */

class single_port_mem_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(single_port_mem_scoreboard)
    
    uvm_analysis_imp #(single_port_mem_transaction, single_port_mem_scoreboard) analysis_export;
    
    // Memory model
    bit [63:0] mem_model[logic [63:0]];
    
    // Statistics
    int unsigned num_writes = 0;
    int unsigned num_reads = 0;
    int unsigned num_errors = 0;
    int unsigned num_matches = 0;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_export = new("analysis_export", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), "Scoreboard built", UVM_MEDIUM)
    endfunction
    
    virtual function void write(single_port_mem_transaction tr);
        bit [63:0] expected_data;
        
        if (tr.wr_en) begin
            // Write operation
            mem_model[tr.addr] = tr.wr_data;
            num_writes++;
            `uvm_info(get_type_name(), $sformatf("WRITE: addr=0x%0h data=0x%0h", tr.addr, tr.wr_data), UVM_LOW)
        end else begin
            // Read operation
            num_reads++;
            
            if (mem_model.exists(tr.addr)) begin
                expected_data = mem_model[tr.addr];
            end else begin
                expected_data = '0;
            end
            
            if (tr.rd_data === expected_data) begin
                `uvm_info(get_type_name(), $sformatf("READ OK: addr=0x%0h expected=0x%0h got=0x%0h", tr.addr, expected_data, tr.rd_data), UVM_LOW)
                num_matches++;
            end else begin
                `uvm_error(get_type_name(), $sformatf("READ ERROR: addr=0x%0h expected=0x%0h got=0x%0h", tr.addr, expected_data, tr.rd_data))
                num_errors++;
            end
        end
    endfunction
    
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        
        `uvm_info(get_type_name(), $sformatf("\n================== SCOREBOARD REPORT ==================", ), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("Total Writes    : %0d", num_writes), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("Total Reads     : %0d", num_reads), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("Matched Reads   : %0d", num_matches), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("Mismatched Reads: %0d", num_errors), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("========================================================", ), UVM_LOW)
        
        if (num_errors == 0 && (num_writes + num_reads) > 0) begin
            `uvm_info(get_type_name(), "*** TEST PASSED ***", UVM_LOW)
        end else if (num_errors > 0) begin
            `uvm_error(get_type_name(), "*** TEST FAILED ***")
        end
    endfunction
    
endclass
