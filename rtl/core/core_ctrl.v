`include "defines.v"

module core_ctrl (
    /* instruction_input */
    input  [`CPU_INSTR_SIZE-1:0] instr_i,
    input  [2:0] branch_judgment,
    
    /* output control signals */
    // use in IFU
    output pc_src,
    // use in IDU
    output idx_src,
    // use in EXU
    output [1:0] alu_op,
    output alu_src,
    output alu_w_sext,
    // use in MEM
    output mem_read,
    output mem_write,
    output [2:0] read_type,
    output [1:0] write_type,
    // use in WB
    output reg_write,
    output [2:0] mem2reg
    
);

wire [2:0] funct3;
wire [6:0] opcode;

wire branch;
wire branch_judge;
wire b_or_j;

wire r_format;
wire i_format;
wire load_format;
wire store_format;
wire branch_format;
wire jal_format;
wire jalr_format;
wire lui_format;
wire auipc_format;

wire w_alu;
wire n1;
wire n2;
wire n3;

assign funct3 = instr_i[14:12];
assign opcode = instr_i[6:0];
/* control signals */
// branch and jump
assign branch = opcode[6];
assign b_or_j = opcode[2];
assign pc_src = branch & (b_or_j | branch_judge);

MuxKey #(6, 3, 1) u_MuxKey(
    .out (branch_judge ),
    .key (funct3       ),
    .lut ({
        3'h0, branch_judgment[2],
        3'h1, ~branch_judgment[2],
        3'h4, branch_judgment[1],
        3'h5, ~branch_judgment[1],
        3'h6, branch_judgment[0],
        3'h7, ~branch_judgment[0]
    } )
);

// data memory
assign read_type = funct3;
assign write_type = funct3[1:0];

// main control signals
and a1(r_format,      ~opcode[6],  opcode[5],  opcode[4],             ~opcode[2], opcode[1], opcode[0]);
and a2(i_format,      ~opcode[6], ~opcode[5],  opcode[4],             ~opcode[2], opcode[1], opcode[0]);
and a3(load_format,   ~opcode[6], ~opcode[5], ~opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0]);
and a4(store_format,  ~opcode[6],  opcode[5], ~opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0]);
and a5(branch_format,  opcode[6],  opcode[5], ~opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0]);
and a6(jal_format,     opcode[6],  opcode[5], ~opcode[4],  opcode[3],  opcode[2], opcode[1], opcode[0]);
and a7(jalr_format,    opcode[6],  opcode[5], ~opcode[4], ~opcode[3],  opcode[2], opcode[1], opcode[0]);
and a8(lui_format,    ~opcode[6],  opcode[5],  opcode[4], ~opcode[3],  opcode[2], opcode[1], opcode[0]);
and a9(auipc_format,  ~opcode[6], ~opcode[5],  opcode[4], ~opcode[3],  opcode[2], opcode[1], opcode[0]);

assign idx_src = jalr_format;
assign alu_op = {i_format, r_format};
or o1(alu_src, i_format, load_format, store_format);
assign mem_read = load_format | store_format;
assign mem_write = store_format;
assign mem2reg[2] = opcode[5];
assign mem2reg[1] = opcode[2];
or o2(mem2reg[0], load_format, jal_format, jalr_format, auipc_format);
or o3(reg_write, r_format, i_format, load_format, jal_format, jalr_format, lui_format, auipc_format);

// w-instructions alu_o control signal
and a10(n1, instr_i[25], funct3[2]);
and a11(n2, ~instr_i[25], ~funct3[1], funct3[0]);
and a12(n3, ~funct3[2], ~funct3[1], ~funct3[0]);
or o4(w_alu, n1, n2, n3);
assign alu_w_sext = (r_format | i_format) & w_alu & instr_i[3];
    
endmodule