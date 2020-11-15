`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/29 17:31:01
// Design Name: 
// Module Name: fft_multiplier_ifft
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

module fft_multiplier_ifft(
		input clk,
		input rst_n,
		input [15:0]channel1_input_real,
		input [15:0] channel2_input_real,
		input channel1_en,
		output[44:0] ifft1_output_img,
		output[44:0] ifft1_output_real,
		output[7:0]ifft_tlast_cnt,
		output[15:0] ifft1_output_tuser,
		output reg [7:0] multipler_cnt_talst_reg,
		output[33:0]ifft1__input_real,
		output[33:0]ifft1__input_imag,
		output ifft1_output_tvalid,
		output ifft_data_tlast
		);
		

		wire [26:0] channel1_output_img,channel1_output_real;
		wire [15:0]channel1_output_tuser;
		wire [26:0] channel2_output_img;
		wire [26:0]channel2_output_real;
		wire [15:0]channel2_output_tuser;
		wire s_axis_a_tvalid;
		wire s_axis_b_tvalid;
		wire m_axis_dout_tvalid;
		wire [15:0]s_axis_a_tuser;
		reg s_axis_a_tlast;
		wire [15:0]s_axis_b_tuser;
		reg s_axis_b_tlast;
		wire [111:0]m_axis_dout_tdata;
		wire  m_axis_dout_tlast;
		reg ifft1_en;
		wire[54:0] real_dout_tdata;
		wire[54:0] imag_dout_tdata;
		wire ifft_carry_bit;
		wire ifft_carry_bit1;
		wire [45:0] ifft_round ;
		wire [44:0] ifft_imag_round ;
        wire channel2_en;
        assign channel2_en = channel1_en;
	channel1_to_fft channel1_to_fft(
		.clk(clk),
		.rst_n(rst_n),
		.channel1_en(channel1_en),
		.channel1_input_real(channel1_input_real),
		.channel1_output_img(channel1_output_img),
		.channel1_output_real(channel1_output_real),
		.channel1_output_tuser(s_axis_a_tuser),
		.channel1_output_tvalid(s_axis_a_tvalid)
		);	
		
	channel2_to_fft channel2_to_fft(
		.clk(clk),
		.rst_n(rst_n),
		.channel2_en(channel2_en),
		.channel2_input_real(channel2_input_real),
		.channel2_output_img(channel2_output_img),
		.channel2_output_real(channel2_output_real),
		.channel2_output_tuser(s_axis_b_tuser),
		.channel2_output_tvalid(s_axis_b_tvalid)
		);	
		
		
	cmpy_0 cmpy_0_tb(
		.aclk(clk),
		.aresetn(rst_n), 
		.s_axis_a_tvalid(s_axis_a_tvalid),
		.s_axis_a_tlast(s_axis_a_tlast),
		.s_axis_a_tuser(s_axis_a_tuser),
		.s_axis_b_tuser(s_axis_b_tuser),
		.s_axis_b_tlast(s_axis_b_tlast),
		.s_axis_b_tvalid(s_axis_b_tvalid),
		.s_axis_a_tdata({5'b0,channel1_output_img,5'd0,channel1_output_real}),      
		.s_axis_b_tdata({5'd0,channel2_output_img,5'd0,channel2_output_real}),
		.m_axis_dout_tvalid(m_axis_dout_tvalid), 
		.m_axis_dout_tlast(m_axis_dout_tlast),
		.m_axis_dout_tdata(m_axis_dout_tdata)
		 );
	  
	ifft ifft(
		.clk(clk),
		.rst_n(rst_n),
		.s_axis_data_tvalid(m_axis_dout_tvalid),
		.s_axis_data_tlast(m_axis_dout_tlast),
		.ifft1__input_real(ifft1__input_real),
		.ifft1__input_imag(ifft1__input_imag),
		.ifft1_output_img(ifft1_output_img),
		.ifft1_output_real(ifft1_output_real),
		.ifft1_output_tuser(ifft1_output_tuser),
		.ifft1_output_tvalid(ifft1_output_tvalid),
		.m_axis_data_tlast(ifft_data_tlast),
		.ifft_tlast_cnt(ifft_tlast_cnt)
		);

	always @(posedge clk) begin
		 if(s_axis_a_tuser == 4095) begin	
			s_axis_a_tlast<=1;
		end
		else s_axis_a_tlast<=0;
	end	
	 always @(posedge clk or negedge rst_n) 
	     if(!rst_n)
	     ifft1_en <= 1'b0;
		 else if((s_axis_a_tuser>0) && (s_axis_a_tuser<=4095)) 
		 ifft1_en <= 1'b1;		
		 else
		 ifft1_en <= 1'b0;
		 
	always @(posedge clk) begin
		if(s_axis_b_tuser == 16'd4095) 	
			s_axis_b_tlast<=1;
		else
			s_axis_b_tlast<=0;
	end		

	always @(posedge clk or negedge rst_n)
		if(!rst_n)
		multipler_cnt_talst_reg <= 8'd0;
		else if(m_axis_dout_tlast)
		multipler_cnt_talst_reg <= multipler_cnt_talst_reg+1'b1;
		else  if((multipler_cnt_talst_reg>2))
		multipler_cnt_talst_reg<=0;
		
		assign real_dout_tdata=m_axis_dout_tdata[54:0];
		assign imag_dout_tdata=~m_axis_dout_tdata[110:56]+1'b1;
		assign ifft_carry_bit=real_dout_tdata[54]?(real_dout_tdata[8]&(|real_dout_tdata[7:0])):real_dout_tdata[8];
		assign ifft_round={real_dout_tdata[54],real_dout_tdata[54:9]}+ifft_carry_bit;
		assign ifft1__input_real= (ifft_round[45:33]==13'd0||ifft_round[45:33]==13'b1_1111_1111_1111)?ifft_round[33:0]:{ifft_round[45],{33{!ifft_round[45]}}};

		assign ifft_carry_bit1=imag_dout_tdata[54]?(imag_dout_tdata[9]&(|imag_dout_tdata[8:0])):imag_dout_tdata[9];
		assign ifft_imag_round={imag_dout_tdata[54],imag_dout_tdata[54:10]}+ifft_carry_bit1;
		assign ifft1__input_imag= (ifft_imag_round[44:33]==12'd0||ifft_imag_round[44:33]==12'b111111111111)?ifft_imag_round[33:0]:{ifft_imag_round[44],{33{!ifft_imag_round[44]}}};
endmodule
