module hazard_detection (
    input wire [4:0] rs1, rs2,        // Source registers in ID stage
    input wire [4:0] ex_rd,           // Destination register in EX stage
    input wire MemRead_EX,            // Load instruction in EX stage
    output reg stall                  // Stall signal
);

    always @(*) begin
        // Default: No stall
        stall = 1'b0;

        // Load-Use Hazard: If EX stage is a load & ID stage depends on it
        if (MemRead_EX && (ex_rd != 5'b00000) && ((ex_rd == rs1) || (ex_rd == rs2))) begin
            stall = 1'b1;  // Insert a stall
        end
    end

endmodule