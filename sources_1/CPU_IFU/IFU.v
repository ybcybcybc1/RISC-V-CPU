//1-通过pc寄存器给出的地址取指
//2-对跳转指令进行静态预测：
//	对条件跳转预测为跳
//	对jal指令预测为跳，
//	对jalr指令预测为不跳，规避数据冲突问题（后续可优化）
//3-结合biu预测结果，和流水线冲洗信号，更新PC的值
//暂不实现冲刷流水线功能


`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"
module ifu(
	input	clk,
	input	rst,
	
//	input				flush_flag,//冲刷流水线标志
//	input[`XLEN-1:0]	flush_addr,//冲刷流水线重装地址
	input[`XLEN-1:0]	instruction_in,//存储器读出指令
	
	output[`XLEN-1:0]	pc,//当前指令pc
	output[`XLEN-1:0]	instruction_out//传给译码模块的原始指令
	
    );
//线网定义
wire[6:0]		opcode;//biu需要的操作码
wire[31:0]		imm;//biu需要的立即数
wire[`XLEN-1 : 0]	next_pc;

//寄存器定义
reg	pc_en;//PC寄存器使能
reg	pc_write_en;//PC寄存器写入使能
reg[`XLEN-1 : 0]	pc_write_data;


always@(posedge clk or	posedge	rst)begin
	if(rst == `RST_ENABLE)begin
		pc_en <= `CMD_ENABLE;
		pc_write_en <= `WRITE_ENABLE;
		pc_write_data <= `BOOT_IT_ADDR;//复位时写入指令存储器基地址
	end
	else begin
		pc_en <= `CMD_ENABLE;
		pc_write_en <= `WRITE_ENABLE;
		pc_write_data <= next_pc;//写入预测下一个地址
	end
	
	
end
	
	
	

idu	simp_idu(
	.instruction(instruction_in),
	.pc_in(pc),
	.rs1_en(),
	.rs2_en(),
	.rd_en(),	
	.dec_rs1(),
	.dec_rs2(),	
	.dec_rd(),
	.opcode(opcode),
	.func7(),
	.func3(),
	.imm_num(imm),
	.pc_out()
);	
	
pc_reg	pc0(
	.clk(clk),
	.rst(rst),
	.pc_en(pc_en),
	.pc_addr(pc),
	.pc_write_flag(pc_write_en),
	.pc_write_addr(pc_write_data)
);

biu	bpu_u(
	.pc(pc),
	.imm(imm),
	.opcode(opcode),
	.pc_pred(next_pc)
);


endmodule
