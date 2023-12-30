module Branch_comp(
    input  logic [ 2:0] branch_type,
    input  logic [31:0] oprand_a,
    input  logic [31:0] oprand_b,
    output logic        branch_taken
);
 

always_comb 
begin
    if((branch_type == 3'b000) && ($signed(oprand_a) == $signed(oprand_b)))         //SBEQ
        branch_taken = 1'b1;
    else if((branch_type == 3'b001) && ($signed(oprand_a) != $signed(oprand_b)))    //SBNE
        branch_taken = 1'b1;
    else if((branch_type == 3'b010) && ($signed(oprand_a) < $signed(oprand_b)))     //SBLT
        branch_taken = 1'b1;
    else if((branch_type == 3'b100) && (oprand_a) < (oprand_b))                     //BLT
        branch_taken = 1'b1;
    else if ((branch_type == 3'b011) && ($signed(oprand_a) >= $signed(oprand_b)))   //SBGE
        branch_taken = 1'b1;
    else if ((branch_type == 3'b101) && (oprand_a) >= (oprand_b))                   //BGE
        branch_taken = 1'b1;
    else if (branch_type == 3'b111)                                           //Jump
        branch_taken = 1'b1;
    else 
        branch_taken = 1'b0;
        
end

endmodule