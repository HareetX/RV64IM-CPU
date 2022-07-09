`include "defines.v"

module core_id_ex (
    /* input_port */
    // main signals
    input  [`CPU_PC_SIZE-1:0]     pc_i,
    input  [`CPU_INSTR_SIZE-1:0]  instr_i,
    input  [`CPU_PC_SIZE-1:0]     snpc_i,
    input  [`OPERAND_WIDTH-1:0]   imm_i,
    input  [6:0]                  funt7_i,
    input  [2:0]                  funt3_i,

    input  [`CPU_RFIDX_WIDTH-1:0] rsd_idx_i,

    input  [`CPU_RFIDX_WIDTH-1:0] rs1_idx_i,
    input  [`CPU_RFIDX_WIDTH-1:0] rs2_idx_i,

    input  [`OPERAND_WIDTH-1:0]   rs1_data_i,
    input  [`OPERAND_WIDTH-1:0]   rs2_data_i,

    // control signals
    input  [1:0]                  alu_op_i,
    input  [1:0]                  alu_src_i,
    input                         alu_w_sext_i,
    input                         pc_oprd_src_i,

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
    output [`CPU_PC_SIZE-1:0]     snpc_o,
    output [`OPERAND_WIDTH-1:0]   imm_o,
    output [6:0]                  funt7_o,
    output [2:0]                  funt3_o,

    output [`CPU_RFIDX_WIDTH-1:0] rsd_idx_o,

    output [`CPU_RFIDX_WIDTH-1:0] rs1_idx_o,
    output [`CPU_RFIDX_WIDTH-1:0] rs2_idx_o,

    output [`OPERAND_WIDTH-1:0]   rs1_data_o,
    output [`OPERAND_WIDTH-1:0]   rs2_data_o,
    // control signals
    output [1:0]                  alu_op_o,
    output [1:0]                  alu_src_o,
    output                        alu_w_sext_o,

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

parameter EX_CTRL_LEN  = 2 + 2 + 1;
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

Reg #(`CPU_PC_SIZE, 0) u_Reg_snpc(
    .clk  (clk     ),
    .rst  (~rst_n  ),
    .din  (snpc_i    ),
    .dout (snpc_o    ),
    .wen  (1'b1    )
);

Reg #(`OPERAND_WIDTH, 0) u_Reg_imm(
    .clk  (clk      ),
    .rst  (~rst_n   ),
    .din  (imm_i    ),
    .dout (imm_o    ),
    .wen  (1'b1     )
);

Reg #(7, 0) u_Reg_funct7(
    .clk  (clk        ),
    .rst  (~rst_n     ),
    .din  (funt7_i    ),
    .dout (funt7_o    ),
    .wen  (1'b1       )
);

Reg #(3, 0) u_Reg_funct3(
    .clk  (clk        ),
    .rst  (~rst_n     ),
    .din  (funt3_i    ),
    .dout (funt3_o    ),
    .wen  (1'b1       )
);

Reg #(`CPU_RFIDX_WIDTH, 0) u_Reg_rsd_idx(
    .clk  (clk          ),
    .rst  (~rst_n       ),
    .din  (rsd_idx_i    ),
    .dout (rsd_idx_o    ),
    .wen  (1'b1         )
);

Reg #(`CPU_RFIDX_WIDTH, 0) u_Reg_rs1_idx(
    .clk  (clk          ),
    .rst  (~rst_n       ),
    .din  (rs1_idx_i    ),
    .dout (rs1_idx_o    ),
    .wen  (1'b1         )
);

Reg #(`CPU_RFIDX_WIDTH, 0) u_Reg_rs2_idx(
    .clk  (clk          ),
    .rst  (~rst_n       ),
    .din  (rs2_idx_i    ),
    .dout (rs2_idx_o    ),
    .wen  (1'b1         )
);

Reg #(`OPERAND_WIDTH, 0) u_Reg_rs1_data(
    .clk  (clk           ),
    .rst  (~rst_n        ),
    .din  (rs1_data_i    ),
    .dout (rs1_data_o    ),
    .wen  (1'b1          )
);

Reg #(`OPERAND_WIDTH, 0) u_Reg_rs2_data(
    .clk  (clk           ),
    .rst  (~rst_n        ),
    .din  (rs2_data_i    ),
    .dout (rs2_data_o    ),
    .wen  (1'b1          )
);

Reg #(EX_CTRL_LEN, 0) u_Reg_ex_ctrl(
    .clk  (clk     ),
    .rst  (~rst_n  ),
    .din  ({
        alu_op_i,
        alu_src_i,
        alu_w_sext_i
    }    ),
    .dout ({
        alu_op_o,
        alu_src_o,
        alu_w_sext_o
    }    ),
    .wen  (1'b1    )
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

endmodule //core_id_ex