`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/01 02:20:56
// Design Name: 
// Module Name: extract_time_top
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


module extract_time_top(
		input  clk,
		input  rst_n,
		input  [31:0] input_time1,
		input  [31:0] input_time2,
		input  [31:0] input_time3,
	    output reg [31:0] channel1_time,
	    output reg [31:0] channel2_time,
	    output reg [31:0] channel3_time,
	    output reg trans_done
		);
		
		
		wire channel1_begin;
		wire [15:0] channel1_out_data;
		wire [15:0] channel2_out_data;
		
		wire [44:0] ifft1_output_img;
		wire [44:0] ifft1_output_real;
		wire [7:0] ifft_tlast_cnt;
		wire [15:0] ifft1_output_tuser;
		wire [7:0] multipler_cnt_talst_reg;
		wire [33:0]ifft1__input_real;
		wire [33:0]ifft1__input_imag;
		wire ifft1_output_tvalid;
		wire ifft_data_tlast;
		wire [1:0] qianwei1;
		wire [1:0] qianwei2;
		wire [1:0] qianwei3;
		wire [1:0] baiwei1;
		wire [1:0] baiwei2;
		wire [1:0] baiwei3;
		reg [44:0] temp_ifft1_output_real;
		reg  [44:0] max1_V;
		reg  [44:0] max2_V;
		reg  [44:0] max3_V;
        reg  [31:0] temp_time1;
        reg  [31:0] temp_time2;
        reg  [31:0] temp_time3;
        reg  [9:0] temp_channel1_time_1;
	    reg  [9:0] temp_channel2_time_1;
	    reg  [9:0] temp_channel3_time_1;
	    reg  [9:0] temp_channel1_time_2;
	    reg  [9:0] temp_channel2_time_2;
	    reg  [9:0] temp_channel3_time_2;
	rom rom(
		 .clk(clk),
		 .rst_n(rst_n),
		 .input_time1(input_time1),
		 .input_time2(input_time2),
		 .input_time3(input_time3),
		 .ifft_tlast_cnt(ifft_tlast_cnt),
		 .channel1_begin(channel1_begin),	
		 .channel2_begin(),
		 .channel1_out_data(channel1_out_data),
		 .channel2_out_data(channel2_out_data),
		 .qianwei1(qianwei1),
		 .qianwei2(qianwei2),
		 .qianwei3(qianwei3),
		 .baiwei1(baiwei1),
		 .baiwei2(baiwei2),
		 .baiwei3(baiwei3)
	 );
	
	fft_multiplier_ifft fft_multiplier_ifft(
		 .clk(clk),
		 .rst_n(rst_n),
		 .channel1_input_real(channel1_out_data),
		 .channel2_input_real(channel2_out_data),
		 .channel1_en(channel1_begin),
		 .ifft1_output_img(ifft1_output_img),
		 .ifft1_output_real(ifft1_output_real),
		 .ifft_tlast_cnt(ifft_tlast_cnt),
		 .ifft1_output_tuser(ifft1_output_tuser),
		 .multipler_cnt_talst_reg(multipler_cnt_talst_reg),
		 .ifft1__input_real(ifft1__input_real),
		 .ifft1__input_imag(ifft1__input_imag),
		 .ifft1_output_tvalid(ifft1_output_tvalid),
		 .ifft_data_tlast(ifft_data_tlast)
		);
	
		always@(posedge clk)
		if(ifft1_output_real[44]==1)
		temp_ifft1_output_real <= ~ifft1_output_real+1'b1;
		else
		temp_ifft1_output_real <= ifft1_output_real;
		 
		always@(posedge clk or negedge rst_n)
		if(!rst_n)begin
		max1_V <= 45'd0;
		temp_time1 <= 32'd0;
		end
		else if(ifft1_output_tuser==16'd4095)begin
		max1_V <= 45'd0;
		temp_time1 <= 32'd0;
		end
		else if((ifft_tlast_cnt==8'd0)&&(ifft1_output_tvalid)&&(ifft1_output_tuser>0)&&(ifft1_output_tuser<1025)&&(temp_ifft1_output_real>max1_V))begin
		max1_V<=temp_ifft1_output_real;
		temp_time1<= ifft1_output_tuser;
		end
		else begin
		max1_V <= max1_V;
		temp_time1 <= temp_time1;
		end
		
		always@(posedge clk or negedge rst_n)
		if(!rst_n)begin
		max2_V <= 45'd0;
		temp_time2 <= 32'd0;//4096 1024
		end
		else if(ifft1_output_tuser==16'd4095)begin
		max2_V <= 45'd0;
		temp_time2 <= 32'd0;
		end
		else if((ifft_tlast_cnt==8'd1)&&(ifft1_output_tvalid)&&(ifft1_output_tuser>0)&&(ifft1_output_tuser<1025)&&(temp_ifft1_output_real>max2_V))begin
		max2_V<=temp_ifft1_output_real;
		temp_time2<= ifft1_output_tuser;
		end
		else begin
		max2_V <= max2_V;
		temp_time2<= temp_time2;
		end
		
		always@(posedge clk or negedge rst_n)
		if(!rst_n)begin
		max3_V <= 45'd0;
		temp_time3 <= 32'd0;
		end
		else if(ifft1_output_tuser==16'd4095)begin
		max3_V <= 45'd0;
		temp_time3 <= 32'd0;
		end
		else if((ifft_tlast_cnt==8'd2)&&(ifft1_output_tvalid)&&(ifft1_output_tuser>0)&&(ifft1_output_tuser<1025)&&(temp_ifft1_output_real>max3_V))begin
		max3_V<=temp_ifft1_output_real;
		temp_time3<= ifft1_output_tuser;
		end
		else begin
		max3_V <= max3_V;
		temp_time3 <= temp_time3;
		end
		
        always@(posedge clk or negedge rst_n)
        if(!rst_n)
        temp_channel1_time_1 <= 10'd0;
        else if((ifft_tlast_cnt==8'd0)&&(ifft1_output_tuser==16'd1024))
        temp_channel1_time_1 <= temp_time1-1'b1;
        else
        temp_channel1_time_1 <= temp_channel1_time_1;
        
        always@(posedge clk or negedge rst_n)
        if(!rst_n)
        temp_channel2_time_1 <= 10'd0;
        else if((ifft_tlast_cnt==8'd1)&&(ifft1_output_tuser==16'd1024))
        temp_channel2_time_1 <= temp_time2-1'b1;
          else
        temp_channel2_time_1 <= temp_channel2_time_1;
        
        always@(posedge clk or negedge rst_n)
        if(!rst_n)
        temp_channel3_time_1 <= 10'd0;
        else if((ifft_tlast_cnt==8'd2)&&(ifft1_output_tuser==16'd1024))
        temp_channel3_time_1 <= temp_time3-1'b1;
        else
        temp_channel3_time_1 <= temp_channel3_time_1;
        
        always@(posedge clk or negedge rst_n)
        if(!rst_n)
        temp_channel1_time_2 <= 10'd0;
        else if(baiwei1==2'b10)
        temp_channel1_time_2 <= temp_channel1_time_1<<1;
        else
        temp_channel1_time_2 <= temp_channel1_time_1;
        
        always@(posedge clk or negedge rst_n)
        if(!rst_n)
        temp_channel2_time_2 <= 10'd0;
        else if(baiwei2==2'b10)
        temp_channel2_time_2 <= temp_channel2_time_1<<1;
        else
        temp_channel2_time_2 <= temp_channel2_time_1;
        
        always@(posedge clk or negedge rst_n)
        if(!rst_n)
        temp_channel3_time_2 <= 10'd0;
        else if(baiwei3==2'b10)
        temp_channel3_time_2 <= temp_channel3_time_1<<1;
        else
        temp_channel3_time_2 <= temp_channel3_time_1;
        
        always@(posedge clk or negedge rst_n)
        if(!rst_n)
        channel1_time <= 32'd0;
        else if(qianwei1==2'b11&&(ifft1_output_tuser==16'd1024))
        channel1_time <= temp_channel1_time_2+2000;
        else if(qianwei1==2'b10)
        channel1_time <= temp_channel1_time_2+3000;
        else if(qianwei1==2'b01)
        channel1_time <= temp_channel1_time_2+4000;
        
        always@(posedge clk or negedge rst_n)
        if(!rst_n)
        channel2_time <= 32'd0;
        else if(qianwei2==2'b11)
        channel2_time <= temp_channel2_time_2+2000;
        else if(qianwei2==2'b10)
        channel2_time <= temp_channel2_time_2+3000;
        else if(qianwei2==2'b01)
        channel2_time <= temp_channel2_time_2+4000;
        
        always@(posedge clk or negedge rst_n)
        if(!rst_n)
        channel3_time <= 32'd0;
        else if(qianwei3==2'b11)
        channel3_time <= temp_channel3_time_2+2000;
        else if(qianwei3==2'b10)
        channel3_time <= temp_channel3_time_2+3000;
        else if(qianwei3==2'b01)
        channel3_time <= temp_channel3_time_2+4000;
        
        always@(posedge clk or negedge rst_n)
        if(!rst_n)
        trans_done <= 1'd0;
        else if((ifft_tlast_cnt==8'd2)&&(ifft1_output_tuser==16'd4095))
        trans_done <= 1'd1;
        else 
        trans_done <= 0;
		
endmodule

