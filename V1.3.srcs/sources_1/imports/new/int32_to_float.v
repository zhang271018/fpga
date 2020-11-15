`timescale 1ns / 1ps
`define float_length 64
`define int_length 32
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/29 18:10:02
// Design Name: 
// Module Name: int32_to_float
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


module int32_to_float
            (
                type_tran_inXYZ,
                type_tran_outXYZ,
                type_tran_intime,
                type_tran_outtime,
                Clk,
                Rst_n,
                type_tran_en,
                type_tran_done
            );
            
           

input [`int_length*12-1:0]type_tran_inXYZ;
input [`int_length*3-1:0]type_tran_intime;            
input type_tran_en;
input Clk;
input Rst_n;

output reg type_tran_done;
output reg [`float_length*3-1:0]type_tran_outtime;
output reg [`float_length*12-1:0]type_tran_outXYZ;       

//type_tran wires
reg type_tran_invalid;
reg type_tran_outready;
reg [`int_length-1:0]type_tran_indata;

wire type_tran_inready;
wire type_tran_outvalid;
wire [`float_length-1:0]type_tran_outdata;
//int32 to float ip
floating_point_3 type_tran
(
.aclk(Clk), 
.s_axis_a_tvalid(type_tran_invalid), 
.s_axis_a_tready(type_tran_inready), 
.s_axis_a_tdata(type_tran_indata), 
.m_axis_result_tvalid(type_tran_outvalid), 
.m_axis_result_tready(type_tran_outready), 
.m_axis_result_tdata(type_tran_outdata)
); 

parameter  type_tran_idle       = 16'b0000_0000_0000_0001,
                    type_tran_XYZ1     = 16'b0000_0000_0000_0010,
                    type_tran_XYZ2     = 16'b0000_0000_0000_0100,
                    type_tran_XYZ3     = 16'b0000_0000_0000_1000,
                    type_tran_XYZ4     = 16'b0000_0000_0001_0000,
                    type_tran_XYZ5     = 16'b0000_0000_0010_0000,
                    type_tran_XYZ6     = 16'b0000_0000_0100_0000,
                    type_tran_XYZ7     = 16'b0000_0000_1000_0000,
                    type_tran_XYZ8     = 16'b0000_0001_0000_0000,
                    type_tran_XYZ9     = 16'b0000_0010_0000_0000,
                    type_tran_XYZ10   = 16'b0000_0100_0000_0000,
                    type_tran_XYZ11   = 16'b0000_1000_0000_0000,
                    type_tran_XYZ12   = 16'b0001_0000_0000_0000,
                    type_tran_time1    = 16'b0010_0000_0000_0000,
                    type_tran_time2    = 16'b0100_0000_0000_0000,
                    type_tran_time3    = 16'b1000_0000_0000_0000;
                    
reg [15:0]type_tran_state;
reg [2:0]type_tranctrl_cnt;

always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
    begin
        type_tran_done          <= 1'b0;
        type_tran_invalid        <= 1'b0;
        type_tran_outready    <= 1'b1;
        type_tranctrl_cnt         <= 3'd0;
        type_tran_state           <= type_tran_idle;
    end
else
    case(type_tran_state)
        type_tran_idle:
            begin
                type_tran_done          <= 1'b0;
                type_tran_invalid        <= 1'b0;
                type_tran_outready    <= 1'b1;
                type_tranctrl_cnt         <= 3'd0;
                if(type_tran_en)
                    begin
                        type_tran_state   <= type_tran_XYZ1;
                    end
            end
            
        type_tran_XYZ1:
            begin
                type_tran_indata            <= type_tran_inXYZ[383:352];
                if(type_tranctrl_cnt < 3'd4)
                    type_tranctrl_cnt        <= type_tranctrl_cnt + 1'b1;
                if(type_tranctrl_cnt == 3'd0)
                    type_tran_invalid        <= 1'b1;
                else if(type_tran_invalid == 3'd1)
                    type_tran_invalid        <= 1'b0;
                else if(type_tran_outvalid)
                    begin
                        type_tranctrl_cnt    <= 3'd0;
                        type_tran_outXYZ[767:704]   <= type_tran_outdata;
                        type_tran_state      <= type_tran_XYZ2;
                    end
            end
        
        type_tran_XYZ2:
            begin
                type_tran_indata            <= type_tran_inXYZ[351:320];
                if(type_tranctrl_cnt < 3'd4)
                    type_tranctrl_cnt        <= type_tranctrl_cnt + 1'b1;
                if(type_tranctrl_cnt == 3'd0)
                    type_tran_invalid        <= 1'b1;
                else if(type_tran_invalid == 3'd1)
                    type_tran_invalid        <= 1'b0;
                else if(type_tran_outvalid)
                    begin
                        type_tranctrl_cnt    <= 3'd0;
                        type_tran_outXYZ[703:640]   <= type_tran_outdata;
                        type_tran_state      <= type_tran_XYZ3;
                    end
            end
            
        type_tran_XYZ3:
            begin
                type_tran_indata            <= type_tran_inXYZ[319:288];
                if(type_tranctrl_cnt < 3'd4)
                    type_tranctrl_cnt        <= type_tranctrl_cnt + 1'b1;
                if(type_tranctrl_cnt == 3'd0)
                    type_tran_invalid        <= 1'b1;
                else if(type_tran_invalid == 3'd1)
                    type_tran_invalid        <= 1'b0;
                else if(type_tran_outvalid)
                    begin
                        type_tranctrl_cnt    <= 3'd0;
                        type_tran_outXYZ[639:576]   <= type_tran_outdata;
                        type_tran_state      <= type_tran_XYZ4;
                    end
            end 
            
        type_tran_XYZ4:
            begin
                type_tran_indata            <= type_tran_inXYZ[287:256];
                if(type_tranctrl_cnt < 3'd4)
                    type_tranctrl_cnt        <= type_tranctrl_cnt + 1'b1;
                if(type_tranctrl_cnt == 3'd0)
                    type_tran_invalid        <= 1'b1;
                else if(type_tran_invalid == 3'd1)
                    type_tran_invalid        <= 1'b0;
                else if(type_tran_outvalid)
                    begin
                        type_tranctrl_cnt    <= 3'd0;
                        type_tran_outXYZ[575:512]   <= type_tran_outdata;
                        type_tran_state      <= type_tran_XYZ5;
                    end
            end
            
         type_tran_XYZ5:
            begin
                type_tran_indata            <= type_tran_inXYZ[255:224];
                if(type_tranctrl_cnt < 3'd4)
                    type_tranctrl_cnt        <= type_tranctrl_cnt + 1'b1;
                if(type_tranctrl_cnt == 3'd0)
                    type_tran_invalid        <= 1'b1;
                else if(type_tran_invalid == 3'd1)
                    type_tran_invalid        <= 1'b0;
                else if(type_tran_outvalid)
                    begin
                        type_tranctrl_cnt    <= 3'd0;
                        type_tran_outXYZ[511:448]   <= type_tran_outdata;
                        type_tran_state      <= type_tran_XYZ6;
                    end
            end
            
        type_tran_XYZ6:
            begin
                type_tran_indata            <= type_tran_inXYZ[223:192];
                if(type_tranctrl_cnt < 3'd4)
                    type_tranctrl_cnt        <= type_tranctrl_cnt + 1'b1;
                if(type_tranctrl_cnt == 3'd0)
                    type_tran_invalid        <= 1'b1;
                else if(type_tran_invalid == 3'd1)
                    type_tran_invalid        <= 1'b0;
                else if(type_tran_outvalid)
                    begin
                        type_tranctrl_cnt    <= 3'd0;
                        type_tran_outXYZ[447:384]   <= type_tran_outdata;
                        type_tran_state      <= type_tran_XYZ7;
                    end
            end
                                   
        type_tran_XYZ7:
            begin
                type_tran_indata            <= type_tran_inXYZ[191:160];
                if(type_tranctrl_cnt < 3'd4)
                    type_tranctrl_cnt        <= type_tranctrl_cnt + 1'b1;
                if(type_tranctrl_cnt == 3'd0)
                    type_tran_invalid        <= 1'b1;
                else if(type_tran_invalid == 3'd1)
                    type_tran_invalid        <= 1'b0;
                else if(type_tran_outvalid)
                    begin
                        type_tranctrl_cnt    <= 3'd0;
                        type_tran_outXYZ[383:320]   <= type_tran_outdata;
                        type_tran_state      <= type_tran_XYZ8;
                    end
            end
           
        type_tran_XYZ8:
            begin
                type_tran_indata            <= type_tran_inXYZ[159:128];
                if(type_tranctrl_cnt < 3'd4)
                    type_tranctrl_cnt        <= type_tranctrl_cnt + 1'b1;
                if(type_tranctrl_cnt == 3'd0)
                    type_tran_invalid        <= 1'b1;
                else if(type_tran_invalid == 3'd1)
                    type_tran_invalid        <= 1'b0;
                else if(type_tran_outvalid)
                    begin
                        type_tranctrl_cnt    <= 3'd0;
                        type_tran_outXYZ[319:256]   <= type_tran_outdata;
                        type_tran_state      <= type_tran_XYZ9;
                    end
            end
            
        type_tran_XYZ9:
            begin
                type_tran_indata            <= type_tran_inXYZ[127:96];
                if(type_tranctrl_cnt < 3'd4)
                    type_tranctrl_cnt        <= type_tranctrl_cnt + 1'b1;
                if(type_tranctrl_cnt == 3'd0)
                    type_tran_invalid        <= 1'b1;
                else if(type_tran_invalid == 3'd1)
                    type_tran_invalid        <= 1'b0;
                else if(type_tran_outvalid)
                    begin
                        type_tranctrl_cnt    <= 3'd0;
                        type_tran_outXYZ[255:192]   <= type_tran_outdata;
                        type_tran_state      <= type_tran_XYZ10;
                    end
            end
            
        type_tran_XYZ10:
            begin
                type_tran_indata            <= type_tran_inXYZ[95:64];
                if(type_tranctrl_cnt < 3'd4)
                    type_tranctrl_cnt        <= type_tranctrl_cnt + 1'b1;
                if(type_tranctrl_cnt == 3'd0)
                    type_tran_invalid        <= 1'b1;
                else if(type_tran_invalid == 3'd1)
                    type_tran_invalid        <= 1'b0;
                else if(type_tran_outvalid)
                    begin
                        type_tranctrl_cnt    <= 3'd0;
                        type_tran_outXYZ[191:128]   <= type_tran_outdata;
                        type_tran_state      <= type_tran_XYZ11;
                    end
            end
            
        type_tran_XYZ11:
            begin
                type_tran_indata            <= type_tran_inXYZ[63:32];
                if(type_tranctrl_cnt < 3'd4)
                    type_tranctrl_cnt        <= type_tranctrl_cnt + 1'b1;
                if(type_tranctrl_cnt == 3'd0)
                    type_tran_invalid        <= 1'b1;
                else if(type_tran_invalid == 3'd1)
                    type_tran_invalid        <= 1'b0;
                else if(type_tran_outvalid)
                    begin
                        type_tranctrl_cnt    <= 3'd0;
                        type_tran_outXYZ[127:64]   <= type_tran_outdata;
                        type_tran_state      <= type_tran_XYZ12;
                    end
            end        
           
        type_tran_XYZ12:
            begin
                type_tran_indata            <= type_tran_inXYZ[31:0];
                if(type_tranctrl_cnt < 3'd4)
                    type_tranctrl_cnt        <= type_tranctrl_cnt + 1'b1;
                if(type_tranctrl_cnt == 3'd0)
                    type_tran_invalid        <= 1'b1;
                else if(type_tran_invalid == 3'd1)
                    type_tran_invalid        <= 1'b0;
                else if(type_tran_outvalid)
                    begin
                        type_tranctrl_cnt    <= 3'd0;
                        type_tran_outXYZ[63:0]   <= type_tran_outdata;
                        type_tran_state      <= type_tran_time1;
                    end
            end
            
        type_tran_time1:
            begin
                type_tran_indata            <= type_tran_intime[95:64];
                if(type_tranctrl_cnt < 3'd4)
                    type_tranctrl_cnt        <= type_tranctrl_cnt + 1'b1;
                if(type_tranctrl_cnt == 3'd0)
                    type_tran_invalid        <= 1'b1;
                else if(type_tran_invalid == 3'd1)
                    type_tran_invalid        <= 1'b0;
                else if(type_tran_outvalid)
                    begin
                        type_tranctrl_cnt    <= 3'd0;
                        type_tran_outtime[191:128]   <= type_tran_outdata;
                        type_tran_state      <= type_tran_time2;
                    end
            end
            
        type_tran_time2:
            begin
                type_tran_indata            <= type_tran_intime[63:32];
                if(type_tranctrl_cnt < 3'd4)
                    type_tranctrl_cnt        <= type_tranctrl_cnt + 1'b1;
                if(type_tranctrl_cnt == 3'd0)
                    type_tran_invalid        <= 1'b1;
                else if(type_tran_invalid == 3'd1)
                    type_tran_invalid        <= 1'b0;
                else if(type_tran_outvalid)
                    begin
                        type_tranctrl_cnt    <= 3'd0;
                        type_tran_outtime[127:64]   <= type_tran_outdata;
                        type_tran_state      <= type_tran_time3;
                    end
            end
            
        type_tran_time3:
            begin
                type_tran_indata            <= type_tran_intime[31:0];
                if(type_tranctrl_cnt < 3'd4)
                    type_tranctrl_cnt        <= type_tranctrl_cnt + 1'b1;
                if(type_tranctrl_cnt == 3'd0)
                    type_tran_invalid        <= 1'b1;
                else if(type_tran_invalid == 3'd1)
                    type_tran_invalid        <= 1'b0;
                else if(type_tran_outvalid)
                    begin
                        type_tranctrl_cnt    <= 3'd0;
                        type_tran_outtime[63:0]   <= type_tran_outdata;
                        type_tran_state      <= type_tran_idle;
                        type_tran_done      <= 1'b1;
                    end
            end
            
        default:
                     type_tran_state      <= type_tran_idle;                       
    endcase            
            
endmodule
