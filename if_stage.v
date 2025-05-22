module if_stage (
    input wire clk,
    input wire rst,
    input wire PCwrite,
    input wire PCsrc,
    output wire [31:0] pc,
    input wire [31:0] branch_target,
    output reg [31:0] instruction,
    output reg [31:0] pc_plus_4
);

    reg [31:0] PC;
    reg [31:0] instruction_memory [0:255]; // 256 x 32-bit memory

    // Load instructions from file
    initial begin
        $readmemh("instructions.mem", instruction_memory);
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            PC <= 0; // Reset PC
        end else if (PCwrite) begin
            if (PCsrc)
                PC <= branch_target; // Branch taken
            else
                PC <= PC + 4; // Normal execution
        end
    end

    always @(posedge clk) begin
        instruction <= instruction_memory[PC[9:2]]; // Fetch instruction
        pc_plus_4 <= PC + 4; // Calculate next PC value
    end

    assign pc = PC; // Output current PC value

endmodule