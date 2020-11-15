`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/29 16:51:50
// Design Name: 
// Module Name: rom
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


module rom(
		input clk,
		input rst_n,
		input [31:0] input_time1,
		input [31:0] input_time2,
		input [31:0] input_time3,
		input [7:0]ifft_tlast_cnt,
		output reg channel1_begin ,	
		output reg channel2_begin,
		output [15:0] channel1_out_data,
		output [15:0] channel2_out_data,
		output reg [1:0] qianwei1,
		output reg [1:0] qianwei2,
		output reg [1:0] qianwei3,
		output reg [1:0] baiwei1,
		output reg [1:0] baiwei2,
		output reg [1:0] baiwei3
		);
		
		reg [12:0] addr0;
		reg [12:0] addr1;
		reg [9:0] time1;
		reg [9:0] time2;
		reg [9:0] time3;	
		reg [9:0] temp_time1_1,temp_time1_2;
		reg [9:0] temp_input_time1,temp_input_time2,temp_input_time3;
		reg [7:0] temp_ifft_tlast_cnt1,temp_ifft_tlast_cnt2;
		
	dist_mem_gen_0 rom_0(
		.a(addr0),
		.spo(channel1_out_data)
		);

	dist_mem_gen_0 rom_1 (
		.a(addr1),
		.spo(channel2_out_data)
		);
	
 always@(posedge clk or negedge rst_n)
       if(!rst_n)
       qianwei1 <= 2'b00;
       else if((input_time1-2000<1000)&&(input_time1-2000>0))//2000+
       qianwei1 <= 2'b11;
       else if((input_time1-2000>1000)&&(input_time1-2000<2000))//3000+
       qianwei1 <= 2'b10;
	   else if((input_time1-2000>2000)&&(input_time1-2000<3000))//4000+
       qianwei1 <= 2'b01;
       
 always@(posedge clk or negedge rst_n)
       if(!rst_n)
       qianwei2 <= 2'b00;
       else if((input_time2-2000<1000)&&(input_time2-2000>0))//2000+
       qianwei2 <= 2'b11;
       else if((input_time2-2000>1000)&&(input_time2-2000<2000))//3000+
       qianwei2 <= 2'b10;
	   else if((input_time2-2000>2000)&&(input_time2-2000<3000))//4000+
       qianwei2 <= 2'b01;
       
 always@(posedge clk or negedge rst_n)
       if(!rst_n)
       qianwei3 <= 2'b00;
       else if((input_time3-2000<1000)&&(input_time3-2000>0))//2000+
       qianwei3 <= 2'b11;
       else if((input_time3-2000>1000)&&(input_time3-2000<2000))//3000+
       qianwei3 <= 2'b10;
	   else if((input_time3-2000>2000)&&(input_time3-2000<3000))//4000+
       qianwei3 <= 2'b01;
       
  always@(posedge clk or negedge rst_n)
       if(!rst_n)
       temp_input_time1 <= 10'd0;
       else if(qianwei1==2'b11)
       temp_input_time1 <= input_time1 - 2000;
       else if(qianwei1==2'b10)
       temp_input_time1 <= input_time1 - 3000;
       else if(qianwei1==2'b01)
       temp_input_time1 <= input_time1 - 4000;
       
   always@(posedge clk or negedge rst_n)
       if(!rst_n)
       temp_input_time2 <= 10'd0;
       else if(qianwei2==2'b11)
       temp_input_time2 <= input_time2 - 2000;
       else if(qianwei2==2'b10)
       temp_input_time2 <= input_time2 - 3000;
       else if(qianwei2==2'b01)
       temp_input_time2 <= input_time2 - 4000;
       
  always@(posedge clk or negedge rst_n)
       if(!rst_n)
       temp_input_time3 <= 10'd0;
       else if(qianwei3==2'b11)
       temp_input_time3 <= input_time3 - 2000;
       else if(qianwei3==2'b10)
       temp_input_time3 <= input_time3 - 3000;
       else if(qianwei3==2'b01)
       temp_input_time3 <= input_time3 - 4000;
       
   always@(posedge clk or negedge rst_n)
       if(!rst_n)
       time1 <= 10'b0;
       else if(temp_input_time1>=500)
       time1 <= temp_input_time1>>1;
       else 
       time1 <= temp_input_time1;
       
   always@(posedge clk or negedge rst_n)
       if(!rst_n)
       time2 <= 10'b0;
       else if(temp_input_time2>=500)
       time2 <= temp_input_time2>>1;
       else 
       time2 <= temp_input_time2;
       
   always@(posedge clk or negedge rst_n)
       if(!rst_n)
       time3 <= 10'b0;
       else if(temp_input_time3>=500)
       time3 <= temp_input_time3>>1;
       else 
       time3 <= temp_input_time3;
 
     always@(posedge clk or negedge rst_n)
       if(!rst_n)
       baiwei1 <= 2'b0;
       else if(temp_input_time1>=500)
       baiwei1 <= 2'b10;
       else 
       baiwei1 <= 2'b01;
       
   always@(posedge clk or negedge rst_n)
       if(!rst_n)
       baiwei2 <= 2'b0;
       else if(temp_input_time2>=500)
       baiwei2 <= 2'b10;
       else 
       baiwei2 <= 2'b01;
       
   always@(posedge clk or negedge rst_n)
       if(!rst_n)
       baiwei3 <= 2'b0;
       else if(temp_input_time3>=500)
       baiwei3 <= 2'b10;
       else 
       baiwei3 <= 2'b01;
       
 always@(posedge clk or negedge rst_n)
		if(!rst_n)begin
		temp_time1_1<=10'd0;
		temp_time1_2<=10'd0;
		end
		else begin
		temp_time1_1<=time1;
		temp_time1_2<=temp_time1_1;
		end
 always@(posedge clk or negedge rst_n)
		if(!rst_n)begin
		temp_ifft_tlast_cnt1<=10'd0;
		temp_ifft_tlast_cnt2<=10'd0;
		end
		else begin
		temp_ifft_tlast_cnt1<=ifft_tlast_cnt;
		temp_ifft_tlast_cnt2<=temp_ifft_tlast_cnt1;
		end
 always@(posedge clk or negedge rst_n)
		if(!rst_n)
		channel1_begin <= 1'd0;
		else if(temp_time1_1!=temp_time1_2)
		channel1_begin <= 1'b1;
		else if((temp_ifft_tlast_cnt1!=temp_ifft_tlast_cnt2)&&(temp_ifft_tlast_cnt1!=3)&&(temp_ifft_tlast_cnt1!=0))
		channel1_begin <= 1'b1;
		else if(addr0==4096)
		channel1_begin <= 1'd0;
		else
		channel1_begin <= channel1_begin;
		
always@(posedge clk or negedge rst_n)
		if(!rst_n)
		addr0 <= 13'd0;
		else if(channel1_begin&&addr0<4096)
		addr0 <= addr0 + 1'd1;
		else
		addr0<=0;
		
always@(posedge clk or negedge rst_n)
		if(!rst_n)
		channel2_begin <= 1'b0;
		else if((addr0==time1-1'b1)&&(ifft_tlast_cnt==7'd0)&&(addr0>0))
		channel2_begin <= 1'b1;
		else if((addr0==time2-1'b1)&&(ifft_tlast_cnt==7'd1)&&(addr0>0))
		channel2_begin <= 1'b1;
		else if((addr0==time3-1'b1)&&(ifft_tlast_cnt==7'd2)&&(addr0>0))
		channel2_begin <= 1'b1;
		else if(addr0==4096)
		channel2_begin <= 1'b0;
		
		
always@(posedge clk or negedge rst_n)
		if(!rst_n)
		addr1 <= 13'd0;
		else if(channel2_begin)
		addr1 <= addr1 +1'd1;
		else 
		addr1 <= 13'd0;
		
	
	endmodule
	