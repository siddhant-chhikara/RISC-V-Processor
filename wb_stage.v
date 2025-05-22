module wb_stage (
    input wire [31:0] ALU_result,    // Result from ALU
    input wire [31:0] MemReadData,   // Data read from memory
    input wire [4:0] rd,             // Destination register
    input wire RegWrite,             // Register write enable signal
    input wire MemToReg,             // Select between ALU_result and MemReadData

    output reg [31:0] WriteData,     // Data to write to the register file
    output reg [4:0] WriteReg,       // Register to write to
    output reg WriteEnable           // Write enable signal
);

    always @(*) begin
        // Set write enable signal
        WriteEnable = RegWrite;

        if (RegWrite) begin
            // Write to the specified register
            WriteReg = rd;
            WriteData = (MemToReg) ? MemReadData : ALU_result;
        end else begin
            // Default values when no write occurs
            WriteReg = 5'b00000;   // Default to register 0 (no writes)
            WriteData = 32'b0;     // Prevent unintended writes
        end
    end

endmodule