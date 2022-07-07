/* defines */
// program_counter
`define CPU_PC_SIZE       64
`define CPU_PC_RST_IDX    64'h80000000
// instruction
`define CPU_INSTR_SIZE    32
// register_file
`define CPU_RFIDX_WIDTH   5
`define CPU_REGS_NUM      32
`define CPU_RFDATA_WIDTH  64
// execution
`define OPERAND_WIDTH     64
`define ALU_CTRL_WIDTH    5
// rom
`define ROM_DATA_NUM      256
`define ROM_DATA_IDXLEN   8 + 5 - 3
// ram
`define RAM_DATA_NUM      32
`define RAM_DATA_IDXLEN   5 + 6
