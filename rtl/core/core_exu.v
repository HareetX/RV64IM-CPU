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

//=====================================================================
// Designer   : 
//
// Description:
//  The EXU module to implement entire Excution Stage
//
// ====================================================================
`include "defines.v"

module core_exu (
    /* reg_signals */
    // input
    // from ID/EX_Register
    input  [`CPU_PC_SIZE-1:0]     pc_i,
    input  [`CPU_INSTR_SIZE-1:0]  instr_i,
    input  [`CPU_PC_SIZE-1:0]     snpc_i,
    input  [`OPERAND_WIDTH-1:0]   imm_i,
    input  [6:0]                  funct7_i,
    input  [2:0]                  funct3_i,
    
    input  [`CPU_RFIDX_WIDTH-1:0] rsd_idx_i,
    
    input  [`CPU_RFIDX_WIDTH-1:0] rs1_idx_i,
    input  [`CPU_RFIDX_WIDTH-1:0] rs2_idx_i,    

    input  [`OPERAND_WIDTH-1:0]   rs1_data_i,
    input  [`OPERAND_WIDTH-1:0]   rs2_data_i,

    // output
    // to EX/MEM_Register
    output [`CPU_PC_SIZE-1:0]     pc_o,
    output [`CPU_INSTR_SIZE-1:0]  instr_o,
    output [`CPU_PC_SIZE-1:0]     snpc_o,
    output [`OPERAND_WIDTH-1:0]   imm_o,
    
    output [`CPU_RFIDX_WIDTH-1:0] ex2mem_rsd_idx_o,

    output [`OPERAND_WIDTH-1:0]   rs2_data_o,
    
    output [`OPERAND_WIDTH-1:0]   alu_o,

    // to Hazard_Detection_Unit
    output [`CPU_RFIDX_WIDTH-1:0] ex2hdu_rsd_idx_o,
    // to Forwarding_Unit
    output [`CPU_RFIDX_WIDTH-1:0] rs1_idx_o, 
    output [`CPU_RFIDX_WIDTH-1:0] rs2_idx_o, 
    
    /* control_signals */
    input  [1:0]                  alu_op,
    input  [1:0]                  alu_src,
    input                         w_sext,
    input                         pc_oprd_src,

    /* basic_signals */
    input                         clk,
    input                         rst_n
);

wire [`OPERAND_WIDTH-1:0]  oprd1;
wire [`OPERAND_WIDTH-1:0]  oprd2;
wire [`ALU_CTRL_WIDTH-1:0] alu_ctrl;

wire [`OPERAND_WIDTH-1:0]  alu_result;
wire [`OPERAND_WIDTH-1:0]  alu_w_sext;

MuxKey #(2, 1, `OPERAND_WIDTH) u_MuxKey_alu_src_rs1(
    .out (oprd1       ),
    .key (alu_src[0]  ),
    .lut ({
        1'b0, rs1_data_i,
        1'b1, pc_i
    } )
);

MuxKey #(2, 1, `OPERAND_WIDTH) u_MuxKey_alu_src_rs2(
    .out (oprd2      ),
    .key (alu_src[1] ),
    .lut ({
        1'b0, rs2_data_i,
        1'b1, imm_i
    } )
);

core_alu_ctrl u_core_alu_ctrl(
    .alu_op   (alu_op     ),
    .funct7   (funct7_i   ),
    .funct3   (funct3_i   ),
    .alu_ctrl (alu_ctrl   )
);

core_alu u_core_alu(
    .oprd1      (oprd1      ),
    .oprd2      (oprd2      ),
    .alu_ctrl_i (alu_ctrl   ),
    .alu_o      (alu_result )
);

assign alu_w_sext = {{32{alu_result[31]}}, alu_result[31:0]};

MuxKey #(2, 1, `OPERAND_WIDTH) u_MuxKey_w_sext(
    .out (alu_o  ),
    .key (w_sext ),
    .lut ({
        1'b0, alu_result,
        1'b1, alu_w_sext
    } )
);


assign pc_o = pc_i;
assign instr_o = instr_i;
assign imm_o = imm_i;

assign ex2mem_rsd_idx_o = rsd_idx_i;

assign rs2_data_o = rs2_data_i;

assign rs1_idx_o = rs1_idx_i;
assign rs2_idx_o = rs2_idx_i;

assign ex2hdu_rsd_idx_o = rsd_idx_i;

endmodule