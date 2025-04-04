`timescale 1ns / 1ps
module cpu_tb(
    );
reg clk;
reg rst;
wire[31:0] data;
initial begin
	clk = 1'b0;
	rst = 1'b1;
	#100
	rst = 1'b0;
end	
always begin//50MHz

	#10
	clk = 1'b1;
	#10
	clk = 1'b0;
	
end
	
	
cpu_top cpu_top_u(
	.sys_clk(clk),
	.sys_rst_p(rst),
	.data_flag(1'b1),
	.data_addr(16'hffdb),
	.data_out(data)
);
	
	
	
	
endmodule
