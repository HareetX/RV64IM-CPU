`include "defines.v"

module core_mem_wb (
    /* input_port */
    // main signals
    input  [`CPU_PC_SIZE-1:0]     pc_i,
    input  [`CPU_INSTR_SIZE-1:0]  instr_i,
    input  [`OPERAND_WIDTH-1:0]   imm_i,

    input  [`CPU_RFIDX_WIDTH-1:0] rsd_idx_i,

    input  [`OPERAND_WIDTH-1:0]   alu_i,

    input  [`OPERAND_WIDTH-1:0]   mem_data_i,

    // control signals
    input                         reg_write_i,
    input  [2:0]                  mem2reg_i,

    /* output_port */
    // main signals
    output [`CPU_PC_SIZE-1:0]     pc_o,
    output [`CPU_INSTR_SIZE-1:0]  instr_o,
    output [`OPERAND_WIDTH-1:0]   imm_o,

    output [`CPU_RFIDX_WIDTH-1:0] rsd_idx_o,

    output [`OPERAND_WIDTH-1:0]   alu_o,

    output [`OPERAND_WIDTH-1:0]   mem_data_o,

    // control signals
    output                        reg_write_o,
    output [2:0]                  mem2reg_o,

    /* control_signals */

    /* basic_signals */
    input                         clk,
    input                         rst_n
);

parameter WB_CTRL_LEN  = 1 + 3;

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

Reg #(`OPERAND_WIDTH, 0) u_Reg_alu(
    .clk  (clk      ),
    .rst  (~rst_n   ),
    .din  (alu_i    ),
    .dout (alu_o    ),
    .wen  (1'b1     )
);

Reg #(`OPERAND_WIDTH, 0) u_Reg_mem_data(
    .clk  (clk           ),
    .rst  (~rst_n        ),
    .din  (mem_data_i    ),
    .dout (mem_data_o    ),
    .wen  (1'b1          )
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

endmodule //core_mem_wb