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
//  The IDU module to implement entire Decode Stage
//
// ====================================================================
`include "defines.v"

module core_idu (
    /* reg_signals */
    // input
    // from IF/ID_Register
    input  [`CPU_PC_SIZE-1:0]     pc_i,
    input  [`CPU_INSTR_SIZE-1:0]  instr_i,
    // from Register_File
    input  [`OPERAND_WIDTH-1:0]   rs1_data_i,
    input  [`OPERAND_WIDTH-1:0]   rs2_data_i,

    // output
    // to ID/EX_Register
    output [`CPU_PC_SIZE-1:0]     pc_o,
    output [`CPU_INSTR_SIZE-1:0]  instr_o,
    output [`OPERAND_WIDTH-1:0]   imm_o,
    output [6:0]                  funt7_o,
    output [2:0]                  funt3_o,
    
    output [`CPU_RFIDX_WIDTH-1:0] rsd_idx_o,
    
    output [`CPU_RFIDX_WIDTH-1:0] id2ex_rs1_idx_o,
    output [`CPU_RFIDX_WIDTH-1:0] id2ex_rs2_idx_o,
    
    output [`OPERAND_WIDTH-1:0]   rs1_data_o,
    output [`OPERAND_WIDTH-1:0]   rs2_data_o,
    // to Register_File
    output [`CPU_RFIDX_WIDTH-1:0] id2rf_rs1_idx_o,  
    output [`CPU_RFIDX_WIDTH-1:0] id2rf_rs2_idx_o,  
    // to PC
    output [`CPU_PC_SIZE-1:0]     pc_branch_o,
    // to Controller
    output [2:0]                  branch_judgment, // {is_eq, is_lt, is_ltu}

    /* control_signals */
    input                         idx_src,

    /* basic_signals */
    input                         clk,
    input                         rst_n

);

wire [`OPERAND_WIDTH-1:0] imm_oprd;
wire [`CPU_PC_SIZE-1:0] new_idx;

wire [`CPU_RFIDX_WIDTH-1:0] rs1_idx_o;
wire [`CPU_RFIDX_WIDTH-1:0] rs2_idx_o;

wire signed [`OPERAND_WIDTH-1:0] s_rs1_data;
wire signed [`OPERAND_WIDTH-1:0] s_rs2_data;

core_imm u_core_imm(
    .instr_i (instr_i    ),
    .imm_o   (imm_oprd   )
);

MuxKey #(2, 1, `CPU_PC_SIZE) u_MuxKey(
    .out (new_idx ),
    .key (idx_src ),
    .lut ({
        1'b0, pc_i,
        1'b1, rs1_data_i
    } )
);


assign pc_o = pc_i;
assign instr_o = instr_i;
assign imm_o = imm_oprd;
assign funt7_o = instr_i[31:25];
assign funt3_o = instr_i[14:12];

assign rsd_idx_o = instr_i[11:7];

assign rs1_idx_o = instr_i[19:15];
assign rs2_idx_o = instr_i[24:20];

assign id2ex_rs1_idx_o = rs1_idx_o;
assign id2ex_rs2_idx_o = rs2_idx_o;

assign rs1_data_o = rs1_data_i;
assign rs2_data_o = rs2_data_i;

assign s_rs1_data = rs1_data_i;
assign s_rs2_data = rs2_data_i;

assign id2rf_rs1_idx_o = rs1_idx_o;
assign id2rf_rs2_idx_o = rs2_idx_o;

assign pc_branch_o = new_idx + imm_oprd;
assign branch_judgment[2] = (rs1_data_i == rs2_data_i);
assign branch_judgment[1] = (s_rs1_data < s_rs2_data);
assign branch_judgment[0] = (rs1_data_i < rs2_data_i);

endmodule