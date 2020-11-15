`timescale 1ns / 1ps
`define float_length 64
`define int_length 32

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/19 21:40:27
// Design Name: 
// Module Name: chan_1
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


module chan_1(Clk,time_1,time_2,time_3,S1,S2,S3,Rst_n,chan_en,chan_done);
    
    input Clk;
    input signed [`int_length - 1:0]time_1;
    input signed [`int_length - 1:0]time_2;
    input signed [`int_length - 1:0]time_3;
    input Rst_n;
    input chan_en;
    
    output reg chan_done;
    output reg signed [31:0]S1;
    output reg signed [31:0]S2;
    output reg signed [31:0]S3;
    reg signed [63:0]S_1;
    reg signed [63:0]S_2;
    reg signed [63:0]S_3;
    
//    reg [`float_length - 1:0]float_A00;
//    reg [`float_length - 1:0]float_A01;
//    reg [`float_length - 1:0]float_A02;
//    reg [`float_length - 1:0]float_A10;
//    reg [`float_length - 1:0]float_A11;
//    reg [`float_length - 1:0]float_A12;
//    reg [`float_length - 1:0]float_A20;
//    reg [`float_length - 1:0]float_A21;
//    reg [`float_length - 1:0]float_A22;

//wire of type transform from int32 to double  
    wire [`float_length*12 - 1:0]base_station_XYZ; 
    wire [`float_length*3 - 1:0]type_tran_time;
    wire [`float_length*3 - 1:0]delay_time_group;
    wire type_tran_done;  
    reg type_tran_en;
    
//wire of div
    reg [`float_length - 1:0]div_data2;
    reg [`float_length - 1:0]div_data1;
    reg div_en;
    wire [`float_length - 1:0]div_result;
    wire div_done;
//wire of add
    reg add_en;
    reg [`float_length - 1:0]add_a1;
    reg [`float_length - 1:0]add_a2;
    reg [`float_length - 1:0]add_a3;
    reg [`float_length - 1:0]add_b1;
    reg [`float_length - 1:0]add_b2;
    reg [`float_length - 1:0]add_b3;
    wire add_done;
    wire [`float_length - 1:0]add_result_1;
    wire [`float_length - 1:0]add_result_2;
    wire [`float_length - 1:0]add_result_3;
    
//wire of float to int
    reg float_to_int_en;
    reg [`float_length-1:0]float_data;
    wire [`int_length-1:0]int_data;
    wire float_result_done;    
//time
    reg [`float_length - 1:0]delay_time1;
    reg [`float_length - 1:0]delay_time2;
    reg [`float_length - 1:0]delay_time3;
    reg time_get_done;
//linear matrix
    reg [`float_length*3-1:0]B0;
    reg [`float_length*3-1:0]B1;
    reg [`float_length*3-1:0]B2;
//wire or pinv
    reg pinv_en;
    wire pinv_done;    
    wire [`float_length*3-1:0]pinv_B0;
    wire [`float_length*3-1:0]pinv_B1;
    wire [`float_length*3-1:0]pinv_B2;
    
    reg [4:0]div_state;
    reg [20:0]add_state; 
    reg [19:0]multip_state;
    reg [3:0]tran_state;
    
//wire of multip
    reg multip_en;
    wire multip_done;
    reg [`float_length-1:0]multip_a1;  
    reg [`float_length-1:0]multip_a2; 
    reg [`float_length-1:0]multip_a3; 
    reg [`float_length-1:0]multip_b1; 
    reg [`float_length-1:0]multip_b2; 
    reg [`float_length-1:0]multip_b3;
    wire [`float_length-1:0]multip_result_1;
    wire [`float_length-1:0]multip_result_2;
    wire [`float_length-1:0]multip_result_3;
//wire or square_root

    reg square_root_valid;   
    wire square_root_result_valid;
    wire [`float_length-1:0]square_root_result;  
//deltaR
    reg [`float_length-1:0]deltaR1;
    reg [`float_length-1:0]deltaR2;
    reg [`float_length-1:0]deltaR3;
    reg [`float_length-1:0]deltaR1_square;
    reg [`float_length-1:0]deltaR2_square;
    reg [`float_length-1:0]deltaR3_square;
//Axx2
    reg [`float_length-1:0]A_00_square; 
    reg [`float_length-1:0]A_01_square;  
    reg [`float_length-1:0]A_02_square;  
    reg [`float_length-1:0]A_03_square;  
    reg [`float_length-1:0]A_10_square;  
    reg [`float_length-1:0]A_11_square;
    reg [`float_length-1:0]A_12_square;  
    reg [`float_length-1:0]A_13_square;  
    reg [`float_length-1:0]A_20_square;
    reg [`float_length-1:0]A_21_square;  
    reg [`float_length-1:0]A_22_square;  
    reg [`float_length-1:0]A_23_square;  
//K
    reg [`float_length-1:0]T_K0;
    reg [`float_length-1:0]T_K1;
    reg [`float_length-1:0]T_K2; 
    reg [`float_length-1:0]K0; 
    reg [`float_length-1:0]K1; 
    reg [`float_length-1:0]K2;
    
//n
    reg [`float_length-1:0]F00_K0;
    reg [`float_length-1:0]F01_K1;
    reg [`float_length-1:0]F02_K2;
    reg [`float_length-1:0]F10_K0;
    reg [`float_length-1:0]F11_K1;
    reg [`float_length-1:0]F12_K2;
    reg [`float_length-1:0]F20_K0;
    reg [`float_length-1:0]F21_K1;                
    reg [`float_length-1:0]F22_K2;
    reg [`float_length-1:0]m1;
    reg [`float_length-1:0]m2;
    reg [`float_length-1:0]m3;
    
//m
    reg [`float_length-1:0]F00_deltaR1;
    reg [`float_length-1:0]F01_deltaR2;
    reg [`float_length-1:0]F02_deltaR3;
    reg [`float_length-1:0]F10_deltaR1;
    reg [`float_length-1:0]F11_deltaR2;
    reg [`float_length-1:0]F12_deltaR3;
    reg [`float_length-1:0]F20_deltaR1;
    reg [`float_length-1:0]F21_deltaR2;                
    reg [`float_length-1:0]F22_deltaR3;
    reg [`float_length-1:0]n1;
    reg [`float_length-1:0]n2;
    reg [`float_length-1:0]n3;
    reg [`float_length-1:0]n1_square;
    reg [`float_length-1:0]n2_square;
    reg [`float_length-1:0]n3_square;     
   
//f,g,h
    reg [`float_length-1:0]m1_A00; 
    reg [`float_length-1:0]m2_A10;
    reg [`float_length-1:0]m3_A20; 
    reg [`float_length-1:0]f;  
    reg [`float_length-1:0]g;
    reg [`float_length-1:0]add_g1;
    reg [`float_length-1:0]add_g2; 
    reg [`float_length-1:0]add_g3;    
    reg [`float_length-1:0]h; 
    reg [`float_length-1:0]add_h1;
    reg [`float_length-1:0]add_h2;
    reg [`float_length-1:0]add_h3;         
//R0
    reg [`float_length-1:0]r0;
    reg [`float_length-1:0]r0_1;
    reg [`float_length-1:0]r0_2;
    reg [`float_length-1:0]r0_3;
    reg [`float_length-1:0]r0_4;
    reg [`float_length-1:0]r0_5;
    reg [`float_length-1:0]r0_6;   
    
     reg add_r1_done;
     reg add_r_done;
     reg r0_done;
     
//
//XYZ of the base station
    parameter A_00 = 32'd0,
                       A_01 = 32'd750,
                       A_02 = -32'd750,
                       A_03 = 32'd0,
                       
                       A_10 = 32'd0,
                       A_11 = 32'd1229,
                       A_12 = 32'd1229,
                       A_13 = -32'd1500,
                       
                       A_20 = 32'd1,
                       A_21 = 32'd2,
                       A_22 = 32'd1,
                       A_23 = 32'd0;

    parameter C = 64'h41B1_E1A3_0000_0000;//C=3E8
//div state  //1_0001_1110_0001_1010_0011_0000_0000
    parameter div_idle          = 5'b00001,
                       div_time1      = 5'b00010,
                       div_time2      = 5'b00100,
                       div_time3      = 5'b01000,
                       div_r0            = 5'b10000;     
                       
   parameter   tran_idle          = 4'b0001,
                        tran_s1           = 4'b0010,
                        tran_s2           = 4'b0100,
                        tran_s3           = 4'b1000;                       
//add state
    parameter  add_idle                  = 21'b00000_0000_0000_0000_0001, 
                        add_linear1             = 21'b00000_0000_0000_0000_0010, 
                        add_linear2             = 21'b00000_0000_0000_0000_0100, 
                        add_linear3             = 21'b00000_0000_0000_0000_1000, 
                        add_K1                    = 21'b00000_0000_0000_0001_0000, 
                        add_K2                    = 21'b00000_0000_0000_0010_0000, 
                        add_K3                    = 21'b00000_0000_0000_0100_0000, 
                        add_K4                    = 21'b00000_0000_0000_1000_0000, 
                        add_K5                    = 21'b00000_0000_0001_0000_0000, 
                        add_K6                    = 21'b00000_0000_0010_0000_0000, 
                        add_n1                    = 21'b00000_0000_0100_0000_0000, 
                        add_n2                    = 21'b00000_0000_1000_0000_0000, 
                        add_m1                   = 21'b00000_0001_0000_0000_0000, 
                        add_m2                   = 21'b00000_0010_0000_0000_0000, 
                        add_root1               = 21'b00000_0100_0000_0000_0000, 
                        add_root2               = 21'b00000_1000_0000_0000_0000, 
                        add_root3               = 21'b00001_0000_0000_0000_0000, 
                        add_root4               = 21'b00010_0000_0000_0000_0000, 
                        add_r_1                   = 21'b00100_0000_0000_0000_0000, 
                        add_r_2                   = 21'b01000_0000_0000_0000_0000,
                        add_xyz                   = 21'b10000_0000_0000_0000_0000;
                        
    parameter   multip_idle              = 20'b0000_0000_0000_0000_0001,
                         multip_deltaR         = 20'b0000_0000_0000_0000_0010,
                         multip_Ax0             = 20'b0000_0000_0000_0000_0100,
                         multip_Ax1             = 20'b0000_0000_0000_0000_1000,
                         multip_Ax2             = 20'b0000_0000_0000_0001_0000,
                         multip_Ax3             = 20'b0000_0000_0000_0010_0000,
                         multip_deltaR2      = 20'b0000_0000_0000_0100_0000,
                         multip_K                = 20'b0000_0000_0000_1000_0000,
                         multip_n1              = 20'b0000_0000_0001_0000_0000,
                         multip_n2              = 20'b0000_0000_0010_0000_0000,
                         multip_n3              = 20'b0000_0000_0100_0000_0000,
                         multip_m1             = 20'b0000_0000_1000_0000_0000,
                         multip_m2             = 20'b0000_0001_0000_0000_0000,
                         multip_m3             = 20'b0000_0010_0000_0000_0000,
                         multip_root1          = 20'b0000_0100_0000_0000_0000,
                         multip_root2          = 20'b0000_1000_0000_0000_0000,
                         multip_root3          = 20'b0001_0000_0000_0000_0000,
                         multip_r_1              = 20'b0010_0000_0000_0000_0000,
                         multip_r_2              = 20'b0100_0000_0000_0000_0000,
                         multip_xyz             = 20'b1000_0000_0000_0000_0000;                    
             
    int32_to_float int32_to_float
            (
            .type_tran_inXYZ({A_00,A_01,A_02,A_03,
                                          A_10,A_11,A_12,A_13
                                          ,A_20,A_21,A_22,A_23}),
            .type_tran_outXYZ(base_station_XYZ),
            .type_tran_intime({time_1,time_2,time_3}),
            .type_tran_outtime(delay_time_group),
            .Clk(Clk),
            .Rst_n(Rst_n),
            .type_tran_en(type_tran_en),
            .type_tran_done(type_tran_done)
            );
            
    div div(
        .Clk(Clk),
        .Rst_n(Rst_n),
        .div_data2(div_data2),
        .div_data1(div_data1),
        .div_result(div_result),
        .div_en(div_en),
        .div_done(div_done)
        );
        
    add_3_3 adder
            (
            .Clk(Clk),
            .Rst_n(Rst_n),
            .add_en(add_en),
            .add_done(add_done),
            .add_a1(add_a1),
            .add_a2(add_a2),
            .add_a3(add_a3),
            .add_b1(add_b1),
            .add_b2(add_b2),
            .add_b3(add_b3),
            .result_1(add_result_1),
            .result_2(add_result_2),
            .result_3(add_result_3)
            );
            
    pinv  pinv_B(
            .Clk(Clk),
            .Rst_n(Rst_n),
            .input_martix_A0(B0),
            .input_martix_A1(B1),
            .input_martix_A2(B2),
            .output_martix_B0(pinv_B0),
            .output_martix_B1(pinv_B1),
            .output_martix_B2(pinv_B2),
            .pinv_done(pinv_done),
            .pinv_en(pinv_en)
            ); 
            
    multip_3_3 multip(
                                .multip_en(multip_en),
                                .multip_done(multip_done),
                                .multip_a1(multip_a1),
                                .multip_a2(multip_a2),
                                .multip_a3(multip_a3),
                                .multip_b1(multip_b1),
                                .multip_b2(multip_b2),
                                .multip_b3(multip_b3),
                                .result_1(multip_result_1),
                                .result_2(multip_result_2),
                                .result_3(multip_result_3),
                                .Clk(Clk),
                                .Rst_n(Rst_n)
                                );  
                                
     floating_point_4 square_root(
    .aclk(Clk), 
    .s_axis_a_tvalid(square_root_valid), 
    .s_axis_a_tready(), 
    .s_axis_a_tdata(r0_5), 
    .m_axis_result_tvalid(square_root_result_valid),
    .m_axis_result_tready(1'b1), 
    .m_axis_result_tdata(square_root_result)
     );          
     
     floating_point_5 float_to_int
    (
    .aclk(Clk), 
    .s_axis_a_tvalid(float_to_int_en), 
    .s_axis_a_tready(), 
    .s_axis_a_tdata(float_data), 
    .m_axis_result_tvalid(float_result_done), 
    .m_axis_result_tready(1'b1), 
    .m_axis_result_tdata(int_data)
    );
    
  
    reg [2:0]float_cnt;
    always@(posedge Clk or negedge Rst_n)
    if(!Rst_n)
        begin
            float_to_int_en <= 1'b0;
            tran_state         <= tran_idle;
            float_cnt <= 3'd0;  
        end    
    else
        case(tran_state)
            tran_idle:
                begin
                    float_to_int_en     <= 1'b0;
                    float_cnt    <= 3'd0;  
                    if(chan_done)
                        tran_state          <= tran_s1;
                end
                
            tran_s1:
                begin
                    float_data                        <= S_1;
                    if(float_cnt<3'd4)
                        float_cnt                      <=  float_cnt +1'b1;
                    if(float_cnt==3'd1)
                        float_to_int_en             <= 1'b1;    
                    else if(float_cnt==3'd2)
                        float_to_int_en              <= 1'b0;
                    else if(float_result_done)    
                        begin
                            S1                              <= int_data;
                            tran_state                  <= tran_s2;
                            float_cnt                     <= 3'd0;
                        end
                end
                
                tran_s2:
                begin
                    float_data                        <= S_2;
                    if(float_cnt<3'd4)
                        float_cnt                      <=  float_cnt +1'b1;
                    if(float_cnt==3'd1)
                        float_to_int_en             <= 1'b1;    
                    else if(float_cnt==3'd2)
                        float_to_int_en              <= 1'b0;
                    else if(float_result_done)    
                        begin
                            S2                              <= int_data;
                            tran_state                  <= tran_s3;
                            float_cnt                     <= 3'd0;
                        end
                end
                
                tran_s3:
                begin
                    float_data                        <= S_3;
                    if(float_cnt<3'd4)
                        float_cnt                      <=  float_cnt +1'b1;
                    if(float_cnt==3'd1)
                        float_to_int_en             <= 1'b1;    
                    else if(float_cnt==3'd2)
                        float_to_int_en              <= 1'b0;
                    else if(float_result_done)    
                        begin
                            S3                              <= int_data;
                            tran_state                  <= tran_idle;
                            float_cnt                     <= 3'd0;
                        end
                end
                
            default:
                tran_state              <= tran_idle;
        endcase    
                                  
    //transform data from int32 to float
    always@(posedge Clk or negedge Rst_n)
    if(!Rst_n)
        type_tran_en            <= 1'b0;
    else if(chan_en)
        type_tran_en            <= 1'b1;
    else 
        type_tran_en            <= 1'b0;
     
     //square_root
     always@(posedge Clk or negedge Rst_n)
     if(!Rst_n)
        begin
            square_root_valid           <= 1'b0;
        end
     else if(add_r1_done)
        square_root_valid               <= 1'b1;
     else   
        square_root_valid               <= 1'b0;
     
     //transform the data which has been enlarged  or count the r0
     always@(posedge Clk or negedge Rst_n)
     if(!Rst_n)
        begin
            div_en                  <= 1'b0;
            div_data1             <= `float_length'd0;
            div_data2             <= `float_length'd0;
            div_state               <= div_idle;
            time_get_done     <= 1'b0;
            r0_done                <= 1'b0;
        end
    else
        case(div_state)
            div_idle:
                begin
                    div_en                  <= 1'b0;
                    div_data1             <= `float_length'd0;
                    div_data2             <= `float_length'd0;
                    time_get_done     <= 1'b0;
                    r0_done                <= 1'b0;
                    if(type_tran_done)
                        div_state           <= div_time1;
                end
            div_time1://1_1101_1100_1101_0110_0101_0000_0000 10e9
                begin
                    div_data1               <= delay_time_group[191:128];
                    div_data2               <= 64'h41CD_CD65_0000_0000;//10E10
                    div_en                    <= 1'b1;
                    if(div_done)
                        begin
                            div_en             <= 1'b0;
                            div_state         <= div_time2;
                            delay_time1    <= div_result;
                        end
                end
            div_time2:
                begin
                    div_data1               <= delay_time_group[127:64];
                    div_data2               <= 64'h41CD_CD65_0000_0000;//10e10
                    div_en                    <= 1'b1;
                    if(div_done)
                        begin
                            div_en             <= 1'b0;
                            div_state         <= div_time3;
                            delay_time2    <= div_result;
                        end
                end
                
            div_time3:
                begin
                    div_data1               <= delay_time_group[63:0];
                    div_data2               <= 64'h41CD_CD65_0000_0000;//10e10
                    div_en                    <= 1'b1;
                    if(div_done)
                        begin
                            div_en             <= 1'b0;
                            div_state         <= div_r0;
                            delay_time3    <= div_result;
                            time_get_done<= 1'b1;
                        end
                end
            div_r0:
                begin
                    if(add_r_done)
                        begin
                            div_data1            <= r0_6;
                            div_data2            <= r0_4;
                            div_en                 <= 1'b1;
                        end
                    if(div_done)
                        begin
                            r0                      <= div_result;
                            div_en              <= 1'b0;
                            div_state           <= div_idle;
                            r0_done             <= 1'b1;
                        end    
                
                end     
            default:
                div_state                       <= div_idle;        
                
        endcase
     
     reg linear_done;
     reg delta_done; 
     reg add_K_done;
     reg n_done;
     reg m_done;
     reg n_square_done;
     reg add_root_done;
     reg multip_root_done;
     reg add_m_done;
     reg add_gfh_done;
     reg multip_r_done;
     reg multip_xyz_done; 
    
    // Linearized matrix equation coefficients   
    always@(posedge Clk or negedge Rst_n)             
    if(!Rst_n)
        begin
            add_en                  <= 1'b0;
            add_state              <= add_idle;
            linear_done           <= 1'b0;
            add_K_done          <= 1'b0;
            add_root_done      <= 1'b0;
            add_m_done          <= 1'b0;
            add_gfh_done        <= 1'b0;
            add_r1_done          <= 1'b0;
            add_r_done           <= 1'b0;
            chan_done             <= 1'b0;
        end
    else 
        case(add_state)
            add_idle:
                begin
                    add_en                  <= 1'b0;
                    linear_done           <= 1'b0;
                    add_K_done          <= 1'b0;
                    add_root_done      <= 1'b0;
                    add_gfh_done        <= 1'b0;
                    add_m_done          <= 1'b0;
                    add_r1_done          <= 1'b0;
                    add_r_done           <= 1'b0;
                    chan_done             <= 1'b0;
                    if(type_tran_done)
                        begin
                            add_state      <= add_linear1;
                        end
                end 
                
            add_linear1:
                begin
                    add_a1                  <= base_station_XYZ[767:704];
                    add_b1                  <= base_station_XYZ[703:640] + 64'h8000_0000_0000_0000;
                    add_a2                  <= base_station_XYZ[511:448];
                    add_b2                  <= base_station_XYZ[447:384] + 64'h8000_0000_0000_0000;
                    add_a3                  <= base_station_XYZ[255:192];
                    add_b3                  <= base_station_XYZ[191:128] + 64'h8000_0000_0000_0000;
                    add_en                  <= 1'b1;
                    if(add_done)
                        begin
                            add_en          <= 1'b0;
                            B0[191:128]  <= add_result_1; 
                            B0[127:64]    <= add_result_2; 
                            B0[63:0]        <= add_result_3; 
                            add_state      <= add_linear2;
                        end
                end
                
            add_linear2:
                begin
                    add_a1                  <= base_station_XYZ[767:704];                             
                    add_b1                  <= base_station_XYZ[639:576] + 64'h8000_0000_0000_0000; 
                    add_a2                  <= base_station_XYZ[511:448];                          
                    add_b2                  <= base_station_XYZ[383:320] + 64'h8000_0000_0000_0000;
                    add_a3                  <= base_station_XYZ[255:192];                          
                    add_b3                  <= base_station_XYZ[127:64] + 64'h8000_0000_0000_0000;
                    add_en                  <= 1'b1;
                    if(add_done)
                        begin
                            add_en          <= 1'b0;
                            B1[191:128]  <= add_result_1; 
                            B1[127:64]    <= add_result_2; 
                            B1[63:0]        <= add_result_3; 
                            add_state      <= add_linear3;
                        end
                end
                
            add_linear3:
                begin
                    add_a1                  <= base_station_XYZ[767:704];                             
                    add_b1                  <= base_station_XYZ[575:512] + 64'h8000_0000_0000_0000; 
                    add_a2                  <= base_station_XYZ[511:448];                          
                    add_b2                  <= base_station_XYZ[319:256] + 64'h8000_0000_0000_0000;
                    add_a3                  <= base_station_XYZ[255:192];                          
                    add_b3                  <= base_station_XYZ[63:0] + 64'h8000_0000_0000_0000;
                    add_en                  <= 1'b1;
                    if(add_done)
                        begin
                            add_en          <= 1'b0;
                            B2[191:128]  <= add_result_1; 
                            B2[127:64]    <= add_result_2; 
                            B2[63:0]        <= add_result_3; 
                            add_state      <= add_K1; 
                            linear_done   <= 1'b1;
                        end
                end
                
            add_K1:
                begin
                    if(delta_done)
                        begin
                            linear_done           <= 1'b0;
                            add_a1                  <= deltaR1_square;
                            add_a2                  <= deltaR2_square;
                            add_a3                  <= deltaR3_square;
                            add_b1                  <= A_00_square;
                            add_b2                  <= A_00_square;
                            add_b3                  <= A_00_square;
                            add_en                  <= 1'b1;
                        end    
                if(add_done)
                    begin
                        add_a1              <= add_result_1;
                        add_a2              <= add_result_2;
                        add_a3              <= add_result_3;
                        add_b1              <= A_10_square;
                        add_b2              <= A_10_square;
                        add_b3              <= A_10_square;
                        add_en              <= 1'b0;
                        add_state          <= add_K2;
                    end
                end
                 
                add_K2:                     
                    begin
                    add_en                  <= 1'b1;
                if(add_done)
                    begin
                        add_a1              <= add_result_1;
                        add_a2              <= add_result_2;
                        add_a3              <= add_result_3;
                        add_b1              <= A_20_square;
                        add_b2              <= A_20_square;
                        add_b3              <= A_20_square;
                        add_en              <= 1'b0;
                        add_state          <= add_K3;
                    end
                end
                  
                add_K3:                     
                    begin
                    add_en                  <= 1'b1;
                if(add_done)
                    begin
                        add_a1              <= add_result_1;
                        add_a2              <= add_result_2;
                        add_a3              <= add_result_3;
                        add_b1              <= A_01_square + 64'h8000_0000_0000_0000;
                        add_b2              <= A_02_square + 64'h8000_0000_0000_0000;
                        add_b3              <= A_03_square + 64'h8000_0000_0000_0000;
                        add_en              <= 1'b0;
                        add_state          <= add_K4;
                    end 
                end
                
               add_K4:                     
                    begin
                    add_en                  <= 1'b1;
                if(add_done)
                    begin
                        add_a1              <= add_result_1;
                        add_a2              <= add_result_2;
                        add_a3              <= add_result_3;
                        add_b1              <= A_11_square + 64'h8000_0000_0000_0000;
                        add_b2              <= A_12_square + 64'h8000_0000_0000_0000;
                        add_b3              <= A_13_square + 64'h8000_0000_0000_0000;
                        add_en              <= 1'b0;
                        add_state          <= add_K5;
                    end 
                end
                
            add_K5:                     
                    begin
                    add_en                  <= 1'b1;
                if(add_done)
                    begin
                        add_a1              <= add_result_1;
                        add_a2              <= add_result_2;
                        add_a3              <= add_result_3;
                        add_b1              <= A_21_square + 64'h8000_0000_0000_0000;
                        add_b2              <= A_22_square + 64'h8000_0000_0000_0000;
                        add_b3              <= A_23_square + 64'h8000_0000_0000_0000;
                        add_en              <= 1'b0;
                        add_state          <= add_K6;
                    end 
                end
                
            add_K6:                     
                begin
                    add_en                  <= 1'b1;
                if(add_done)
                    begin
                        add_en              <= 1'b0;
                        T_K0                  <= add_result_1;
                        T_K1                  <= add_result_2;  
                        T_K2                  <= add_result_3;
                        add_state           <= add_n1;
                        add_K_done       <= 1'b1;                
                    end 
                end
                
            add_n1:
                begin
                    if(n_done)
                        begin
                            add_a1          <= F00_deltaR1;
                            add_b1          <= F01_deltaR2;
                            add_a2          <= F10_deltaR1;
                            add_b2          <= F11_deltaR2;
                            add_a3          <= F20_deltaR1;
                            add_b3          <= F21_deltaR2;
                            add_en          <= 1'b1;
                        end    
                    if(add_done)
                        begin
                            add_state            <= add_n2;
                            add_a1                <= add_result_1;
                            add_a2                <= add_result_2;
                            add_a3                <= add_result_3;
                            add_b1                <= F02_deltaR3;
                            add_b2                <= F12_deltaR3;
                            add_b3                <= F22_deltaR3;
                            add_en                <= 1'b0;
                        end
                end 
                
            add_n2:
                begin
                    add_en                  <= 1'b1;
                    if(add_done)
                        begin
                            n1                  <= add_result_1;
                            n2                  <= add_result_2;
                            n3                  <= add_result_3;
                            add_state       <=  add_m1;
                            add_en           <= 1'b0;
                        end
                end
                
            add_m1:
                begin
                    if(m_done)
                        begin
                            add_a1          <= F00_K0;
                            add_b1          <= F01_K1;
                            add_a2          <= F10_K0;
                            add_b2          <= F11_K1;
                            add_a3          <= F20_K0;
                            add_b3          <= F21_K1;
                            add_en          <= 1'b1;
                        end    
                    if(add_done)
                        begin
                            add_state            <= add_m2;
                            add_a1                <= add_result_1;
                            add_a2                <= add_result_2;
                            add_a3                <= add_result_3;
                            add_b1                <= F02_K2;
                            add_b2                <= F12_K2;
                            add_b3                <= F22_K2;
                            add_en                <= 1'b0;
                        end
                end 
                
            add_m2:
                begin
                    add_en                  <= 1'b1;
                    if(add_done)
                        begin
                            m1                  <= add_result_1;
                            m2                  <= add_result_2;
                            m3                  <= add_result_3;
                            add_state       <=  add_root1;
                            add_en           <= 1'b0;
                            add_m_done  <= 1'b1;
                        end
                end 
            
            add_root1:
                begin
                    if(n_square_done)
                        begin
                            add_a1          <= m3;                                                 
                            add_b1          <= base_station_XYZ[255:192] + 64'h8000_0000_0000_0000;
                            add_a2          <= m1;
                            add_b2          <= base_station_XYZ[767:704] + 64'h8000_0000_0000_0000;  
                            add_a3          <= m2;
                            add_b3          <= base_station_XYZ[511:448] + 64'h8000_0000_0000_0000;  
                            add_en          <= 1'b1;
                        end
                    if(add_done)
                        begin
                            add_en          <= 1'b0;
                            m3_A20         <= add_result_1;
                            m1_A00         <= add_result_2;
                            m2_A10         <= add_result_3;
                            add_state       <= add_root2;
                            add_root_done <= 1'b1;
                        end    
                end
                
            add_root2:
                begin
                    if(multip_root_done)
                        begin
                            add_a1                  <= n1_square;
                            add_b1                  <= n2_square;
                            add_a2                  <= add_g1;
                            add_b2                  <= add_g2;
                            add_a3                  <= add_h1;
                            add_b3                  <= add_h2;
                            add_en                  <= 1'b1;
                        end
                    if(add_done)
                        begin
                            add_en                  <= 1'b0;
                            add_a1                  <= add_result_1;
                            add_a2                  <= add_result_2;
                            add_a3                  <= add_result_3;
                            add_b1                  <= n3_square;
                            add_b2                  <= add_g3;
                            add_b3                  <= add_h3;
                            add_state              <= add_root3;
                        end
                end                         
                
            add_root3:
                begin
                    add_en                  <= 1'b1;
                    if(add_done)
                        begin
                            add_en          <= 1'b0;
                            g                   <= add_result_2;
                            h                   <= add_result_3;
                            add_a1          <= add_result_1;
                            add_b1          <= 64'hbff0_0000_0000_0000;
                            add_state      <= add_root4;
                        end
                end
           
           add_root4:
                begin
                    add_en                  <= 1'b1;
                    if(add_done)
                        begin
                            add_en          <= 1'b0;
                            f                     <= add_result_1;
                            add_state       <= add_r_1;
                            add_gfh_done<=1'b1;
                        end
                end
                
            add_r_1:
		      begin
		      	if(multip_r_done)
		      		begin
		      			add_a1					<= r0_2;
		      			add_b1					<= r0_3 + 64'h8000_0000_0000_0000;
		      			add_en					<= 1'b1;
		      		end
		      	if(add_done)
		      		begin
		      			r0_5				    <= add_result_1;
		      			add_en				<= 1'b0;
		      			add_state			<= add_r_2;
		      			add_r1_done   <= 1'b1;
		      		end
		      end
		    
		    add_r_2:
		      begin
		          if(square_root_result_valid)
		              begin
		                  add_a1                  <= r0_1;
		                  add_b1                  <= square_root_result;
		                  add_en                  <= 1'b1;
		              end
		          if(add_done)
		              begin
		                  add_en                  <= 1'b0;
		                  r0_6                       <= add_result_1;
		                  add_state              <= add_xyz;
		                  add_r_done           <= 1'b1;
		              end    
		      end 
		    
		    add_xyz:
		      begin
		          if(multip_xyz_done)
		              begin
		                  add_a1                  <= multip_result_1;
		                  add_a2                  <= multip_result_2;
		                  add_a3                  <= multip_result_3;
		                  add_b1                  <= m1;
		                  add_b2                  <= m2;
		                  add_b3                  <= m3;
		                  add_en                  <= 1'b1;
		              end
		          if(add_done)
		              begin
		                  S_1                           <= add_result_1;
		                  S_2                           <= add_result_2;
		                  S_3                           <= add_result_3;
		                  add_en                     <= 1'b0;
		                  add_state                 <= add_idle;
		                  chan_done               <= 1'b1;
		              end
		      end                
            default:
                add_state                   <= add_idle;
        endcase
//caculate the pinv of B(the Linearized matrix equation coefficients) 
    always@(posedge Clk or negedge Rst_n)
    if(!Rst_n)
        pinv_en                 <= 1'b0;
    else if(linear_done)
        pinv_en                 <= 1'b1;
    else
        pinv_en                 <= 1'b0;
        
        
           
//multip
    always@(posedge Clk or negedge Rst_n)   
    if(!Rst_n)
        begin
            multip_en                  <= 1'b0;
            multip_state              <= multip_idle;
            delta_done                <= 1'b0;
            n_done                      <= 1'b0;
            n_square_done          <= 1'b0;
            multip_root_done      <= 1'b0;
            multip_r_done            <= 1'b0;
            multip_xyz_done        <= 1'b0;
            m_done                      <= 1'b0;
        end
    else
        case(multip_state)
            multip_idle:
                begin
                    multip_en                 <= 1'b0;
                    delta_done               <= 1'b0;
                    n_done                     <= 1'b0;
                    n_square_done         <= 1'b0;
                    multip_root_done     <= 1'b0;
                    multip_r_done           <= 1'b0;
                    multip_xyz_done        <= 1'b0;
                    m_done                      <= 1'b0;
                    if(time_get_done)
                        multip_state            <= multip_deltaR;
                end
                
            multip_deltaR:
                begin
                    multip_a1                   <= C;
                    multip_a2                   <= C;
                    multip_a3                   <= C;
                    multip_b1                   <= delay_time1;
                    multip_b2                   <= delay_time2;
                    multip_b3                   <= delay_time3;
                    multip_en                   <= 1'b1;
                    if(multip_done)
                        begin
                            multip_en               <= 1'b0;
                            deltaR1                   <= multip_result_1;
                            deltaR2                   <= multip_result_2;
                            deltaR3                   <= multip_result_3;
                            multip_state            <= multip_Ax0;
                        end    
                end         
                       
            multip_Ax0:
                begin
                    multip_a1                   <= base_station_XYZ[767:704];
                    multip_a2                   <= base_station_XYZ[511:448];
                    multip_a3                   <= base_station_XYZ[255:192];
                    multip_b1                   <= base_station_XYZ[767:704];
                    multip_b2                   <= base_station_XYZ[511:448];
                    multip_b3                   <= base_station_XYZ[255:192];
                    multip_en                   <= 1'b1;
                    if(multip_done)
                        begin
                            multip_en           <= 1'b0;
                            A_00_square       <= multip_result_1;
                            A_10_square       <= multip_result_2;
                            A_20_square       <= multip_result_3;
                            multip_state        <= multip_Ax1;
                        end
                end
                
            multip_Ax1:
                begin
                    multip_a1                   <= base_station_XYZ[703:640];
                    multip_a2                   <= base_station_XYZ[447:384];
                    multip_a3                   <= base_station_XYZ[191:128];
                    multip_b1                   <= base_station_XYZ[703:640];
                    multip_b2                   <= base_station_XYZ[447:384];
                    multip_b3                   <= base_station_XYZ[191:128];
                    multip_en                   <= 1'b1;
                    if(multip_done)
                        begin
                            multip_en           <= 1'b0;
                            A_01_square       <= multip_result_1;
                            A_11_square       <= multip_result_2;
                            A_21_square       <= multip_result_3;
                            multip_state        <= multip_Ax2;
                        end
                end
                
            multip_Ax2:
                begin
                    multip_a1                   <= base_station_XYZ[639:576];
                    multip_a2                   <= base_station_XYZ[383:320];
                    multip_a3                   <= base_station_XYZ[127:64];
                    multip_b1                   <= base_station_XYZ[639:576];
                    multip_b2                   <= base_station_XYZ[383:320];
                    multip_b3                   <= base_station_XYZ[127:64];
                    multip_en                   <= 1'b1;
                    if(multip_done)
                        begin
                            multip_en           <= 1'b0;
                            A_02_square       <= multip_result_1;
                            A_12_square       <= multip_result_2;
                            A_22_square       <= multip_result_3;
                            multip_state        <= multip_Ax3;
                        end
                end
                
            multip_Ax3:
                begin
                    multip_a1                   <= base_station_XYZ[575:512];
                    multip_a2                   <= base_station_XYZ[319:256];
                    multip_a3                   <= base_station_XYZ[63:0];
                    multip_b1                   <= base_station_XYZ[575:512];
                    multip_b2                   <= base_station_XYZ[319:256];
                    multip_b3                   <= base_station_XYZ[63:0];
                    multip_en                   <= 1'b1;
                    if(multip_done)
                        begin
                            multip_en           <= 1'b0;
                            A_03_square       <= multip_result_1;
                            A_13_square       <= multip_result_2;
                            A_23_square       <= multip_result_3;
                            multip_state        <= multip_deltaR2;
                        end
                end 
            
            multip_deltaR2:
                begin
                    multip_a1                   <= deltaR1;
                    multip_a2                   <= deltaR2;
                    multip_a3                   <= deltaR3;
                    multip_b1                   <= deltaR1;
                    multip_b2                   <= deltaR2;
                    multip_b3                   <= deltaR3;
                    multip_en                   <= 1'b1;
                    if(multip_done)
                        begin
                            multip_en           <= 1'b0;
                            deltaR1_square  <= multip_result_1;
                            deltaR2_square  <= multip_result_2;
                            deltaR3_square  <= multip_result_3;
                            multip_state       <= multip_K;
                            delta_done         <= 1'b1;
                        end
                end
                
            multip_K:
                begin
                    if(add_K_done)
                        begin
                            multip_a1           <= T_K0;
                            multip_a2           <= T_K1;
                            multip_a3           <= T_K2;
                            multip_b1           <= 64'h3fe0_0000_0000_0000;//0.5
                            multip_b2           <= 64'h3fe0_0000_0000_0000;
                            multip_b3           <= 64'h3fe0_0000_0000_0000;
                            multip_en           <= 1'b1;
                        end
                    if(multip_done)
                        begin
                            multip_en           <= 1'b0;    
                            multip_state       <= multip_n1;
                            K0                       <= multip_result_1;
                            K1                       <= multip_result_2;
                            K2                       <= multip_result_3;
                        end
                end     
                
            multip_n1:
                begin
                    if(pinv_done)
                        begin
                            multip_a1                   <= pinv_B0[191:128];
                            multip_b1                   <= deltaR1;
                            multip_a2                   <= pinv_B0[127:64];
                            multip_b2                   <= deltaR2;
                            multip_a3                   <= pinv_B0[63:0];
                            multip_b3                   <= deltaR3;
                            multip_en                   <= 1'b1;
                        end    
                    if(multip_done)
                        begin
                            multip_en           <= 1'b0;
                            F00_deltaR1       <= multip_result_1;
                            F01_deltaR2       <= multip_result_2;
                            F02_deltaR3       <= multip_result_3;
                            multip_state       <= multip_n2;
                        end
                end
                
            multip_n2:
                begin
                    multip_a1                   <= pinv_B1[191:128];
                    multip_b1                   <= deltaR1;
                    multip_a2                   <= pinv_B1[127:64];
                    multip_b2                   <= deltaR2;
                    multip_a3                   <= pinv_B1[63:0];
                    multip_b3                   <= deltaR3;
                    multip_en                   <= 1'b1;
                    if(multip_done)
                        begin
                            multip_en           <= 1'b0;
                            F10_deltaR1       <= multip_result_1;
                            F11_deltaR2       <= multip_result_2;
                            F12_deltaR3       <= multip_result_3;
                            multip_state       <= multip_n3;
                        end
                end
                
            multip_n3:
                begin
                    multip_a1                   <= pinv_B2[191:128];
                    multip_b1                   <= deltaR1;
                    multip_a2                   <= pinv_B2[127:64];
                    multip_b2                   <= deltaR2;
                    multip_a3                   <= pinv_B2[63:0];
                    multip_b3                   <= deltaR3;
                    multip_en                   <= 1'b1;
                    if(multip_done)
                        begin
                            multip_en           <= 1'b0;
                            F20_deltaR1       <= multip_result_1;
                            F21_deltaR2       <= multip_result_2;
                            F22_deltaR3       <= multip_result_3;
                            multip_state       <= multip_m1;
                            n_done              <= 1'b1;
                        end
                end
                
            multip_m1:
                begin
                    if(n_done)
                        begin
                            multip_a1                   <= pinv_B0[191:128];
                            multip_b1                   <= K0;
                            multip_a2                   <= pinv_B0[127:64];
                            multip_b2                   <= K1;
                            multip_a3                   <= pinv_B0[63:0];
                            multip_b3                   <= K2;
                            multip_en                   <= 1'b1;
                        end    
                    if(multip_done)
                        begin
                            multip_en           <= 1'b0;
                            F00_K0               <= multip_result_1;
                            F01_K1               <= multip_result_2;
                            F02_K2               <= multip_result_3;
                            multip_state       <= multip_m2;
                        end
                end
                
            multip_m2:
                begin
                    multip_a1                   <= pinv_B1[191:128];
                    multip_b1                   <= K0;
                    multip_a2                   <= pinv_B1[127:64];
                    multip_b2                   <= K1;
                    multip_a3                   <= pinv_B1[63:0];
                    multip_b3                   <= K2;
                    multip_en                   <= 1'b1;
                    if(multip_done)
                        begin
                            multip_en           <= 1'b0;
                            F10_K0               <= multip_result_1;
                            F11_K1               <= multip_result_2;
                            F12_K2               <= multip_result_3;
                            multip_state       <= multip_m3;
                        end
                end
                
            multip_m3:
                begin
                    multip_a1                   <= pinv_B2[191:128];
                    multip_b1                   <= K0;
                    multip_a2                   <= pinv_B2[127:64];
                    multip_b2                   <= K1;
                    multip_a3                   <= pinv_B2[63:0];
                    multip_b3                   <= K2;
                    multip_en                   <= 1'b1;
                    if(multip_done)
                        begin
                            multip_en           <= 1'b0;
                            F20_K0               <= multip_result_1;
                            F21_K1               <= multip_result_2;
                            F22_K2               <= multip_result_3;
                            multip_state       <= multip_root1;
                            m_done              <= 1'b1;
                        end
                end                
                
            multip_root1:
                begin
                    if(add_m_done)
                    begin
                        m_done                      <= 1'b0;
                        multip_a1                   <= n1;
                        multip_a2                   <= n2;
                        multip_a3                   <= n3;
                        multip_b1                   <= n1;
                        multip_b2                   <= n2;
                        multip_b3                   <= n3;
                        multip_en                   <= 1'b1;
                    end     
                    if(multip_done)
                        begin
                            multip_en           <= 1'b0;
                            n1_square           <= multip_result_1;
                            n2_square           <= multip_result_2;
                            n3_square           <= multip_result_3;
                            multip_state        <= multip_root2; 
                            n_square_done   <= 1'b1;
                        end
                end
                
            multip_root2:
                begin
                    if(add_root_done)
                        begin
                            multip_a1                   <= m1_A00;
                            multip_a2                   <= m2_A10;
                            multip_a3                   <= m3_A20;
                            multip_b1                   <= n1;
                            multip_b2                   <= n2;
                            multip_b3                   <= n3;
                            multip_en                   <= 1'b1;
                        end
                    if(multip_done)
                        begin
                            multip_en                   <= 1'b0;
                            add_g1                       <= multip_result_1;
                            add_g2                       <= multip_result_2;
                            add_g3                       <= multip_result_3;
                            multip_state               <= multip_root3;
                        end
                end
                
            multip_root3:
                begin
                    multip_a1                   <= m1_A00;
                    multip_a2                   <= m2_A10;
                    multip_a3                   <= m3_A20;
                    multip_b1                   <= m1_A00;
                    multip_b2                   <= m2_A10;
                    multip_b3                   <= m3_A20;
                    multip_en                   <= 1'b1;
                    if(multip_done)
                        begin
                            multip_en           <= 1'b0;
                            add_h1               <= multip_result_1;
                            add_h2               <= multip_result_2;
                            add_h3               <= multip_result_3;
                            multip_state       <= multip_r_1;
                            multip_root_done    <= 1'b1;
                        end
                end
            
           multip_r_1:
	           begin
		          if(add_gfh_done)
			         begin
				        multip_a1					<= 64'hC000_0000_0000_0000;
				        multip_b1				<= g;
				        multip_a2					<= 64'h4010_0000_0000_0000;
				        multip_b2				<= g;
				        multip_a3					<= 64'h4010_0000_0000_0000;
				        multip_b3				<= f ;
				        multip_en				<= 1'b1;
			     end
		      if(multip_done)	
		      	begin
		      		multip_en			    <= 1'b0;
		      		r0_1						    <= multip_result_1;
		      		multip_a1					<= multip_result_2;
		      		multip_b1				<= g;
		      		multip_a2					<= multip_result_3;
		      		multip_b2				<= h;
		      		multip_a3					<= 64'h4000_0000_0000_0000;
		      		multip_b3				<= f;
		      		multip_state			<= multip_r_2;
		      	end
	   end
	
        multip_r_2:
		begin
			multip_en					<= 1'b1;
			if(multip_done)
				begin
					r0_2				<= multip_result_1;
					r0_3				<= multip_result_2;
					r0_4				<= multip_result_3;
					multip_en			<= 1'b0;
					multip_state		<= multip_xyz;
					multip_r_done		<= 1'b1;
				end
		end
		
		multip_xyz:
		  begin
		      if(r0_done)
		          begin
		              multip_a1                   <= r0;
		              multip_a2                   <= r0;
		              multip_a3                   <= r0;
		              multip_b1                   <= n1;
		              multip_b2                   <= n2;
		              multip_b3                   <= n3;
		              multip_en                   <= 1'b1;
		          end
		      if(multip_done)
		          begin
		              multip_en                   <= 1'b0;
		              multip_state               <= multip_idle;
		              multip_xyz_done        <= 1'b1;
		          end
		  end      
                            
            default:
                multip_state                    <= multip_idle;               
        endcase
        
//Ì½ÕëÁ¬½Ó
// always@(posedge clk)
// begin
//    probe0<=gpio_psout_tri_o[9:0];
//    probe1<=gpio_psout_tri_o[19:10];
//    probe2<=gpio_psout_tri_o[29:20];
//    probe3<=gpio_plout1_tri_i;
//    probe4<=gpio_plout2_tri_i;
//    probe5<=gpio_plout2_tri_i;
// end
endmodule
