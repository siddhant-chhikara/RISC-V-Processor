module programcounter (
    input wire clk,
    input wire rst,
    input wire ctrl,          
    input wire [15:0] pc_next, 
    output reg [15:0] pc     
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc <= 16'h0000; 
    end
    else if (ctrl) begin
        pc <= pc_next; 
    end
    else begin
        pc <= pc + 4;       
    end
end

endmodule
