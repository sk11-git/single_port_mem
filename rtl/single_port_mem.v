/**
 * Single Port Memory Module
 * Description: A parameterizable single port memory with read/write capability
 * 
 * Features:
 *  - Configurable address width and data width
 *  - Single port for read and write operations
 *  - Synchronous write operation
 *  - Asynchronous read operation
 *  - Write enable control
 */

module single_port_mem #(
    parameter ADDR_WIDTH = 10,    // Number of address bits (1KB default: 2^10)
    parameter DATA_WIDTH = 32     // Width of data bus in bits
)(
    input clk,                                    // Clock signal
    input rst_n,                                  // Active low reset
    input wr_en,                                  // Write enable
    input [ADDR_WIDTH-1:0] addr,                  // Address bus
    input [DATA_WIDTH-1:0] wr_data,               // Write data
    output [DATA_WIDTH-1:0] rd_data               // Read data (combinational)
);

    // Memory array
    reg [DATA_WIDTH-1:0] mem [0:(2**ADDR_WIDTH)-1];
    
    // Read operation (combinational/asynchronous)
    assign rd_data = mem[addr];
    
    // Write operation (synchronous)
    always @(posedge clk) begin
        if (!rst_n) begin
            // Optional: Initialize memory on reset
            // This can be resource intensive for large memories
        end else if (wr_en) begin
            mem[addr] <= wr_data;
        end
    end

endmodule
