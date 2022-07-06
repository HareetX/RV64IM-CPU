`include "defines.v"

module rom_top #(
    parameter BASE_IDX = `CPU_PC_RST_IDX,
    parameter IDX_LEN  = `CPU_PC_SIZE,
    parameter DATA_LEN = `CPU_INSTR_SIZE
) (
    input  [IDX_LEN-1:0]  rom_idx_i,
    output [DATA_LEN-1:0] rom_data_o,

    input  clk,
    input  rst_n
);

wire [IDX_LEN-1:0] rom_idx;

assign rom_idx = rom_idx_i - BASE_IDX;

rom_uninit #(`ROM_DATA_NUM, `ROM_DATA_IDXLEN, DATA_LEN) u_rom_uninit(
    .rom_idx_i   (rom_idx[`ROM_DATA_IDXLEN-1:0]   ),
    .rom_data_o  (rom_data_o                      ),
    .init_data_i ({
        32'h3FF00093,	// addi x1 x0 1023
        32'h3FF00113,	// addi x2 x0 1023
        32'h00100013,	// addi x0 x0 1
        32'h401001B3,	// sub x3 x0 x1
        32'h00208233,	// add x4 x1 x2
        32'h00100013,	// addi x0 x0 1
        32'h00208023,	// sb x2 0(x1)
        32'h00309423,	// sh x3 8(x1)
        32'h0030AC23,   // sw x3 24(x1)
        32'h0230BC23,   // sd x3 56(x1)
        32'h00008283,	// lb x5 0(x1)	
        32'h00009303,	// lh x6 0(x1)	
        32'h0000A383,	// lw x7 0(x1)
        32'h0000C403,	// lbu x8 0(x1)
        32'h0000D483,	// lhu x9 0(x1)
        32'h00016503,   // lwu x10 0(x2)
        32'h0000B583,   // ld x11 0(x1)

        32'hFE208C23,	// sb x2 -8(x1)
        32'hFE309423,	// sh x3 -24(x1)
        32'hFC30A423,   // sw x3 -56(x1)
        32'hF830B423,	// sd x3 -120(x1)
        32'h0000B603,	// ld x12 0(x1)
        32'hFF80B683,	// ld x13 -8(x1)
        32'hFE80B703,	// ld x14 -24(x1)
        32'hFC80B783,	// ld x15 -56(x1)
        32'hF880B803,	// ld x16 -120(x1)
        32'hFC00B883,	// ld x17 -64(x1)
        
        32'b0000000_00000_00000_000_00000_0000000,
        32'b0000000_00000_00000_000_00000_0000000,
        32'b0000000_00000_00000_000_00000_0000000,
        32'b0000000_00000_00000_000_00000_0000000,
        32'b0000000_00000_00000_000_00000_0000000
    } ), // 32-bit instructions
    .clk         (clk                              ),
    .rst_n       (rst_n                            )
);

endmodule