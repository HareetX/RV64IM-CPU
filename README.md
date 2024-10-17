# RV64IM 5-Stage Pipelined Processor

This project implements a 5-stage pipelined processor that supports the RV64IM (RISC-V 64-bit integer and multiply/divide) instruction set. The pipeline includes stages for instruction fetch (IF), instruction decode (ID), execute (EX), memory access (MEM), and write-back (WB). Data hazards are resolved using forwarding, while control hazards are managed using a simple branch-not-taken assumption.

## Pipeline Overview

The pipeline consists of five stages:

1. **IF (Instruction Fetch)**: Fetches the instruction from instruction memory using the program counter (PC).
2. **ID (Instruction Decode)**: Decodes the instruction, reads operands from the register file, and extracts immediate values.
3. **EX (Execute)**: Performs arithmetic or logical operations using the ALU or calculates memory addresses.
4. **MEM (Memory Access)**: Reads from or writes to data memory.
5. **WB (Write-Back)**: Writes the result back to the register file.

## Data Hazard Handling

Data hazards are managed using forwarding and stalling mechanisms:

- **Forwarding**: Operands produced in the EX stage are forwarded directly to dependent instructions in the ID or EX stages.
- **Stalling**: For hazards that cannot be resolved by forwarding (e.g., load-use data hazards), the pipeline stalls the dependent instruction until the data is available.

## Control Hazard Handling

Control hazards are managed using a simple branch-not-taken approach:

- **Branch Not Taken**: The pipeline assumes that branches will not be taken. If a branch is taken, the instructions fetched during this time are flushed.

## Major Components

### 1. Data Path

The data path manages the flow of data through the CPU and includes the following components:

- **IF Stage**:
  - `PC Register`: Stores the address of the current instruction.
  - `Instruction Memory (ROM)`: Stores the program instructions.
- **IF/ID Register**: Latches the outputs of the IF stage for use in the next stage.
- **ID Stage**:
  - `Register File`: Holds the CPU's general-purpose registers.
  - `Immediate Decoder`: Extracts immediate values from the instruction.
- **ID/EX Register**: Latches the outputs of the ID stage for use in the next stage.
- **EX Stage**:
  - `ALU`: Performs arithmetic, logic operations, and address calculation.
- **EX/MEM Register**: Latches the outputs of the EX stage for use in the next stage.
- **MEM Stage**:
  - `Data Memory (RAM)`: Stores data that the program can read or write.
- **MEM/WB Register**: Latches the outputs of the MEM stage for use in the next stage.
- **WB Stage**: Writes the results back to the register file.

### 2. Control Unit

The control unit generates control signals to manage the flow of data through the pipeline and includes the following components:

- **ALU Control Unit**: Determines the specific operation for the ALU based on the instruction type.
- **Main Control Unit**: Decodes instructions and generates control signals for the data path.
- **Forwarding Control Unit**: Detects data hazards and generates signals for forwarding.
- **Hazard Detection Unit**: Detects situations where stalling is necessary, such as load-use hazards.
