module fpu_simple (
    input logic clk,
    input logic reset_n,
    input logic [31:0] Op_A_in,
    input logic [31:0] Op_B_in,
    input logic op_sel,
    output logic [31:0] data_out,
    output logic [3:0] status_out
);

    localparam int EXP_BITS = 7;
    localparam int MANT_BITS = 24;

    logic sign_a, sign_b;
    logic [EXP_BITS-1:0] exp_a, exp_b;
    logic [MANT_BITS:0] mant_a_raw, mant_b_raw;

    always_comb begin
        sign_a = Op_A_in[31];
        sign_b = Op_B_in[31];

        exp_a = Op_A_in[31-1 -: EXP_BITS];
        exp_b = Op_B_in[31-1 -: EXP_BITS];

        mant_a_raw = {1'b1, Op_A_in[31-1-EXP_BITS -: MANT_BITS]};
        mant_b_raw = {1'b1, Op_B_in[31-1-EXP_BITS -: MANT_BITS]};
    end

    logic [EXP_BITS:0] exp_diff;
    logic [MANT_BITS:0] mant_a_shift, mant_b_shift;
    logic [MANT_BITS+2:0] mant_res;
    logic [EXP_BITS:0] exp_res;
    logic result_sign;
    logic shifted_out_bits;  // Flag para bits descartados

    always_comb begin
        status_out = 4'b0000;
        mant_a_shift = mant_a_raw;
        mant_b_shift = mant_b_raw;
        shifted_out_bits = 0;


        // Alinhamento com detecção de bits descartados
        if (exp_a > exp_b) begin
            exp_diff = exp_a - exp_b;
            if (exp_diff > 0)
                shifted_out_bits = |(mant_b_raw & ((1 << exp_diff) - 1));
            mant_b_shift = mant_b_raw >> exp_diff;
            exp_res = exp_a;
            result_sign = sign_a;
        end else begin
            exp_diff = exp_b - exp_a;
            if (exp_diff > 0)
                shifted_out_bits = |(mant_a_raw & ((1 << exp_diff) - 1));
            mant_a_shift = mant_a_raw >> exp_diff;
            exp_res = exp_b;
            result_sign = sign_b;
        end


        // Soma ou Menos
        if (op_sel == 0) begin
            mant_res = mant_a_shift + mant_b_shift;
        end else begin
            if (mant_a_shift >= mant_b_shift) begin
                mant_res = mant_a_shift - mant_b_shift;
                result_sign = sign_a;
            end else begin
                mant_res = mant_b_shift - mant_a_shift;
                result_sign = sign_b;
            end
        end


        // Gam VeGam
        if (mant_res[MANT_BITS+2]) begin
            mant_res = mant_res >> 1;
            exp_res = exp_res + 1;
        end else begin
            while (mant_res[MANT_BITS+1] == 0 && exp_res != 0) begin
                mant_res = mant_res << 1;
                exp_res = exp_res - 1;
            end
        end


        // INEXACT e EXACT
        if (shifted_out_bits || mant_res[0]) begin
            status_out[3] = 1; // INEXACT
        end else begin
            status_out[0] = 1; // EXACT
        end
    

        // OVERFLOW ou UNDERFLOW
        if (exp_res >= (2**EXP_BITS - 1)) begin
            status_out[0] = 0;
            status_out[1] = 1; // OVERFLOW
            status_out[2] = 0;
            status_out[3] = 0;
            exp_res = (2**EXP_BITS - 1);
            mant_res = 0;
        end else if (exp_res == 0) begin
            status_out[0] = 0;
            status_out[1] = 0;
            status_out[2] = 1; // UNDERFLOW
            status_out[3] = 0;
            mant_res = 0;
        end

    end
    always_comb begin
        data_out = {result_sign, exp_res[EXP_BITS-1:0], mant_res[MANT_BITS:1]};
    end

endmodule
