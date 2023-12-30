module Processor (
    input logic clock,
    input logic reset,
    input logic interupt
);

    logic        selec_pc;
    logic        selec_oprand_a;
    logic        selec_oprand_b;
    logic        selec_m;
    logic        en;
    logic [ 2:0] immediate_type;
    
    logic [ 4:0] rs_2;
    logic [ 4:0] rs_1;
    
    logic [ 6:0] opcode;
    logic [ 2:0] func_3;
    logic [ 6:0] func_7;
    logic [31:0] addr;
    logic [31:0] writedata;
    logic [31:0] redata;
    logic [31:0] redata_1;
    
    logic [ 3:0] aluop;
    logic [31:0] immediate;
    
    logic [31:0] mux_output_pc;
    logic [31:0] mux_output_oprand_a;
    logic [31:0] mux_output_oprand_b;
    logic [31:0] mux_output_forward_a;
    logic [31:0] mux_output_forward_b;
    logic [ 2:0] branch_type;
    logic        branch_taken;
    logic        time_interupt;
    logic [31:0] csr_redata;
    logic [31:0] epc;
    logic        epc_taken;
    logic        excep;
    logic        forward_a;
    logic        forward_b;
    logic        selec_forward_a;
    logic        selec_forward_b;
    

    logic        flush_id_exec;
    
    logic        stall_if;
    logic        stall_id_exec;
    
    logic        is_mret_id_exec;
    logic        is_mret_im_writebac;

    logic        csr_red_id_execec;
    logic        csr_rd_im_writebac;

    logic        csr_wr_id_exec;
    logic        csr_wr_im_writebac;
    
    logic [ 1:0] selec_wb_id_exec;
    logic [ 1:0] selec_wb_im_writeback;

    logic        ref_en_id_exec;
    logic        ref_en_im_writebac;

    logic [31:0] pc_output_if;
    logic [31:0] pc_output_id_exec;
    logic [31:0] pc_output_im_writebac;

    logic [31:0] instruction_if;
    logic [31:0] inst_id_exec;
    logic [31:0] inst_im_writebac;
    
    
    
    logic [ 4:0] red_id_exec;
    logic [ 4:0] red_im_writebac;
    
    logic [31:0] redata2_id_exec;
    logic [31:0] redata2_im_writebac;
    
    logic [31:0] oprand_res_id_exec;
    logic [31:0] oprand_res_im_writebac;
    
    
    logic        red_en_id_exec;
    logic        red_en_im_writebac;
    
    logic        wrrite_en_id_exec;
    logic        write_en_im_writebac;
    
    logic [ 2:0] memory_type_id_exec;
    logic [ 2:0] memory_type_im_writeback;

    

    always_comb 
    begin 
    if (epc_taken)
        begin
            mux_output_pc = epc;
        end
        else
        begin
            mux_output_pc = branch_taken ? oprand_res_id_exec : (pc_output_if + 32'd4);
        end
    end
    



    PC PC_i
    (
        .clock    ( clock            ),
        .reset    ( reset            ),
        .enable     ( ~stall_if      ),
        .pc_input  ( mux_output_pc     ),
        .pc_output ( pc_output_if      )
    );

    inst_mem inst_mem_i
    (
        .addr   ( pc_output_if       ),
        .data   ( instruction_if         )
    );

    always_ff @(posedge clock) 
    begin
        if (reset)
        begin
            inst_id_exec   <= 0;
            pc_output_id_exec <= 0;
        end
        else if (flush_id_exec)
        begin
            inst_id_exec   <= 32'h00000033;
            pc_output_id_exec <= 1'b0;

        end
        else if (~stall_id_exec)
        begin
            inst_id_exec   <= instruction_if;
            pc_output_id_exec <= pc_output_if;
        end
    end

    
    

    inst_decode inst_decode_i
    (
        .clock    ( clock             ),
        .instruction   ( inst_id_exec      ),
        .red     ( red_id_exec        ),
        .rs_1    ( rs_1             ),
        .rs_2    ( rs_2             ),
        .opcode ( opcode          ),
        .func_3  ( func_3           ),
        .func_7  ( func_7           )
    );

    reg_file reg_file_i
    (
        .clock    ( clock             ),
        .rs_2    ( rs_2             ),
        .rs_1    ( rs_1             ),
        .red     ( red_im_writebac        ),
        .writedata  ( writedata           ),
        .redata_1 ( redata_1          ),
        .redata_2 ( redata2_id_exec    ),
        .ref_enable  ( ref_en_im_writebac     )

    );

    controller controller_i
    (
        .opcode    ( opcode         ),
        .func_7     ( func_7          ),
        .func_3     ( func_3          ),
        .ref_enable     ( ref_en_id_exec    ),
        .selec_oprand_a ( selec_oprand_a      ),
        .selec_oprand_b ( selec_oprand_b      ),
        .selec_writebac    ( selec_wb_id_exec   ),
        .immediate_type  ( immediate_type       ),
        .aluop     ( aluop          ),
        .branch_type   ( branch_type        ),
        .red_enable     ( red_en_id_exec    ),
        .write_enable     ( wrrite_en_id_exec    ),
        .memory_type  ( memory_type_id_exec ),
        .csr_red    ( csr_red_id_execec   ),
        .csr_write    ( csr_wr_id_exec   ),
        .is_mret   ( is_mret_id_exec  )
    );

    imm_gen imm_gen_i
    (
        .instruction      ( inst_id_exec     ),
        .immediate_type  ( immediate_type       ),
        .immediate       ( immediate            )
    );


    assign mux_output_forward_a = selec_forward_a ? oprand_res_im_writebac : redata_1;

    assign mux_output_forward_b = selec_forward_b ? oprand_res_im_writebac : redata2_id_exec;

    assign mux_output_oprand_a = selec_oprand_a ? pc_output_id_exec : mux_output_forward_a;

    assign mux_output_oprand_b = selec_oprand_b ? immediate    : mux_output_forward_b;

     alu alu_i
    (
        .aluop    ( aluop          ),
        .oprand_a    ( mux_output_oprand_a  ),
        .oprand_b    ( mux_output_oprand_b  ),
        .oprand_reset  ( oprand_res_id_exec  )
    );



    Branch_comp Branch_comp_i
    (
        .branch_type   ( branch_type        ),
        .oprand_a     ( mux_output_forward_a  ),
        .oprand_b     ( mux_output_forward_b  ),
        .branch_taken  ( branch_taken       )
    );


    hazard_detection hazard_detection_i
    (
        .ref_enable      ( ref_en_im_writebac   ),
        .rs_1        ( rs_1           ),
        .rs_2        ( rs_2           ),
        .red         ( red_im_writebac      ),
        .forward_a      ( selec_forward_a     ),
        .forward_b      ( selec_forward_b     ),
        .selec_writebac     ( selec_wb_im_writeback  ),
        .stall_if   ( stall_if      ),
        .stall_id_exec( stall_id_exec   ),
        .flush_id_exec( flush_id_exec   ),
        .branch_taken   ( branch_taken      )   
    );


always_ff @(posedge clock) 
    begin
        if (reset | flush_id_exec)
        begin
            pc_output_im_writebac <= 0;
            oprand_res_im_writebac <= 0;
            redata2_im_writebac <= 0;
            red_im_writebac <= 0;
            inst_im_writebac <= 0;

            ref_en_im_writebac <= 0;
            selec_wb_im_writeback <= 0;
            write_en_im_writebac <= 0;
            red_en_im_writebac <= 0;
            memory_type_im_writeback <= 0;
            is_mret_im_writebac <= 0;
            csr_rd_im_writebac <= 0;
            csr_wr_im_writebac <= 0;
        end
        else
        begin
            pc_output_im_writebac <= pc_output_id_exec;
            oprand_res_im_writebac <= oprand_res_id_exec;
            redata2_im_writebac <= redata2_id_exec;
            red_im_writebac <= red_id_exec;
            inst_im_writebac <= inst_id_exec;

            ref_en_im_writebac <= ref_en_id_exec;
            selec_wb_im_writeback <= selec_wb_id_exec;
            write_en_im_writebac <= wrrite_en_id_exec;
            red_en_im_writebac <= red_en_id_exec;
            memory_type_im_writeback <= memory_type_id_exec;
            is_mret_im_writebac <= is_mret_id_exec;
            csr_rd_im_writebac <= csr_red_id_execec;
            csr_wr_im_writebac <= csr_wr_id_exec;
        end
    end


    data_mem data_mem_i
    (
        .clock       ( clock            ),
        .red_enable     ( red_en_im_writebac    ),
        .write_enable     ( write_en_im_writebac    ),
        .memory_type  ( memory_type_im_writeback ),
        .addr      ( oprand_res_im_writebac  ),
        .writedata     ( redata2_im_writebac   ),
        .redata     ( redata          )
    );

    csr_reg csr_reg_i
    (
        .clock       ( clock             ),
        .reset       ( reset             ),
        .addr      ( oprand_res_im_writebac   ),
        .writedata     ( redata2_im_writebac    ),
        .pc        ( pc_output_im_writebac    ),
        .csr_red    ( csr_rd_im_writebac    ),
        .csr_write    ( csr_wr_im_writebac    ),
        .instruction      ( inst_im_writebac      ),
        .redata     ( csr_redata       )
    );

    interupt interupt_i
    (
        .is_mret    ( is_mret        ),    
        .time_interupt( interupt       ),        
        .epc        ( epc            ),
        .epc_taken  ( epc_taken      ),    
        .excep      ( excep          )
    );


    always_comb
    begin
        case(selec_wb_im_writeback)
            2'b00: writedata = oprand_res_im_writebac;
            2'b01: writedata = redata;
            2'b10: writedata = pc_output_im_writebac + 32'd4;
            2'b11: writedata = csr_redata;
            default:
            begin
                writedata = 32'b0;
            end
        endcase
    end

endmodule