
module ram #(
    parameter ADDR_NUM = 2,
    parameter ADDR_LEN = 1 + 6,
    parameter DATA_LEN = 64
) (
    /* index_port */
    input  [ADDR_LEN-1:0] idx_i,
    /* read_port */
    output [DATA_LEN-1:0] r_data_o,
    /* write_port */
    input  [DATA_LEN-1:0] w_data_i,

    /* control_signals */
    input  wen,
    input  ren,

    /* basic_signals */
    input clk,
    input rst_n
);

reg  [ADDR_NUM*DATA_LEN-1:0] ram_data;

genvar n;
/* read data from Data_Memery */
generate
    for (n = 0; n < DATA_LEN; n = n + 1) begin
        assign r_data_o[n] = ren & ram_data[idx_i + n];
    end
endgenerate

/* write data to Data_Memery */
generate
    for (n = 0; n < DATA_LEN; n = n + 1) begin
        always @(posedge clk) begin
            if (~rst_n) begin
                ram_data <= 0;
            end
            else if (wen) begin
                ram_data[idx_i+n] <= w_data_i[n];
            end
        end
    end
endgenerate

endmodule