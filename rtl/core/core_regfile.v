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
//  The Regfile module.
//
// ====================================================================
`include "defines.v"

module core_regfile (
    /* read_port */
    // read_port_1
    input  [`CPU_RFIDX_WIDTH-1:0]  r1_idx,
    output [`CPU_RFDATA_WIDTH-1:0] r1_data,
    // read_port_2
    input  [`CPU_RFIDX_WIDTH-1:0]  r2_idx,
    output [`CPU_RFDATA_WIDTH-1:0] r2_data,

    /* write_port */
    input  [`CPU_RFIDX_WIDTH-1:0]  wr_indx,
    input  [`CPU_RFDATA_WIDTH-1:0] wr_data,

    /* control_signals */
    input  rf_wen,

    /* basic_signals */
    input clk,
    input rst_n
);

reg [`CPU_RFDATA_WIDTH-1:0] rf [`CPU_REGS_NUM-1:0];

/* write data to RegisterFile */
always @(negedge clk) begin
    if (~rst_n) begin
        rf[0] <= 64'd0;
    end
    else if (rf_wen & (wr_indx != 0)) begin
        rf[wr_indx] <= wr_data;
    end
end

/* read data from RegisterFile */
assign r1_data = rf[r1_idx];
assign r2_data = rf[r2_idx];

endmodule