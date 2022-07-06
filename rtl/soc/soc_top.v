`include "defines.v"

module soc_top (
    /* test */
    output [`CPU_RFIDX_WIDTH-1:0] ex2hdu_rsd_idx_o,
    output [`CPU_RFIDX_WIDTH-1:0] ex2fwd_rs1_idx_o,
    output [`CPU_RFIDX_WIDTH-1:0] ex2fwd_rs2_idx_o,
    
    /* basic_signals */
    input                         clk,
    input                         rst_n
);

// instruction_fetch_signals
wire [`CPU_PC_SIZE-1:0]    ifu_pc_addr;
wire [`CPU_INSTR_SIZE-1:0] ifu_instr_fetched;
// memory_access_signals
wire                       mem_read;
wire                       mem_write;
wire [2:0]                 read_type;
wire [1:0]                 write_type;
wire [`OPERAND_WIDTH-1:0]  mem_wdata;
wire [`OPERAND_WIDTH-1:0]  mem_addr;
wire [`OPERAND_WIDTH-1:0]  mem_rdata;

core u_core(
    .ifu_pc_addr       (ifu_pc_addr       ),
    .ifu_instr_fetched (ifu_instr_fetched ),
    .mem_read          (mem_read          ),
    .mem_write         (mem_write         ),
    .read_type         (read_type         ),
    .write_type        (write_type        ),
    .mem_wdata         (mem_wdata         ),
    .mem_addr          (mem_addr          ),
    .mem_rdata         (mem_rdata         ),
    .ex2hdu_rsd_idx_o  (ex2hdu_rsd_idx_o  ),
    .ex2fwd_rs1_idx_o  (ex2fwd_rs1_idx_o  ),
    .ex2fwd_rs2_idx_o  (ex2fwd_rs2_idx_o  ),
    .clk               (clk               ),
    .rst_n             (rst_n             )
);

rom_top u_rom_top(
    .rom_idx_i  (ifu_pc_addr       ),
    .rom_data_o (ifu_instr_fetched ),
    .clk        (clk               ),
    .rst_n      (rst_n             )
);

ram_top u_ram_top(
    .idx_i      (mem_addr    ),
    .r_data_o   (mem_rdata   ),
    .w_data_i   (mem_wdata   ),
    .ren        (mem_read    ),
    .wen        (mem_write   ),
    .read_type  (read_type   ),
    .write_type (write_type  ),
    .clk        (clk         ),
    .rst_n      (rst_n       )
);


endmodule //soc_top