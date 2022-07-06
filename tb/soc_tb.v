`timescale 1ps/1ps
`include "..\\rtl\\defines.v"

module soc_tb;
/* test */
wire [`CPU_RFIDX_WIDTH-1:0] ex2hdu_rsd_idx_o;
wire [`CPU_RFIDX_WIDTH-1:0] ex2fwd_rs1_idx_o;
wire [`CPU_RFIDX_WIDTH-1:0] ex2fwd_rs2_idx_o;

/* basic_signals */
reg                         clk;
reg                         rst_n;

parameter clk_period = 10;  
initial begin  
    clk = 0;  
    forever  
        #(clk_period/2) clk = ~clk;  
end  

initial begin
    rst_n = 0;
    #(clk_period) rst_n = ~rst_n;
end

initial begin
    $dumpfile("./build/wave.vcd");
    $dumpvars(0,soc_tb);
    #10000 $finish;
end

soc_top u_soc_top(
    .ex2hdu_rsd_idx_o (ex2hdu_rsd_idx_o ),
    .ex2fwd_rs1_idx_o (ex2fwd_rs1_idx_o ),
    .ex2fwd_rs2_idx_o (ex2fwd_rs2_idx_o ),
    .clk              (clk              ),
    .rst_n            (rst_n            )
);


endmodule //soc_tb