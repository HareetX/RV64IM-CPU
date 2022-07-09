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

module core_mem (
    /* reg_signals */
    // input
    // from EX/MEM_Register
    input  [`CPU_PC_SIZE-1:0]     pc_i,
    input  [`CPU_INSTR_SIZE-1:0]  instr_i,
    input  [`CPU_PC_SIZE-1:0]     snpc_i,
    input  [`OPERAND_WIDTH-1:0]   imm_i,
    
    input  [`CPU_RFIDX_WIDTH-1:0] rsd_idx_i,
    
    input  [`OPERAND_WIDTH-1:0]   rs2_data_i,

    input  [`OPERAND_WIDTH-1:0]   alu_i,
    // from Data_Memery
    input  [`OPERAND_WIDTH-1:0]   mem_data_i,

    // output
    // to MEM/WB_Register
    output [`CPU_PC_SIZE-1:0]     pc_o,
    output [`CPU_INSTR_SIZE-1:0]  instr_o,
    output [`CPU_PC_SIZE-1:0]     snpc_o,
    output [`OPERAND_WIDTH-1:0]   imm_o,

    output [`CPU_RFIDX_WIDTH-1:0] rsd_idx_o,
    
    output [`OPERAND_WIDTH-1:0]   mem2wb_alu_o,

    output [`OPERAND_WIDTH-1:0]   mem_data_o,
    // to Data_Memery
    output [`OPERAND_WIDTH-1:0]   mem2dm_rs2_data_o, // as the written data
    output [`OPERAND_WIDTH-1:0]   mem2dm_alu_o, // as the idx
    /* control_signals */

    /* basic_signals */
    input                         clk,
    input                         rst_n
);

assign pc_o = pc_i;
assign instr_o = instr_i;
assign snpc_o = snpc_i;
assign imm_o = imm_i;

assign rsd_idx_o = rsd_idx_i;

assign mem2wb_alu_o = alu_i;

assign mem_data_o = mem_data_i;

assign mem2dm_rs2_data_o = rs2_data_i;
assign mem2dm_alu_o = alu_i;

endmodule