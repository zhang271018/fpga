`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/29 17:24:24
// Design Name: 
// Module Name: ifft
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


module ifft(
		input clk,
		input rst_n,
		input s_axis_data_tvalid,
		input s_axis_data_tlast,	
		input  [33:0] ifft1__input_real,
		input  [33:0] ifft1__input_imag,
		output [44 : 0]ifft1_output_img,
		output [44 : 0] ifft1_output_real,
		output [15:0]ifft1_output_tuser,
		output ifft1_output_tvalid,
		output m_axis_data_tlast,
		output reg [7:0]ifft_tlast_cnt
		);
	
		parameter FFTCONFIG_FWD_INV_FFT		= 1'b1;		//FFT
		parameter FFTCONFIG_FWD_INV_IFFT	= 1'b0;		//IFFT		

		reg [79 : 0] s_axis_data_tdata;
	
		wire s_axis_data_tready;
			
		wire [7 : 0] s_axis_config_tdata;
		reg s_axis_config_tvalid;
		wire s_axis_config_tready;
		reg m_axis_data_tready=1;	
		wire event_frame_started;
		wire event_tlast_unexpected;
		wire event_tlast_missing;
		wire event_data_in_channel_halt;
		wire [95 : 0] m_axis_data_tdata;
		
		reg[15:0] cnt;
		

	always @(posedge clk or negedge rst_n)
		if(!rst_n)
		ifft_tlast_cnt <= 8'd0;
		else if(ifft_tlast_cnt==8'd3)
		ifft_tlast_cnt <= 8'd0;
		else if(m_axis_data_tlast==1) 
		ifft_tlast_cnt <= ifft_tlast_cnt+1'b1;
		
		
	always @(posedge clk or negedge rst_n)
		 if(!rst_n) 
		 s_axis_data_tdata <= 79'd0;
		 else 
		 s_axis_data_tdata <= {6'd0,ifft1__input_imag,6'd0,ifft1__input_real};

	always @(posedge clk or negedge rst_n)
		if(!rst_n) cnt <= 16'd0;
		else if(cnt < 16'hffff) cnt <= cnt+1'b1;

	always @(posedge clk or negedge rst_n)
		if(!rst_n) s_axis_config_tvalid <= 1'b0;
		else if(cnt == 16'h0ff0)
		s_axis_config_tvalid <= 1'b1;
		else 
		s_axis_config_tvalid <= 1'b0;
			
		assign s_axis_config_tdata = {7'd0,FFTCONFIG_FWD_INV_IFFT};	
		
	ifft_1 ifft_1(
      .aclk							(clk), 							 // input wire aclk
	  .aresetn						(rst_n) , 
	  .s_axis_config_tdata			(s_axis_config_tdata),              // input wire [7 : 0] s_axis_config_tdata
	  .s_axis_config_tvalid			(s_axis_config_tvalid),             // input wire s_axis_config_tvalid
	  .s_axis_config_tready			(s_axis_config_tready),             // output wire s_axis_config_tready
	  .s_axis_data_tdata			(s_axis_data_tdata),                // input wire [31 : 0] s_axis_data_tdata
	  .s_axis_data_tvalid			(s_axis_data_tvalid),               // input wire s_axis_data_tvalid
	  .s_axis_data_tready			(s_axis_data_tready),               // output wire s_axis_data_tready
	  .s_axis_data_tlast			(s_axis_data_tlast),                // input wire s_axis_data_tlast			
	  .m_axis_data_tdata			(m_axis_data_tdata),                // output wire [47 : 0] m_axis_data_tdata
	  .m_axis_data_tvalid			(ifft1_output_tvalid),              // output wire m_axis_data_tvalid
	  .m_axis_data_tlast			(m_axis_data_tlast),				// output wire m_axis_data_tlast
	  .m_axis_data_tready           (m_axis_data_tready),  
	  .m_axis_data_tuser            (ifft1_output_tuser),  				
	  .event_frame_started			(event_frame_started),              // output wire event_frame_started
	  .event_tlast_unexpected		(event_tlast_unexpected),           // output wire event_tlast_unexpected
	  .event_tlast_missing			(event_tlast_missing),              // output wire event_tlast_missing
	  .event_data_in_channel_halt	(event_data_in_channel_halt)  		// output wire event_data_in_channel_halt
	  );
		assign ifft1_output_img =m_axis_data_tdata[92:48];   
		assign ifft1_output_real = m_axis_data_tdata[44:0];		
		
endmodule
