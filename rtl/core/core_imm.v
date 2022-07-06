`include "defines.v"

module core_imm (
    /* input_instruction */
    input  [`CPU_INSTR_SIZE-1:0] instr_i,
    /* output_immediate_operand */
    output [`OPERAND_WIDTH-1:0] imm_o
);

// Nodes between AND-gate and OR-gate
wire n1;
wire n2;
wire n3;
wire n4;
wire n5;
wire n6;
wire n7;
// Immediate Operand
wire [`OPERAND_WIDTH-1:0] immR;
wire [`OPERAND_WIDTH-1:0] immI;
wire [`OPERAND_WIDTH-1:0] immS;
wire [`OPERAND_WIDTH-1:0] immB;
wire [`OPERAND_WIDTH-1:0] immU;
wire [`OPERAND_WIDTH-1:0] immJ;

// Immediate Operand key
parameter R_type = 3'd0;
parameter I_type = 3'd1;
parameter S_type = 3'd2;
parameter B_type = 3'd3;
parameter U_type = 3'd4;
parameter J_type = 3'd5;

wire [2:0] imm_key;

and a1(n1,  instr_i[6],  instr_i[5], ~instr_i[4],  instr_i[3],  instr_i[2], instr_i[1], instr_i[0]);
and a2(n2, ~instr_i[6],               instr_i[4], ~instr_i[3],  instr_i[2], instr_i[1], instr_i[0]);
and a3(n3,               instr_i[5], ~instr_i[4], ~instr_i[3], ~instr_i[2], instr_i[1], instr_i[0]);
and a4(n4, ~instr_i[6], ~instr_i[5],  instr_i[4],              ~instr_i[2], instr_i[1], instr_i[0]);
and a5(n5, ~instr_i[6], ~instr_i[5], ~instr_i[4], ~instr_i[3], ~instr_i[2], instr_i[1], instr_i[0]);
and a6(n6,  instr_i[6],  instr_i[5],              ~instr_i[3], ~instr_i[2], instr_i[1], instr_i[0]);
and a7(n7,  instr_i[6],  instr_i[5], ~instr_i[4],               instr_i[2], instr_i[1], instr_i[0]);

or o1(imm_key[2], n1, n2);
assign imm_key[1] = n3;
or o2(imm_key[0], n4, n5, n6, n7);

// Generate Immediate Operand
assign immR = 64'd0;
assign immI = {{52{instr_i[31]}}, instr_i[31:20]};
assign immS = {{52{instr_i[31]}}, instr_i[31:25], instr_i[11:7]};
assign immB = {{52{instr_i[31]}}, instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0};
assign immU = {{32{instr_i[31]}}, instr_i[31:12], 12'h000};
assign immJ = {{44{instr_i[31]}}, instr_i[19:12], instr_i[20], instr_i[30:21], 1'b0};

MuxKey #(6, 3, `OPERAND_WIDTH) u_MuxKey(
    .out (imm_o   ),
    .key (imm_key ),
    .lut ({
        R_type, immR,
        I_type, immI,
        S_type, immS,
        B_type, immB,
        U_type, immU,
        J_type, immJ
    } )
);


endmodule