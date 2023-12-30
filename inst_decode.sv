module inst_decode (
    input  logic        clock,
    input  logic [31:0] instruction,
    output logic [ 4:0] red,
    output logic [ 4:0] rs_1,
    output logic [ 4:0] rs_2,
    output logic [ 6:0] opcode,
    output logic [ 2:0] func_3,
    output logic [ 6:0] func_7
);
    assign opcode  = instruction[  6:0];
    assign func_3   = instruction[14:12];
    assign func_7   = instruction[31:25];
    assign red      = instruction[ 11:7];
    assign rs_1     = instruction[19:15];

    always_comb
    begin 
        if ((opcode == 7'b0110011) || (opcode ==  7'b0100011) || (opcode == 7'b1100011))
        begin
            rs_2 = instruction[24:20];    
        end
    end
endmodule