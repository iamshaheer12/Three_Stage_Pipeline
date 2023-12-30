module controller
(
    input  logic [6:0]    opcode,
    input  logic [6:0]     func_7,
    input  logic [2:0]     func_3,
    output logic           ref_enable,
    output logic           red_enable,
    output logic           write_enable,
    output logic       selec_oprand_a,
    output logic       selec_oprand_b,
    output logic [3:0]     aluop,
    output logic [2:0]   branch_type,
    output logic [2:0]  memory_type,
    output logic [1:0]    selec_writebac,
    output logic [2:0]  immediate_type,
    output logic          csr_red,   
    output logic          csr_write,   
    output logic          is_mret   
);
 
    always_comb
    begin
        case(opcode)
            7'b0110011: //R-Type
            begin

                ref_enable = 1'b1;
                red_enable = 1'b0;
                write_enable = 1'b0;
                
                selec_oprand_a = 1'b0;
                selec_oprand_b = 1'b0;
                selec_writebac    = 2'b00;

                immediate_type  = 3'b000;
                branch_type   = 3'b110;

                case(func_3)
                    3'b000: 
                    begin
                        case(func_7)
                            7'b0000000: aluop = 4'b0000;
                            7'b0100000: aluop = 4'b0001;
                        endcase
                    end
                    3'b001: aluop = 4'b0010;            
                    3'b010: aluop = 4'b0011;             
                    3'b011: aluop = 4'b0100;             
                    3'b100: aluop = 4'b0101;             
                    3'b101:
                    begin
                        case(func_7)
                            7'b0000000: aluop = 4'b0110; 
                            7'b0100000: aluop = 4'b0111; 
                        endcase
                    end
                    3'b110: aluop = 4'b1000;             
                    3'b111: aluop = 4'b1001;             
                endcase
            end

            7'b0010011: //I-Type
            begin
                ref_enable = 1'b1;
                red_enable = 1'b0;
                write_enable = 1'b0;
                selec_oprand_a = 1'b0;
                selec_oprand_b = 1'b1;
                selec_writebac    = 2'b00;

                immediate_type  = 3'b000;


                case (func_3)
                    3'b000: aluop = 4'b0000;             //ADDI
                    3'b001: aluop = 4'b0010;             //SLLI
                    3'b010: aluop = 4'b0011;             //SLTI
                    3'b011: aluop = 4'b0100;             //SLTUI
                    3'b100: aluop = 4'b0101;             //XORI
                    3'b101:
                    begin
                        case (func_7)
                            7'b0000000: aluop = 4'b0110; 
                            7'b0100000: aluop = 4'b0111; 
                        endcase    
                    end
                    3'b110: aluop = 4'b1000;             
                    3'b111: aluop = 4'b1001;           

                    
                endcase
            end

            // I-Type Jump
            7'b1100111:
            begin
                ref_enable = 1'b1;
                red_enable = 1'b0;
                write_enable = 1'b0;
                
                selec_oprand_a = 1'b0;
                selec_oprand_b = 1'b1;
                selec_writebac    = 2'b10;

                immediate_type  = 3'b000;

                aluop = 4'b0000; // add
                branch_type = 3'b111;  
            end
            // S-type
            7'b0100011: // S-type
            begin
                
                ref_enable = 1'b0;
                red_enable = 1'b0;
                write_enable = 1'b1;

                selec_oprand_a = 1'b0;
                selec_oprand_b = 1'b1;
                selec_writebac    = 2'b11;

                immediate_type  = 3'b100;

                aluop = 4'b0000; // add
                case (func_3)
                3'b000: memory_type = 3'b000;
                3'b001: memory_type = 3'b001;
                3'b010: memory_type = 3'b010;
                endcase

            end
            // L-type
            7'b0000011: // L-type
            begin
                ref_enable = 1'b1;
                red_enable = 1'b1;
                write_enable = 1'b0;

                selec_oprand_a = 1'b0;
                selec_oprand_b = 1'b1;
                selec_writebac    = 2'b01;

                immediate_type  = 3'b000;

                aluop = 4'b0000; // add
                case (func_3)
                3'b000: memory_type = 3'b000;
                3'b001: memory_type = 3'b001;
                3'b010: memory_type = 3'b010;
                3'b100: memory_type = 3'b011;
                3'b101: memory_type = 3'b100;
                endcase

            end

            // J-Type
            7'b1101111: // J-Type
            begin
                ref_enable = 1'b1;
                red_enable = 1'b0;
                write_enable = 1'b0;

                selec_oprand_a = 1'b1;
                selec_oprand_b = 1'b1;
                selec_writebac    = 2'b10;

                immediate_type  = 3'b001;

                aluop = 4'b0000; // add
                branch_type = 3'b111;
            end
            // LUI-Type
            7'b0110111: // U-Type
            begin
                ref_enable = 1'b1;
                red_enable = 1'b0;
                write_enable = 1'b0;

                selec_oprand_a = 1'b0;
                selec_oprand_b = 1'b1;
                selec_writebac    = 2'b00;

                immediate_type  = 3'b010;

                
                aluop = 4'b1010; // add-U
            end
            // AUIPC-Type
            7'b0010111: // U-Type
            begin
                ref_enable = 1'b1;
                red_enable = 1'b0;
                write_enable = 1'b0;

                
                selec_oprand_a = 1'b1;
                selec_oprand_b = 1'b1;
                selec_writebac    = 2'b00;

                immediate_type  = 3'b010;

                aluop = 4'b0000; // add-U
            end
            // B-Type
            7'b1100011:
            begin
                ref_enable = 1'b0;
                red_enable = 1'b0;
                write_enable = 1'b0;

                selec_oprand_a = 1'b1;
                selec_oprand_b = 1'b1;

                immediate_type  = 3'b011;

                aluop = 4'b0000;
                case (func_3)
                3'b000: branch_type = 3'b000;
                3'b001: branch_type = 3'b001;
                3'b100: branch_type = 3'b010;
                3'b101: branch_type = 3'b011;
                3'b110: branch_type = 3'b100;
                3'b111: branch_type = 3'b101;
                endcase
            end
            7'b1110011: //# CSR
            begin
                case (func_3)
                3'b000:
                    begin
                        ref_enable = 1'b1;
                        red_enable = 1'b0;
                        write_enable = 1'b0;

                        selec_oprand_a = 1'b0;
                        selec_oprand_b = 1'b1;
                        selec_writebac    = 2'b11;

                        immediate_type  = 3'b000;

                        csr_red       = 1'b1;
                        csr_write       = 1'b1;
                        is_mret      = 1'b0;
                        aluop        = 4'b1010;
                    end

                default:
                    begin
                        ref_enable = 1'b0;
                        red_enable = 1'b0;
                        write_enable = 1'b0;

                        selec_oprand_a = 1'b0;
                        selec_oprand_b = 1'b1;
                        selec_writebac    = 2'b11;

                        immediate_type  = 3'b000;
                        
                        csr_red       = 1'b0;
                        csr_write       = 1'b0;
                        is_mret      = 1'b1;
                    end
                endcase
            end

            default:
            begin
                ref_enable = 1'b0;
                red_enable = 1'b0;
                write_enable = 1'b0;
                selec_oprand_a = 1'b0;
                selec_oprand_b = 1'b0;
                selec_writebac    = 2'b00;
                immediate_type  = 3'b000;
                csr_red       = 1'b0;
                csr_write       = 1'b0;
                
            end
        endcase
    end

endmodule
