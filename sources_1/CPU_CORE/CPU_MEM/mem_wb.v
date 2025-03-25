//同步更新访存阶段的输出到通用寄存器堆的写回接口
`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"
module mem_wb(
	input	clk,
	input	rst,
	
	input	[`XLEN-1:0]	rd_in,
	input	rd_en_in,
	input	[`XREG_ADDRWIDTH-1:0]rd_addr_in,
	
	output reg	[`XLEN-1:0]	rd_out,
	output reg	rd_en_out,
	output reg	[`XREG_ADDRWIDTH-1:0]rd_addr_out
    );

always@(posedge clk or posedge rst)begin
	if(rst == `RST_ENABLE) begin
		rd_out <= `ZERO_32BIT;
		rd_en_out <= `FALSE;
		rd_addr_out <= {`XREG_ADDRWIDTH{0}};
	end
	else begin
		rd_out <= rd_in;
		rd_en_out <= rd_en_in;
		rd_addr_out <= rd_addr_in;
	end	
end
	
endmodule
