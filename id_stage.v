module id_stage (
    input wire clk,
    input wire rst,
    input wire [31:0] PC_in,            // PC from IF/ID
    input wire [31:0] instruction_in,   // Instruction from IF/ID
    input wire RegWrite,                // Write enable for registers
    input wire [4:0] write_register,    // Destination register
    input wire [31:0] write_data,       // Data to write into the register file

    output reg [31:0] PC_out,           // Pass PC to next stage
    output reg [6:0] opcode,            // Extracted opcode
    output reg [4:0] rd,                // Destination register
    output reg [4:0] rs1, rs2,          // Source registers
    output reg [2:0] func3,             // func3 field
    output reg [6:0] func7,             // func7 field
    output reg [31:0] imm_out,          // Sign-extended immediate
    output reg [31:0] read_data1,       // Value from register file (rs1)
    output reg [31:0] read_data2        // Value from register file (rs2)
);

    // Register file (32 registers, 32-bit each)
    reg [31:0] registers [0:31];

    // Initialize register file to 0
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 0; 
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all outputs
            PC_out <= 0;
            opcode <= 0;
            rd <= 0;
            rs1 <= 0;
            rs2 <= 0;
            func3 <= 0;
            func7 <= 0;
            imm_out <= 0;
            read_data1 <= 0;
            read_data2 <= 0;
        end else begin
            // Pass PC to the next stage
            PC_out <= PC_in;

            // Decode instruction fields
            opcode <= instruction_in[6:0];
            rd <= instruction_in[11:7];
            rs1 <= instruction_in[19:15];
            rs2 <= instruction_in[24:20];
            func3 <= instruction_in[14:12];
            func7 <= instruction_in[31:25];

            // Fetch values from register file
            read_data1 <= registers[rs1];
            read_data2 <= registers[rs2];

            // Immediate Extraction (sign-extension)
            case (opcode)
                7'b0010011, 7'b0000011: // I-type
                    imm_out <= {{20{instruction_in[31]}}, instruction_in[31:20]};
                7'b0100011: // S-type
                    imm_out <= {{20{instruction_in[31]}}, instruction_in[31:25], instruction_in[11:7]};
                7'b1100011: // B-type
                    imm_out <= {{19{instruction_in[31]}}, instruction_in[31], instruction_in[7], instruction_in[30:25], instruction_in[11:8], 1'b0};
                default: // Unsupported instruction
                    imm_out <= 0;
            endcase
        end
    end

    // Register Write (Prevent writing to x0)
    always @(posedge clk) begin
        if (RegWrite && write_register != 0) begin
            registers[write_register] <= write_data;
        end
    end

endmodule