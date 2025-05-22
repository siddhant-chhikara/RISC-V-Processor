module mem_stage (
    input wire clk,
    input wire rst,
    input wire [31:0] PC_in,           // Program counter from EX/MEM pipeline register
    input wire [31:0] ALU_result_in,   // ALU result (memory address for load/store)
    input wire [31:0] RegReadData2_in, // Data to write to memory (for store instructions)
    input wire [4:0] rd_in,            // Destination register from EX/MEM pipeline register
    input wire MemWrite_in,            // Memory write enable signal
    input wire MemRead_in,             // Memory read enable signal
    input wire RegWrite_in,            // Register write enable signal
    input wire MemToReg_in,            // Memory-to-register signal

    output reg [31:0] PC_out,          // Program counter to MEM/WB pipeline register
    output reg [31:0] ALU_result_out,  // ALU result to MEM/WB pipeline register
    output reg [31:0] MemReadData_out, // Data read from memory to MEM/WB pipeline register
    output reg [4:0] rd_out,           // Destination register to MEM/WB pipeline register
    output reg RegWrite_out,           // Register write enable signal to MEM/WB pipeline register
    output reg MemToReg_out            // Memory-to-register signal to MEM/WB pipeline register
);

    // 256 x 32-bit memory (word-aligned)
    reg [31:0] memory [0:255]; 

    // Initialize memory to 0 (useful for simulation)
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            memory[i] = 0;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all outputs
            PC_out <= 0;
            ALU_result_out <= 0;
            MemReadData_out <= 0;
            rd_out <= 0;
            RegWrite_out <= 0;
            MemToReg_out <= 0;
        end else begin
            // Pass inputs to outputs
            PC_out <= PC_in;
            ALU_result_out <= ALU_result_in;
            rd_out <= rd_in;
            RegWrite_out <= RegWrite_in;
            MemToReg_out <= MemToReg_in;

            // Memory Read (Word-aligned address)
            if (MemRead_in) begin
                MemReadData_out <= memory[ALU_result_in[9:2]];
            end else begin
                MemReadData_out <= 0; // Clear when no read
            end

            // Memory Write (Only when enabled)
            if (MemWrite_in) begin
                memory[ALU_result_in[9:2]] <= RegReadData2_in;
            end
        end
    end
endmodule