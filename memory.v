module memory (
    input wire clk,                   // Clock input (for synchronous reads)
    input wire [31:0] address,         // Address input
    output reg [31:0] instruction      // Instruction output
);
    
    // ROM to store instructions
    reg [31:0] ROM [0:255]; // 256 x 32-bit memory

    initial begin
        // Load instructions from a file (e.g., "instructions.mem")
        $readmemh("instructions.mem", ROM);
    end

    always @(posedge clk) begin
        // Fetch instruction from ROM (word-aligned access)
        instruction <= ROM[address[9:2]];
    end

endmodule
