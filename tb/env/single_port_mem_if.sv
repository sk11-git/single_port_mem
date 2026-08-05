/**
 * Single Port Memory Interface
 * Defines the interface between testbench and DUT
 */

interface single_port_mem_if #(
    parameter ADDR_WIDTH = 10,
    parameter DATA_WIDTH = 32
)(
    input clk,
    input rst_n
);
    
    // Interface signals
    logic wr_en;
    logic [ADDR_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] wr_data;
    logic [DATA_WIDTH-1:0] rd_data;
    
    // Modport for testbench
    modport testbench (
        input clk, rst_n,
        output wr_en, addr, wr_data,
        input rd_data
    );
    
    // Modport for DUT
    modport dut (
        input clk, rst_n, wr_en, addr, wr_data,
        output rd_data
    );
    
    // Clocking block for testbench
    clocking cb @(posedge clk);
        default input #1 output #1;
        output wr_en, addr, wr_data;
        input rd_data;
    endclocking
    
endinterface
