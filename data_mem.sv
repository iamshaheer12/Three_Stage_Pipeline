module data_mem
(
    input  logic        clock, 
    input  logic        red_enable, 
    input  logic        write_enable,
	input  logic [ 2:0] memory_type,
	input  logic [31:0] addr,
	input  logic [31:0] writedata,
	output logic [31:0] redata
);

	logic [31:0] data_mem [31:0]; 
	
	initial begin 
		$readmemb("d_m.mem", data_mem);
	end

    always_ff @(posedge clock)
    begin  
        if(write_enable)
        begin
        case(memory_type)
            3'b000: 
            begin
                data_mem[addr] <= writedata[7:0];
            end
            3'b001: 
            begin
                data_mem[addr] <= writedata[7:0];
                data_mem[addr+1] <= writedata[15:8];
            end
            3'b010:
            begin
                data_mem[addr] <= writedata[7:0];
                data_mem[addr+1] <= writedata[15:8];
                data_mem[addr+2] <= writedata[23:16];
                data_mem[addr+3] <= writedata[31:24];
            end
            default: data_mem[addr] <= 0; 
        endcase
        end
    end

    always_comb
    begin
        if(red_enable)
        begin
        case(memory_type)
            3'b000:
            begin
                    redata = $signed(data_mem[addr]);
            end
            3'b001:
            begin
                    redata = $signed({data_mem[addr+1], data_mem[addr]});
            end
            3'b010:
            begin
                    redata = $signed({data_mem[addr+3], data_mem[addr+2], data_mem[addr+1], data_mem[addr]});
            end
            3'b011:
            begin
                    redata = (data_mem[addr]);
            end
            3'b100:
            begin
                    redata = ({data_mem[addr+1], data_mem[addr]});
            end
            default: redata = 0;
        endcase
        end
    end  

    final
    begin
        $writememb("d_m.mem", dut.data_mem_i.data_mem);
    end

	
endmodule