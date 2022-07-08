`include "defines.v"

module core_ex_mem (
    /* input_port */
    // main signals
    input  [`CPU_PC_SIZE-1:0]     pc_i,
    input  [`CPU_INSTR_SIZE-1:0]  instr_i,
    input  [`OPERAND_WIDTH-1:0]   imm_i,
    
    input  [`CPU_RFIDX_WIDTH-1:0] rsd_idx_i,
    
    input  [`OPERAND_WIDTH-1:0]   rs2_data_i,

    input  [`OPERAND_WIDTH-1:0]   alu_i,

    input  [`CPU_PC_SIZE-1:0]     pc_offset_result_i,
    
    // control signals
    input                         mem_read_i,
    input                         mem_write_i,
    input  [2:0]                  read_type_i,
    input  [1:0]                  write_type_i,

    input                         reg_write_i,
    input  [1:0]                  mem2reg_i,

    /* output_port */
    // main signals
    output [`CPU_PC_SIZE-1:0]     pc_o,
    output [`CPU_INSTR_SIZE-1:0]  instr_o,
    output [`OPERAND_WIDTH-1:0]   imm_o,

    output [`CPU_RFIDX_WIDTH-1:0] rsd_idx_o,

    output [`OPERAND_WIDTH-1:0]   rs2_data_o,

    output [`OPERAND_WIDTH-1:0]   alu_o,

    output [`CPU_PC_SIZE-1:0]     pc_offset_result_o,
    
    // control signals
    output                        mem_read_o,
    output                        mem_write_o,
    output [2:0]                  read_type_o,
    output [1:0]                  write_type_o,

    output                        reg_write_o,
    output [1:0]                  mem2reg_o,

    /* control_signals */

    /* basic_signals */
    input                         clk,
    input                         rst_n
);

parameter MEM_CTRL_LEN = 1 + 1 + 3 + 2;
parameter WB_CTRL_LEN  = 1 + 2;

Reg #(`CPU_PC_SIZE, 0) u_Reg_pc(
    .clk  (clk     ),
    .rst  (~rst_n  ),
    .din  (pc_i    ),
    .dout (pc_o    ),
    .wen  (1'b1    )
);

Reg #(`CPU_INSTR_SIZE, 0) u_Reg_instr(
    .clk  (clk      ),
    .rst  (~rst_n   ),
    .din  (instr_i  ),
    .dout (instr_o  ),
    .wen  (1'b1     )
);

Reg #(`OPERAND_WIDTH, 0) u_Reg_imm(
    .clk  (clk      ),
    .rst  (~rst_n   ),
    .din  (imm_i    ),
    .dout (imm_o    ),
    .wen  (1'b1     )
);

Reg #(`CPU_RFIDX_WIDTH, 0) u_Reg_rsd_idx(
    .clk  (clk          ),
    .rst  (~rst_n       ),
    .din  (rsd_idx_i    ),
    .dout (rsd_idx_o    ),
    .wen  (1'b1         )
);

Reg #(`OPERAND_WIDTH, 0) u_Reg_rs2_data(
    .clk  (clk           ),
    .rst  (~rst_n        ),
    .din  (rs2_data_i    ),
    .dout (rs2_data_o    ),
    .wen  (1'b1          )
);

Reg #(`OPERAND_WIDTH, 0) u_Reg_alu(
    .clk  (clk      ),
    .rst  (~rst_n   ),
    .din  (alu_i    ),
    .dout (alu_o    ),
    .wen  (1'b1     )
);

Reg #(`CPU_PC_SIZE, 0) u_Reg_pc_offset_result(
    .clk  (clk                   ),
    .rst  (~rst_n                ),
    .din  (pc_offset_result_i    ),
    .dout (pc_offset_result_o    ),
    .wen  (1'b1                  )
);

Reg #(MEM_CTRL_LEN, 0) u_Reg_mem_ctrl(
    .clk  (clk     ),
    .rst  (~rst_n  ),
    .din  ({
        mem_read_i,
        mem_write_i,
        read_type_i,
        write_type_i
    }  ),
    .dout ({
        mem_read_o,
        mem_write_o,
        read_type_o,
        write_type_o
    } ),
    .wen  (1'b1    )
);

Reg #(WB_CTRL_LEN, 0) u_Reg_wb_ctrl(
    .clk  (clk     ),
    .rst  (~rst_n  ),
    .din  ({
        reg_write_i,
        mem2reg_i
    }  ),
    .dout ({
        reg_write_o,
        mem2reg_o
    } ),
    .wen  (1'b1    )
);

endmodule //core_ex_mem