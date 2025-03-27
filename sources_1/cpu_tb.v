`timescale 1ns / 1ps
module cpu_tb(
    );
reg clk;
reg rst;
initial begin
	clk = 1'b0;
	rst = 1'b1;
	#1
	rst = 1'b0;
end	
always begin
	#3
	clk = 1'b1;
	#3
	clk = 1'b0;
	
end
	
	
cpu_top cpu_top_u(
	.sys_clk(clk),
	.sys_rst_p(rst)
);
	
	
	
	
endmodule
