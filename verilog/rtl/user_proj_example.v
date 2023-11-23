// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module user_proj_example #(
    parameter BITS = 16
)(
`ifdef USE_POWER_PINS
    inout vdd,	// User area 1 1.8V supply
    inout vss,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [63:0] la_data_in,
    output [63:0] la_data_out,
    input  [63:0] la_oenb,

    // IOs
    input  [BITS-1:0] io_in,
    output [BITS-1:0] io_out,
    output [BITS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);
    wire clk;
    wire rst;

    wire [BITS-1:0] rdata; 
    wire [BITS-1:0] wdata;
    wire [BITS-1:0] count;

    wire valid;
    wire [3:0] wstrb;
    wire [BITS-1:0] la_write;

    // WB MI A
    
wire [31:0] data_in_i;
wire [7:0] addr_in_i;



assign data_in_i=(wbs_stb_i && wbs_cyc_i)? (wbs_dat_i || (32'd0)): (data_in_i || (32'd0));
assign addr_in_i=(wbs_stb_i && wbs_cyc_i)? (wbs_adr_i[23:16] || (8'd0)): (addr_in_i || (8'd0));


blake2s blake1(
	.clk(wb_clk_i),
        .reset_n(wb_rst_i),

        .cs(wbs_stb_i && wbs_cyc_i),
        .we(wbs_we_i),

        .address(addr_in_i),
        .write_data(data_in_i),
        .read_data(wbs_dat_o[31:0])
);


    /*aes aes1(

           // Clock and reset.
           .clk(wb_clk_i),
           .reset_n(wb_rst_i),

           // Control.
           .cs(wbs_stb_i && wbs_cyc_i),
           .we(wbs_we_i),

           // Data ports.
           .address(wbs_adr_i[23:16]),
           .write_data(wbs_dat_i),
           .read_data(wbs_dat_o)
          );*/

endmodule


`default_nettype wire
