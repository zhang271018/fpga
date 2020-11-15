`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/29 17:04:52
// Design Name: 
// Module Name: channel1_to_fft
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


module channel1_to_fft(
		input clk,
		input rst_n,
		input channel1_en,
		input  [15:0]   channel1_input_real,
		output [26 : 0] channel1_output_img,
		output [26 : 0] channel1_output_real,
		output [15:0]	channel1_output_tuser,
		output channel1_output_tvalid
		);		
		parameter FFTCONFIG_FWD_INV_FFT		= 1'b1;		//FFT
		parameter FFTCONFIG_FWD_INV_IFFT	= 1'b0;		//IFFT		
	
		reg [31 : 0] s_axis_data_tdata;
		wire s_axis_data_tvalid;
		wire s_axis_data_tready;
		wire s_axis_data_tlast;	

		wire event_frame_started;
		wire event_tlast_unexpected;
		wire event_tlast_missing;
		wire event_data_in_channel_halt;
		wire [63 : 0] m_axis_data_tdata;
		wire m_axis_data_tlast;
		wire [7 : 0] s_axis_config_tdata;
		reg s_axis_config_tvalid;
		wire s_axis_config_tready;
		reg m_axis_data_tready =1 ;
		
		reg[15:0] cnt;
		reg[13:0] num;
		assign s_axis_data_tvalid = ((num>14'd0)&&(num<=14'd4096))?1'b1:1'b0;
		assign s_axis_data_tlast = (num==14'd4097)?1'b1:1'b0;
	always @(posedge clk or negedge rst_n)
		if(!rst_n) 
		num <= 14'd0;
		else if(num==14'd4097)
		num <= 14'd0;
		else if(channel1_en==1)
		num <= num+1'b1;
		else 
		num <= 14'd0;
	
	always @(posedge clk or negedge rst_n)
		if(!rst_n) 
		s_axis_data_tdata <= 32'd0;
		else 
		s_axis_data_tdata <= {7'd0,9'd0,channel1_input_real};

	always @(posedge clk or negedge rst_n)
		if(!rst_n)
		cnt <= 16'd0;
		else if(cnt < 16'hffff) 
		cnt <= cnt+1'b1;

	always @(posedge clk or negedge rst_n)
		if(!rst_n)
		s_axis_config_tvalid <= 1'b0;
		else if(cnt == 16'h0ff0) 
		s_axis_config_tvalid <= 1'b1;
		else 
		s_axis_config_tvalid <= 1'b0;
	
	assign s_axis_config_tdata = {7'd0,FFTCONFIG_FWD_INV_FFT};	
	

    xfft_0 fft1 (
		.aclk							(clk),  
		.aresetn						(rst_n) , 							// input wire aclk
		.s_axis_config_tdata			(s_axis_config_tdata),              // input wire [7 : 0] s_axis_config_tdata
		.s_axis_config_tvalid			(s_axis_config_tvalid),             // input wire s_axis_config_tvalid
		.s_axis_config_tready			(s_axis_config_tready),             // output wire s_axis_config_tready
		.s_axis_data_tdata				(s_axis_data_tdata),                // input wire [31 : 0] s_axis_data_tdata
		.s_axis_data_tvalid				(s_axis_data_tvalid),               // input wire s_axis_data_tvalid
		.s_axis_data_tready				(s_axis_data_tready),               // output wire s_axis_data_tready
		.s_axis_data_tlast				(s_axis_data_tlast),                // input wire s_axis_data_tlast			
		.m_axis_data_tdata				(m_axis_data_tdata),                // output wire [47 : 0] m_axis_data_tdata
		.m_axis_data_tvalid				(channel1_output_tvalid),               // output wire m_axis_data_tvalid
		.m_axis_data_tlast				(m_axis_data_tlast),
		.m_axis_data_tready           	(m_axis_data_tready),  
		.m_axis_data_tuser            	(channel1_output_tuser),  			// output wire m_axis_data_tlast
		.event_frame_started			(event_frame_started),              // output wire event_frame_started
		.event_tlast_unexpected			(event_tlast_unexpected),           // output wire event_tlast_unexpected
		.event_tlast_missing			(event_tlast_missing),              // output wire event_tlast_missing
		.event_data_in_channel_halt		(event_data_in_channel_halt)  		// output wire event_data_in_channel_halt
		);
		
	assign channel1_output_img =~m_axis_data_tdata[58:32]+1'b1;   //signed(10.10)
	assign channel1_output_real = m_axis_data_tdata[26:0];		//signed(10.10)
endmodule
