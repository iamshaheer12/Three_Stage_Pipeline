
module PC 
(
    input  logic        clock,
    input  logic        reset,
    input  logic        enable,
    input  logic [31:0] pc_input,
    output logic [31:0] pc_output
);

    always_ff @(posedge clock) 
    begin 
        if (reset)
        begin
            pc_output <= 0;
        end
        else if (enable)
        begin
            pc_output <= pc_input;
        end
    end    

endmodule