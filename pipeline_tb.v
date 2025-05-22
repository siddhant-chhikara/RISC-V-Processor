`timescale 1ns / 1ps

module pipeline_tb;
    // Clock and Reset
    reg clk, rst;

    // Instantiate the Pipeline
    pipeline uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock Generation (10ns clock period)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("waveform.vcd"); // For waveform generation
        $dumpvars(0, pipeline_tb); // Dump all signals in the testbench

        // Initialize signals
        clk = 0;
        rst = 1;
        #15 rst = 0; // Release reset after 15ns

        // Run simulation for some time
        #500;

        // End simulation
        $display("✅ Pipeline Test Completed");
        $finish;
    end

    // Monitor important signals
    initial begin
        $monitor("Time=%0t | PC=%h | IF/ID_PC=%h | IF/ID_Instruction=%h | ID/EX_Reg1=%h | EX/MEM_ALU=%h | MEM/WB_WriteData=%h", 
                 $time, uut.if_pc, uut.if_id_pc, uut.if_id_instruction, 
                 uut.id_ex_reg1, uut.ex_mem_alu_result, uut.mem_wb_alu_result);
    end

endmodule