 /*                                                                      
 Copyright 2022-2022 School of Physics and Technology， Wuhan University                
                                                                         
 Licensed under the Apache License, Version 2.0 (the "License");         
 you may not use this file except in compliance with the License.        
 You may obtain a copy of the License at                                 
                                                                         
     http://www.apache.org/licenses/LICENSE-2.0                          
                                                                         
  Unless required by applicable law or agreed to in writing, software    
 distributed under the License is distributed on an "AS IS" BASIS,       
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and     
 limitations under the License.                                          
 */      

`include "defines.v"

module core (
    /* external_signals */
    // instruction_fetch_signals
    output [`CPU_PC_SIZE-1:0]    ifu_pc_addr,

    input  [`CPU_INSTR_SIZE-1:0] ifu_instr_fetched,

    // memory_access_signals
    output                        mem_read,
    output                        mem_write,
    output [2:0]                  read_type,
    output [1:0]                  write_type,
    output [`OPERAND_WIDTH-1:0]   mem_wdata,
    output [`OPERAND_WIDTH-1:0]   mem_addr,
    
    input  [`OPERAND_WIDTH-1:0]   mem_rdata,
    
    /* test */
    output [`CPU_RFIDX_WIDTH-1:0] ex2hdu_rsd_idx_o,
    output [`CPU_RFIDX_WIDTH-1:0] ex2fwd_rs1_idx_o,
    output [`CPU_RFIDX_WIDTH-1:0] ex2fwd_rs2_idx_o,
    
    /* basic_signals */
    input                         clk,
    input                         rst_n
);

/* inter_reg_signals */
// IFU to IDU
wire [`CPU_PC_SIZE-1:0]       if2id_pc_i;
wire [`CPU_INSTR_SIZE-1:0]    if2id_instr_i;
wire [`CPU_PC_SIZE-1:0]       if2id_snpc_i;
wire [`CPU_PC_SIZE-1:0]       if2id_pc_o;
wire [`CPU_INSTR_SIZE-1:0]    if2id_instr_o;
wire [`CPU_PC_SIZE-1:0]       if2id_snpc_o;
// IDU to EXU
wire [`CPU_PC_SIZE-1:0]       id2ex_pc_i;
wire [`CPU_INSTR_SIZE-1:0]    id2ex_instr_i;
wire [`CPU_PC_SIZE-1:0]       id2ex_snpc_i;
wire [`OPERAND_WIDTH-1:0]     id2ex_imm_i;
wire [6:0]                    id2ex_funt7_i;
wire [2:0]                    id2ex_funt3_i;
wire [`CPU_PC_SIZE-1:0]       id2ex_pc_o;
wire [`CPU_INSTR_SIZE-1:0]    id2ex_instr_o;
wire [`CPU_PC_SIZE-1:0]       id2ex_snpc_o;
wire [`OPERAND_WIDTH-1:0]     id2ex_imm_o;
wire [6:0]                    id2ex_funt7_o;
wire [2:0]                    id2ex_funt3_o;

wire [`CPU_RFIDX_WIDTH-1:0]   id2ex_rsd_idx_i;
wire [`CPU_RFIDX_WIDTH-1:0]   id2ex_rsd_idx_o;

wire [`CPU_RFIDX_WIDTH-1:0]   id2ex_rs1_idx_i;
wire [`CPU_RFIDX_WIDTH-1:0]   id2ex_rs2_idx_i;
wire [`CPU_RFIDX_WIDTH-1:0]   id2ex_rs1_idx_o;
wire [`CPU_RFIDX_WIDTH-1:0]   id2ex_rs2_idx_o;

wire [`OPERAND_WIDTH-1:0]     id2ex_rs1_data_i;
wire [`OPERAND_WIDTH-1:0]     id2ex_rs2_data_i;
wire [`OPERAND_WIDTH-1:0]     id2ex_rs1_data_o;
wire [`OPERAND_WIDTH-1:0]     id2ex_rs2_data_o;
// EXU to MEM
wire [`CPU_PC_SIZE-1:0]       ex2mem_pc_i;
wire [`CPU_INSTR_SIZE-1:0]    ex2mem_instr_i;
wire [`CPU_PC_SIZE-1:0]       ex2mem_snpc_i;
wire [`OPERAND_WIDTH-1:0]     ex2mem_imm_i;
wire [`CPU_PC_SIZE-1:0]       ex2mem_pc_o;
wire [`CPU_INSTR_SIZE-1:0]    ex2mem_instr_o;
wire [`CPU_PC_SIZE-1:0]       ex2mem_snpc_o;
wire [`OPERAND_WIDTH-1:0]     ex2mem_imm_o;

wire [`CPU_RFIDX_WIDTH-1:0]   ex2mem_rsd_idx_i;
wire [`CPU_RFIDX_WIDTH-1:0]   ex2mem_rsd_idx_o;

wire [`OPERAND_WIDTH-1:0]     ex2mem_rs2_data_i;
wire [`OPERAND_WIDTH-1:0]     ex2mem_rs2_data_o;

wire [`OPERAND_WIDTH-1:0]     ex2mem_alu_i;
wire [`OPERAND_WIDTH-1:0]     ex2mem_alu_o;



// MEM to WB
wire [`CPU_PC_SIZE-1:0]       mem2wb_pc_i;
wire [`CPU_INSTR_SIZE-1:0]    mem2wb_instr_i;
wire [`CPU_PC_SIZE-1:0]       mem2wb_snpc_i;
wire [`OPERAND_WIDTH-1:0]     mem2wb_imm_i;
wire [`CPU_PC_SIZE-1:0]       mem2wb_pc_o;
wire [`CPU_INSTR_SIZE-1:0]    mem2wb_instr_o;
wire [`CPU_PC_SIZE-1:0]       mem2wb_snpc_o;
wire [`OPERAND_WIDTH-1:0]     mem2wb_imm_o;

wire [`CPU_RFIDX_WIDTH-1:0]   mem2wb_rsd_idx_i;
wire [`CPU_RFIDX_WIDTH-1:0]   mem2wb_rsd_idx_o;

wire [`OPERAND_WIDTH-1:0]     mem2wb_alu_i;
wire [`OPERAND_WIDTH-1:0]     mem2wb_alu_o;

wire [`OPERAND_WIDTH-1:0]     mem2wb_mem_data_i;
wire [`OPERAND_WIDTH-1:0]     mem2wb_mem_data_o;

// IDU <-> Register_File
wire [`CPU_RFIDX_WIDTH-1:0]   id2rf_rs1_idx;
wire [`CPU_RFIDX_WIDTH-1:0]   id2rf_rs2_idx;

wire [`OPERAND_WIDTH-1:0]     rf2id_rs1_data;
wire [`OPERAND_WIDTH-1:0]     rf2id_rs2_data;

// WB -> Register_File
wire [`CPU_RFIDX_WIDTH-1:0]   wb2rf_rsd_idx;
wire [`OPERAND_WIDTH-1:0]     wb2rf_rsd_data;

// pc_branch: IDU -> IFU
wire [`CPU_PC_SIZE-1:0]       id2if_pc_branch;

// Data_Path <-> Control_Unit
wire                          ifu_pc_src;
wire                          idu_idx_src;
wire [2:0]                    idu_branch_judgment;

wire [1:0]                    idu_alu_op;
wire [1:0]                    idu_alu_src;
wire                          idu_alu_w_sext;
wire [1:0]                    exu_alu_op;
wire [1:0]                    exu_alu_src;
wire                          exu_alu_w_sext;

wire                          idu_mem_read;
wire                          idu_mem_write;
wire [2:0]                    idu_read_type;
wire [1:0]                    idu_write_type;
wire                          exu_mem_read;
wire                          exu_mem_write;
wire [2:0]                    exu_read_type;
wire [1:0]                    exu_write_type;
wire                          mem_mem_read;
wire                          mem_mem_write;
wire [2:0]                    mem_read_type;
wire [1:0]                    mem_write_type;

wire                          idu_reg_write;
wire [1:0]                    idu_mem2reg;
wire                          exu_reg_write;
wire [1:0]                    exu_mem2reg;
wire                          mem_reg_write;
wire [1:0]                    mem_mem2reg;
wire                          wbu_reg_write;
wire [1:0]                    wbu_mem2reg;

core_ifu u_core_ifu(
    .pc_idx        (ifu_pc_addr         ),
    .instr_fetched (ifu_instr_fetched   ),
 
    .pc_o          (if2id_pc_i          ),
    .instr_o       (if2id_instr_i       ),

    .snpc_o        (if2id_snpc_i        ),
 
    .pc_branch     (id2if_pc_branch     ),
     
    .pc_wen        (1'b1                ),//
    .pc_src        (ifu_pc_src          ),
 
    .clk           (clk                 ),
    .rst_n         (rst_n               )
);

core_if_id u_core_if_id(
    .pc_i    (if2id_pc_i          ),
    .instr_i (if2id_instr_i       ),
    .snpc_i  (if2id_snpc_i        ),
    .pc_o    (if2id_pc_o          ),
    .instr_o (if2id_instr_o       ),
    .snpc_o  (if2id_snpc_o        ),
    .clk     (clk                 ),
    .rst_n   (rst_n & ~ifu_pc_src )
);


core_idu u_core_idu(
    .pc_i            (if2id_pc_o            ),
    .instr_i         (if2id_instr_o         ),
    .snpc_i          (if2id_pc_o            ),

    .rs1_data_i      (rf2id_rs1_data        ),
    .rs2_data_i      (rf2id_rs2_data        ),

    .pc_o            (id2ex_pc_i            ),
    .instr_o         (id2ex_instr_i         ),
    .snpc_o          (id2ex_snpc_i          ),
    .imm_o           (id2ex_imm_i           ),
    .funt7_o         (id2ex_funt7_i         ),
    .funt3_o         (id2ex_funt3_i         ),

    .rsd_idx_o       (id2ex_rsd_idx_i       ),

    .id2ex_rs1_idx_o (id2ex_rs1_idx_i       ),
    .id2ex_rs2_idx_o (id2ex_rs2_idx_i       ),

    .rs1_data_o      (id2ex_rs1_data_i      ),
    .rs2_data_o      (id2ex_rs2_data_i      ),

    .id2rf_rs1_idx_o (id2rf_rs1_idx         ),
    .id2rf_rs2_idx_o (id2rf_rs2_idx         ),

    .pc_branch_o     (id2if_pc_branch       ),

    .branch_judgment (idu_branch_judgment   ),

    .idx_src         (idu_idx_src           ),

    .clk             (clk                   ),
    .rst_n           (rst_n                 )
);

core_id_ex u_core_id_ex(
    .pc_i          (id2ex_pc_i         ),
    .instr_i       (id2ex_instr_i      ),
    .snpc_i        (id2ex_snpc_i       ),
    .imm_i         (id2ex_imm_i        ),
    .funt7_i       (id2ex_funt7_i      ),
    .funt3_i       (id2ex_funt3_i      ),
    .rsd_idx_i     (id2ex_rsd_idx_i    ),
    .rs1_idx_i     (id2ex_rs1_idx_i    ),
    .rs2_idx_i     (id2ex_rs2_idx_i    ),
    .rs1_data_i    (id2ex_rs1_data_i   ),
    .rs2_data_i    (id2ex_rs2_data_i   ),
    .alu_op_i      (idu_alu_op         ),
    .alu_src_i     (idu_alu_src        ),
    .alu_w_sext_i  (idu_alu_w_sext     ),
    .mem_read_i    (idu_mem_read       ),
    .mem_write_i   (idu_mem_write      ),
    .read_type_i   (idu_read_type      ),
    .write_type_i  (idu_write_type     ),
    .reg_write_i   (idu_reg_write      ),
    .mem2reg_i     (idu_mem2reg        ),
    .pc_o          (id2ex_pc_o         ),
    .instr_o       (id2ex_instr_o      ),
    .snpc_o        (id2ex_snpc_o       ),
    .imm_o         (id2ex_imm_o        ),
    .funt7_o       (id2ex_funt7_o      ),
    .funt3_o       (id2ex_funt3_o      ),
    .rsd_idx_o     (id2ex_rsd_idx_o    ),
    .rs1_idx_o     (id2ex_rs1_idx_o    ),
    .rs2_idx_o     (id2ex_rs2_idx_o    ),
    .rs1_data_o    (id2ex_rs1_data_o   ),
    .rs2_data_o    (id2ex_rs2_data_o   ),
    .alu_op_o      (exu_alu_op         ),
    .alu_src_o     (exu_alu_src        ),
    .alu_w_sext_o  (exu_alu_w_sext     ),
    .mem_read_o    (exu_mem_read       ),
    .mem_write_o   (exu_mem_write      ),
    .read_type_o   (exu_read_type      ),
    .write_type_o  (exu_write_type     ),
    .reg_write_o   (exu_reg_write      ),
    .mem2reg_o     (exu_mem2reg        ),
    .clk           (clk                ),
    .rst_n         (rst_n              )
);


core_exu u_core_exu(
    .pc_i               (id2ex_pc_o               ),
    .instr_i            (id2ex_instr_o            ),
    .snpc_i             (id2ex_snpc_o             ),
    .imm_i              (id2ex_imm_o              ),
    .funct7_i           (id2ex_funt7_o            ),
    .funct3_i           (id2ex_funt3_o            ),

    .rsd_idx_i          (id2ex_rsd_idx_o          ),

    .rs1_idx_i          (id2ex_rs1_idx_o          ),
    .rs2_idx_i          (id2ex_rs2_idx_o          ),

    .rs1_data_i         (id2ex_rs1_data_o         ),
    .rs2_data_i         (id2ex_rs2_data_o         ),

    .pc_o               (ex2mem_pc_i              ),
    .instr_o            (ex2mem_instr_i           ),
    .snpc_o             (ex2mem_snpc_i            ),
    .imm_o              (ex2mem_imm_i             ),

    .ex2mem_rsd_idx_o   (ex2mem_rsd_idx_i         ),

    .rs2_data_o         (ex2mem_rs2_data_i        ),

    .alu_o              (ex2mem_alu_i             ),

    .ex2hdu_rsd_idx_o   (ex2hdu_rsd_idx_o         ),//

    .rs1_idx_o          (ex2fwd_rs1_idx_o         ),//
    .rs2_idx_o          (ex2fwd_rs2_idx_o         ),//

    .alu_op             (exu_alu_op               ),
    .alu_src            (exu_alu_src              ),
    .w_sext             (exu_alu_w_sext           ),

    .clk                (clk                      ),
    .rst_n              (rst_n                    )
);

core_ex_mem u_core_ex_mem(
    .pc_i               (ex2mem_pc_i               ),
    .instr_i            (ex2mem_instr_i            ),
    .snpc_i             (ex2mem_snpc_i             ),
    .imm_i              (ex2mem_imm_i              ),
    .rsd_idx_i          (ex2mem_rsd_idx_i          ),
    .rs2_data_i         (ex2mem_rs2_data_i         ),
    .alu_i              (ex2mem_alu_i              ),
    .mem_read_i         (exu_mem_read              ),
    .mem_write_i        (exu_mem_write             ),
    .read_type_i        (exu_read_type             ),
    .write_type_i       (exu_write_type            ),
    .reg_write_i        (exu_reg_write             ),
    .mem2reg_i          (exu_mem2reg               ),
    .pc_o               (ex2mem_pc_o               ),
    .instr_o            (ex2mem_instr_o            ),
    .snpc_o             (ex2mem_snpc_o             ),
    .imm_o              (ex2mem_imm_o              ),
    .rsd_idx_o          (ex2mem_rsd_idx_o          ),
    .rs2_data_o         (ex2mem_rs2_data_o         ),
    .alu_o              (ex2mem_alu_o              ),
    .mem_read_o         (mem_mem_read              ),
    .mem_write_o        (mem_mem_write             ),
    .read_type_o        (mem_read_type             ),
    .write_type_o       (mem_write_type            ),
    .reg_write_o        (mem_reg_write             ),
    .mem2reg_o          (mem_mem2reg               ),
    .clk                (clk                       ),
    .rst_n              (rst_n                     )
);


core_mem u_core_mem(
    .pc_i               (ex2mem_pc_o               ),
    .instr_i            (ex2mem_instr_o            ),
    .snpc_i             (ex2mem_snpc_o             ),
    .imm_i              (ex2mem_imm_o              ),

    .rsd_idx_i          (ex2mem_rsd_idx_o          ),

    .rs2_data_i         (ex2mem_rs2_data_o         ),

    .alu_i              (ex2mem_alu_o              ),

    .mem_data_i         (mem_rdata                 ),

    .pc_o               (mem2wb_pc_i               ),
    .instr_o            (mem2wb_instr_i            ),
    .snpc_o             (mem2wb_snpc_i             ),
    .imm_o              (mem2wb_imm_i              ),

    .rsd_idx_o          (mem2wb_rsd_idx_i          ),

    .mem2wb_alu_o       (mem2wb_alu_i              ),

    .mem_data_o         (mem2wb_mem_data_i         ),

    .mem2dm_rs2_data_o  (mem_wdata                 ),
    .mem2dm_alu_o       (mem_addr                  ),

    .clk                (clk                       ),
    .rst_n              (rst_n                     )
);
assign mem_read   = mem_mem_read;
assign mem_write  = mem_mem_write;
assign read_type  = mem_read_type;
assign write_type = mem_write_type;

core_mem_wb u_core_mem_wb(
    .pc_i               (mem2wb_pc_i               ),
    .instr_i            (mem2wb_instr_i            ),
    .snpc_i             (mem2wb_snpc_i             ),
    .imm_i              (mem2wb_imm_i              ),
    .rsd_idx_i          (mem2wb_rsd_idx_i          ),
    .alu_i              (mem2wb_alu_i              ),
    .mem_data_i         (mem2wb_mem_data_i         ),
    .reg_write_i        (mem_reg_write             ),
    .mem2reg_i          (mem_mem2reg               ),
    .pc_o               (mem2wb_pc_o               ),
    .instr_o            (mem2wb_instr_o            ),
    .snpc_o             (mem2wb_snpc_o             ),
    .imm_o              (mem2wb_imm_o              ),
    .rsd_idx_o          (mem2wb_rsd_idx_o          ),
    .alu_o              (mem2wb_alu_o              ),
    .mem_data_o         (mem2wb_mem_data_o         ),
    .reg_write_o        (wbu_reg_write             ),
    .mem2reg_o          (wbu_mem2reg               ),
    .clk                (clk                       ),
    .rst_n              (rst_n                     )
);


core_wb u_core_wb(
    .pc_i               (mem2wb_pc_o               ),
    .instr_i            (mem2wb_instr_o            ),
    .snpc_i             (mem2wb_snpc_o             ),
    .imm_i              (mem2wb_imm_o              ),

    .rsd_idx_i          (mem2wb_rsd_idx_o          ),
    .alu_i              (mem2wb_alu_o              ),
    
    .mem_data_i         (mem2wb_mem_data_o         ),

    .rsd_idx_o          (wb2rf_rsd_idx             ),
    .rsd_data_o         (wb2rf_rsd_data            ),

    .mem2reg            (wbu_mem2reg               ),

    .clk                (clk                       ),
    .rst_n              (rst_n                     )
);

core_regfile u_core_regfile(
    .r1_idx  (id2rf_rs1_idx  ),
    .r1_data (rf2id_rs1_data ),

    .r2_idx  (id2rf_rs2_idx  ),
    .r2_data (rf2id_rs2_data ),

    .wr_indx (wb2rf_rsd_idx  ),
    .wr_data (wb2rf_rsd_data ),

    .rf_wen  (wbu_reg_write  ),

    .clk     (clk            ),
    .rst_n   (rst_n          )
);

core_ctrl u_core_ctrl(
    .instr_i         (if2id_instr_o       ),
    .branch_judgment (idu_branch_judgment ),
    .pc_src          (ifu_pc_src          ),
    .idx_src         (idu_idx_src         ),
    .alu_op          (idu_alu_op          ),
    .alu_src         (idu_alu_src         ),
    .alu_w_sext      (idu_alu_w_sext      ),
    .mem_read        (idu_mem_read        ),
    .mem_write       (idu_mem_write       ),
    .read_type       (idu_read_type       ),
    .write_type      (idu_write_type      ),
    .reg_write       (idu_reg_write       ),
    .mem2reg         (idu_mem2reg         )
);
    
endmodule