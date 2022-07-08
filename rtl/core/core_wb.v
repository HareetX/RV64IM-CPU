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
//  The WB module to implement entire Write_back Stage
//
// ====================================================================
`include "defines.v"

module core_wb (
    /* reg_signals */
    // input from MEM/WB_Register
    input  [`CPU_PC_SIZE-1:0]     pc_i,
    input  [`CPU_INSTR_SIZE-1:0]  instr_i,
    input  [`OPERAND_WIDTH-1:0]   imm_i,
  
    input  [`CPU_RFIDX_WIDTH-1:0] rsd_idx_i,

    input  [`OPERAND_WIDTH-1:0]   alu_i,

    input  [`CPU_PC_SIZE-1:0]     pc_offset_result_i,

    input  [`OPERAND_WIDTH-1:0]   mem_data_i,

    // output to Register_File
    output [`CPU_RFIDX_WIDTH-1:0] rsd_idx_o,
    output [`OPERAND_WIDTH-1:0]   rsd_data_o,

    /* control_signals */
    input  [1:0]                  mem2reg,

    /* basic_signals */
    input                         clk,
    input                         rst_n
);

MuxKey #(4, 2, `OPERAND_WIDTH) u_MuxKey(
    .out (rsd_data_o ),
    .key (mem2reg[1:0]    ),
    .lut ({
        2'b00, alu_i,
        2'b01, mem_data_i,
        2'b10, imm_i,
        2'b11, pc_offset_result_i
    } )
);


assign rsd_idx_o = rsd_idx_i;

endmodule