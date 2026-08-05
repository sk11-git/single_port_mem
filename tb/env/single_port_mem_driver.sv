/**
 * Single Port Memory Driver
 * Responsible for driving stimulus to the DUT
 */

class single_port_mem_driver;
    
    virtual single_port_mem_if vif;
    mailbox gen2drv;
    
    int addr_width;
    int data_width;
    
    function new(virtual single_port_mem_if vif, mailbox gen2drv, int addr_width, int data_width);
        this.vif = vif;
        this.gen2drv = gen2drv;
        this.addr_width = addr_width;
        this.data_width = data_width;
    endfunction
    
    // Main driver loop
    task run();
        single_port_mem_transaction tr;
        
        $display("[DRIVER] Starting driver...");
        
        forever begin
            gen2drv.get(tr);
            drive_transaction(tr);
        end
    endtask
    
    // Drive a single transaction
    task drive_transaction(single_port_mem_transaction tr);
        @(posedge vif.clk);
        
        vif.wr_en <= tr.wr_en;
        vif.addr <= tr.addr;
        vif.wr_data <= tr.wr_data;
        
        if (tr.wr_en) begin
            $display("[DRIVER] Writing to addr=0x%0h, data=0x%0h", tr.addr, tr.wr_data);
        end else begin
            $display("[DRIVER] Reading from addr=0x%0h", tr.addr);
        end
    endtask
    
endclass
