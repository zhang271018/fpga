`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/24 19:10:07
// Design Name: 
// Module Name: extract_time_location
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


module extract_time_location(clk,rst_n,input_time);
	input clk;
	input rst_n;
	input [29:0] input_time;
	
	wire signed [31:0]S_1;
    wire signed [31:0]S_2;
    wire signed [31:0]S_3;
	
	wire [9:0] channel1_time;
	wire [9:0] channel2_time;
	wire [9:0] channel3_time;
	wire trans_done;
	
	extract_time_top extract_time_top(
		.clk(clk),
		.rst_n(rst_n),
		.input_time(input_time),
		.channel1_time(channel1_time),
		.channel2_time(channel2_time),
		.channel3_time(channel3_time),
		.trans_done(trans_done)
		);
		
	chan_1 chan_1(
		.Clk(clk),
		.time_1({22'b0,channel1_time}),
		.time_2({22'b0,channel2_time}),
		.time_3({22'b0,channel3_time}),
		.S1(S_1),
		.S2(S_2),
		.S3(S_3),
		.Rst_n(rst_n),
		.chan_en(trans_done),
		.chan_done(chan_done)
		);
	
endmodule













