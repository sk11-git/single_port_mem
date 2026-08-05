/**
 * Single Port Memory Top Testbench
 * Top-level testbench for SPM verification
 */

`timescale 1ns/1ps

// Import packages/defines
`include "tb/env/single_port_mem_transaction.sv"
`include "tb/env/single_port_mem_config.sv"
`include "tb/env/single_port_mem_if.sv"
`include "tb/env/single_port_mem_driver.sv"
`include "tb/env/single_port_mem_monitor.sv"
`include "tb/env/single_port_mem_scoreboard.sv"
`include "tb/env/single_port_mem_generator.sv"
`include "tb/env/single_port_mem_env.sv"
`include "tb/tests/single_port_mem_base_test.sv"
`include "tb/tests/single_port_mem_random_test.sv"
`include "tb/tests/single_port_mem_write_test.sv"
`include "tb/tests/single_port_mem_read_test.sv"
`include "tb/tests/single_port_mem_stress_test.sv"

module top_tb;
    
    // Parameters
    localparam ADDR_WIDTH = 10;
    localparam DATA_WIDTH = 32;
    
    // Clock and reset
    logic clk;
    logic rst_n;
    
    // Clock generation (50MHz)
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;  // 20ns period = 50MHz
    end
    
    // Reset generation
    initial begin
        rst_n = 1'b0;
        #100 rst_n = 1'b1;  // Release reset after 100ns
    end
    
    // Interface instantiation
    single_port_mem_if #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) 
        spm_if (clk, rst_n);
    
    // DUT instantiation
    single_port_mem #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(spm_if.clk),
        .rst_n(spm_if.rst_n),
        .wr_en(spm_if.wr_en),
        .addr(spm_if.addr),
        .wr_data(spm_if.wr_data),
        .rd_data(spm_if.rd_data)
    );
    
    // Test selection
    initial begin
        single_port_mem_base_test test;
        string test_name;
        
        // Get test name from command line, default to random
        if (!$value$plusargs("TEST=%s", test_name)) begin
            test_name = "random";
        end
        
        $display("\n");
        $display("=====================================");
        $display("  Single Port Memory Verification   ");
        $display("=====================================");
        $display("Running Test: %s", test_name);
        $display("=====================================\n");
        
        // Instantiate appropriate test
        case (test_name)
            "random": begin
                test = new single_port_mem_random_test(spm_if);
            end
            "write": begin
                test = new single_port_mem_write_test(spm_if);
            end
            "read": begin
                test = new single_port_mem_read_test(spm_if);
            end
            "stress": begin
                test = new single_port_mem_stress_test(spm_if);
            end
            default: begin
                $display("Unknown test: %s. Using random test.", test_name);
                test = new single_port_mem_random_test(spm_if);
            end
        endcase
        
        // Wait for reset to complete
        @(posedge rst_n);
        repeat(5) @(posedge clk);
        
        // Execute test
        test.execute();
        
        // Print summary
        $display("\n");
        $display("=====================================");
        $display("  Test Execution Completed           ");
        $display("=====================================\n");
        
        $finish;
    end
    
    // Timeout mechanism
    initial begin
        #1000000;
        $display("\n[TIMEOUT] Simulation exceeded maximum time limit!");
        $finish;
    end
    
    // Waveform dumping (optional)
    initial begin
        if ($test$plusargs("DUMP")) begin
            $dumpfile("spm_sim.vcd");
            $dumpvars(0, top_tb);
        end
    end
    
endmodule
