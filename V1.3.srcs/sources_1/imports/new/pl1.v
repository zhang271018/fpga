`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/06 21:01:18
// Design Name: 
// Module Name: plmodify
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


module plmodify(
 clk,
 input_time,
 outchannel1
    );
	input clk;
	input [29:0]input_time;
	output reg [31:0]outchannel1;
	reg [9:0] probe0;
	reg [9:0] probe1;
	reg [9:0] probe2;
	reg [31:0] probe3;
ila_0  ILA(
.clk   (clk),
.probe0(probe0),
.probe1(probe1),
.probe2(probe2),
.probe3(probe3),
.probe4(probe4),
.probe5(probe5)
);
always@(posedge clk)
begin 
	outchannel1<={2'b00,input_time+1};
end

always@(posedge clk)
begin
	probe0<=input_time[9:0];
	probe1<=input_time[19:10];
	probe2<=input_time[29:20];
	probe3<=outchannel1;
end
endmodule
