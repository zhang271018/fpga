`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/20 09:31:20
// Design Name: 
// Module Name: matrix_tran
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

//matrix transform 3x3
module matrix_tran(
 Clk,
 Rst_n,
 tran_en,

     A0,
     A1,
     A2,

    tran_A_0,
    tran_A_1,
    tran_A_2,
    
  tran_done
);
 
output reg      [191:0]tran_A_0;
output reg      [191:0]tran_A_1;
output reg      [191:0]tran_A_2;
output reg      tran_done;

input wire [191:0]A0;
input wire [191:0]A1;
input wire [191:0]A2;


input tran_en;
input Clk;
input Rst_n;

always@(posedge Clk or negedge Rst_n)
if(!Rst_n)
    begin
        tran_A_0    <= 191'd0;
        tran_A_1    <= 191'd0;
        tran_A_2    <= 191'd0;
        tran_done  <= 1'b0;
    end
    else if(tran_en)
        begin
            tran_A_0[191:128] <= A0[191:128];
            tran_A_0[128:64]   <= A1[191:128];
            tran_A_0[63:0]       <= A2[191:128];
            
            tran_A_1[191:128] <= A0[127:64];
            tran_A_1[128:64]   <= A1[127:64];
            tran_A_1[63:0]       <= A2[127:64];
            
            tran_A_2[191:128] <= A0[63:0];
            tran_A_2[128:64]   <= A1[63:0];
            tran_A_2[63:0]       <= A2[63:0];
            
            tran_done              <= 1'b1;
        end
    else
        tran_done  <= 1'b0;
    
endmodule
