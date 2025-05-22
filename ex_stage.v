module ex_stage (
    input wire [31:0] reg1,          // First operand (from register file)
    input wire [31:0] reg2,          // Second operand (from register file)
    input wire [31:0] imm,           // Immediate value
    input wire [2:0] func3,          // func3 field (ALU operation)
    input wire [6:0] func7,          // func7 field (e.g., ADD vs. SUB)
    input wire ALUsrc,               // Control signal to select imm or reg2

    output reg [31:0] alu_result,    // Result of ALU operation
    output reg zero_flag             // Zero flag for branch instructions
);

    reg [31:0] operand1, operand2;

    always @(*) begin
        // Select operands
        operand1 = reg1;
        operand2 = ALUsrc ? imm : reg2;

        // Perform ALU operations
        case (func3)
            3'b000: begin // ADD or SUB
                if (func7 == 7'b0100000)  // SUB
                    alu_result = operand1 - operand2;
                else                      // ADD
                    alu_result = operand1 + operand2;
            end
            3'b110: alu_result = operand1 | operand2;  // OR
            3'b111: alu_result = operand1 & operand2;  // AND
            default: alu_result = 32'b0;              // Unsupported operation
        endcase

        // Set zero flag
        zero_flag = (alu_result == 0);
    end

endmodule