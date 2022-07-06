`include "defines.v"

module core_alu (
    /* operand_port */
    input  [`OPERAND_WIDTH-1:0] oprd1,
    input  [`OPERAND_WIDTH-1:0] oprd2,

    /* control_signals */
    input  [`ALU_CTRL_WIDTH-1:0] alu_ctrl_i,

    /* alu_output */
    output [`OPERAND_WIDTH-1:0] alu_o
);

parameter ADD = `ALU_CTRL_WIDTH'b00000;
parameter SUB = `ALU_CTRL_WIDTH'b00001;
parameter XOR = `ALU_CTRL_WIDTH'b00011;
parameter OR  = `ALU_CTRL_WIDTH'b00010;
parameter AND = `ALU_CTRL_WIDTH'b00110;
parameter SLL = `ALU_CTRL_WIDTH'b00100;
parameter SRL = `ALU_CTRL_WIDTH'b00101;
parameter SRA = `ALU_CTRL_WIDTH'b00111;
parameter LT  = `ALU_CTRL_WIDTH'b01111;
parameter LTU = `ALU_CTRL_WIDTH'b01011;

parameter MUL   = `ALU_CTRL_WIDTH'b10000;
parameter MULH  = `ALU_CTRL_WIDTH'b10001;
parameter MULSU = `ALU_CTRL_WIDTH'b10011;
parameter MULHU = `ALU_CTRL_WIDTH'b10010;
parameter DIV   = `ALU_CTRL_WIDTH'b10110;
parameter DIVU  = `ALU_CTRL_WIDTH'b10100;
parameter REM   = `ALU_CTRL_WIDTH'b10101;
parameter REMU  = `ALU_CTRL_WIDTH'b10111;

wire [`OPERAND_WIDTH-1:0] add_out;
wire [`OPERAND_WIDTH-1:0] sub_out;
wire [`OPERAND_WIDTH-1:0] xor_out;
wire [`OPERAND_WIDTH-1:0] or_out;
wire [`OPERAND_WIDTH-1:0] and_out;
wire [`OPERAND_WIDTH-1:0] sll_out;
wire [`OPERAND_WIDTH-1:0] srl_out;
wire [`OPERAND_WIDTH-1:0] sra_out;
wire [`OPERAND_WIDTH-1:0] lt_out;
wire [`OPERAND_WIDTH-1:0] ltu_out;
wire [`OPERAND_WIDTH-1:0] mul_out;
wire [`OPERAND_WIDTH-1:0] mulh_out;
wire [`OPERAND_WIDTH-1:0] mulsu_out;
wire [`OPERAND_WIDTH-1:0] mulhu_out;
wire [`OPERAND_WIDTH-1:0] div_out;
wire [`OPERAND_WIDTH-1:0] divu_out;
wire [`OPERAND_WIDTH-1:0] rem_out;
wire [`OPERAND_WIDTH-1:0] remu_out;

wire signed [`OPERAND_WIDTH-1:0] s_oprd1;
wire signed [`OPERAND_WIDTH-1:0] s_oprd2;

wire [`OPERAND_WIDTH-1:0] s_mul;
wire [`OPERAND_WIDTH-1:0] su_mul;

assign s_oprd1 = oprd1;
assign s_oprd2 = oprd2;

assign add_out    = oprd1 + oprd2;
assign sub_out    = oprd1 - oprd2;
assign xor_out    = oprd1 ^ oprd2;
assign or_out     = oprd1 | oprd2;
assign and_out    = oprd1 & oprd2;
assign sll_out    = oprd1 << oprd2[5:0];
assign srl_out    = oprd1 >> oprd2[5:0];
assign sra_out    = s_oprd1 >>> oprd2[5:0];
assign lt_out     = (s_oprd1 < s_oprd2) ? 1 : 0;
assign ltu_out    = (oprd1 < oprd2) ? 1 : 0;

assign {mulhu_out, mul_out} = oprd1 * oprd2;
assign {mulh_out, s_mul}    = s_oprd1 * s_oprd2;
assign {mulsu_out, su_mul} = s_oprd1 * oprd2; // TEST
assign div_out = s_oprd1 / s_oprd2;
assign divu_out = oprd1 / oprd2;
assign rem_out = s_oprd1 % s_oprd2;
assign remu_out = oprd1 % oprd2;

MuxKey #(18, `ALU_CTRL_WIDTH, `OPERAND_WIDTH) u_MuxKey(
    .out (alu_o      ),
    .key (alu_ctrl_i ),
    .lut ({
        ADD, add_out,
        SUB, sub_out,
        XOR, xor_out,
        OR , or_out ,
        AND, and_out,
        SLL, sll_out,
        SRL, srl_out,
        SRA, sra_out,
        LT , lt_out ,
        LTU, ltu_out,
        MUL  , mul_out,
        MULH , mulh_out,
        MULSU, mulsu_out,
        MULHU, mulhu_out,
        DIV  , div_out,
        DIVU , divu_out,
        REM  , rem_out,
        REMU , remu_out
    } )
);

    
endmodule