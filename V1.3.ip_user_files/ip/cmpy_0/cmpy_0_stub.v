// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Sat Nov 14 18:47:15 2020
// Host        : UK1 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub d:/Users/paste/V1.3.srcs/sources_1/ip/cmpy_0/cmpy_0_stub.v
// Design      : cmpy_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "cmpy_v6_0_17,Vivado 2019.1" *)
module cmpy_0(aclk, aresetn, s_axis_a_tvalid, s_axis_a_tuser, 
  s_axis_a_tlast, s_axis_a_tdata, s_axis_b_tvalid, s_axis_b_tuser, s_axis_b_tlast, 
  s_axis_b_tdata, m_axis_dout_tvalid, m_axis_dout_tuser, m_axis_dout_tlast, 
  m_axis_dout_tdata)
/* synthesis syn_black_box black_box_pad_pin="aclk,aresetn,s_axis_a_tvalid,s_axis_a_tuser[15:0],s_axis_a_tlast,s_axis_a_tdata[63:0],s_axis_b_tvalid,s_axis_b_tuser[15:0],s_axis_b_tlast,s_axis_b_tdata[63:0],m_axis_dout_tvalid,m_axis_dout_tuser[31:0],m_axis_dout_tlast,m_axis_dout_tdata[111:0]" */;
  input aclk;
  input aresetn;
  input s_axis_a_tvalid;
  input [15:0]s_axis_a_tuser;
  input s_axis_a_tlast;
  input [63:0]s_axis_a_tdata;
  input s_axis_b_tvalid;
  input [15:0]s_axis_b_tuser;
  input s_axis_b_tlast;
  input [63:0]s_axis_b_tdata;
  output m_axis_dout_tvalid;
  output [31:0]m_axis_dout_tuser;
  output m_axis_dout_tlast;
  output [111:0]m_axis_dout_tdata;
endmodule
