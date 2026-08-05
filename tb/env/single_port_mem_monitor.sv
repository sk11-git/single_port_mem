/**
 * Single Port Memory Monitor
 * Observes and collects transactions from the DUT
 */

class single_port_mem_monitor;
    
    virtual single_port_mem_if vif;
    mailbox mon2sb;
    
    int addr_width;
    int data_width;
    int num_transactions;
    
    function new(virtual single_port_mem_if vif, mailbox mon2sb, int addr_width, int data_width);
        this.vif = vif;
        this.mon2sb = mon2sb;
        this.addr_width = addr_width;
        this.data_width = data_width;
        this.num_transactions = 0;
    endfunction
    
    // Main monitor loop
    task run();
        $display("[MONITOR] Starting monitor...");
        
        forever begin
            collect_transaction();
        end
    endtask
    
    // Collect a transaction
    task collect_transaction();
        single_port_mem_transaction tr;
        
        @(posedge vif.clk);
        
        tr = new();
        tr.wr_en = vif.wr_en;
        tr.addr = vif.addr;
        tr.wr_data = vif.wr_data;
        tr.rd_data = vif.rd_data;
        tr.timestamp = $time;
        
        mon2sb.put(tr);
        num_transactions++;
        
        $display("[MONITOR] Transaction #%0d: wr_en=%b, addr=0x%0h, wr_data=0x%0h, rd_data=0x%0h @ %0t",
                 num_transactions, tr.wr_en, tr.addr, tr.wr_data, tr.rd_data, tr.timestamp);
    endtask
    
    // Get transaction count
    function int get_num_transactions();
        return num_transactions;
    endfunction
    
endclass
