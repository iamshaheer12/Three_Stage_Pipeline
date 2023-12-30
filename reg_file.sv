module reg_file (
    input  logic        clock,
    input  logic        ref_enable,
    input  logic [ 4:0] rs_2,
    input  logic [ 4:0] rs_1,
    input  logic [ 4:0] red,
    input  logic [31:0] writedata,
    output logic [31:0] redata_1,
    output logic [31:0] redata_2
);
    
    logic [31:0] reg_memory [0:31];

   
    always_comb 
    begin 
        redata_1 = reg_memory[rs_1];
        redata_2 = reg_memory[rs_2];
    end
    
    always_ff @(posedge clock) 
    begin
        if (ref_enable)
        begin
            if (reg_memory[0] != red)
            begin
                reg_memory[red] <= writedata;
            end
        end
    end
    
endmodule