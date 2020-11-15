`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/21 19:48:38
// Design Name: 
// Module Name: pinv
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

//this module can compute a martix's pinv
module pinv(Clk,Rst_n,
            input_martix_A0,
            input_martix_A1,
            input_martix_A2,
            output_martix_B0,
            output_martix_B1,
            output_martix_B2,
            pinv_done,
            pinv_en
            );
    
input Clk;
input Rst_n;
input pinv_en;

input [191:0]input_martix_A0;
input [191:0]input_martix_A1;
input [191:0]input_martix_A2;

output reg [191:0]output_martix_B0;
output reg [191:0]output_martix_B1;
output reg [191:0]output_martix_B2;

output reg pinv_done;


wire [191:0]tran_A_0;
wire [191:0]tran_A_1;
wire [191:0]tran_A_2;

reg [191:0]multip_left_A0;
reg [191:0]multip_left_A1;
reg [191:0]multip_left_A2;

reg [191:0]multip_right_B0;
reg [191:0]multip_right_B1;
reg [191:0]multip_right_B2;

wire [191:0]outcome_C0;
wire [191:0]outcome_C1;
wire [191:0]outcome_C2;

reg [191:0]input_invA0;
reg [191:0]input_invA1;
reg [191:0]input_invA2;

wire [191:0]inv_A0;
wire [191:0]inv_A1;
wire [191:0]inv_A2;

reg tran_en;
reg multip_en;
reg inv_en;
reg multip_flag;
wire multip_done;
wire inv_done;
 


wire tran_done;

inv inv(
.A0(input_invA0),
.A1(input_invA1),
.A2(input_invA2),
.inv_A0(inv_A0),
.inv_A1(inv_A1),
.inv_A2(inv_A2),
.Clk(Clk),
.Rst_n(Rst_n),
.inv_en(inv_en),
.inv_done(inv_done)
);

martix_multip martix_multip_0(
        .Clk(Clk),
        .Rst_n(Rst_n),
        .A0(multip_left_A0),
        .A1(multip_left_A1),
        .A2(multip_left_A2),
        .B0(multip_right_B0),
        .B1(multip_right_B1),
        .B2(multip_right_B2),
        .C0(outcome_C0),
        .C1(outcome_C1),
        .C2(outcome_C2),
        .multip_en(multip_en),
        .done(multip_done)
    );
    
matrix_tran matrix_tran_0(
    .Clk(Clk),
    .Rst_n(Rst_n),
    .tran_en(tran_en),
    
    .A0(input_martix_A0),
    .A1(input_martix_A1),
    .A2(input_martix_A2),

    .tran_A_0(tran_A_0),
    .tran_A_1(tran_A_1),
    .tran_A_2(tran_A_2),
    
    .tran_done(tran_done)
);
    
always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
        tran_en <= 1'b0;
else if(pinv_en == 1'b1)
    tran_en <= 1'b1;
else 
    tran_en <= 1'b0;
 
always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
    begin
        multip_left_A0 <= 191'd0;
        multip_left_A1 <= 191'd0;
        multip_left_A2 <= 191'd0;
        multip_right_B0 <= 191'd0;
        multip_right_B1 <= 191'd0;
        multip_right_B2 <= 191'd0;

    end
else if(tran_done)
    begin
        multip_left_A0 <= tran_A_0;
        multip_left_A1 <= tran_A_1;
        multip_left_A2 <= tran_A_2;
        multip_right_B0 <= input_martix_A0;
        multip_right_B1 <= input_martix_A1;
        multip_right_B2 <= input_martix_A2;
    end
 else if(inv_done)
       begin
        multip_left_A0 <= inv_A0;
        multip_left_A1 <= inv_A1;
        multip_left_A2 <= inv_A2;
        multip_right_B0 <= tran_A_0;
        multip_right_B1 <= tran_A_1;
        multip_right_B2 <= tran_A_2;
    end

always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
    begin
        multip_en  <= 1'b0;
        multip_flag <= 1'b0;
    end    
else if(tran_done)
    begin
        multip_en <= 1'b1;
        multip_flag<= 1'b0;
    end    
else if(inv_done)
    begin
        multip_en <= 1'b1;
        multip_flag <= 1'b1;
    end    
else 
    begin
        multip_en <= 1'b0;
    end
    
always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
	inv_en    <= 1'b0;
else if(multip_done&&(!multip_flag))
	inv_en    <= 1'b1;
else 
	inv_en    <= 1'b0;

always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
    pinv_done <= 1'b0;
else if(multip_flag&&multip_done)
    pinv_done <= 1'b1;
else 
    pinv_done <= 1'b0;
    
always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
    begin
        input_invA0 <= 191'd0;
        input_invA1 <= 191'd0;
        input_invA2 <= 191'd0;
    end
else if(multip_done&&(!multip_flag))
    begin
        input_invA0 <= outcome_C0;
        input_invA1 <= outcome_C1;
        input_invA2 <= outcome_C2;
    end

always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
begin
    output_martix_B0   <= 191'd0;
    output_martix_B1   <= 191'd0;
    output_martix_B2   <= 191'd0;
end
else if(pinv_done)
begin
    output_martix_B0   <= outcome_C0;
    output_martix_B1   <= outcome_C1;
    output_martix_B2   <= outcome_C2;
end
    
endmodule
