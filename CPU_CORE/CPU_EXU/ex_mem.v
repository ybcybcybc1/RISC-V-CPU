//使ex模块的输出同步时钟更新
`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"
module ex_mem(
	input	clk,
	input	rst,
	
	input [`XLEN-1:0]		rd_in,
	input				rd_en_in,
	input[`XREG_ADDRWIDTH-1:0]rd_addr_in,
	
	input[4:0]			load_flag_in,
	input[3:0]			store_flag_in,
	input[`XLEN-1:0]	store_data_in,
	
	output reg[`XLEN-1:0]	rd_out,
	output reg				rd_en_out,
	output reg[`XREG_ADDRWIDTH-1:0]rd_addr_out,	
	
	output reg[4:0]			load_flag_out,
	output reg[3:0]			store_flag_out,
	output reg[`XLEN-1:0]	store_data_out
    );
	
	
always@(posedge clk or posedge rst)begin
	if(rst == `RST_ENABLE)begin
		rd_out <= `ZERO_32BIT;
		rd_en_out <= `FALSE;
		rd_addr_out <= 5'b0;
		load_flag_out <= `NO_LOAD;
		store_flag_out <= `NO_STORE;
		store_data_out <= `ZERO_32BIT;
	end
	else begin
		rd_out <= rd_in;
		rd_en_out <= rd_en_in;
		rd_addr_out <= rd_addr_in;
		load_flag_out <= load_flag_in;
		store_flag_out <= store_flag_in;
		store_data_out <= store_data_in;
	end
end
	
	
	
endmodule
