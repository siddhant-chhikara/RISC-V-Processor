module mem_wb (
    input wire clk,
    input wire rst,
    input wire [31:0] ALU_result_in,   // ALU result from MEM stage
    input wire [31:0] MemReadData_in,  // Data read from memory (if applicable)
    input wire [4:0] rd_in,            // Destination register from MEM stage
    input wire RegWrite_in,            // Register write enable signal
    input wire MemToReg_in,            // Memory-to-register signal

    output reg [31:0] ALU_result_out,  // ALU result to WB stage
    output reg [31:0] MemReadData_out, // Data read from memory to WB stage
    output reg [4:0] rd_out,           // Destination register to WB stage
    output reg RegWrite_out,           // Register write enable signal to WB stage
    output reg MemToReg_out            // Memory-to-register signal to WB stage
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all outputs
            ALU_result_out <= 0;
            MemReadData_out <= 0;
            rd_out <= 0;
            RegWrite_out <= 0;
            MemToReg_out <= 0;
        end else begin
            // Pass inputs to outputs
            ALU_result_out <= ALU_result_in;
            MemReadData_out <= MemReadData_in;
            rd_out <= rd_in;
            RegWrite_out <= RegWrite_in;
            MemToReg_out <= MemToReg_in;
        end
    end

endmodule