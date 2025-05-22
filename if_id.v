module if_id (
    input wire clk,
    input wire rst,
    input wire stall,                // Hazard detection signal (1 = freeze)
    input wire flush,                // Control hazard signal (1 = clear)
    input wire [31:0] PC_in,         // Incoming PC value from IF stage
    input wire [31:0] instruction_in, // Incoming instruction from IF stage
    output reg [31:0] PC_out,        // Output PC to ID stage
    output reg [31:0] instruction_out // Output instruction to ID stage
);

    // Initialize outputs to 0 (useful for simulation)
    initial begin
        PC_out = 0;
        instruction_out = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset pipeline register
            PC_out <= 0;
            instruction_out <= 0;
        end else if (flush) begin
            // Flush pipeline register (clear values)
            PC_out <= 0;
            instruction_out <= 0;
        end else if (!stall) begin
            // Update pipeline register if no stall
            PC_out <= PC_in;
            instruction_out <= instruction_in;
        end
        // If stall == 1, retain previous values (freeze pipeline)
    end

endmodule