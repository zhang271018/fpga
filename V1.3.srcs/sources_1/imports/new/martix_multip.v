`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/20 18:12:51
// Design Name: 
// Module Name: martix_multip
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

//martix multiple 3x3
module martix_multip(
        Clk,Rst_n,
        A0,A1,A2,
        B0,B1,B2,
        C0,C1,C2,
        multip_en,
        done
    );
    
    input Clk;
    input Rst_n;
    input [191:0]A0;
    input [191:0]A1;
    input [191:0]A2;
    
    input [191:0]B0;
    input [191:0]B1;
    input [191:0]B2;
    
    input multip_en;
    
    output reg [191:0]C0;
    output reg [191:0]C1;
    output reg [191:0]C2;
    
    output reg done;
   
    wire signed [63:0]multip_0_output;
    reg signed [63:0]multip_0_input_1;
    reg signed [63:0]multip_0_input_2;
    
    wire signed [63:0]multip_1_output;
    reg signed [63:0]multip_1_input_1;
    reg signed [63:0]multip_1_input_2;
    
    wire signed [63:0]multip_2_output;
    reg signed [63:0]multip_2_input_1;
    reg signed [63:0]multip_2_input_2;
    
    wire signed [63:0]sub_output;
    reg signed [63:0]sub_input1;
    reg signed [63:0]sub_input2;
    
    reg multip_start_a0;//运算开始
    reg multip_start_a1;
    reg multip_start_a2;
    reg multip_start_b0;//运算开始
    reg multip_start_b1;
    reg multip_start_b2;
    reg sub_start;
    
    wire multip_end_0;//运算完成
    wire multip_end_1;
    wire multip_end_2;
    wire sub_end;
    
    wire multip_ready_a0;//乘法器已准备
    wire multip_ready_a1;
    wire multip_ready_a2;
    wire sub_ready_1;
    
    wire multip_ready_b0;
    wire multip_ready_b1;
    wire multip_ready_b2;
    wire sub_ready_2;
    
    reg result_got_0; //得到结果
    reg result_got_1; 
    reg result_got_2; 
    reg sub_result_got;
    
    floating_point_0 floating_point_0//multip
    (
    .aclk(Clk), 
    .s_axis_a_tvalid(multip_start_a0), 
    .s_axis_a_tready(multip_ready_a0), 
    .s_axis_a_tdata(multip_0_input_1), 
    .s_axis_b_tvalid(multip_start_b0), 
    .s_axis_b_tready(multip_ready_b0), 
    .s_axis_b_tdata(multip_0_input_2), 
    .m_axis_result_tvalid(multip_end_0), 
    .m_axis_result_tready(result_got_0), 
    .m_axis_result_tdata(multip_0_output)
    );
    
    floating_point_0 floating_point_1//multip
    (
    .aclk(Clk), 
    .s_axis_a_tvalid(multip_start_a1), 
    .s_axis_a_tready(multip_ready_a1), 
    .s_axis_a_tdata(multip_1_input_1), 
    .s_axis_b_tvalid(multip_start_b1), 
    .s_axis_b_tready(multip_ready_b1), 
    .s_axis_b_tdata(multip_1_input_2), 
    .m_axis_result_tvalid(multip_end_1), 
    .m_axis_result_tready(result_got_1), 
    .m_axis_result_tdata(multip_1_output)
    );
    
    floating_point_0 floating_point_2//multip
    (
    .aclk(Clk), 
    .s_axis_a_tvalid(multip_start_a2), 
    .s_axis_a_tready(multip_ready_a2), 
    .s_axis_a_tdata(multip_2_input_1), 
    .s_axis_b_tvalid(multip_start_b2), 
    .s_axis_b_tready(multip_ready_b2), 
    .s_axis_b_tdata(multip_2_input_2), 
    .m_axis_result_tvalid(multip_end_2), 
    .m_axis_result_tready(result_got_2), 
    .m_axis_result_tdata(multip_2_output)
    );
    
    floating_point_1 floating_point_3//sub
    (
    .aclk(Clk), 
    .s_axis_a_tvalid(sub_start), 
    .s_axis_a_tready(sub_ready_1), 
    .s_axis_a_tdata(sub_input1), 
    .s_axis_b_tvalid(sub_start), 
    .s_axis_b_tready(sub_ready_2), 
    .s_axis_b_tdata(sub_input2), 
    .m_axis_result_tvalid(sub_end), 
    .m_axis_result_tready(sub_result_got), 
    .m_axis_result_tdata(sub_output)
    );
    
    reg [9:0]multip_state;
    reg [3:0]multip_cnt;

    reg [9:0]sub_wait;
    reg [9:0]multip_wait;

    
    parameter sub_idle    =         10'b0000_0000_01,
                       sub_C00   =         10'b0000_0000_10,
                       sub_C01   =         10'b0000_0001_00,
                       sub_C02   =         10'b0000_0010_00,
                       sub_C10   =         10'b0000_0100_00,
                       sub_C11   =         10'b0000_1000_00,
                       sub_C12   =         10'b0001_0000_00,
                       sub_C20   =         10'b0010_0000_00,
                       sub_C21   =         10'b0100_0000_00,
                       sub_C22   =         10'b1000_0000_00;
    
    parameter idle               =         10'b0000_0000_01,
                       multip_C00   =         10'b0000_0000_10,
                       multip_C01   =         10'b0000_0001_00,
                       multip_C02   =         10'b0000_0010_00,
                       multip_C10   =         10'b0000_0100_00,
                       multip_C11   =         10'b0000_1000_00,
                       multip_C12   =         10'b0001_0000_00,
                       multip_C20   =         10'b0010_0000_00,
                       multip_C21   =         10'b0100_0000_00,
                       multip_C22   =         10'b1000_0000_00;
    
   parameter 
                    multip_wait_time  = 10'd60,
                    sub_wait_time       = 10'd35;
    
    
    always@(posedge Clk or negedge Rst_n)
    if(!Rst_n)
        begin
           result_got_0          <= 1'b0;
           result_got_1          <= 1'b0;
           result_got_2          <= 1'b0;
           multip_start_a0      <= 1'b0;
           multip_start_a1      <= 1'b0;
           multip_start_a2      <= 1'b0;
           multip_start_b0      <= 1'b0;
           multip_start_b1      <= 1'b0;
           multip_start_b2      <= 1'b0;
           multip_state           <= idle;
           multip_wait            <= 10'd0;
           
           multip_cnt              <= 4'd0;
        end   
     else 
        case(multip_state)
            idle:
                begin
                    result_got_0          <= 1'b0;
                    result_got_1          <= 1'b0;
                    result_got_2          <= 1'b0;
                    multip_wait            <= 10'd0;

                    multip_cnt              <= 4'd0;
                    if(multip_en)
                        begin
                            multip_state <= multip_C00;
                            multip_start_a0      <= 1'b0;
                            multip_start_a1      <= 1'b0;
                            multip_start_a2      <= 1'b0;
                            multip_start_b0      <= 1'b0;
                            multip_start_b1      <= 1'b0;
                            multip_start_b2      <= 1'b0;
                            result_got_0          <= 1'b0;
                            result_got_1          <= 1'b0;
                            result_got_2          <= 1'b0;
                        end
                end
         multip_C00:
            begin
                multip_wait            <= multip_wait + 1'b1;
            if(multip_wait <multip_wait_time/3)
                begin
                            result_got_0          <= 1'b0;
                            result_got_1          <= 1'b0;
                            result_got_2          <= 1'b0;
                            
                            multip_start_a0      <= 1'b1;
                            multip_start_a1      <= 1'b1;
                            multip_start_a2      <= 1'b1;
                            multip_start_b0      <= 1'b1;
                            multip_start_b1      <= 1'b1;
                            multip_start_b2      <= 1'b1;
                            
                            multip_0_input_1  <= A0[191:128];
                            multip_0_input_2  <= B0[191:128];
                            
                            multip_1_input_1  <= A0[127:64];
                            multip_1_input_2  <= B1[191:128];
                            
                            multip_2_input_1  <= A0[63:0];
                            multip_2_input_2  <= B2[191:128];
                 end
         else if(multip_wait == multip_wait_time/3)
            begin
                multip_start_a0      <= 1'b0;
                multip_start_a1      <= 1'b0;
                multip_start_a2      <= 1'b0;
                multip_start_b0      <= 1'b0;
                multip_start_b1      <= 1'b0;
                multip_start_b2      <= 1'b0;
                result_got_0          <= 1'b1;
                result_got_1          <= 1'b1;
                result_got_2          <= 1'b1;
                multip_cnt              <= multip_cnt + 1'd1;
            end
       else if(multip_wait == multip_wait_time)
            begin
                multip_state <= multip_C01;
                multip_wait <= 10'd0;
            end
        end
        
        multip_C01:
            begin
                multip_wait            <= multip_wait + 1'b1;
            if(multip_wait <multip_wait_time/3)
                begin
                            result_got_0          <= 1'b0;
                            result_got_1          <= 1'b0;
                            result_got_2          <= 1'b0;
                            multip_start_a0      <= 1'b1;
                            multip_start_a1      <= 1'b1;
                            multip_start_a2      <= 1'b1;
                            multip_start_b0      <= 1'b1;
                            multip_start_b1      <= 1'b1;
                            multip_start_b2      <= 1'b1;
                        
                            multip_0_input_1  <= A0[191:128];
                            multip_0_input_2  <= B0[127:64];
                            
                            multip_1_input_1  <= A0[127:64];
                            multip_1_input_2  <= B1[127:64];
                            
                            multip_2_input_1  <= A0[63:0];
                            multip_2_input_2  <= B2[127:64];
                 end
         else if(multip_wait == multip_wait_time/3)
            begin
                result_got_0          <= 1'b1;
                result_got_1          <= 1'b1;
                result_got_2          <= 1'b1;
                multip_start_a0      <= 1'b0;
                multip_start_a1      <= 1'b0;
                multip_start_a2      <= 1'b0;
                multip_start_b0      <= 1'b0;
                multip_start_b1      <= 1'b0;
                multip_start_b2      <= 1'b0;
                multip_cnt              <= multip_cnt + 1'd1;
            end
       else if(multip_wait ==multip_wait_time)
            begin
                multip_state <= multip_C02;
                multip_wait <= 10'd0;
            end
        end
        
        multip_C02:
            begin
                multip_wait            <= multip_wait + 1'b1;
            if(multip_wait <multip_wait_time/3)
                begin
                            result_got_0          <= 1'b0;
                            result_got_1          <= 1'b0;
                            result_got_2          <= 1'b0;
                            multip_start_a0      <= 1'b1;
                            multip_start_a1      <= 1'b1;
                            multip_start_a2      <= 1'b1;
                            multip_start_b0      <= 1'b1;
                            multip_start_b1      <= 1'b1;
                            multip_start_b2      <= 1'b1;
                        
                            multip_0_input_1  <= A0[191:128];
                            multip_0_input_2  <= B0[63:0];
                            
                            multip_1_input_1  <= A0[127:64];
                            multip_1_input_2  <= B1[63:0];
                            
                            multip_2_input_1  <= A0[63:0];
                            multip_2_input_2  <= B2[63:0];
                 end
         else if(multip_wait == multip_wait_time/3)
            begin
                result_got_0          <= 1'b1;
                result_got_1          <= 1'b1;
                result_got_2          <= 1'b1;
                multip_start_a0      <= 1'b0;
                multip_start_a1      <= 1'b0;
                multip_start_a2      <= 1'b0;
                multip_start_b0      <= 1'b0;
                multip_start_b1      <= 1'b0;
                multip_start_b2      <= 1'b0;
                multip_cnt              <= multip_cnt + 1'd1;
            end
       else if(multip_wait == multip_wait_time)
            begin
                multip_state <= multip_C10;
                multip_wait <= 10'd0;
            end
        end
        
        multip_C10:
            begin
                multip_wait            <= multip_wait + 1'b1;
            if(multip_wait <multip_wait_time/3)
                begin
                            result_got_0          <= 1'b0;
                            result_got_1          <= 1'b0;
                            result_got_2          <= 1'b0;
                            multip_start_a0      <= 1'b1;
                            multip_start_a1      <= 1'b1;
                            multip_start_a2      <= 1'b1;
                            multip_start_b0      <= 1'b1;
                            multip_start_b1      <= 1'b1;
                            multip_start_b2      <= 1'b1;
                        
                            multip_0_input_1  <= A1[191:128];
                            multip_0_input_2  <= B0[191:128];
                            
                            multip_1_input_1  <= A1[127:64];
                            multip_1_input_2  <= B1[191:128];
                            
                            multip_2_input_1  <= A1[63:0];
                            multip_2_input_2  <= B2[191:128];
                 end
         else if(multip_wait == multip_wait_time/3)
            begin
                result_got_0          <= 1'b1;
                result_got_1          <= 1'b1;
                result_got_2          <= 1'b1;
                multip_start_a0      <= 1'b0;
                multip_start_a1      <= 1'b0;
                multip_start_a2      <= 1'b0;
                multip_start_b0      <= 1'b0;
                multip_start_b1      <= 1'b0;
                multip_start_b2      <= 1'b0;
                multip_cnt              <= multip_cnt + 1'd1;
            end
       else if(multip_wait == multip_wait_time)
            begin
                multip_state <= multip_C11;
                multip_wait <= 10'd0;
            end
        end
        
        multip_C11:
            begin
                multip_wait            <= multip_wait + 1'b1;
            if(multip_wait <multip_wait_time/3)
                begin
                            result_got_0          <= 1'b0;
                            result_got_1          <= 1'b0;
                            result_got_2          <= 1'b0;
                            multip_start_a0      <= 1'b1;
                            multip_start_a1      <= 1'b1;
                            multip_start_a2      <= 1'b1;
                            multip_start_b0      <= 1'b1;
                            multip_start_b1      <= 1'b1;
                            multip_start_b2      <= 1'b1;
                        
                            multip_0_input_1  <= A1[191:128];
                            multip_0_input_2  <= B0[127:64];
                            
                            multip_1_input_1  <= A1[127:64];
                            multip_1_input_2  <= B1[127:64];
                            
                            multip_2_input_1  <= A1[63:0];
                            multip_2_input_2  <= B2[127:64];
                 end
         else if(multip_wait == multip_wait_time/3)
            begin
                result_got_0          <= 1'b1;
                result_got_1          <= 1'b1;
                result_got_2          <= 1'b1;
                multip_start_a0      <= 1'b0;
                multip_start_a1      <= 1'b0;
                multip_start_a2      <= 1'b0;
                multip_start_b0      <= 1'b0;
                multip_start_b1      <= 1'b0;
                multip_start_b2      <= 1'b0;
                multip_cnt              <= multip_cnt + 1'd1;
            end
       else if(multip_wait == multip_wait_time)
            begin
                multip_state <= multip_C12;
                multip_wait <= 10'd0;
            end
        end
        
        multip_C12:
            begin
                multip_wait            <= multip_wait + 1'b1;
            if(multip_wait <multip_wait_time/3)
                begin
                            result_got_0          <= 1'b0;
                            result_got_1          <= 1'b0;
                            result_got_2          <= 1'b0;
                            multip_start_a0      <= 1'b1;
                            multip_start_a1      <= 1'b1;
                            multip_start_a2      <= 1'b1;
                            multip_start_b0      <= 1'b1;
                            multip_start_b1      <= 1'b1;
                            multip_start_b2      <= 1'b1;
                        
                            multip_0_input_1  <= A1[191:128];
                            multip_0_input_2  <= B0[63:0];
                            
                            multip_1_input_1  <= A1[127:64];
                            multip_1_input_2  <= B1[63:0];
                            
                            multip_2_input_1  <= A1[63:0];
                            multip_2_input_2  <= B2[63:0];
                 end
         else if(multip_wait == multip_wait_time/3)
            begin
                result_got_0          <= 1'b1;
                result_got_1          <= 1'b1;
                result_got_2          <= 1'b1;
                multip_start_a0      <= 1'b0;
                multip_start_a1      <= 1'b0;
                multip_start_a2      <= 1'b0;
                multip_start_b0      <= 1'b0;
                multip_start_b1      <= 1'b0;
                multip_start_b2      <= 1'b0;
                multip_cnt              <= multip_cnt + 1'd1;
            end
       else if(multip_wait == multip_wait_time)
            begin
                multip_state <= multip_C20;
                multip_wait <= 10'd0;
            end
        end
        
        multip_C20:
            begin
                multip_wait            <= multip_wait + 1'b1;
            if(multip_wait <multip_wait_time/3)
                begin
                            result_got_0          <= 1'b0;
                            result_got_1          <= 1'b0;
                            result_got_2          <= 1'b0;
                            multip_start_a0      <= 1'b1;
                            multip_start_a1      <= 1'b1;
                            multip_start_a2      <= 1'b1;
                            multip_start_b0      <= 1'b1;
                            multip_start_b1      <= 1'b1;
                            multip_start_b2      <= 1'b1;
                        
                            multip_0_input_1  <= A2[191:128];
                            multip_0_input_2  <= B0[191:128];
                            
                            multip_1_input_1  <= A2[127:64];
                            multip_1_input_2  <= B1[191:128];
                            
                            multip_2_input_1  <= A2[63:0];
                            multip_2_input_2  <= B2[191:128];
                 end
         else if(multip_wait == multip_wait_time/3)
            begin
                result_got_0          <= 1'b1;
                result_got_1          <= 1'b1;
                result_got_2          <= 1'b1;
                multip_start_a0      <= 1'b0;
                multip_start_a1      <= 1'b0;
                multip_start_a2      <= 1'b0;
                multip_start_b0      <= 1'b0;
                multip_start_b1      <= 1'b0;
                multip_start_b2      <= 1'b0;
                multip_cnt              <= multip_cnt + 1'd1;
            end
       else if(multip_wait == multip_wait_time)
            begin
                multip_state <= multip_C21;
                multip_wait <= 10'd0;
            end
        end
        
        multip_C21:
            begin
                multip_wait            <= multip_wait + 1'b1;
            if(multip_wait <multip_wait_time/3)
                begin
                            result_got_0          <= 1'b0;
                            result_got_1          <= 1'b0;
                            result_got_2          <= 1'b0;
                            multip_start_a0      <= 1'b1;
                            multip_start_a1      <= 1'b1;
                            multip_start_a2      <= 1'b1;
                            multip_start_b0      <= 1'b1;
                            multip_start_b1      <= 1'b1;
                            multip_start_b2      <= 1'b1;
                        
                            multip_0_input_1  <= A2[191:128];
                            multip_0_input_2  <= B0[127:64];
                            
                            multip_1_input_1  <= A2[127:64];
                            multip_1_input_2  <= B1[127:64];
                            
                            multip_2_input_1  <= A2[63:0];
                            multip_2_input_2  <= B2[127:64];
                 end
         else if(multip_wait == multip_wait_time/3)
            begin
                result_got_0          <= 1'b1;
                result_got_1          <= 1'b1;
                result_got_2          <= 1'b1;
                multip_start_a0      <= 1'b0;
                multip_start_a1      <= 1'b0;
                multip_start_a2      <= 1'b0;
                multip_start_b0      <= 1'b0;
                multip_start_b1      <= 1'b0;
                multip_start_b2      <= 1'b0;
                multip_cnt              <= multip_cnt + 1'd1;
            end
       else if(multip_wait == multip_wait_time)
            begin
                multip_state <= multip_C22;
                multip_wait <= 10'd0;
            end
        end
        
        multip_C22:
            begin
                multip_wait            <= multip_wait + 1'b1;
            if(multip_wait <multip_wait_time/3)
                begin
                            result_got_0          <= 1'b0;
                            result_got_1          <= 1'b0;
                            result_got_2          <= 1'b0;
                            multip_start_a0      <= 1'b1;
                            multip_start_a1      <= 1'b1;
                            multip_start_a2      <= 1'b1;
                            multip_start_b0      <= 1'b1;
                            multip_start_b1      <= 1'b1;
                            multip_start_b2      <= 1'b1;
                        
                            multip_0_input_1  <= A2[191:128];
                            multip_0_input_2  <= B0[63:0];
                            
                            multip_1_input_1  <= A2[127:64];
                            multip_1_input_2  <= B1[63:0];
                            
                            multip_2_input_1  <= A2[63:0];
                            multip_2_input_2  <= B2[63:0];
                 end
         else if(multip_wait == multip_wait_time/3)
            begin
                result_got_0          <= 1'b1;
                result_got_1          <= 1'b1;
                result_got_2          <= 1'b1;
                multip_start_a0      <= 1'b0;
                multip_start_a1      <= 1'b0;
                multip_start_a2      <= 1'b0;
                multip_start_b0      <= 1'b0;
                multip_start_b1      <= 1'b0;
                multip_start_b2      <= 1'b0;
                multip_cnt              <= multip_cnt + 1'd1;
            end
       else if(multip_wait == multip_wait_time)
            begin
                multip_state <= idle;
                multip_wait <= 10'd0;
                multip_cnt   <= 4'd0;
            end
        end
        
        default:
            multip_state <= idle;
     endcase
     


always@(posedge Clk or negedge Rst_n)
    if(!Rst_n)
        begin
            sub_start           <= 1'b0;
            sub_result_got  <= 1'b0;
            sub_input1        <= 64'd0;
            sub_input2        <= 64'd0;
            sub_wait     <= 10'd0;
            done                  <= 1'b0;
        end
    else if(result_got_1 == 0)
        begin
            sub_wait             <= 10'd0;      
            sub_start            <= 1'b1;
            sub_result_got   <= 1'b1;
            done                   <= 1'b0;
        end                    
    else if(result_got_1)         
        begin
                    sub_wait <= sub_wait +1'b1;
                    if(sub_wait<sub_wait_time/2)
                        begin
                            sub_input1     <= multip_1_output;
                            sub_input2     <= multip_0_output;
                        end
                    if(sub_wait== sub_wait_time/2)
                        begin
                            sub_input1 <= multip_2_output;
                            sub_input2 <= sub_output;
                        end
                    else if(sub_wait == sub_wait_time)
                        begin
                            sub_wait <= 10'd0;
                            case(multip_cnt)
                                    4'd1:
                                        C0[191:128] <= sub_output;
                                    4'd2:
                                        C0[127:64] <= sub_output;
                                    4'd3:
                                        C0[63:0] <= sub_output;
                                    4'd4:
                                        C1[191:128] <= sub_output;
                                    4'd5:
                                        C1[127:64] <= sub_output;
                                    4'd6:
                                        C1[63:0] <= sub_output;
                                    4'd7:
                                        C2[191:128] <= sub_output;
                                    4'd8:
                                        C2[127:64] <= sub_output;
                                    4'd9:
                                        begin
                                            C2[63:0] <= sub_output;    
                                            done      <= 1'b1;
                                        end    
                                endcase      
                        end
        end 
                        
             
      
        
        
endmodule     
    
      


