module alu (
    input wire [31:0] operand1,
    input wire [31:0] operand2,
    input wire [3:0] opcode,
    output reg [31:0] result,
    output reg zero_flag
);

always @(*) begin
    case (opcode)
        4'b0000: result = operand1 + operand2;   // ADD
        4'b0001: result = operand1 - operand2;   // SUB
        4'b0010: result = operand1 & operand2;   // AND
        4'b0011: result = operand1 | operand2;   // OR
        4'b0100: result = operand1 ^ operand2;   // XOR
        4'b0101: result = ~operand1;             // NOT
        4'b0110: result = operand1 << operand2;  // SLL (Shift Left Logical)
        4'b0111: result = operand1 >> operand2;  // SRL (Shift Right Logical)
        4'b1000: result = operand1 + 1;          // Increment
        4'b1001: result = operand1 - 1;          // Decrement
        default: result = 32'b0;                 // Default case
    endcase
    
    // Zero flag: Set if result is 0
    zero_flag = (result == 32'b0) ? 1 : 0;
end

endmodule