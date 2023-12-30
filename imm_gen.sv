module imm_gen
(
    input  logic [31:0] instruction,
    input  logic [ 2:0] immediate_type,
    output logic [31:0] immediate
);
    logic [31:0] i_immediate;
    logic [31:0] j_immediate;
    logic [31:0] u_immediate;
    logic [31:0] b_immediate;
    logic [31:0] s_immediate;

    always_comb
    begin
        i_immediate = {{20{instruction[31]}}, instruction[31:20]};
        u_immediate = {{12{instruction[31]}}, instruction[31:12]};
        u_immediate = u_immediate << 12;
        j_immediate = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
        b_immediate = {{11{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
        s_immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
    end

    always_comb
    begin
        case(immediate_type)
            3'b000: immediate = i_immediate;
            3'b001: immediate = j_immediate;
            3'b010: immediate = u_immediate;
            3'b011: immediate = b_immediate;
            3'b100: immediate = s_immediate;
        endcase
    end

endmodule