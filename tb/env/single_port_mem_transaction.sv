/**
 * Single Port Memory Transaction
 * Defines the basic transaction for SPM testing
 */

class single_port_mem_transaction;
    
    // Transaction fields
    rand bit wr_en;                    // Write enable
    rand logic [63:0] addr;            // Address (supports up to 64-bit)
    rand logic [63:0] wr_data;         // Write data (supports up to 64-bit)
    logic [63:0] rd_data;              // Read data
    time timestamp;                    // Timestamp of transaction
    
    // Constraints
    constraint addr_constraint {
        addr < (1 << 10);              // Limit to 10-bit address (2K locations)
    }
    
    constraint data_constraint {
        wr_data < (1 << 32);           // Limit to 32-bit data
    }
    
    // Constructor
    function new();
        this.wr_en = 1'b0;
        this.addr = '0;
        this.wr_data = '0;
        this.rd_data = '0;
        this.timestamp = 0;
    endfunction
    
    // Copy function
    function single_port_mem_transaction copy();
        single_port_mem_transaction tr = new();
        tr.wr_en = this.wr_en;
        tr.addr = this.addr;
        tr.wr_data = this.wr_data;
        tr.rd_data = this.rd_data;
        tr.timestamp = this.timestamp;
        return tr;
    endfunction
    
    // Print function
    function void print(string prefix = "");
        $display("%s [TXN] wr_en=%b | addr=0x%0h | wr_data=0x%0h | rd_data=0x%0h | time=%0t",
                 prefix, wr_en, addr, wr_data, rd_data, timestamp);
    endfunction
    
    // Convert to string
    function string convert2string();
        return $sformatf("wr_en=%b addr=0x%h wr_data=0x%h rd_data=0x%h", 
                         wr_en, addr, wr_data, rd_data);
    endfunction
    
endclass
