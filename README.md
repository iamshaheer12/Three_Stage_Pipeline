Three_Stages_Pipeline 

Certainly! Let's delve into more detailed explanations for each module in the three-stage pipeline processor with hazards. 

  Here is my Architectural Diagram ![Three Stage Pipeline](https://github.com/iamshaheer12/Three_Stages_Pipeline/assets/118367889/dfa40fa4-9895-4c4b-bb76-1d6b238fc502)

 1. **IF Stage** 

  

#### `PC.sv` 

  

This module, the Program Counter (PC), is a crucial part of the instruction fetch stage. 

  

**Inputs:** 

  - `clock`: The clock signal that regulates the module's operations. 

  - `reset`: The reset signal that initializes or resets the PC. 

  - `en`: The enable signal that controls the incrementing of the PC. 

  - `pc_input`: The input program counter value for setting the PC to a specific value. 

  

**Outputs:** 

    `pc_output`: The output program counter value. 

  

**Functionality:** 

  - On each rising edge of the clock (`clock`), the module updates the program counter (`pc_output`). 

  - The PC is initialized to 0 and increments by 4 in each clock cycle when enabled (`en`). 

  - It can be reset (`reset`) to 0. 

  

#### `inst_mem.sv` 

  

This module represents the instruction memory, providing instructions based on the given address. 

  

**Inputs:** 

   `addr`: Address for instruction fetch. 

  

**Outputs:** 

`data`: Fetched instruction. 

  

**Functionality:** 

  - Reads the instruction from memory (`mem`) based on the provided address. 

  

 2. **ID Stage** 

  

 `inst_decode.sv` 

  

This module decodes instructions, extracting relevant fields such as opcode, source, and destination registers. 

  

**Inputs:** 

  - `clock`: Clock signal. 

  - `instruction`: Input instruction. 

  

**Outputs:** 

  - `rd`, `rs_1`, `rs_2`: Destination, source 1, and source 2 registers. 

  - `opcode`: Opcode of the instruction. 

  - `func_3`, `func_7`: Function codes for additional instruction details. 

  

 **Functionality:** 

  - Extracts different fields from the input instruction. 

  

`reg_file.sv` 

  

This module implements the register file, allowing the processor to read and write data to registers. 

  

**Inputs:** 

  - `clock`: Clock signal. 

  - `ref_en`: Enable signal for register file access. 

  - `rs_1`, `rs_2`: Source registers for read operations. 

  - `red`: Destination register for write operation. 

  - `writedata`: Data to be written into the register file. 

  

**Outputs:** 

  - `redata1`, `redata2`: Data read from source registers. 

  

**Functionality:** 

  - Implements a register file with asynchronous read and synchronous write operations. 

  

 `controller.sv 

This module generates control signals based on the opcode and function codes of instructions. 

  

**Inputs:** 

  - `opcode`: Opcode of the instruction. 

  - `func_7`, `func_3`: Function codes for additional instruction details. 

  - `ref_en`: Enable signal for register file access. 

  

**Outputs:** 

  - Various control signals like `selec_opr_a`, `selec_opr_b`, `selec_wb`, etc. 

  

**Functionality:** 

  - Analyzes the opcode and function codes to generate control signals for the processor. 

`hazard_detection.sv 

This module detects hazards, including data hazards and branch hazards. 

  

**Inputs:** 

  - `ref_en`: Enable signal for register file access. 

  - `rs_1`, `rs_2`: Source registers. 

  - `red`: Destination register. 

  - `selec_wb`: Write-back selection signal. 

  - `stall_if`, `stall_id_ex`: Stall signals for different pipeline stages. 

  - `flush_id_ex`: Flush signal for the ID/EX pipeline register. 

  - `branch_taken`: Signal indicating a taken branch. 

*Outputs:** 

  - `forward_a`, `forward_b`: Signals indicating hazards for operand forwarding. 

  - `stall_if`, `stall_id_ex`: Stall signals for different pipeline stages. 

  - `flush_id_ex`: Flush signal for the ID/EX pipeline register. 

  - `branch_taken`: Signal indicating a taken branch. 

  

Certainly! In the hazards detection module (hazard_detection.sv), various types of hazards are identified and handled. Let's break down how each hazard is managed: 

  

1. Data Hazards 

a. Forwarding for Operand A (forward_a) 

if (((rs_1 == red) & ref_en) & (rs_1 != 0)) 

    forward_a = 1'b1; 

else 

    forward_a = 1'b0; 

This section checks if there is a data hazard for operand A. If the source register (rs1) matches the destination register (rd) of the previous instruction (and register file is enabled), a hazard is detected, and for_a is set to 1 to enable operand forwarding. Otherwise, it is set to 0. 

  

b. Forwarding for Operand B (forward_b) 

if (((rs_2 == red) & ref_en) & (rs_2 != 0)) 

    forward_b = 1'b1; 

else 

    forward_b = 1'b0; 

Similar to operand A, this section checks for a data hazard for operand B. If the source register (rs_2) matches the destination register (red) of the previous instruction (and register file is enabled), forward_b is set to 1 for operand forwarding; otherwise, it is set to 0. 

  

2. Load-Use Data Hazard (Stall for Load) 

c. Load-Use Hazard (stall_lw) 

if((selec_wb == 2'b01) & ((rs_1 == rd) | (rs_2 == red))) 

    stall_lw = 1'b1; 

else 

    stall_lw = 1'b0; 

This section checks for a load-use hazard, where the previous instruction is a load (selec_wb == 2'b01) and the source registers (rs_1 or rs_2) match the destination register (red) of the current instruction. If such a hazard is detected, stall_lw is set to 1 to stall the pipeline, preventing the use of potentially incorrect data. 

  

3. Branch Hazard 

d. Branch Hazard (flush_id_ex) 

assign flush_id_ex = (stall_lw | br_taken); 

The flush_id_ex signal is used to flush the ID/EX pipeline register. It is set to 1 when either a load-use hazard (stall_lw) or a branch is taken (branch_taken). Flushing the pipeline helps in maintaining correct program execution by avoiding the propagation of incorrect data or instructions. 

 3. **EX Stage** 

  

 `alu.sv` 

  

This module is the Arithmetic Logic Unit (ALU), responsible for executing arithmetic and logical operations. 

  

"Inputs": 

aluop: 4-bit input representing the ALU operation code. 

opr_a, opr_b: 32-bit inputs representing the operands for the ALU operation. 

  

Outputs: 

opr_reset: 32-bit output representing the result of the ALU operation. 

  

**Functionality:** 

The alu module is an Arithmetic Logic Unit that performs various arithmetic and logical operations based on the aluop input. 

The case statement interprets the aluop code and executes the corresponding operation. 

ADD: Addition 

SUB: Subtraction 

AND: Bitwise AND 

OR: Bitwise OR 

XOR: Bitwise XOR 

NOT: Bitwise NOT 

SLL: Shift left logical 

SRL: Shift right logical 

SRA: Shift right arithmetic 

SLT: Set on less than 

The result of the operation is stored in the opr_res output. 

Note: 

The module uses SystemVerilog's case statement to easily handle different ALU operations. 

For each operation, it computes the result and assigns it to opr_res. 

The default case provides a default value (32'b0) for unknown or unsupported operations. 

  

Branch_comp.sv 

Module Purpose: 

The Branch_comp module is designed to compare two operands and determine whether a branch should be taken. It plays a critical role in the execution stage of the processor, evaluating conditions for branch instructions. 

  

Module Inputs: 

branch_type: This input represents the type of branch operation to be performed. It is a control signal generated by the controller based on the opcode and function codes of the instruction.  

opr_a and opr_b: These inputs are the two operands that need to be compared to evaluate the branch condition. The values of these operands are typically derived from previous stages of the pipeline. 

  


Module Outputs: 

branch_taken: This output is a control signal indicating whether the branch should be taken. If br_taken is asserted (logic high), the processor should take the branch; otherwise, it continues with the sequential execution of instructions. 

Functional Description: 

The Branch_comp module performs different types of comparisons based on the br_type input. The supported branch types may include equality, inequality, less than, greater than, etc. 

  

Equality (BEQ): 

  

If branch_type is set to the equality condition, the module checks if opr_a is equal to opr_b. 

Inequality (BNE): 

  

If branch_type is set to the inequality condition, the module checks if opr_a is not equal to opr_b. 

Less Than (BLT): 

  

If branch_type is set to the less-than condition, the module checks if opr_a is less than opr_b. 

Greater Than (BGT): 

  

If branch_type is set to the greater-than condition, the module checks if opr_a is greater than opr_b. 

#Less Than or Equal (BLE): 

  

If branch_type is set to the less-than-or-equal condition, the module checks if opr_a is less than or equal to opr_b. 

Greater Than or Equal (BGE): 

  

If branch_type is set to the greater-than-or-equal condition, the module checks if opr_a is greater than or equal to opr_b. 

Example: 

For example, if the br_type is set to the equality condition (BEQ), the module will assert br_taken if opr_a is equal to opr_b. If br_taken is asserted, it indicates that the branch condition is satisfied, and the processor should take the branch. 

  
The output br_taken is typically used in the processor's control logic to determine whether to update the program counter for a branch instruction. If br_taken is asserted, the program counter is modified to the branch target address; otherwise, it proceeds with the next sequential instruction. 


Considerations: 

The specific branch conditions and comparisons supported by the module may vary based on the RISC-V ISA and the design choices made in the processor. 

Usage: 
## How to Use

1. Clone the repository: `git clone https://github.com/iamshaheer12/Three_Stages_Pipeline.git`
2. Navigate to the project directory: `cd three-stage-pipeline-verilog`

## Simulation

To simulate the processor, use the provided testbench and simulation scripts:

1. Navigate to the `sim/` directory.
2. Run the simulation script: `./CC.bat`



  
