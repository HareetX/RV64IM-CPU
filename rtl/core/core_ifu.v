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
//  The IFU module to implement entire Instruction_fetch Stage
//
// ====================================================================
`include "defines.v"

module core_ifu (
    /* instruction_fetch_signals */
    output [`CPU_PC_SIZE-1:0] pc_idx,
    input  [`CPU_INSTR_SIZE-1:0] instr_fetched,

    /* reg_signals */
    // output
    output [`CPU_PC_SIZE-1:0] pc_o,
    output [`CPU_INSTR_SIZE-1:0] instr_o,
    
    /* branch_pc_signal */
    input  [`CPU_PC_SIZE-1:0] pc_branch,
    
    /* control_signals */
    input  pc_wen,
    input  pc_src,

    /* basic_signals */
    input clk,
    input rst_n
);

wire [`CPU_PC_SIZE-1:0] pc_next;
wire [`CPU_PC_SIZE-1:0] snpc;
wire [`CPU_PC_SIZE-1:0] pc;

core_pc_reg u_pc_reg(
    .pc_o  (pc       ),
    .pc_i  (pc_next  ),
    .wen   (pc_wen   ),
    .clk   (clk      ),
    .rst_n (rst_n    )
);

assign snpc = pc + 4;
assign pc_idx = pc;
assign pc_o = pc;
assign instr_o = instr_fetched;

MuxKey #(2, 1, `CPU_PC_SIZE) u_MuxKey(
	.out (pc_next   ),
    .key (pc_src    ),
    .lut ({
        1'b0, snpc,
        1'b1, pc_branch
    } )
);

endmodule