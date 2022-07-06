`include "defines.v"

module core_alu_ctrl (
    /* imput_signals */
    input  [1:0] alu_op, // 00 / 01(R-type) / 10(I-type)
    input  [6:0] funct7,
    input  [2:0] funct3,

    /* output_control_signals */
    output [`ALU_CTRL_WIDTH-1:0] alu_ctrl
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

parameter DFT = `ALU_CTRL_WIDTH'b11111;

// Nodes between Mux
wire [`ALU_CTRL_WIDTH-1:0] n_alu;
wire [`ALU_CTRL_WIDTH-1:0] n_Rtype;
wire [`ALU_CTRL_WIDTH-1:0] n_Itype;
wire [`ALU_CTRL_WIDTH-1:0] n_shift;
wire [`ALU_CTRL_WIDTH-1:0] n_instrI;
wire [`ALU_CTRL_WIDTH-1:0] n_instrM;

wire funct7_flag;
wire [3:0] funct_op;

MuxKey #(2, 1, `ALU_CTRL_WIDTH) u_MuxKey1(
    .out (alu_ctrl            ),
    .key (alu_op[1]^alu_op[0] ),
    .lut ({
        1'd0, ADD,
        1'd1, n_alu
    } )
);

MuxKey #(2, 1, `ALU_CTRL_WIDTH) u_MuxKey2(
    .out (n_alu     ),
    .key (alu_op[1] ),
    .lut ({
        1'd0, n_Rtype,
        1'd1, n_Itype
    } )
);

MuxKeyWithDefault #(6, 3, `ALU_CTRL_WIDTH) u_MuxKeyWithDefault_Itype(
    .out         (n_Itype     ),
    .key         (funct3      ),
    .default_out (n_shift ),
    .lut         ({
        3'h0, ADD,
        3'h4, XOR,
        3'h6, OR,
        3'h7, AND,
        3'h2, LT,
        3'h3, LTU
    }         )
);

assign funct7_flag = |{funct7[6],funct7[4:1]};
assign funct_op = {funct7[5], funct3};

MuxKeyWithDefault #(3, 4, `ALU_CTRL_WIDTH) u_MuxKeyWithDefault_shift(
    .out         (n_shift                     ),
    .key         ({4{funct7_flag}} ^ funct_op ),
    .default_out (DFT                         ),
    .lut         ({
        4'b0001, SLL,
        4'b0101, SRL,
        4'b1101, SRA
    }                         )
);

assign n_Rtype = ((|funct7[6:1]) | (~funct7[0])) ? n_instrI : n_instrM;

MuxKeyWithDefault #(10, 4, `ALU_CTRL_WIDTH) u_MuxKeyWithDefault_instrI(
    .out (n_instrI                                ),
    .key ({4{funct7_flag | funct7[0]}} ^ funct_op ),
    .default_out (DFT                             ),
    .lut ({
        4'b0000, ADD,
        4'b1000, SUB,
        4'b0100, XOR,
        4'b0110, OR ,
        4'b0111, AND,
        4'b0001, SLL,
        4'b0101, SRL,
        4'b1101, SRA, 
        4'b0010, LT ,
        4'b0011, LTU
    }                        )
);

MuxKey #(8, 3, `ALU_CTRL_WIDTH) u_MuxKey_instrM(
    .out (n_instrM     ),
    .key (funct3       ),
    .lut ({
        3'h0, MUL,
        3'h1, MULH,
        3'h2, MULSU,
        3'h3, MULHU,
        3'h4, DIV,
        3'h5, DIVU,
        3'h6, REM,
        3'h7, REMU
    } )
);

endmodule