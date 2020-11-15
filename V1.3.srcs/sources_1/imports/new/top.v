`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/11 04:26:14
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    clk,
    rst_n
    );
  input clk;
  input rst_n;
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  
  wire [31:0]GPIO_PLOUT_tri_i;
  wire [31:0]GPIO_PSOUT1_tri_o;
  wire [31:0]GPIO_PSOUT2_tri_o;
  wire [31:0]GPIO_PSOUT3_tri_o;
  wire ps_clk;
  
  wire signed [31:0]S_1;
  wire signed [31:0]S_2;
  wire signed [31:0]S_3;
  wire [31:0]channel1_time;
  wire [31:0]channel2_time;
  wire [31:0]channel3_time;
  wire trans_done;
  wire chan_done;
  design_1_wrapper design_1_wrapper0(
        .DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .GPIO_PLOUT_tri_i(GPIO_PLOUT_tri_i),
        .GPIO_PSOUT1_tri_o(GPIO_PSOUT1_tri_o),
        .GPIO_PSOUT2_tri_o(GPIO_PSOUT2_tri_o),
        .GPIO_PSOUT3_tri_o(GPIO_PSOUT3_tri_o),
        .ps_clk(ps_clk));
  

  
  ila_0 ila_0(
  .clk(ps_clk),
  .probe0(GPIO_PSOUT1_tri_o),
  .probe1(GPIO_PSOUT2_tri_o),
  .probe2(GPIO_PSOUT3_tri_o),
  .probe3(channel1_time),
  .probe4(channel2_time),
  .probe5(channel3_time),
	.probe6(S_1),
	.probe7(S_2),
	.probe8(S_3)
  );
 extract_time_top extract_time_top(
		.clk(ps_clk),
		.rst_n(!rst_n),
		.input_time1(GPIO_PSOUT1_tri_o),
		.input_time2(GPIO_PSOUT2_tri_o),
		.input_time3(GPIO_PSOUT3_tri_o),
		.channel1_time(channel1_time),
		.channel2_time(channel2_time),
		.channel3_time(channel3_time),
		.trans_done(trans_done)
		);
	chan_1 chan_10(
	.Clk(ps_clk),
	.time_1(channel1_time),
	.time_2(channel2_time),
	.time_3(channel3_time),
	.S1(S_1),
	.S2(S_2),
	.S3(S_3),
	.Rst_n(!rst_n),
	.chan_en(trans_done),
	.chan_done(chan_done)
	);
assign 	GPIO_PLOUT_tri_i={0,0,S_1[9:0],S_2[9:0],S_3[9:0]};



endmodule
