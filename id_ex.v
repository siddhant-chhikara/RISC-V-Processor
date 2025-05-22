module id_ex (
    input wire clk,
    input wire rst,
    input wire stall,                // Hazard detection signal
    input wire flush,                // Control hazard signal (1 = clear)
    input wire [31:0] PC_in,         // Program counter from ID stage
    input wire [31:0] instruction_in, // Instruction from ID stage
    input wire [4:0] rs1, rs2, rd,   // Source and destination registers
    input wire [2:0] func3,          // func3 field
    input wire [6:0] func7,          // func7 field
    input wire [31:0] reg_data1, reg_data2, // Register values
    input wire [31:0] imm,           // Sign-extended immediate
    input wire [6:0] opcode,         // Opcode
    input wire MemRead, MemWrite, RegWrite, ALUsrc, MemToReg, Branch, // Control signals
    input wire [2:0] ALUop,          // ALU operation signal

    output reg [31:0] PC_out,        // Program counter to EX stage
    output reg [31:0] instruction_out, // Instruction to EX stage
    output reg [4:0] rs1_out, rs2_out, rd_out, // Source and destination registers to EX stage
    output reg [2:0] func3_out,      // func3 field to EX stage
    output reg [6:0] func7_out,      // func7 field to EX stage
    output reg [31:0] reg_data1_out, reg_data2_out, // Register values to EX stage
    output reg [31:0] imm_out,       // Sign-extended immediate to EX stage
    output reg [6:0] opcode_out,     // Opcode to EX stage
    output reg MemRead_out, MemWrite_out, RegWrite_out, ALUsrc_out, MemToReg_out, Branch_out, // Control signals to EX stage
    output reg [2:0] ALUop_out       // ALU operation signal to EX stage
);

    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            // Reset or flush pipeline register
            PC_out <= 0;
            instruction_out <= 0;
            rs1_out <= 0;
            rs2_out <= 0;
            rd_out <= 0;
            func3_out <= 0;
            func7_out <= 0;
            reg_data1_out <= 0;
            reg_data2_out <= 0;
            imm_out <= 0;
            opcode_out <= 0;
            MemRead_out <= 0;
            MemWrite_out <= 0;
            RegWrite_out <= 0;
            ALUsrc_out <= 0;
            MemToReg_out <= 0;
            Branch_out <= 0;
            ALUop_out <= 0;
        end else if (!stall) begin
            // Pass inputs to outputs if no stall
            PC_out <= PC_in;
            instruction_out <= instruction_in;
            rs1_out <= rs1;
            rs2_out <= rs2;
            rd_out <= rd;
            func3_out <= func3;
            func7_out <= func7;
            reg_data1_out <= reg_data1;
            reg_data2_out <= reg_data2;
            imm_out <= imm;
            opcode_out <= opcode;
            MemRead_out <= MemRead;
            MemWrite_out <= MemWrite;
            RegWrite_out <= RegWrite;
            ALUsrc_out <= ALUsrc;
            MemToReg_out <= MemToReg;
            Branch_out <= Branch;
            ALUop_out <= ALUop;
        end
    end

endmodule