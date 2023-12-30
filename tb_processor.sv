module tb_processor ();
    
    logic clock;
    logic reset;
    logic interupt;
     
    Processor dut
    (
        .clock(clock),
        .reset(reset),
        .interupt(interupt)
    );



    initial 
    begin
        clock = 0;
        forever 
        begin
            #5 clock =~ clock;     
        end    
    end

    initial 
    begin
        reset = 1;
        #10;
        reset = 0;
        #5
        interupt = 1;
        #5
        interupt = 0;

        #100000;
        $finish;    
    end

    initial
    begin
        $readmemh("inst.mem", dut.inst_mem_i.mem);
        $readmemb("rf.mem", dut.reg_file_i.reg_memory); 
        $readmemb("d_m.mem", dut.data_mem_i.data_mem);  
        $readmemb("csr_reg.mem", dut.csr_reg_i.csr_reg);
        $readmemb("csr_reg.mem", dut.interupt_i.csr_reg);
    end

    initial 
    begin
        $dumpfile("processor.vcd");
        $dumpvars(0,dut);
    end

    final
    begin
        $writememh("rf_out.mem", dut.reg_file_i.reg_memory); 
        $writememh("d_m.mem", dut.data_mem_i.data_mem); 
        $writememh("csr_reg_out.mem", dut.csr_reg_i.csr_reg);
        $writememh("csr_reg_out.mem", dut.interupt_i.csr_reg);
    end

endmodule