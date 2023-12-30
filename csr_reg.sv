module csr_reg
(
    input  logic         clock,
    input  logic         reset,
    input  logic [31: 0] addr,
    input  logic [31: 0] writedata, 
    input  logic [31: 0] pc,   
    input  logic         csr_red, 
    input  logic         csr_write,
    input  logic [31: 0] instruction,
    output logic [31: 0] redata
);
    logic [31: 0] csr_reg [4];

    // asynchronous read
    always_comb
    begin
        if (csr_red)
        begin
            case (addr)
                12'h300: redata = csr_reg[0]; // Machine Status 
                12'h304: redata = csr_reg[1]; // MIE
                12'h341: redata = csr_reg[2]; // MEPC
                12'h344: redata = csr_reg[3]; // MIP
            endcase
        end
        else
        begin
            redata = 32'b0;
        end
    end

    always_ff @(posedge clock)
    begin
        if (csr_write)
        begin
            case (addr)
                12'h300: csr_reg[0] <= writedata; // Machine Status
                12'h304: csr_reg[1] <= writedata; // MIE
                12'h341: csr_reg[2] <= writedata; // MEPC
                12'h344: csr_reg[3] <= writedata; // MIP 
            endcase
        end
    end

    
endmodule