module register_file (
    input wire clk, 
    input wire rst,
    input wire [4:0] read_add1,
    input wire [4:0] read_add2,
    input wire [4:0] write_add,
    input wire [31:0] write_data,
    input wire reg_write,
    output reg [31:0] read_data1,
    output reg [31:0] read_data2
);

    reg [31:0] registers [0:31];

    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'h00000000;
            end
        end else if (reg_write && write_add != 5'b00000) begin
            registers[write_add] <= write_data;
        end
    end

    always @(*) begin
        read_data1 = registers[read_add1];
        read_data2 = registers[read_add2];
    end

endmodule
