`timescale 1ns/1ps
module fpu_simple_tb;
    logic clk;
    logic reset_n;
    logic [31:0] A, B;
    logic op_sel;
    logic [31:0] RESULT;
    logic [3:0] STATUS;

    fpu_simple dut (
        .clk(clk),
        .reset_n(reset_n),
        .Op_A_in(A),
        .Op_B_in(B),
        .op_sel(op_sel),
        .data_out(RESULT),
        .status_out(STATUS)
    );

    // Clock
    initial clk = 0;
    always #5000 clk = ~clk;

    task run_test(input [31:0] a, input [31:0] b, input bit sel);
        begin
            A = a; B = b; op_sel = sel;
            #10000; // Rega uma rodada
            $display("Test: A=%h B=%h sel=%0d => RESULT=%h STATUS=%b", A, B, sel, RESULT, STATUS);
            $display("RESULT=%h | EXACT=%b, OVERFLOW=%b, UNDERFLOW=%b, INEXACT=%b",
                     RESULT,      STATUS[0],  STATUS[1],    STATUS[2],  STATUS[3]);
        end
    endtask

    initial begin
        // Reset
        reset_n = 0;
        #5000;
        reset_n = 1;
        #5000;
        
        // Test cases
        run_test(32'h00000000, 32'h4D5D1148, 0); // 0 + val (inexact)
        run_test(32'h4D5D1148, 32'h4D5D1148, 1); // val - val
        run_test(32'h7fffffff, 32'h7fffffff, 0); // overflow case
        run_test(32'h00800000, 32'h00800000, 1); // underflow case
        run_test(32'h3F800000, 32'h3F800000, 0);// exact: 1.0 + 1.0 = 2.0

        $finish;
    end

endmodule
