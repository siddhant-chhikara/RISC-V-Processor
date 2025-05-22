module pipeline (
    input wire clk,
    input wire rst
);

    // Wires for inter-stage communication
    wire [31:0] if_pc, if_instruction;
    wire [31:0] if_id_pc, if_id_instruction;
    wire [31:0] id_ex_pc, id_ex_reg1, id_ex_reg2, id_ex_imm;
    wire [4:0] id_ex_rs1, id_ex_rs2, id_ex_rd;
    wire [6:0] id_ex_opcode, id_ex_func7;
    wire [2:0] id_ex_func3;
    wire id_ex_MemRead, id_ex_MemWrite, id_ex_RegWrite, id_ex_ALUsrc, id_ex_MemToReg, id_ex_Branch;
    wire [2:0] id_ex_ALUop;
    wire [31:0] ex_mem_alu_result, ex_mem_reg2;
    wire [4:0] ex_mem_rd;
    wire ex_mem_MemRead, ex_mem_MemWrite, ex_mem_RegWrite, ex_mem_MemToReg;
    wire [31:0] mem_wb_alu_result, mem_wb_mem_data;
    wire [4:0] mem_wb_rd;
    wire mem_wb_RegWrite, mem_wb_MemToReg;
    wire [31:0] wb_write_data;

    // Hazard detection and forwarding
    wire stall;

    // Instruction Fetch (IF) Stage
    if_stage IF_STAGE (
        .clk(clk),
        .rst(rst),
        .PCwrite(~stall),
        .PCsrc(1'b0), // Assuming no branch for now
        .pc(if_pc),
        .branch_target(32'b0), // No branch target for now
        .instruction(if_instruction)
    );

    // IF/ID Pipeline Register
    if_id IF_ID (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(1'b0),
        .PC_in(if_pc),
        .instruction_in(if_instruction),
        .PC_out(if_id_pc),
        .instruction_out(if_id_instruction)
    );

    // Instruction Decode (ID) Stage
    id_stage ID_STAGE (
        .clk(clk),
        .rst(rst),
        .PC_in(if_id_pc),
        .instruction_in(if_id_instruction),
        .RegWrite(mem_wb_RegWrite),
        .write_register(mem_wb_rd),
        .write_data(wb_write_data),
        .PC_out(id_ex_pc),
        .opcode(id_ex_opcode),
        .rd(id_ex_rd),
        .rs1(id_ex_rs1),
        .rs2(id_ex_rs2),
        .func3(id_ex_func3),
        .func7(id_ex_func7),
        .imm_out(id_ex_imm),
        .read_data1(id_ex_reg1),
        .read_data2(id_ex_reg2)
    );

    // ID/EX Pipeline Register
    id_ex ID_EX (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(1'b0),
        .PC_in(id_ex_pc),
        .rs1(id_ex_rs1),
        .rs2(id_ex_rs2),
        .rd(id_ex_rd),
        .func3(id_ex_func3),
        .func7(id_ex_func7),
        .reg_data1(id_ex_reg1),
        .reg_data2(id_ex_reg2),
        .imm(id_ex_imm),
        .opcode(id_ex_opcode),
        .MemRead(id_ex_MemRead),
        .MemWrite(id_ex_MemWrite),
        .RegWrite(id_ex_RegWrite),
        .ALUsrc(id_ex_ALUsrc),
        .MemToReg(id_ex_MemToReg),
        .Branch(id_ex_Branch),
        .ALUop(id_ex_ALUop),
        .PC_out(id_ex_pc)
    );

    // Execution (EX) Stage
    ex_stage EX_STAGE (
        .reg1(id_ex_reg1),
        .reg2(id_ex_reg2),
        .imm(id_ex_imm),
        .func3(id_ex_func3),
        .func7(id_ex_func7),
        .ALUsrc(id_ex_ALUsrc),
        .alu_result(ex_mem_alu_result),
        .zero_flag() // Not used for now
    );

    // EX/MEM Pipeline Register
    ex_mem EX_MEM (
        .clk(clk),
        .rst(rst),
        .flush(1'b0),
        .PC_in(id_ex_pc),
        .ALU_result_in(ex_mem_alu_result),
        .RegReadData2_in(id_ex_reg2),
        .rd_in(id_ex_rd),
        .Zero_in(1'b0), // Not used for now
        .MemWrite_in(id_ex_MemWrite),
        .MemRead_in(id_ex_MemRead),
        .RegWrite_in(id_ex_RegWrite),
        .MemToReg_in(id_ex_MemToReg),
        .Branch_in(id_ex_Branch),
        .PC_out(),
        .ALU_result_out(ex_mem_alu_result),
        .RegReadData2_out(ex_mem_reg2),
        .rd_out(ex_mem_rd),
        .Zero_out(),
        .MemWrite_out(ex_mem_MemWrite),
        .MemRead_out(ex_mem_MemRead),
        .RegWrite_out(ex_mem_RegWrite),
        .MemToReg_out(ex_mem_MemToReg),
        .Branch_out()
    );

    // Memory (MEM) Stage
    mem_stage MEM_STAGE (
        .clk(clk),
        .rst(rst),
        .PC_in(),
        .ALU_result_in(ex_mem_alu_result),
        .RegReadData2_in(ex_mem_reg2),
        .rd_in(ex_mem_rd),
        .MemWrite_in(ex_mem_MemWrite),
        .MemRead_in(ex_mem_MemRead),
        .RegWrite_in(ex_mem_RegWrite),
        .MemToReg_in(ex_mem_MemToReg),
        .PC_out(),
        .ALU_result_out(mem_wb_alu_result),
        .MemReadData_out(mem_wb_mem_data),
        .rd_out(mem_wb_rd),
        .RegWrite_out(mem_wb_RegWrite),
        .MemToReg_out(mem_wb_MemToReg)
    );

    // MEM/WB Pipeline Register
    mem_wb MEM_WB (
        .clk(clk),
        .rst(rst),
        .ALU_result_in(mem_wb_alu_result),
        .MemReadData_in(mem_wb_mem_data),
        .rd_in(mem_wb_rd),
        .RegWrite_in(mem_wb_RegWrite),
        .MemToReg_in(mem_wb_MemToReg),
        .ALU_result_out(mem_wb_alu_result),
        .MemReadData_out(mem_wb_mem_data),
        .rd_out(mem_wb_rd),
        .RegWrite_out(mem_wb_RegWrite),
        .MemToReg_out(mem_wb_MemToReg)
    );

    // Writeback (WB) Stage
    wb_stage WB_STAGE (
        .ALU_result(mem_wb_alu_result),
        .MemReadData(mem_wb_mem_data),
        .rd(mem_wb_rd),
        .RegWrite(mem_wb_RegWrite),
        .MemToReg(mem_wb_MemToReg),
        .WriteData(wb_write_data),
        .WriteReg(),
        .WriteEnable()
    );

       // Hazard Detection Unit
    hazard_detection HDU (
        .rs1(id_ex_rs1),
        .rs2(id_ex_rs2),
        .ex_rd(ex_mem_rd),
        .MemRead_EX(id_ex_MemRead),
        .stall(stall)
    );

endmodule