`include "defines.v"

module core_pc_reg (
    /* read _port */
    output [63:0] pc_o,

    /* write_port */
    input  [63:0] pc_i,
    
    /* control_signals */
    input  wen,
    
    /* basic_signals */
    input  clk,
    input  rst_n
);

Reg #(`CPU_PC_SIZE, `CPU_PC_RST_IDX) pc(
	.clk  (clk    ),
    .rst  (~rst_n ),
    .din  (pc_i   ),
    .dout (pc_o   ),
    .wen  (wen    )
);
    
    
endmodule