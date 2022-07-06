`include "defines.v"

module core_if_id (
    /* input_port */
    // main signals
    input  [`CPU_PC_SIZE-1:0] pc_i,
    input  [`CPU_INSTR_SIZE-1:0] instr_i,

    /* output_port */
    // main signals
    output [`CPU_PC_SIZE-1:0] pc_o,
    output [`CPU_INSTR_SIZE-1:0] instr_o,

    /* control_signals */

    /* basic_signals */
    input clk,
    input rst_n

);

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

endmodule //core_if_id