`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/24 20:50:00
// Design Name: 
// Module Name: inv
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


module inv(A0,A1,A2,inv_A0,inv_A1,inv_A2,Clk,Rst_n,inv_en,inv_done);

  input Clk;
  input Rst_n;
  input [191:0]A0;  
  input [191:0]A1; 
  input [191:0]A2; 
  input inv_en;
  
  output reg [191:0]inv_A0;
  output reg [191:0]inv_A1;
  output reg [191:0]inv_A2;
  output reg inv_done;
   
//transform martrix
reg tran_en;
wire tran_done;
wire [191:0]tran_A_0;
wire [191:0]tran_A_1;
wire [191:0]tran_A_2;
    
// multip_0_wire    
  reg multip_a1_valid;
  reg multip_b1_valid;
  wire multip_result1_valid;
  
  wire multip_a1_ready;
  wire multip_b1_ready;
  reg multip_result1_ready;
  
  reg [63:0]multip_a1_data;  
  reg [63:0]multip_b1_data;
  wire [63:0]multip_result1_data;
  
// multip_2_wire    
  reg multip_a2_valid;
  reg multip_b2_valid;
  wire multip_result2_valid;
  
  wire multip_a2_ready;
  wire multip_b2_ready;
  reg multip_result2_ready;
  
  reg [63:0]multip_a2_data;  
  reg [63:0]multip_b2_data;
  wire [63:0]multip_result2_data;

//add_0_wire
    reg add_a1_valid;
    reg add_b1_valid;
    wire add_result1_valid;
    
    wire add_a1_ready;
    wire add_b1_ready;
    reg add_result1_ready;
    
    reg [63:0]add_a1_data;
    reg [63:0]add_b1_data;
    wire [63:0]add_result1_data;
    
//add_0_wire
    reg add_a2_valid;
    reg add_b2_valid;
    wire add_result2_valid;
    
    wire add_a2_ready;
    wire add_b2_ready;
    reg add_result2_ready;
    
    reg [63:0]add_a2_data;
    reg [63:0]add_b2_data;
    wire [63:0]add_result2_data;  
    
//div_wire
    reg div_a_valid;
    reg div_b_valid;
    reg [63:0]div_a_data;
    reg [63:0]div_b_data;
    reg div_result_ready;
    wire div_a_ready;
    wire div_b_ready;
    wire div_result_valid;
    wire [63:0]div_result_data;      

//public(the adjoint matrix and the det)  intermadiate variable
reg [63:0]A00_multip_A11;//the result of A00 and A11
reg [63:0]A01_multip_A12;//the result of A00 and A11
reg [63:0]A02_multip_A10;//the result of A00 and A11
reg [63:0]A02_multip_A11;//the result of A00 and A11
reg [63:0]A12_multip_A21;//the result of A00 and A11
reg [63:0]A22_multip_A01;//the result of A00 and A11

//the elements of the adjoint matrix
reg [63:0]adjoint_matrix_A00;
reg [63:0]adjoint_matrix_A01;
reg [63:0]adjoint_matrix_A02;
reg [63:0]adjoint_matrix_A10;
reg [63:0]adjoint_matrix_A11;
reg [63:0]adjoint_matrix_A12;
reg [63:0]adjoint_matrix_A20;
reg [63:0]adjoint_matrix_A21;
reg [63:0]adjoint_matrix_A22;

reg [63:0]det_result;

  floating_point_0 floating_multip_1//multip_ip
  (
  .aclk(Clk), 
  .s_axis_a_tvalid(multip_a1_valid), 
  .s_axis_a_tready(multip_a1_ready), 
  .s_axis_a_tdata(multip_a1_data), 
  .s_axis_b_tvalid(multip_b1_valid), 
  .s_axis_b_tready(multip_b1_ready), 
  .s_axis_b_tdata(multip_b1_data), 
  .m_axis_result_tvalid(multip_result1_valid), 
  .m_axis_result_tready(multip_result1_ready), 
  .m_axis_result_tdata(multip_result1_data)
  );
  
  floating_point_0 floating_multip_2//multip_ip
  (
  .aclk(Clk), 
  .s_axis_a_tvalid(multip_a2_valid), 
  .s_axis_a_tready(multip_a2_ready), 
  .s_axis_a_tdata(multip_a2_data), 
  .s_axis_b_tvalid(multip_b2_valid), 
  .s_axis_b_tready(multip_b2_ready), 
  .s_axis_b_tdata(multip_b2_data), 
  .m_axis_result_tvalid(multip_result2_valid), 
  .m_axis_result_tready(multip_result2_ready), 
  .m_axis_result_tdata(multip_result2_data)
  );
  
  floating_point_1 floating_sub_1//add
  (
  .aclk(Clk), 
  .s_axis_a_tvalid(add_a1_valid), 
  .s_axis_a_tready(add_a1_ready), 
  .s_axis_a_tdata(add_a1_data), 
  .s_axis_b_tvalid(add_b1_valid), 
  .s_axis_b_tready(add_b1_ready), 
  .s_axis_b_tdata(add_b1_data), 
  .m_axis_result_tvalid(add_result1_valid), 
  .m_axis_result_tready(add_result1_ready), 
  .m_axis_result_tdata(add_result1_data)
  );
  
  floating_point_1 floating_sub_2//add
  (
  .aclk(Clk), 
  .s_axis_a_tvalid(add_a2_valid), 
  .s_axis_a_tready(add_a2_ready), 
  .s_axis_a_tdata(add_a2_data), 
  .s_axis_b_tvalid(add_b2_valid), 
  .s_axis_b_tready(add_b2_ready), 
  .s_axis_b_tdata(add_b2_data), 
  .m_axis_result_tvalid(add_result2_valid), 
  .m_axis_result_tready(add_result2_ready), 
  .m_axis_result_tdata(add_result2_data)
  );
  
  matrix_tran matrix(
.Clk(Clk),
.Rst_n(Rst_n),
.tran_en(tran_en),
.A0({adjoint_matrix_A00,adjoint_matrix_A01,adjoint_matrix_A02}),
.A1({adjoint_matrix_A10,adjoint_matrix_A11,adjoint_matrix_A12}),
.A2({adjoint_matrix_A20,adjoint_matrix_A21,adjoint_matrix_A22}),
.tran_A_0(tran_A_0),
.tran_A_1(tran_A_1),
.tran_A_2(tran_A_2),
.tran_done(tran_done)
);

floating_point_2 float_div
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
.m_axis_result_tdata(div_result_data)
);
  
  reg public_done;

  reg det_done;
  reg adjoint_multip_done;
  reg adjoint_done;
  reg add1_start;
  
  reg [3:0]public_state;
  reg [6:0]det_multip_state;
  reg [5:0]det_add_state;
  reg [12:0]adjoint_multip_state;
  reg [9:0]adjoint_add_state;
  reg [9:0]div_state;
  
  reg [2:0]public_wait_valid_cnt;
  reg [2:0]det_wait_valid_cnt;
  reg [2:0]det_add_cnt;
  reg [2:0]adjoin_add_cnt;
  reg [2:0]adjoint_wait_valid_cnt;
  reg [2:0]div_cnt;
  
  reg multip_a1_valid_public;
  reg multip_b1_valid_public;
  reg multip_a2_valid_public;
  reg multip_b2_valid_public;
  reg [63:0]multip_a1_data_public;  
  reg [63:0]multip_b1_data_public;
  reg [63:0]multip_a2_data_public;  
  reg [63:0]multip_b2_data_public;
  
  reg multip_a1_valid_det;
  reg multip_b1_valid_det;
  reg [63:0]multip_a1_data_det;  
  reg [63:0]multip_b1_data_det;
  reg multip_a2_valid_adjoint;
  reg multip_b2_valid_adjoint;
  reg [63:0]multip_a2_data_adjoint;  
  reg [63:0]multip_b2_data_adjoint;
  
  reg public_caculate_en;
  reg det_caculate_en;
  reg adjoint_caculate_en;
  

  
  parameter public_idle        = 4'b0001,
                     public_1            = 4'b0010,
                     public_2            = 4'b0100,
                     public_3            = 4'b1000;
   
  parameter det_multip_idle             = 7'b0000_001,                   
                     det_multip_1                 = 7'b0000_010,   
                     det_multip_2                 = 7'b0000_100,   
                     det_multip_3                 = 7'b0001_000,   
                     det_multip_4                 = 7'b0010_000,   
                     det_multip_5                 = 7'b0100_000,   
                     det_multip_6                 = 7'b1000_000;  
                      
  parameter det_add_idle                  = 6'b00_0001,
                     det_add_1                      = 6'b00_0010,
                     det_add_2                      = 6'b00_0100,
                     det_add_3                      = 6'b00_1000,
                     det_add_4                      = 6'b01_0000,
                     det_add_5                      = 6'b10_0000;                    
  
  parameter adjoint_multip_idle        = 13'b0000_0000_0000_1,
                     adjoint_multip_1            = 13'b0000_0000_0001_0,
                     adjoint_multip_2            = 13'b0000_0000_0010_0,
                     adjoint_multip_3            = 13'b0000_0000_0100_0,
                     adjoint_multip_4            = 13'b0000_0000_1000_0,
                     adjoint_multip_5            = 13'b0000_0001_0000_0,
                     adjoint_multip_6            = 13'b0000_0010_0000_0,
                     adjoint_multip_7            = 13'b0000_0100_0000_0,
                     adjoint_multip_8            = 13'b0000_1000_0000_0,
                     adjoint_multip_9            = 13'b0001_0000_0000_0,
                     adjoint_multip_10          = 13'b0010_0000_0000_0,
                     adjoint_multip_11          = 13'b0100_0000_0000_0,
                     adjoint_multip_12          = 13'b1000_0000_0000_0;
                     
  parameter adjoint_add_idle            = 10'b0000_0000_01,
                     adjoint_add_1                = 10'b0000_0000_10,  
                     adjoint_add_2                = 10'b0000_0001_00, 
                     adjoint_add_3                = 10'b0000_0010_00, 
                     adjoint_add_4                = 10'b0000_0100_00, 
                     adjoint_add_5                = 10'b0000_1000_00,
                     adjoint_add_6                = 10'b0001_0000_00, 
                     adjoint_add_7                = 10'b0010_0000_00, 
                     adjoint_add_8                = 10'b0100_0000_00, 
                     adjoint_add_9                = 10'b1000_0000_00;
                     
   parameter div_idle      = 10'b00_0000_0001,
		              div_1         = 10'b00_0000_0010,
		              div_2         = 10'b00_0000_0100,
		              div_3         = 10'b00_0000_1000,
		              div_4         = 10'b00_0001_0000,
		              div_5         = 10'b00_0010_0000,
		              div_6         = 10'b00_0100_0000,
		              div_7         = 10'b00_1000_0000,
		              div_8         = 10'b01_0000_0000,
		              div_9         = 10'b10_0000_0000;                    
                             
  
always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
    begin
        multip_b1_valid <= 1'b0;
        multip_a1_valid <= 1'b0;
        multip_a1_data  <=  64'd0;
        multip_b1_data  <=  64'd0;
    end
else if(public_caculate_en)
    begin
        multip_a1_valid <=  multip_a1_valid_public;
        multip_b1_valid <=  multip_a1_valid_public;
        multip_a1_data  <=  multip_a1_data_public;
        multip_b1_data  <=  multip_b1_data_public;
    end    
else if(det_caculate_en)
    begin
        multip_a1_valid <=  multip_a1_valid_det;
        multip_b1_valid <=  multip_b1_valid_det;
        multip_a1_data  <=  multip_a1_data_det;
        multip_b1_data  <=  multip_b1_data_det;
    end
else
    begin
        multip_b1_valid <= 1'b0;
        multip_a1_valid <= 1'b0;
        multip_a1_data  <=  64'd0;
        multip_b1_data  <=  64'd0;
    end
    
always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
    begin
        multip_b2_valid <= 1'b0;
        multip_a2_valid <= 1'b0;
        multip_a2_data  <=  64'd0;
        multip_b2_data  <=  64'd0;
    end
else if(public_caculate_en)
    begin
        multip_a2_valid <=  multip_a2_valid_public;
        multip_b2_valid <=  multip_b2_valid_public;
        multip_a2_data  <=  multip_a2_data_public;
        multip_b2_data  <=  multip_b2_data_public;
    end    
else if(adjoint_caculate_en)
    begin
        multip_a2_valid <=  multip_a2_valid_adjoint;
        multip_b2_valid <=  multip_b2_valid_adjoint;
        multip_a2_data  <=  multip_a2_data_adjoint;
        multip_b2_data  <=  multip_b2_data_adjoint;
    end
else
    begin
        multip_b2_valid <= 1'b0;
        multip_a2_valid <= 1'b0;
        multip_a2_data  <=  64'd0;
        multip_b2_data  <=  64'd0;
    end
    
    
    
  //caculate the public(the adjoint matrix and the det)  intermadiate variable
  always@(posedge Clk or negedge Rst_n)
  if(!Rst_n)
        begin
            multip_a1_valid_public <= 1'b0;
            multip_b1_valid_public <= 1'b0;
            multip_a2_valid_public <= 1'b0;
            multip_b2_valid_public <= 1'b0;
            multip_result1_ready  <= 1'b1;
            multip_result2_ready  <= 1'b1;
            public_state                 <= 4'b0001;
            public_wait_valid_cnt  <= 3'd0;
            public_caculate_en      <= 1'b0;
            public_done                 <= 1'b0;
        end
   else 
        case(public_state)
            public_idle:
                begin
                    multip_a1_valid_public <= 1'b0;
                    multip_b1_valid_public <= 1'b0;
                    multip_a2_valid_public <= 1'b0;
                    multip_b2_valid_public <= 1'b0;
                    multip_result1_ready  <= 1'b1;
                    multip_result2_ready  <= 1'b1;
                    public_wait_valid_cnt   <= 3'd0;
                    public_caculate_en      <= 1'b0;
                    public_done                 <= 1'b0;
                    if(inv_en)
                        begin
                            public_state <= public_1;
                            public_caculate_en <= 1'b1;
                        end    
                end
                
           public_1:
                begin
                    multip_a1_data_public          <= A0[191:128];//A00
                    multip_b1_data_public          <= A1[127:64];//A11
                    multip_a2_data_public          <= A0[127:64];//A01
                    multip_b2_data_public          <= A1[63:0];//A12
                    if(public_wait_valid_cnt<4)
                        public_wait_valid_cnt <= public_wait_valid_cnt +1'b1;
                    if(public_wait_valid_cnt == 3'd1)
                        begin
                            multip_a1_valid_public <= 1'b1;
                            multip_b1_valid_public <= 1'b1;
                            multip_a2_valid_public <= 1'b1;
                            multip_b2_valid_public <= 1'b1;
                        end
                    else if(public_wait_valid_cnt == 3'd2)
                        begin
                            multip_a1_valid_public <= 1'b0;
                            multip_b1_valid_public <= 1'b0;
                            multip_a2_valid_public <= 1'b0;
                            multip_b2_valid_public <= 1'b0;
                        end
                    else if(multip_result1_valid) 
                        begin
                            public_state                <= public_2;
                            public_wait_valid_cnt <= 3'd0;
                            A00_multip_A11         <= multip_result1_data;
                            A01_multip_A12         <= multip_result2_data;
                        end
                end
                
            public_2:
                begin
                    multip_a1_data_public          <= A0[63:0];//A02
                    multip_b1_data_public          <= A1[191:128];//A10
                    multip_a2_data_public          <= A0[63:0];//A02
                    multip_b2_data_public          <= A1[127:64];//A11
                    if(public_wait_valid_cnt<4)
                        public_wait_valid_cnt <= public_wait_valid_cnt +1'b1;
                    if(public_wait_valid_cnt == 3'd1)
                        begin
                            multip_a1_valid_public <= 1'b1;
                            multip_b1_valid_public <= 1'b1;
                            multip_a2_valid_public <= 1'b1;
                            multip_b2_valid_public <= 1'b1;
                        end
                    else if(public_wait_valid_cnt == 3'd2)
                        begin
                            multip_a1_valid_public <= 1'b0;
                            multip_b1_valid_public <= 1'b0;
                            multip_a2_valid_public <= 1'b0;
                            multip_b2_valid_public <= 1'b0;
                        end
                    else if(multip_result1_valid) 
                        begin
                            public_state                <= public_3;
                            public_wait_valid_cnt <= 3'd0;
                            A02_multip_A10         <= multip_result1_data;
                            A02_multip_A11         <= multip_result2_data;
                        end
                end
                
           public_3:
                begin
                    multip_a1_data_public          <= A1[63:0];//A12
                    multip_b1_data_public          <= A2[127:64];//A21
                    multip_a2_data_public          <= A2[63:0];//A22
                    multip_b2_data_public          <= A0[127:64];//A01
                    if(public_wait_valid_cnt<4)
                        public_wait_valid_cnt <= public_wait_valid_cnt +1'b1;
                    if(public_wait_valid_cnt == 3'd1)
                        begin
                            multip_a1_valid_public <= 1'b1;
                            multip_b1_valid_public <= 1'b1;
                            multip_a2_valid_public <= 1'b1;
                            multip_b2_valid_public <= 1'b1;
                        end
                    else if(public_wait_valid_cnt == 3'd2)
                        begin
                            multip_a1_valid_public <= 1'b0;
                            multip_b1_valid_public <= 1'b0;
                            multip_a2_valid_public <= 1'b0;
                            multip_b2_valid_public <= 1'b0;
                        end
                    else if(multip_result1_valid) 
                        begin
                            public_state                <= public_idle;
                            public_wait_valid_cnt <= 3'd0;
                            A12_multip_A21         <= multip_result1_data;
                            A22_multip_A01         <= multip_result2_data;
                            public_done                <= 1'b1;
                        end
                end     
                
           default:
                    public_state <= public_idle;
        endcase
 
 
 
 //caculate the each element's products of  the det(A)
always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
    begin
        det_caculate_en         <= 1'b0;
        multip_a1_valid_det   <= 1'b0;
        multip_b1_valid_det   <= 1'b0;
        det_wait_valid_cnt      <= 3'd0;
        det_multip_state         <= det_multip_idle;
        add1_start                   <= 1'b0;
    end
else 
    case(det_multip_state)
        det_multip_idle:
            begin
                det_caculate_en         <= 1'b0;
                multip_a1_valid_det   <= 1'b0;
                multip_b1_valid_det   <= 1'b0;
                det_wait_valid_cnt      <= 3'd0;
                add1_start                   <= 1'b0;
                if(public_done)
                    begin
                        det_multip_state <= det_multip_1;
                        det_caculate_en  <= 1'b1;
                    end
            end
        
        det_multip_1://caculate A00*A11*A22
            begin
                add1_start                    <= 1'b1;
                multip_a1_data_det      <= A00_multip_A11;
                multip_b1_data_det      <= A2[63:0];
                if(det_wait_valid_cnt <3'd4)
                    det_wait_valid_cnt     <= det_wait_valid_cnt +1'b1;
                if(det_wait_valid_cnt == 3'd1)
                    begin
                        multip_a1_valid_det   <= 1'b1;
                        multip_b1_valid_det   <= 1'b1;
                    end
                else if(det_wait_valid_cnt == 3'd2)
                    begin
                        multip_a1_valid_det   <= 1'b0;
                        multip_b1_valid_det   <= 1'b0;
                    end  
                else if(multip_result1_valid)
                    begin
                        det_wait_valid_cnt      <= 3'd0;
                        det_multip_state         <= det_multip_2;
                    end
            end
            
        det_multip_2://caculate A01*A12*A20
            begin
                multip_a1_data_det      <= A01_multip_A12;
                multip_b1_data_det      <= A2[191:128];
                if(det_wait_valid_cnt <3'd4)
                    det_wait_valid_cnt     <= det_wait_valid_cnt +1'b1;
                if(det_wait_valid_cnt == 3'd1)
                    begin
                        multip_a1_valid_det   <= 1'b1;
                        multip_b1_valid_det   <= 1'b1;
                    end
                else if(det_wait_valid_cnt == 3'd2)
                    begin
                        multip_a1_valid_det   <= 1'b0;
                        multip_b1_valid_det   <= 1'b0;
                    end  
                else if(multip_result1_valid)
                    begin
                        det_wait_valid_cnt      <= 3'd0;
                        det_multip_state         <= det_multip_3;
                        
                    end
            end
            
        det_multip_3://caculate A02*A10*A21
            begin
                multip_a1_data_det      <= A02_multip_A10;
                multip_b1_data_det      <= A2[127:64];
                if(det_wait_valid_cnt <3'd4)
                    det_wait_valid_cnt     <= det_wait_valid_cnt +1'b1;
                if(det_wait_valid_cnt == 3'd1)
                    begin
                        multip_a1_valid_det   <= 1'b1;
                        multip_b1_valid_det   <= 1'b1;
                    end
                else if(det_wait_valid_cnt == 3'd2)
                    begin
                        multip_a1_valid_det   <= 1'b0;
                        multip_b1_valid_det   <= 1'b0;
                    end  
                else if(multip_result1_valid)
                    begin
                        det_wait_valid_cnt      <= 3'd0;
                        det_multip_state         <= det_multip_4;
                    end
            end
            
        det_multip_4://caculate A02*A11*A20
            begin
                multip_a1_data_det      <= A02_multip_A11;
                multip_b1_data_det      <= A2[191:128];
                if(det_wait_valid_cnt <3'd4)
                    det_wait_valid_cnt     <= det_wait_valid_cnt +1'b1;
                if(det_wait_valid_cnt == 3'd1)
                    begin
                        multip_a1_valid_det   <= 1'b1;
                        multip_b1_valid_det   <= 1'b1;
                    end
                else if(det_wait_valid_cnt == 3'd2)
                    begin
                        multip_a1_valid_det   <= 1'b0;
                        multip_b1_valid_det   <= 1'b0;
                    end  
                else if(multip_result1_valid)
                    begin
                        det_wait_valid_cnt      <= 3'd0;
                        det_multip_state         <= det_multip_5;
                    end
            end
            
        det_multip_5://caculate A12*A21*A00
            begin
                multip_a1_data_det      <= A12_multip_A21;
                multip_b1_data_det      <= A0[191:128];
                if(det_wait_valid_cnt <3'd4)
                    det_wait_valid_cnt     <= det_wait_valid_cnt +1'b1;
                if(det_wait_valid_cnt == 3'd1)
                    begin
                        multip_a1_valid_det   <= 1'b1;
                        multip_b1_valid_det   <= 1'b1;
                    end
                else if(det_wait_valid_cnt == 3'd2)
                    begin
                        multip_a1_valid_det   <= 1'b0;
                        multip_b1_valid_det   <= 1'b0;
                    end  
                else if(multip_result1_valid)
                    begin
                        det_wait_valid_cnt      <= 3'd0;
                        det_multip_state         <= det_multip_6;
                    end
            end
            
        det_multip_6://caculate A22*A01*A10
            begin
                multip_a1_data_det      <= A22_multip_A01;
                multip_b1_data_det      <= A1[191:128];
                if(det_wait_valid_cnt <3'd4)
                    det_wait_valid_cnt     <= det_wait_valid_cnt +1'b1;
                if(det_wait_valid_cnt == 3'd1)
                    begin
                        multip_a1_valid_det   <= 1'b1;
                        multip_b1_valid_det   <= 1'b1;
                    end
                else if(det_wait_valid_cnt == 3'd2)
                    begin
                        multip_a1_valid_det   <= 1'b0;
                        multip_b1_valid_det   <= 1'b0;
                    end  
                else if(multip_result1_valid)
                    begin
                        det_wait_valid_cnt      <= 3'd0;
                        det_multip_state         <= det_multip_idle;
                    end
            end            
            
    endcase    

reg add_flag;


//caculate the result of det(A)
always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
    begin
        det_add_state          <= det_add_idle;
        add_a1_valid            <= 1'b0;
        add_b1_valid            <= 1'b0;
        det_add_cnt             <= 3'd0;
        det_done                  <= 1'b0;
        add_result1_ready    <= 1'b1;
        add_flag                    <= 1'b0;
    end
else
    case(det_add_state)
        det_add_idle:
            begin
                add_a1_valid            <= 1'b0;
                add_b1_valid            <= 1'b0;
                det_add_cnt             <= 3'd0;
                det_done                  <= 1'b0;
                add_result1_ready    <= 1'b1;
                add_flag                    <= 1'b0;
                
                if(multip_result1_valid&&add1_start)
                    begin
                        det_add_state   <= det_add_1;
                        add_a1_data  <= multip_result1_data;
                    end
            end
            
        det_add_1:
            begin
                if(multip_result1_valid)
                    begin
                        add_b1_data <= multip_result1_data;
                        add_flag        <= 1'b1;   
                    end
                else if(add_flag)
                    begin    
                        if(det_add_cnt < 3'd4)
                            det_add_cnt <= det_add_cnt +1'b1;
                        if(det_add_cnt == 3'd1)
                            begin
                                add_a1_valid            <= 1'b1;
                                add_b1_valid            <= 1'b1;
                            end
                        else if(det_add_cnt == 3'd2)
                            begin
                                add_a1_valid            <= 1'b0;
                                add_b1_valid            <= 1'b0;
                            end
                        else if(add_result1_valid)
                            begin
                                add_a1_data     <= add_result1_data;
                                det_add_state   <=  det_add_2;
                                add_flag            <= 1'b0;
                                det_add_cnt      <= 3'd0;
                            end
                    end
                end
            
            det_add_2:
            begin
                if(multip_result1_valid)
                    begin
                        add_b1_data <= multip_result1_data;
                        add_flag        <= 1'b1;   
                    end
                else if(add_flag)
                    begin
                        if(det_add_cnt < 3'd4)
                            det_add_cnt <= det_add_cnt +1'b1;
                        if(det_add_cnt == 3'd1)
                            begin
                                add_a1_valid            <= 1'b1;
                                add_b1_valid            <= 1'b1;
                            end
                        else if(det_add_cnt == 3'd2)
                            begin
                                add_a1_valid            <= 1'b0;
                                add_b1_valid            <= 1'b0;
                            end
                        else if(add_result1_valid)
                            begin
                                add_a1_data     <= add_result1_data;
                                det_add_state   <=  det_add_3;
                                add_flag            <= 1'b0;
                                det_add_cnt      <= 3'd0;
                            end
                    end
           end
            
            det_add_3:
            begin
                if(multip_result1_valid)
                    begin
                        add_b1_data <= multip_result1_data + 64'h8000_0000_0000_0000;
                        add_flag        <= 1'b1;   
                    end
                else if(add_flag)
                    begin
                        if(det_add_cnt < 3'd4)
                            det_add_cnt <= det_add_cnt +1'b1;
                        if(det_add_cnt == 3'd1)
                            begin
                                add_a1_valid            <= 1'b1;
                                add_b1_valid            <= 1'b1;
                            end
                        else if(det_add_cnt == 3'd2)
                            begin
                                add_a1_valid            <= 1'b0;
                                add_b1_valid            <= 1'b0;
                            end
                        else if(add_result1_valid)
                            begin
                                add_a1_data     <= add_result1_data;
                                det_add_state   <=  det_add_4;
                                add_flag            <= 1'b0;
                                det_add_cnt      <= 3'd0;
                            end 
                    end
            end
            
            det_add_4:
            begin
                if(multip_result1_valid)
                    begin
                        add_b1_data <= multip_result1_data + 64'h8000_0000_0000_0000;
                        add_flag        <= 1'b1;   
                    end
                else if(add_flag)
                    begin
                        if(det_add_cnt < 3'd4)
                            det_add_cnt <= det_add_cnt +1'b1;
                        if(det_add_cnt == 3'd1)
                            begin
                                add_a1_valid            <= 1'b1;
                                add_b1_valid            <= 1'b1;
                            end
                        else if(det_add_cnt == 3'd2)
                            begin
                                add_a1_valid            <= 1'b0;
                                add_b1_valid            <= 1'b0;
                            end  
                        else if(add_result1_valid)
                            begin
                                add_a1_data     <= add_result1_data;
                                det_add_state   <=  det_add_5;
                                add_flag            <= 1'b0;
                                det_add_cnt      <= 3'd0;
                            end
                    end
            end
            
            det_add_5:
            begin
                if(multip_result1_valid)
                    begin
                        add_b1_data <= multip_result1_data + 64'h8000_0000_0000_0000;
                        add_flag        <= 1'b1;   
                    end
                else if(add_flag)
                    begin    
                        if(det_add_cnt < 3'd4)
                            det_add_cnt <= det_add_cnt +1'b1;
                        if(det_add_cnt == 3'd1)
                            begin
                                add_a1_valid            <= 1'b1;
                                add_b1_valid            <= 1'b1;
                            end
                        else if(det_add_cnt == 3'd2)
                            begin
                                add_a1_valid            <= 1'b0;
                                add_b1_valid            <= 1'b0;
                            end
                        else if(add_result1_valid)
                            begin
                                det_result         <= add_result1_data;
                                det_add_state   <=  det_add_idle;
                                det_done          <= 1'b1;
                                add_flag            <= 1'b0;
                                det_add_cnt      <= 3'd0;
                            end
                    end
            end     
            
    endcase

reg adjoint_add_flag1;
reg adjoint_add_flag2;


//multip_a2_data_adjoint
always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
    begin
        adjoint_caculate_en          <=   1'b0;
        multip_a2_valid_adjoint    <=   1'b0;
        multip_b2_valid_adjoint    <=   1'b0;
        adjoint_multip_state         <=   adjoint_multip_idle;
        adjoint_wait_valid_cnt       <= 3'd0;
        adjoint_add_flag1              <= 1'b0;
        adjoint_add_flag2              <= 1'b0;
    end
else 
    case(adjoint_multip_state)
        adjoint_multip_idle:
            begin
                adjoint_caculate_en          <=   1'b0;
                multip_a2_valid_adjoint    <=   1'b0;
                multip_b2_valid_adjoint    <=   1'b0;
                adjoint_wait_valid_cnt       <=   3'd0;
                adjoint_add_flag1              <= 1'b0;
                adjoint_add_flag2              <= 1'b0;
                if(public_done)
                    begin
                        adjoint_caculate_en          <=   1'b1;
                        adjoint_multip_state         <=   adjoint_multip_1;
                    end
            end
            
        adjoint_multip_1:
            begin
                multip_a2_data_adjoint                 <= A1[127:64];
                multip_b2_data_adjoint                 <= A2[63:0];
                if(adjoint_wait_valid_cnt < 3'd4)
                    adjoint_wait_valid_cnt <= adjoint_wait_valid_cnt +1'b1;
                if(adjoint_wait_valid_cnt == 3'd1)
                    begin
                        multip_a2_valid_adjoint    <=   1'b1;
                        multip_b2_valid_adjoint    <=   1'b1;
                    end
                else if(adjoint_wait_valid_cnt == 3'd2)
                    begin
                        multip_a2_valid_adjoint    <=   1'b0;
                        multip_b2_valid_adjoint    <=   1'b0;
                    end
                else if(multip_result2_valid)
                    begin
                        adjoint_multip_state         <= adjoint_multip_2;
                        adjoint_wait_valid_cnt      <= 3'd0;
                        adjoint_add_flag2             <=1'b1; 
                    end
            end
            
        adjoint_multip_2:
            begin
                multip_a2_data_adjoint                 <= A1[191:128];
                multip_b2_data_adjoint                 <= A2[63:0];
                adjoint_add_flag2                          <=1'b0; 
                adjoint_add_flag1                          <= 1'b0;
                if(adjoint_wait_valid_cnt < 3'd4)
                    adjoint_wait_valid_cnt <= adjoint_wait_valid_cnt +1'b1;
                if(adjoint_wait_valid_cnt == 3'd1)
                    begin
                        multip_a2_valid_adjoint    <=   1'b1;
                        multip_b2_valid_adjoint    <=   1'b1;
                    end
                else if(adjoint_wait_valid_cnt == 3'd2)
                    begin
                        multip_a2_valid_adjoint    <=   1'b0;
                        multip_b2_valid_adjoint    <=   1'b0;
                    end
                else if(multip_result2_valid)
                    begin
                        adjoint_multip_state         <= adjoint_multip_3;
                        adjoint_wait_valid_cnt      <= 3'd0;
                        adjoint_add_flag1              <= 1'b1;
                        adjoint_add_flag2              <= 1'b0;
                    end
            end
            
        adjoint_multip_3:
            begin
                multip_a2_data_adjoint                 <= A1[63:0];
                multip_b2_data_adjoint                 <= A2[191:128];
                adjoint_add_flag1                          <= 1'b0;
                adjoint_add_flag2                          <= 1'b0;
                if(adjoint_wait_valid_cnt < 3'd4)
                    adjoint_wait_valid_cnt <= adjoint_wait_valid_cnt +1'b1;
                if(adjoint_wait_valid_cnt == 3'd1)
                    begin
                        multip_a2_valid_adjoint    <=   1'b1;
                        multip_b2_valid_adjoint    <=   1'b1;
                    end
                else if(adjoint_wait_valid_cnt == 3'd2)
                    begin
                        multip_a2_valid_adjoint    <=   1'b0;
                        multip_b2_valid_adjoint    <=   1'b0;
                    end
                else if(multip_result2_valid)
                    begin
                        adjoint_multip_state         <= adjoint_multip_4;
                        adjoint_wait_valid_cnt      <= 3'd0;
                        adjoint_add_flag2             <=1'b1;
                        adjoint_add_flag1             <=1'b0; 
                    end
            end
            
        adjoint_multip_4:
            begin
                multip_a2_data_adjoint                 <= A1[191:128];//a10
                multip_b2_data_adjoint                 <= A2[127:64];//a21
                adjoint_add_flag1                          <= 1'b0;
                adjoint_add_flag2                          <= 1'b0;
                if(adjoint_wait_valid_cnt < 3'd4)
                    adjoint_wait_valid_cnt <= adjoint_wait_valid_cnt +1'b1;
                if(adjoint_wait_valid_cnt == 3'd1)
                    begin
                        multip_a2_valid_adjoint    <=   1'b1;
                        multip_b2_valid_adjoint    <=   1'b1;
                    end
                else if(adjoint_wait_valid_cnt == 3'd2)
                    begin
                        multip_a2_valid_adjoint    <=   1'b0;
                        multip_b2_valid_adjoint    <=   1'b0;
                    end
                else if(multip_result2_valid)
                    begin
                        adjoint_multip_state         <= adjoint_multip_5;
                        adjoint_wait_valid_cnt      <= 3'd0;
                        adjoint_add_flag2             <=1'b0;
                        adjoint_add_flag1             <=1'b1; 
                    end
            end    
            
        adjoint_multip_5:
            begin
                multip_a2_data_adjoint                 <= A1[127:64];//a11
                multip_b2_data_adjoint                 <= A2[191:128];//a20
                adjoint_add_flag1                          <= 1'b0;
                adjoint_add_flag2                          <= 1'b0;
                if(adjoint_wait_valid_cnt < 3'd4)
                    adjoint_wait_valid_cnt <= adjoint_wait_valid_cnt +1'b1;
                if(adjoint_wait_valid_cnt == 3'd1)
                    begin
                        multip_a2_valid_adjoint    <=   1'b1;
                        multip_b2_valid_adjoint    <=   1'b1;
                    end
                else if(adjoint_wait_valid_cnt == 3'd2)
                    begin
                        multip_a2_valid_adjoint    <=   1'b0;
                        multip_b2_valid_adjoint    <=   1'b0;
                    end
                else if(multip_result2_valid)
                    begin
                        adjoint_multip_state         <= adjoint_multip_6;
                        adjoint_wait_valid_cnt      <= 3'd0;
                        adjoint_add_flag2             <=1'b1;
                        adjoint_add_flag1             <=1'b0; 
                    end
            end
            
        adjoint_multip_6:
            begin
                multip_a2_data_adjoint                 <= A0[63:0];//a02
                multip_b2_data_adjoint                 <= A2[127:64];//a21
                adjoint_add_flag1                          <= 1'b0;
                adjoint_add_flag2                          <= 1'b0;
                if(adjoint_wait_valid_cnt < 3'd4)
                    adjoint_wait_valid_cnt <= adjoint_wait_valid_cnt +1'b1;
               if(adjoint_wait_valid_cnt == 3'd1)
                    begin
                        multip_a2_valid_adjoint    <=   1'b1;
                        multip_b2_valid_adjoint    <=   1'b1;
                    end
                else if(adjoint_wait_valid_cnt == 3'd2)
                    begin
                        multip_a2_valid_adjoint    <=   1'b0;
                        multip_b2_valid_adjoint    <=   1'b0;
                    end
                else if(multip_result2_valid)
                    begin
                        adjoint_multip_state         <= adjoint_multip_7;
                        adjoint_wait_valid_cnt      <= 3'd0;
                        adjoint_add_flag2             <=1'b1;
                        adjoint_add_flag1             <=1'b0; 
                    end
            end
            
        adjoint_multip_7:
            begin
                multip_a2_data_adjoint                 <= A0[191:128];//a00
                multip_b2_data_adjoint                 <= A2[63:0];//a22
                adjoint_add_flag1                          <= 1'b0;
                adjoint_add_flag2                          <= 1'b0;
                if(adjoint_wait_valid_cnt < 3'd4)
                    adjoint_wait_valid_cnt <= adjoint_wait_valid_cnt +1'b1;
                if(adjoint_wait_valid_cnt == 3'd1)
                    begin
                        multip_a2_valid_adjoint    <=   1'b1;
                        multip_b2_valid_adjoint    <=   1'b1;
                    end
                else if(adjoint_wait_valid_cnt == 3'd2)
                    begin
                        multip_a2_valid_adjoint    <=   1'b0;
                        multip_b2_valid_adjoint    <=   1'b0;
                    end
                else if(multip_result2_valid)
                    begin
                        adjoint_multip_state         <= adjoint_multip_8;
                        adjoint_wait_valid_cnt      <= 3'd0;
                        adjoint_add_flag2             <=1'b0;
                        adjoint_add_flag1             <=1'b1;
                    end
            end
            
        adjoint_multip_8:
            begin
                multip_a2_data_adjoint                 <= A0[63:0];//a02
                multip_b2_data_adjoint                 <= A2[191:128];//a20
                adjoint_add_flag1                          <= 1'b0;
                adjoint_add_flag2                          <= 1'b0; 
                if(adjoint_wait_valid_cnt < 3'd4)
                    adjoint_wait_valid_cnt <= adjoint_wait_valid_cnt +1'b1;
                if(adjoint_wait_valid_cnt == 3'd1)
                    begin
                        multip_a2_valid_adjoint    <=   1'b1;
                        multip_b2_valid_adjoint    <=   1'b1;
                    end
                else if(adjoint_wait_valid_cnt == 3'd2)
                    begin
                        multip_a2_valid_adjoint    <=   1'b0;
                        multip_b2_valid_adjoint    <=   1'b0;
                    end
                else if(multip_result2_valid)
                    begin
                        adjoint_multip_state         <= adjoint_multip_9;
                        adjoint_wait_valid_cnt      <= 3'd0;
                        adjoint_add_flag2             <=1'b1;
                        adjoint_add_flag1             <=1'b0;
                    end
            end
            
        adjoint_multip_9:
            begin
                multip_a2_data_adjoint                 <= A0[191:128];//a00
                multip_b2_data_adjoint                 <= A2[127:64];//a21
                adjoint_add_flag1                          <= 1'b0;
                adjoint_add_flag2                          <= 1'b0; 
                if(adjoint_wait_valid_cnt < 3'd4)
                    adjoint_wait_valid_cnt <= adjoint_wait_valid_cnt +1'b1;
                if(adjoint_wait_valid_cnt == 3'd1)
                    begin
                        multip_a2_valid_adjoint    <=   1'b1;
                        multip_b2_valid_adjoint    <=   1'b1;
                    end
                else if(adjoint_wait_valid_cnt == 3'd2)
                    begin
                        multip_a2_valid_adjoint    <=   1'b0;
                        multip_b2_valid_adjoint    <=   1'b0;
                    end
                else if(multip_result2_valid)
                    begin
                        adjoint_multip_state         <= adjoint_multip_10;
                        adjoint_wait_valid_cnt      <= 3'd0;
                        adjoint_add_flag2             <=1'b0;
                        adjoint_add_flag1             <=1'b1;
                    end
            end
            
        adjoint_multip_10:
            begin
                multip_a2_data_adjoint                 <= A0[127:64];//a01
                multip_b2_data_adjoint                 <= A2[191:128];//a20
                adjoint_add_flag1                          <= 1'b0;
                adjoint_add_flag2                          <= 1'b0;
                if(adjoint_wait_valid_cnt < 3'd4)
                    adjoint_wait_valid_cnt <= adjoint_wait_valid_cnt +1'b1;
                if(adjoint_wait_valid_cnt == 3'd1)
                    begin
                        multip_a2_valid_adjoint    <=   1'b1;
                        multip_b2_valid_adjoint    <=   1'b1;
                    end
                else if(adjoint_wait_valid_cnt == 3'd2)
                    begin
                        multip_a2_valid_adjoint    <=   1'b0;
                        multip_b2_valid_adjoint    <=   1'b0;
                    end
                else if(multip_result2_valid)
                    begin
                        adjoint_multip_state         <= adjoint_multip_11;
                        adjoint_wait_valid_cnt      <= 3'd0;
                        adjoint_add_flag2             <=1'b1;
                        adjoint_add_flag1             <=1'b0; 
                    end
            end
            
        adjoint_multip_11:
            begin
                multip_a2_data_adjoint                 <= A0[191:128];//a00
                multip_b2_data_adjoint                 <= A1[63:0];//a12
                adjoint_add_flag1                          <= 1'b0;
                adjoint_add_flag2                          <= 1'b0; 
                if(adjoint_wait_valid_cnt < 3'd4)
                    adjoint_wait_valid_cnt <= adjoint_wait_valid_cnt +1'b1;
                if(adjoint_wait_valid_cnt == 3'd1)
                    begin
                        multip_a2_valid_adjoint    <=   1'b1;
                        multip_b2_valid_adjoint    <=   1'b1;
                    end
                else if(adjoint_wait_valid_cnt == 3'd2)
                    begin
                        multip_a2_valid_adjoint    <=   1'b0;
                        multip_b2_valid_adjoint    <=   1'b0;
                    end
                else if(multip_result2_valid)
                    begin
                        adjoint_multip_state         <= adjoint_multip_12;
                        adjoint_wait_valid_cnt      <= 3'd0;
                        adjoint_add_flag2             <=1'b1;
                        adjoint_add_flag1             <=1'b0;
                    end
            end
            
        adjoint_multip_12:
            begin
                multip_a2_data_adjoint                 <= A0[127:64];//a01
                multip_b2_data_adjoint                 <= A1[191:128];//a10
                adjoint_add_flag1                          <= 1'b0;
                adjoint_add_flag2                          <= 1'b0;
                if(adjoint_wait_valid_cnt < 3'd4)
                    adjoint_wait_valid_cnt <= adjoint_wait_valid_cnt +1'b1;
                if(adjoint_wait_valid_cnt == 3'd1)
                    begin
                        multip_a2_valid_adjoint    <=   1'b1;
                        multip_b2_valid_adjoint    <=   1'b1;
                    end
                else if(adjoint_wait_valid_cnt == 3'd2)
                    begin
                        multip_a2_valid_adjoint    <=   1'b0;
                        multip_b2_valid_adjoint    <=   1'b0;
                    end
                else if(multip_result2_valid)
                    begin
                        adjoint_multip_state         <= adjoint_multip_idle;
                        adjoint_wait_valid_cnt      <= 3'd0;
                        adjoint_add_flag2             <=1'b1;
                        adjoint_add_flag1             <=1'b0;
                    end
            end
            
    endcase

reg add_2_start;

//caculate the result of each elements in the adjoint martrix
always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
    begin
        add_a2_valid                <=    1'b0;
        add_b2_valid                <=    1'b0;
        add_result2_ready       <=    1'b1;
        adjoin_add_cnt            <=    3'd0;
        adjoint_done               <=    1'b0;
        adjoint_add_state        <=    adjoint_add_idle;
        add_2_start                  <= 1'b0;
    end
else
    case(adjoint_add_state)
        adjoint_add_idle:
            begin
                add_a2_valid                <=    1'b0;
                add_b2_valid                <=    1'b0;
                add_result2_ready       <=    1'b1;
                adjoin_add_cnt            <=    3'd0;
                adjoint_done               <=    1'b0;
                add_2_start                  <= 1'b0;
                if(public_done)
                    begin
                        adjoint_add_state  <= adjoint_add_1;
                    end
            end
            
        adjoint_add_1:
            begin
                add_a2_data               <=A01_multip_A12;
                add_b2_data               <=A02_multip_A11 + 64'h8000_0000_0000_0000;
                if(adjoin_add_cnt < 3'd4)
                    adjoin_add_cnt       <= adjoin_add_cnt  + 1'b1;
                if(adjoin_add_cnt==3'd1)
                    begin
                        add_a2_valid       <= 1'b1;
                        add_b2_valid       <= 1'b1;
                    end
                else if(adjoin_add_cnt == 3'd2)
                    begin
                        add_a2_valid        <= 1'b0;
                        add_b2_valid        <= 1'b0;
                    end
                else if(add_result2_valid)
                    begin
                        adjoint_matrix_A20   <= add_result2_data;
                        adjoin_add_cnt          <= 3'd0;
                        adjoint_add_state      <= adjoint_add_2;         
                    end
            end
        
        adjoint_add_2:
            begin
                add_a2_data             <= A12_multip_A21 + 64'h8000_0000_0000_0000;
                if(adjoint_add_flag2)
                    begin
                        add_b2_data         <=  multip_result2_data;
                        add_2_start           <= 1'b1;
                    end
                else if(add_2_start)    
                    begin
                        if(adjoin_add_cnt < 3'd4)
                            adjoin_add_cnt  <= adjoin_add_cnt + 1'b1;
                        if(adjoin_add_cnt == 3'd1)
                            begin
                                add_a2_valid       <= 1'b1;
                                add_b2_valid       <= 1'b1;
                            end
                        else if(adjoin_add_cnt == 3'd2)
                            begin
                                add_a2_valid       <= 1'b0;
                                add_b2_valid       <= 1'b0;
                            end
                        else if(add_result2_valid)
                            begin
                                adjoint_matrix_A00   <= add_result2_data;
                                adjoin_add_cnt          <= 3'd0;
                                adjoint_add_state      <= adjoint_add_3;
                                add_2_start                <= 1'b0;
                            end
                    end    
            end
            
        adjoint_add_3:
            begin
                if(adjoint_add_flag1)
                    begin
                        add_a2_data             <= multip_result2_data + 64'h8000_0000_0000_0000;
                    end
                else if(adjoint_add_flag2)
                     begin
                        add_b2_data         <=  multip_result2_data;
                        add_2_start           <= 1'b1;
                    end
                else if(add_2_start)    
                    begin
                        if(adjoin_add_cnt < 3'd4)
                            adjoin_add_cnt     <= adjoin_add_cnt + 1'b1;
                        if(adjoin_add_cnt == 3'd1)
                            begin
                                add_a2_valid       <= 1'b1;
                                add_b2_valid       <= 1'b1;
                            end
                        else if(adjoin_add_cnt == 3'd2)
                            begin
                                add_a2_valid       <= 1'b0;
                                add_b2_valid       <= 1'b0;
                            end
                        else if(add_result2_valid)
                            begin
                                adjoint_matrix_A01   <= add_result2_data;
                                adjoin_add_cnt          <= 3'd0;
                                adjoint_add_state      <= adjoint_add_4;
                                add_2_start                <= 1'b0;
                            end
                    end
            end
            
       adjoint_add_4:
            begin
                if(adjoint_add_flag1)
                    begin
                        add_a2_data             <= multip_result2_data;
                    end
                else if(adjoint_add_flag2)
                    begin
                        add_b2_data         <=  multip_result2_data + 64'h8000_0000_0000_0000;
                        add_2_start           <= 1'b1;
                    end
                else if(add_2_start)    
                    begin    
                        if(adjoin_add_cnt < 3'd4)
                            adjoin_add_cnt     <= adjoin_add_cnt + 1'b1;
                        if(adjoin_add_cnt == 3'd1)
                            begin
                                add_a2_valid       <= 1'b1;
                                add_b2_valid       <= 1'b1;
                            end
                        else if(adjoin_add_cnt == 3'd2)
                            begin
                                add_a2_valid       <= 1'b0;
                                add_b2_valid       <= 1'b0;
                            end
                        else if(add_result2_valid)
                            begin
                                adjoint_matrix_A02   <= add_result2_data;
                                adjoin_add_cnt          <= 3'd0;
                                adjoint_add_state      <= adjoint_add_5;
                                add_2_start                <= 1'b0;
                            end
                    end
            end
            
        adjoint_add_5:
            begin
                add_a2_data             <= A22_multip_A01 + 64'h8000_0000_0000_0000;
                if(adjoint_add_flag2)
                     begin
                        add_b2_data         <=  multip_result2_data;
                        add_2_start           <= 1'b1;
                    end
                else if(add_2_start)    
                    begin
                        if(adjoin_add_cnt < 3'd4)
                            adjoin_add_cnt  <= adjoin_add_cnt + 1'b1;
                        if(adjoin_add_cnt == 3'd1)
                            begin
                                add_a2_valid       <= 1'b1;
                                add_b2_valid       <= 1'b1;
                            end
                        else if(adjoin_add_cnt == 3'd2)
                            begin
                                add_a2_valid       <= 1'b0;
                                add_b2_valid       <= 1'b0;
                            end
                        else if(add_result2_valid)
                            begin
                                adjoint_matrix_A10   <= add_result2_data;
                                adjoin_add_cnt          <= 3'd0;
                                adjoint_add_state      <= adjoint_add_6;
                                add_2_start                <= 1'b0;
                            end
                    end    
            end
            
        adjoint_add_6:
            begin
                if(adjoint_add_flag1)
                    begin
                        add_a2_data             <= multip_result2_data;
                    end
                else if(adjoint_add_flag2)
                     begin
                        add_b2_data         <=  multip_result2_data + 64'h8000_0000_0000_0000;
                        add_2_start           <= 1'b1;
                    end
                else if(add_2_start)    
                    begin    
                        if(adjoin_add_cnt < 3'd4)
                            adjoin_add_cnt     <= adjoin_add_cnt + 1'b1;
                        if(adjoin_add_cnt == 3'd1)
                            begin
                                add_a2_valid       <= 1'b1;
                                add_b2_valid       <= 1'b1;
                            end
                        else if(adjoin_add_cnt == 3'd2)
                            begin
                                add_a2_valid       <= 1'b0;
                                add_b2_valid       <= 1'b0;
                            end
                        else if(add_result2_valid)
                            begin
                                adjoint_matrix_A11   <= add_result2_data;
                                adjoin_add_cnt          <= 3'd0;
                                adjoint_add_state      <= adjoint_add_7;
                                add_2_start                <= 1'b0;
                            end
                    end
            end    
            
        adjoint_add_7:
            begin
                if(adjoint_add_flag1)
                    begin
                        add_a2_data             <= multip_result2_data + 64'h8000_0000_0000_0000;
                    end
                else if(adjoint_add_flag2)
                     begin
                        add_b2_data         <=  multip_result2_data;
                        add_2_start           <= 1'b1;
                    end
                else if(add_2_start)    
                    begin
                        if(adjoin_add_cnt < 3'd4)
                            adjoin_add_cnt     <= adjoin_add_cnt + 1'b1;
                        if(adjoin_add_cnt == 3'd1)
                            begin
                                add_a2_valid       <= 1'b1;
                                add_b2_valid       <= 1'b1;
                            end
                        else if(adjoin_add_cnt == 3'd2)
                            begin
                                add_a2_valid       <= 1'b0;
                                add_b2_valid       <= 1'b0;
                            end
                        else if(add_result2_valid)
                            begin
                                adjoint_matrix_A12   <= add_result2_data;
                                adjoin_add_cnt          <= 3'd0;
                                adjoint_add_state      <= adjoint_add_8;
                                add_2_start                <= 1'b0;
                            end
                    end
            end    
            
        adjoint_add_8:
            begin
                add_a2_data             <= A02_multip_A10 ;
                if(adjoint_add_flag2)
                     begin
                        add_b2_data         <=  multip_result2_data + 64'h8000_0000_0000_0000;
                        add_2_start           <= 1'b1;
                    end
                else if(add_2_start)    
                    begin
                        if(adjoin_add_cnt < 3'd4)
                            adjoin_add_cnt  <= adjoin_add_cnt + 1'b1;
                        if(adjoin_add_cnt == 3'd1)
                            begin
                                add_a2_valid       <= 1'b1;
                                add_b2_valid       <= 1'b1;
                            end
                        else if(adjoin_add_cnt == 3'd2)
                            begin
                                add_a2_valid       <= 1'b0;
                                add_b2_valid       <= 1'b0;
                            end
                        else if(add_result2_valid)
                            begin
                                adjoint_matrix_A21   <= add_result2_data;
                                adjoin_add_cnt          <= 3'd0;
                                adjoint_add_state      <= adjoint_add_9;
                                add_2_start                <= 1'b0;
                            end
                    end    
            end
            
        adjoint_add_9:
            begin
                add_a2_data             <= A00_multip_A11 ;
                if(adjoint_add_flag2)
                    begin
                        add_b2_data         <=  multip_result2_data + 64'h8000_0000_0000_0000;
                        add_2_start           <= 1'b1;
                    end
                else if(add_2_start)    
                    begin     
                        if(adjoin_add_cnt < 3'd4)
                            adjoin_add_cnt  <= adjoin_add_cnt + 1'b1;
                        if(adjoin_add_cnt == 3'd1)
                            begin
                                add_a2_valid       <= 1'b1;
                                add_b2_valid       <= 1'b1;
                            end
                        else if(adjoin_add_cnt == 3'd2)
                            begin
                                add_a2_valid       <= 1'b0;
                                add_b2_valid       <= 1'b0;
                            end
                        else if(add_result2_valid)
                            begin
                                adjoint_matrix_A22   <= add_result2_data;
                                adjoin_add_cnt          <= 3'd0;
                                adjoint_add_state      <= adjoint_add_idle;
                                adjoint_done             <= 1'b1;
                                add_2_start                <= 1'b0;
                            end
                    end    
            end                     
    endcase

always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
    tran_en <= 1'b0;
else if(adjoint_done)
    tran_en <= 1'b1;
else 
    tran_en <= 1'b0;
    
always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
	begin
		div_result_ready  		<= 1'b1;
		div_a_valid             <= 1'b0;
		div_b_valid				<= 1'b0;
		div_state               <= div_idle;
		div_cnt					<= 3'd0;
		inv_done        		<= 1'b0;
	end
else
	case(div_state)
		div_idle:
			begin
				div_result_ready  		<= 1'b1;
				div_a_valid             <= 1'b0;
				div_b_valid				<= 1'b0;
				div_cnt                 <= 3'd0;
				div_b_data              <= 64'd0;
				inv_done        		<= 1'b0;
				if(tran_done)
					begin
						div_state       <= div_1;
						div_b_data      <= det_result;
					end	
			end
			
		div_1:
			begin
				div_a_data 				<= tran_A_0[191:128];
				if(div_cnt < 3'd4)
					div_cnt 			<= div_cnt + 1'b1;
				if(div_cnt == 3'd1)
					begin
						div_a_valid     <= 1'b1;
						div_b_valid     <= 1'b1;
					end
				else if(div_cnt == 3'd2)
					begin
						div_a_valid     <= 1'b0;
						div_b_valid     <= 1'b0;
					end
				else if(div_result_valid)
					begin
						inv_A0[191:128] <= div_result_data;
						div_state       <= div_2;
						div_cnt         <= 3'd0;
					end
			end
			
		div_2:
			begin
				div_a_data 				<= tran_A_0[127:64];
				if(div_cnt < 3'd4)
					div_cnt 			<= div_cnt + 1'b1;
				if(div_cnt == 3'd1)
					begin
						div_a_valid     <= 1'b1;
						div_b_valid     <= 1'b1;
					end
				else if(div_cnt == 3'd2)
					begin
						div_a_valid     <= 1'b0;
						div_b_valid     <= 1'b0;
					end
				else if(div_result_valid)
					begin
						inv_A0[127:64] <= div_result_data;
						div_state       <= div_3;
						div_cnt         <= 3'd0;
					end
			end

		div_3:
			begin
				div_a_data 				<= tran_A_0[63:0];
				if(div_cnt < 3'd4)
					div_cnt 			<= div_cnt + 1'b1;
				if(div_cnt == 3'd1)
					begin
						div_a_valid     <= 1'b1;
						div_b_valid     <= 1'b1;
					end
				else if(div_cnt == 3'd2)
					begin
						div_a_valid     <= 1'b0;
						div_b_valid     <= 1'b0;
					end
				else if(div_result_valid)
					begin
						inv_A0[63:0] <= div_result_data;
						div_state       <= div_4;
						div_cnt         <= 3'd0;
					end
			end

		div_4:
			begin
				div_a_data 				<= tran_A_1[191:128];
				if(div_cnt < 3'd4)
					div_cnt 			<= div_cnt + 1'b1;
				if(div_cnt == 3'd1)
					begin
						div_a_valid     <= 1'b1;
						div_b_valid     <= 1'b1;
					end
				else if(div_cnt == 3'd2)
					begin
						div_a_valid     <= 1'b0;
						div_b_valid     <= 1'b0;
					end
				else if(div_result_valid)
					begin
						inv_A1[191:128] <= div_result_data;
						div_state       <= div_5;
						div_cnt         <= 3'd0;
					end
			end
			
		div_5:
			begin
				div_a_data 				<= tran_A_1[127:64];
				if(div_cnt < 3'd4)
					div_cnt 			<= div_cnt + 1'b1;
				if(div_cnt == 3'd1)
					begin
						div_a_valid     <= 1'b1;
						div_b_valid     <= 1'b1;
					end
				else if(div_cnt == 3'd2)
					begin
						div_a_valid     <= 1'b0;
						div_b_valid     <= 1'b0;
					end
				else if(div_result_valid)
					begin
						inv_A1[127:64] <= div_result_data;
						div_state       <= div_6;
						div_cnt         <= 3'd0;
					end
			end

		div_6:
			begin
				div_a_data 				<= tran_A_1[63:0];
				if(div_cnt < 3'd4)
					div_cnt 			<= div_cnt + 1'b1;
				if(div_cnt == 3'd1)
					begin
						div_a_valid     <= 1'b1;
						div_b_valid     <= 1'b1;
					end
				else if(div_cnt == 3'd2)
					begin
						div_a_valid     <= 1'b0;
						div_b_valid     <= 1'b0;
					end
				else if(div_result_valid)
					begin
						inv_A1[63:0] <= div_result_data;
						div_state       <= div_7;
						div_cnt         <= 3'd0;
					end
			end

		div_7:
			begin
				div_a_data 				<= tran_A_2[191:128];
				if(div_cnt < 3'd4)
					div_cnt 			<= div_cnt + 1'b1;
				if(div_cnt == 3'd1)
					begin
						div_a_valid     <= 1'b1;
						div_b_valid     <= 1'b1;
					end
				else if(div_cnt == 3'd2)
					begin
						div_a_valid     <= 1'b0;
						div_b_valid     <= 1'b0;
					end
				else if(div_result_valid)
					begin
						inv_A2[191:128] <= div_result_data;
						div_state       <= div_8;
						div_cnt         <= 3'd0;
					end
			end
			
		div_8:
			begin
				div_a_data 				<= tran_A_2[127:64];
				if(div_cnt < 3'd4)
					div_cnt 			<= div_cnt + 1'b1;
				if(div_cnt == 3'd1)
					begin
						div_a_valid     <= 1'b1;
						div_b_valid     <= 1'b1;
					end
				else if(div_cnt == 3'd2)
					begin
						div_a_valid     <= 1'b0;
						div_b_valid     <= 1'b0;
					end
				else if(div_result_valid)
					begin
						inv_A2[127:64] <= div_result_data;
						div_state       <= div_9;
						div_cnt         <= 3'd0;
					end
			end

		div_9:
			begin
				div_a_data 				<= tran_A_2[63:0];
				if(div_cnt < 3'd4)
					div_cnt 			<= div_cnt + 1'b1;
				if(div_cnt == 3'd1)
					begin
						div_a_valid     <= 1'b1;
						div_b_valid     <= 1'b1;
					end
				else if(div_cnt == 3'd2)
					begin
						div_a_valid     <= 1'b0;
						div_b_valid     <= 1'b0;
					end
				else if(div_result_valid)
					begin
						inv_A2[63:0] <= div_result_data;
						div_state       <= div_idle;
						div_cnt         <= 3'd0;
						inv_done        <= 1'b1;
					end
			end	
	endcase	
    

    
endmodule
