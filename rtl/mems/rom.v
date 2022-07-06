
module rom_uninit #(
    parameter ADDR_NUM = 2,
    parameter ADDR_LEN = 1 + 5 - 3,
    parameter DATA_LEN = 32
) (
    input  [ADDR_LEN-1:0] rom_idx_i,
    output [DATA_LEN-1:0] rom_data_o,

    input  [ADDR_NUM*DATA_LEN-1:0] init_data_i,

    /* basic_signals */
    input clk,
    input rst_n
);

wire [ADDR_LEN+3-1:0] rom_addr;
reg [ADDR_NUM*DATA_LEN-1:0] rom_data;

genvar n;
/* initial ROM */
generate
    for (n = 0; n < ADDR_NUM; n = n + 1) begin
        always @(posedge clk) begin
            if (~rst_n) begin
                rom_data[DATA_LEN*(n+1)-1:DATA_LEN*n] <= init_data_i[(ADDR_NUM-n)*DATA_LEN-1:(ADDR_NUM-n-1)*DATA_LEN];
            end
        end
    end
    
endgenerate


assign rom_addr = {rom_idx_i, 3'b000};

/* read data */
generate
    for (n = 0; n < DATA_LEN; n = n + 1) begin
        assign rom_data_o[n] = rom_data[rom_addr + n];
    end
endgenerate


endmodule