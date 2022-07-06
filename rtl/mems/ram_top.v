`include "defines.v"

module ram_top #(
    parameter IDX_LEN  = `OPERAND_WIDTH,
    parameter DATA_LEN = `OPERAND_WIDTH
) (
    /* index_port */
    input  [IDX_LEN-1:0] idx_i,
    /* read_port */
    output [DATA_LEN-1:0] r_data_o,
    /* write_port */
    input  [DATA_LEN-1:0] w_data_i,

    /* control_signals */
    input  ren,
    input  wen,

    input  [2:0] read_type,
    input  [1:0] write_type,

    /* basic_signals */
    input clk,
    input rst_n
);

wire [DATA_LEN-1:0] r_data_tmp;
wire [DATA_LEN-1:0] w_data_tmp;

ram #(`RAM_DATA_NUM, `RAM_DATA_IDXLEN, DATA_LEN) u_ram(
    .idx_i    (idx_i[`RAM_DATA_IDXLEN-1:0]    ),
    .r_data_o (r_data_tmp                     ),
    .w_data_i (w_data_tmp                     ),
    .wen      (wen                            ),
    .ren      (ren                            ),
    .clk      (clk                            ),
    .rst_n    (rst_n                          )
);

MuxKey #(7, 3, DATA_LEN) u_MuxKey_read(
    .out (r_data_o  ),
    .key (read_type ),
    .lut ({
        3'd0, {{56{r_data_tmp[7]}}, r_data_tmp[7:0]},
        3'd1, {{48{r_data_tmp[15]}}, r_data_tmp[15:0]},
        3'd2, {{32{r_data_tmp[31]}}, r_data_tmp[31:0]},
        3'd3, r_data_tmp[63:0],
        3'd4, {56'b0, r_data_tmp[7:0]},
        3'd5, {48'b0, r_data_tmp[15:0]},
        3'd6, {32'b0, r_data_tmp[31:0]}
    } )
);

MuxKey #(4, 2, DATA_LEN) u_MuxKey_write(
    .out (w_data_tmp ),
    .key (write_type ),
    .lut ({
        2'd0, {r_data_tmp[63:8], w_data_i[7:0]},
        2'd1, {r_data_tmp[63:16], w_data_i[15:0]},
        2'd2, {r_data_tmp[63:32], w_data_i[31:0]},
        2'd3, w_data_i[63:0]
    } )
);

endmodule
