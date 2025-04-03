//提供锁定的时钟信号
module pll(
    input   clk,
    input   rst,
    output  clk1,
    output  clk2
    );

wire    clk_out1;
wire    clk_out2;
wire    loaked;

assign clk1 = (locked == 1'b1)  ?   clk_out1    :   1'b0;
assign clk2 = (locked == 1'b1)  ?   clk_out2    :   1'b0;

clk_wiz_0 clk_wiz_0_u
(
    // Clock out ports
    .clk_out1(clk_out1),     // output clk_out1
    .clk_out2(clk_out2),     // output clk_out2
    // Status and control signals
    .reset(rst), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(clk)
);      // input clk_in1
endmodule
