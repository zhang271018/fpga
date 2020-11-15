`timescale 1ns / 1ps
`define float_length 64
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/03 02:17:35
// Design Name: 
// Module Name: multip_3_3
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


module multip_3_3(multip_en,multip_done,multip_a1,multip_a2,multip_a3,
                                multip_b1,multip_b2,multip_b3,result_1,result_2,result_3,Clk,
                                Rst_n);
          
input multip_en;
input [`float_length-1:0]multip_a1; 
input [`float_length-1:0]multip_a2;   
input [`float_length-1:0]multip_a3;   
input [`float_length-1:0]multip_b1;   
input [`float_length-1:0]multip_b2;   
input [`float_length-1:0]multip_b3;
input Clk;
input Rst_n;

output reg [`float_length-1:0]result_1;
output reg [`float_length-1:0]result_2;
output reg [`float_length-1:0]result_3;
output reg multip_done;   

//multip_1_wire         
reg multip_a_valid;
reg multip_b_valid;
reg multip_result_ready;
wire multip_a1_ready;
wire multip_b1_ready;
wire multip_result1_valid;
reg [`float_length-1:0]multip_a1_data;
reg [`float_length-1:0]multip_b1_data;
wire [`float_length-1:0]multip_result1_data;

//multip_2_wire         
wire multip_a2_ready;
wire multip_b2_ready;
wire multip_result2_valid;
reg [`float_length-1:0]multip_a2_data;
reg [`float_length-1:0]multip_b2_data;
wire [`float_length-1:0]multip_result2_data;

//multip_3_wire         
wire multip_a3_ready;
wire multip_b3_ready;
wire multip_result3_valid;
reg [`float_length-1:0]multip_a3_data;
reg [`float_length-1:0]multip_b3_data;
wire [`float_length-1:0]multip_result3_data;
        
floating_point_0 multip1
(
.aclk(Clk), 
.s_axis_a_tvalid(multip_a_valid), 
.s_axis_a_tready(multip_a1_ready), 
.s_axis_a_tdata(multip_a1_data), 
.s_axis_b_tvalid(multip_b_valid), 
.s_axis_b_tready(multip_b1_ready), 
.s_axis_b_tdata(multip_b1_data), 
.m_axis_result_tvalid(multip_result1_valid), 
.m_axis_result_tready(multip_result_ready), 
.m_axis_result_tdata(multip_result1_data)
);

floating_point_0 multip2
(
.aclk(Clk), 
.s_axis_a_tvalid(multip_a_valid), 
.s_axis_a_tready(multip_a2_ready), 
.s_axis_a_tdata(multip_a2_data), 
.s_axis_b_tvalid(multip_b_valid), 
.s_axis_b_tready(multip_b2_ready), 
.s_axis_b_tdata(multip_b2_data), 
.m_axis_result_tvalid(multip_result2_valid), 
.m_axis_result_tready(multip_result_ready), 
.m_axis_result_tdata(multip_result2_data)
);     

floating_point_0 multip3
(
.aclk(Clk), 
.s_axis_a_tvalid(multip_a_valid), 
.s_axis_a_tready(multip_a3_ready), 
.s_axis_a_tdata(multip_a3_data), 
.s_axis_b_tvalid(multip_b_valid), 
.s_axis_b_tready(multip_b3_ready), 
.s_axis_b_tdata(multip_b3_data), 
.m_axis_result_tvalid(multip_result3_valid), 
.m_axis_result_tready(multip_result_ready), 
.m_axis_result_tdata(multip_result3_data)
);                                     


reg [2:0]multip_ctrl_cnt;

always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
    begin
        multip_a_valid                 <= 1'b0;
        multip_b_valid                 <= 1'b0;
        multip_result_ready        <= 1'b1;
        multip_ctrl_cnt                <= 3'd0;
        multip_done                    <= 1'b0;
    end
else if(multip_en)
    begin
        multip_a1_data                 <= multip_a1;          
        multip_a2_data                 <= multip_a2;  
        multip_a3_data                 <= multip_a3;  
        multip_b1_data                 <= multip_b1;  
        multip_b2_data                 <= multip_b2;  
        multip_b3_data                 <= multip_b3; 
        multip_done                     <= 1'b0;
        if(multip_ctrl_cnt < 3'd4)
            multip_ctrl_cnt              <= 1'b1 + multip_ctrl_cnt;
        if(multip_ctrl_cnt == 3'd2)
            begin
                multip_a_valid           <= 1'b1;
                multip_b_valid           <= 1'b1;
            end
        else if(multip_ctrl_cnt == 3'd3)   
              begin
                multip_a_valid           <= 1'b0;
                multip_b_valid           <= 1'b0;
              end  
        else if(multip_result1_valid)
            begin
                multip_ctrl_cnt       <= 3'd0;
                result_1                  <= multip_result1_data;
                result_2                  <= multip_result2_data;
                result_3                  <= multip_result3_data;
                multip_done               <= 1'b1;
              end 
    end                                
endmodule
