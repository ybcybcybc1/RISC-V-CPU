//使id模块的输出同步时钟更新
`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"
module id_ex(
	input	clk,//实现同步输出
	input	rst,//同步复位
	input	load_hazerd,//load类数据冲突暂停更新
	input	flush_flag,//冲刷流水线标志
	
	//id组合电路输出的数据//
	input[6:0]			opcode_in,
	input[2:0]			func3_in,
	input[6:0]			func7_in,
	input[`XLEN-1:0]	pc_in,
	input				rd_en_in,
	input[`XREG_ADDRWIDTH-1:0]rd_addr_in,
	input[31:0]			imm_in,
	
	input[`XLEN-1:0]	rs1_in,
	input[`XLEN-1:0]	rs2_in,
	//id部分同步输出的数据
	output reg[6:0]			opcode_out,
	output reg[2:0]			func3_out,
	output reg[6:0]			func7_out,
	output reg[`XLEN-1:0]	pc_out,
	output reg				rd_en_out,
	output reg[`XREG_ADDRWIDTH-1:0]rd_addr_out,
	output reg[31:0]			imm_out,
	
	output reg[`XLEN-1:0]	rs1_out,
	output reg[`XLEN-1:0]	rs2_out
    );
	
always@(posedge clk , posedge rst)begin
	if(rst == `RST_ENABLE || flush_flag == `TURE || load_hazerd == `TURE)begin
		opcode_out <= 7'b0_000_000;
		func3_out <= 3'b000;
		func7_out <= 7'b0_000_000;
		pc_out <= `ZERO_32BIT;
		rd_en_out <= `FALSE;
		rd_addr_out <= `ZERO_32BIT;
		imm_out <= `ZERO_32BIT;
		rs1_out <= `ZERO_32BIT;
		rs2_out <= `ZERO_32BIT;
	end
	else begin
		opcode_out <= opcode_in;
		func3_out <= func3_in;
		func7_out <= func7_in;
		pc_out <= pc_in;
		rd_en_out <= rd_en_in;
		rd_addr_out <= rd_addr_in;
		imm_out <= imm_in;
		rs1_out <= rs1_in;
		rs2_out <= rs2_in;
	end
		
end
endmodule
