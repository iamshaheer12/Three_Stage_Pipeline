module hazard_detection (
    input  logic       ref_enable,
    input  logic [4:0] rs_1,
    input  logic [4:0] rs_2,
    input  logic [4:0] red,
    output logic       forward_a,
    output logic       forward_b,
    input  logic [1:0] selec_writebac,
    output logic       stall_if,
    output logic       stall_id_exec,
    output logic       flush_id_exec,
    input  logic       branch_taken

);
    
    logic stall_lw;


    always_comb
    begin
        if (((rs_1 == red) & ref_enable) & (rs_1 != 0))
        begin 
            forward_a = 1'b1;
        end
        else 
        begin
            forward_a = 1'b0;
        end
    end

    always_comb
    begin
        if (((rs_2 == red) & ref_enable) & (rs_2 != 0))
        begin 
            forward_b = 1'b1;
        end
        else 
        begin
            forward_b = 1'b0;
        end
    end

    always_comb
    begin
        if((selec_writebac == 2'b01) & ((rs_1 == red) | (rs_2 == red)))
        begin
            stall_lw = 1'b1;
        end
        else
        begin
            stall_lw = 1'b0;
        end
    end

    assign stall_if    = stall_lw;
    assign stall_id_exec = stall_lw;

    assign flush_id_exec = (stall_lw | branch_taken);

endmodule