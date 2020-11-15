`timescale 1ns / 1ps
`define float_length 64
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/03 13:31:24
// Design Name: 
// Module Name: div
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


module div(Clk,Rst_n,div_data2,div_data1,div_result,div_en,div_done);
    input Clk;
    input Rst_n;
    input [`float_length-1:0]div_data1;
    input [`float_length-1:0]div_data2;
    input div_en;
    
    output reg [`float_length-1:0]div_result;
    output reg div_done;

reg div_a_valid;
reg div_b_valid;
reg div_result_ready;
reg [`float_length-1:0]div_a_data;
reg [`float_length-1:0]div_b_data;
wire div_a_ready;
wire div_b_ready;
wire div_result_valid;
wire [`float_length-1:0]result;

floating_point_2 div
    (
    .aclk(Clk), 
    .s_axis_a_tvalid(div_a_valid), 
    .s_axis_a_tready(div_a_ready), 
    .s_axis_a_tdata(div_a_data), 
    .s_axis_b_tvalid(div_b_valid), 
    .s_axis_b_tready(div_b_ready), 
    .s_axis_b_tdata(div_b_data), 
    .m_axis_result_tvalid(div_result_valid), 
    .m_axis_result_tready(div_result_ready), 
    .m_axis_result_tdata(result)
    );
    
    reg [2:0]div_ctrl_cnt;
    
    always@(posedge Clk or negedge Rst_n)
    if(!Rst_n)
        begin
            div_a_valid    <= 1'b0;
            div_b_valid    <= 1'b0;
            div_result_ready   <= 1'b1;
            div_done       <= 1'b0;
            div_ctrl_cnt    <= 3'd0;
        end
    else if(div_en)
        begin
            div_done   <= 1'b0;
            div_a_data <= div_data1;
            div_b_data <= div_data2;
            if(div_ctrl_cnt <3'd4)
                div_ctrl_cnt <= div_ctrl_cnt +1'b1;
            if(div_ctrl_cnt == 3'd1)
                begin
                    div_a_valid    <= 1'b1;
                    div_b_valid    <= 1'b1;
                end
            else if(div_ctrl_cnt == 3'd2)
                begin
                    div_a_valid    <= 1'b0;
                    div_b_valid    <= 1'b0;
                end    
            else if(div_result_valid)
                begin
                    div_ctrl_cnt    <= 3'd0;
                    div_done       <= 1'b1;
                    div_result      <= result;
                end    
        end    
    
endmodule
