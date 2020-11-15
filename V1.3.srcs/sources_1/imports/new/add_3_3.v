`timescale 1ns / 1ps
`define float_length 64
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/29 21:07:18
// Design Name: 
// Module Name: add_3_3
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

//this module has 3 adders , can caculate 3 times of addition in 1 time of add_en
module add_3_3
            (
            Clk,
            Rst_n,
            add_en,
            add_done,
            add_a1,
            add_a2,
            add_a3,
            add_b1,
            add_b2,
            add_b3,
            result_1,
            result_2,
            result_3
            );
            
input Clk;
input Rst_n;
input [`float_length-1:0]add_a1;
input [`float_length-1:0]add_a2;
input [`float_length-1:0]add_a3;
input [`float_length-1:0]add_b1;
input [`float_length-1:0]add_b2;
input [`float_length-1:0]add_b3;
input add_en;

output reg add_done;
output reg [`float_length-1:0]result_1;
output reg [`float_length-1:0]result_2;
output reg [`float_length-1:0]result_3;

//add_1_wire
reg add_a_valid;
reg add_b_valid;
reg add_result_ready;
wire add_a1_ready;
wire add_b1_ready;
wire add_result1_valid;
reg [`float_length-1:0]add_a1_data;
reg [`float_length-1:0]add_b1_data;
wire [`float_length-1:0]add_result1_data;
//add_2_wire
wire add_a2_ready;
wire add_b2_ready;
wire add_result2_valid;
reg [`float_length-1:0]add_a2_data;
reg [`float_length-1:0]add_b2_data;
wire [`float_length-1:0]add_result2_data;
//add_3_wire
wire add_a3_ready;
wire add_b3_ready;
wire add_result3_valid;
reg [`float_length-1:0]add_a3_data;
reg [`float_length-1:0]add_b3_data;
wire [`float_length-1:0]add_result3_data;

floating_point_1 add_1
(
.aclk(Clk),
.s_axis_a_tvalid(add_a_valid), 
.s_axis_a_tready(add_a1_ready), 
.s_axis_a_tdata(add_a1_data), 
.s_axis_b_tvalid(add_b_valid), 
.s_axis_b_tready(add_b1_ready), 
.s_axis_b_tdata(add_b1_data), 
.m_axis_result_tvalid(add_result1_valid), 
.m_axis_result_tready(add_result_ready), 
.m_axis_result_tdata(add_result1_data)
);

floating_point_1 add_2
(
.aclk(Clk),
.s_axis_a_tvalid(add_a_valid), 
.s_axis_a_tready(add_a2_ready), 
.s_axis_a_tdata(add_a2_data), 
.s_axis_b_tvalid(add_b_valid), 
.s_axis_b_tready(add_b2_ready), 
.s_axis_b_tdata(add_b2_data), 
.m_axis_result_tvalid(add_result2_valid), 
.m_axis_result_tready(add_result_ready), 
.m_axis_result_tdata(add_result2_data)
);

floating_point_1 add_3
(
.aclk(Clk),
.s_axis_a_tvalid(add_a_valid), 
.s_axis_a_tready(add_a3_ready), 
.s_axis_a_tdata(add_a3_data), 
.s_axis_b_tvalid(add_b_valid), 
.s_axis_b_tready(add_b3_ready), 
.s_axis_b_tdata(add_b3_data), 
.m_axis_result_tvalid(add_result3_valid), 
.m_axis_result_tready(add_result_ready), 
.m_axis_result_tdata(add_result3_data)
);

reg [2:0]add_ctrl_cnt;

always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
    begin
        add_a_valid                 <= 1'b0;
        add_b_valid                 <= 1'b0;
        add_result_ready         <= 1'b1;
        add_ctrl_cnt                 <= 3'd0;
        add_done                     <= 1'b0;
    end
else if(add_en)
    begin
        add_a1_data                 <= add_a1;          
        add_a2_data                 <= add_a2;  
        add_a3_data                 <= add_a3;  
        add_b1_data                 <= add_b1;  
        add_b2_data                 <= add_b2;  
        add_b3_data                 <= add_b3; 
        add_done                      <= 1'b0;
        if(add_ctrl_cnt < 3'd4)
            add_ctrl_cnt              <= 1'b1 + add_ctrl_cnt;
        if(add_ctrl_cnt == 3'd1)
            begin
                add_a_valid           <= 1'b1;
                add_b_valid           <= 1'b1;
            end
        else if(add_ctrl_cnt == 3'd2)   
              begin
                add_a_valid           <= 1'b0;
                add_b_valid           <= 1'b0;
              end  
        else if(add_result1_valid)
            begin
                result_1                  <= add_result1_data;
                result_2                  <= add_result2_data;
                result_3                  <= add_result3_data;
                add_ctrl_cnt           <= 3'd0;
                add_done               <= 1'b1;
              end 
    end


endmodule
