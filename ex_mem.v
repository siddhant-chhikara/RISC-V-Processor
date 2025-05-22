module ex_mem (
    input wire clk,
    input wire rst,
    input wire flush,                // Branch misprediction flush signal
    input wire [31:0] PC_in,         // Program counter from EX stage
    input wire [31:0] ALU_result_in, // ALU result from EX stage
    input wire [31:0] RegReadData2_in, // Second operand (for store instructions)
    input wire [4:0] rd_in,          // Destination register from EX stage
    input wire Zero_in,              // Zero flag from EX stage
    input wire MemWrite_in,          // Memory write enable signal
    input wire MemRead_in,           // Memory read enable signal
    input wire RegWrite_in,          // Register write enable signal
    input wire MemToReg_in,          // Memory-to-register signal
    input wire Branch_in,            // Branch signal

    output reg [31:0] PC_out,        // Program counter to MEM stage
    output reg [31:0] ALU_result_out, // ALU result to MEM stage
    output reg [31:0] RegReadData2_out, // Second operand to MEM stage
    output reg [4:0] rd_out,         // Destination register to MEM stage
    output reg Zero_out,             // Zero flag to MEM stage
    output reg MemWrite_out,         // Memory write enable signal to MEM stage
    output reg MemRead_out,          // Memory read enable signal to MEM stage
    output reg RegWrite_out,         // Register write enable signal to MEM stage
    output reg MemToReg_out,         // Memory-to-register signal to MEM stage
    output reg Branch_out            // Branch signal to MEM stage
);

    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            // Reset or flush the pipeline stage
            PC_out <= 0;
            ALU_result_out <= 0;
            RegReadData2_out <= 0;
            rd_out <= 0;
            Zero_out <= 0;
            MemWrite_out <= 0;
            MemRead_out <= 0;
            RegWrite_out <= 0;
            MemToReg_out <= 0;
            Branch_out <= 0;
        end else begin
            // Pass inputs to outputs
            PC_out <= PC_in;
            ALU_result_out <= ALU_result_in;
            RegReadData2_out <= RegReadData2_in;
            rd_out <= rd_in;
            Zero_out <= Zero_in;
            MemWrite_out <= MemWrite_in;
            MemRead_out <= MemRead_in;
            RegWrite_out <= RegWrite_in;
            MemToReg_out <= MemToReg_in;
            Branch_out <= Branch_in;
        end
    end

endmodule