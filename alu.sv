module alu (
    input  logic [ 3:0] aluop,
    input  logic [31:0] oprand_a,
    input  logic [31:0] oprand_b,
    output logic [31:0] oprand_reset
);
    
    logic sra;
    

    always_comb
    begin 
        case(aluop)
            4'b0000: oprand_reset = oprand_a  +  oprand_b;                                     
            4'b0001: oprand_reset = oprand_a  -  oprand_b;                                     
            4'b0010: oprand_reset = oprand_a  << oprand_b[4:0];                                
            4'b0011: oprand_reset = ($signed(oprand_a) < $signed(oprand_b)) ? 32'b1 : 32'b0;   
            4'b0100: oprand_reset = (oprand_a  <  oprand_b) ? 32'b1 : 32'b0;                  
            4'b0101: oprand_reset = oprand_a  ^  oprand_b;                                   
            4'b0110: oprand_reset = oprand_a  >> oprand_b[4:0];                               
            4'b0111: 
                    begin
                    sra = oprand_a[31]==1? 1'b1:1'b0;
                    if(sra)
                    begin
                        oprand_reset = $signed(oprand_a) >>> oprand_b[4:0];
                    end
                    else
                    begin
                        oprand_reset = oprand_a  >> oprand_b[4:0];                              
                    end
                    end
            4'b1000: oprand_reset = oprand_a  |  oprand_b;                                     
            4'b1001: oprand_reset = oprand_a  &  oprand_b;                                    
            4'b1010: oprand_reset = oprand_b;                                    
            default: oprand_reset = 32'b0;                                         
        endcase

    end
    
endmodule