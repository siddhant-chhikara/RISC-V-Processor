`timescale 1ns / 1ps

module control_unit (
    input wire clk,
    input wire rst,
    input wire [6:0] opcode,
    input wire [2:0] func3,
    input wire [6:0] func7,
    input wire zero_flag,
    output reg PCwrite,
    output reg MemRead,
    output reg MemWrite,
    output reg RegWrite,
    output reg [2:0] ALUop,
    output reg ALUsrc,
    output reg MemToReg,
    output reg Branch,
    output reg [2:0] state
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 3'b000; // Reset state
    end else begin
        case (state)
            3'b000: state <= 3'b001; // FETCH → DECODE
            3'b001: begin // DECODE
                if (opcode == 7'b0110011 || opcode == 7'b0010011) // R-type / I-type ALU
                    state <= 3'b010;
                else if (opcode == 7'b0000011) // Load
                    state <= 3'b011;
                else if (opcode == 7'b0100011) // Store
                    state <= 3'b011;
                else if (opcode == 7'b1100011) // Branch
                    state <= 3'b010;
                else
                    state <= 3'b000; // Invalid opcode, restart
            end
            3'b010: begin // EXECUTE
                if (opcode == 7'b0000011 || opcode == 7'b0100011) // Load/Store
                    state <= 3'b011;
                else
                    state <= 3'b100; // ALU result → WRITEBACK
            end
            3'b011: state <= 3'b100; // Memory Access → Writeback
            3'b100: state <= 3'b000; // Writeback → Fetch next instruction
            default: state <= 3'b000;
        endcase
    end
end

always @(*) begin
    PCwrite = 0; MemRead = 0; MemWrite = 0;
    RegWrite = 0; ALUop = 3'b000; ALUsrc = 0;
    MemToReg = 0; Branch = 0;

    case (state)
        3'b000: begin // FETCH
            PCwrite = 1;
            MemRead = 1;
        end
        3'b001: begin // DECODE
        end
        3'b010: begin // EXECUTE
            if (opcode == 7'b0110011) begin // R-Type
                ALUop = 3'b010;
                RegWrite = 1;
            end else if (opcode == 7'b0010011) begin // I-Type ALU Instructions
                ALUop = 3'b010;
                RegWrite = 1;
                ALUsrc = 1; // Immediate value
            end else if (opcode == 7'b1100011) begin // Branch
                Branch = 1;
            end else if (opcode == 7'b0000011 || opcode == 7'b0100011) begin // Load/Store
                ALUsrc = 1; // Memory operations use immediate offset
            end
        end
        3'b011: begin // MEMORY ACCESS
            if (opcode == 7'b0000011) begin // Load
                MemRead = 1;
            end else if (opcode == 7'b0100011) begin // Store
                MemWrite = 1;
            end
        end
        3'b100: begin // WRITEBACK
            if (opcode == 7'b0000011) begin // Load
                RegWrite = 1;
                MemToReg = 1;
            end
        end
    endcase
end

endmodule
