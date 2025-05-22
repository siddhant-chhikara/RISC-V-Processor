module data_memory (
    input wire clk,
    input wire MemRead,
    input wire MemWrite,
    input wire [31:0] address,
    input wire [31:0] write_data,
    output reg [31:0] read_data
);

    reg [31:0] memory [0:255];

    always @(posedge clk) begin
        if (MemWrite) begin
            memory[address[9:2]] <= write_data; // Word-aligned write
        end
    end

    always @(posedge clk) begin
        if (MemRead) begin
            read_data <= memory[address[9:2]]; // Word-aligned read
        end else begin
            read_data <= 32'b0;
        end
    end

endmodule
