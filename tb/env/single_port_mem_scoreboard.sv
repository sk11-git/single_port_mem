/**
 * Single Port Memory Scoreboard
 * Checks expected vs actual behavior
 */

class single_port_mem_scoreboard;
    
    mailbox mon2sb;
    
    // Memory model
    associative array bit [63:0] mem_model [logic [63:0]];
    
    // Statistics
    int num_writes = 0;
    int num_reads = 0;
    int num_errors = 0;
    int num_matches = 0;
    
    // Track pending writes for synchronization
    logic [63:0] last_written_addr;
    logic [63:0] last_written_data;
    int write_pending = 0;
    
    function new(mailbox mon2sb);
        this.mon2sb = mon2sb;
    endfunction
    
    // Main scoreboard loop
    task run();
        single_port_mem_transaction tr;
        
        $display("[SCOREBOARD] Starting scoreboard...");
        
        forever begin
            mon2sb.get(tr);
            check_transaction(tr);
        end
    endtask
    
    // Check a transaction
    task check_transaction(single_port_mem_transaction tr);
        bit error = 1'b0;
        logic [63:0] expected_data;
        
        if (tr.wr_en) begin
            // Write operation - update model
            mem_model[tr.addr] = tr.wr_data;
            last_written_addr = tr.addr;
            last_written_data = tr.wr_data;
            write_pending = 1;
            num_writes++;
            
            $display("[SCOREBOARD] WRITE  >> addr=0x%0h data=0x%0h", tr.addr, tr.wr_data);
        end else begin
            // Read operation - check against model
            num_reads++;
            
            // For read immediately after write to same address, data is old
            // (since write is synchronous, read shows previous value)
            if (mem_model.exists(tr.addr)) begin
                expected_data = mem_model[tr.addr];
            end else begin
                expected_data = '0;  // Uninitialized memory reads as 0
            end
            
            if (tr.rd_data === expected_data) begin
                $display("[SCOREBOARD] READ OK >> addr=0x%0h expected=0x%0h got=0x%0h", 
                         tr.addr, expected_data, tr.rd_data);
                num_matches++;
            end else begin
                $display("[SCOREBOARD] ERROR   >> addr=0x%0h expected=0x%0h got=0x%0h", 
                         tr.addr, expected_data, tr.rd_data);
                error = 1'b1;
                num_errors++;
            end
        end
        
        write_pending = 0;
    endtask
    
    // Print statistics
    function void print_statistics();
        $display("\n");
        $display("=========== SCOREBOARD STATISTICS ===========");
        $display("Total Writes    : %0d", num_writes);
        $display("Total Reads     : %0d", num_reads);
        $display("Matched Reads   : %0d", num_matches);
        $display("Mismatched Reads: %0d", num_errors);
        $display("============================================");
        
        if (num_errors == 0 && (num_writes + num_reads) > 0) begin
            $display("           *** TEST PASSED ***");
        end else if (num_errors > 0) begin
            $display("           *** TEST FAILED ***");
        end
        $display("\n");
    endfunction
    
endclass
