//1-通过pc寄存器给出的地址取指
//2-对跳转指令进行静态预测：
//	对条件跳转预测为跳
//	对jal指令预测为跳，
//	对jalr指令预测为不跳，规避数据冲突问题（后续可优化）
//3-结合biu预测结果，和流水线冲洗信号，更新PC的值
//暂不实现冲刷流水线功能


`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"
module ifu(
	input	clk,//提供给pc寄存器的同步时钟
	input	rst,//提供给pc寄存器的同步复位

	input	clk_ram,//提供给bram的快速时钟
	input	uart_done,//完成四一字节数据接收
    input[7:0]	buffer,//一字节数据缓冲
    input[15:0]  data_addr,//要写入的指令存储地址

	
	input				flush_flag,//冲刷流水线标志
	input[`XLEN-1:0]	flush_addr,//冲刷流水线重装地址
	input				load_hazerd,//流水线暂停标志
	
	output[`XLEN-1:0]	pc,//当前指令pc
	output[`XLEN-1:0]	instruction
	
    );
//线网定义
wire[6:0]		opcode;//biu需要的操作码
wire[31:0]		imm;//biu需要的立即数
wire[`XLEN-1 : 0]	next_pc;
wire	pc_write_en;//PC寄存器写入使能
wire[`XLEN-1 : 0]	pc_write_data;

assign	pc_write_en = ~load_hazerd;//暂停信号来临时，不允许pc更新
assign	pc_write_data = next_pc;
	

	

idu	simp_idu(
	.instruction(instruction),
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
	.pc_addr(pc),
	.pc_write_en(pc_write_en),
	.pc_write_addr(pc_write_data)
);

bpu	bpu_u(
	.pc(pc),
	.imm(imm),
	.flush_flag(flush_flag),
	.flush_addr(flush_addr),
	.opcode(opcode),
	.pc_pred(next_pc)
);

it_ram it_ram_u
(
    .clka(clk_ram),
    .ena(`TURE),
    .wea(uart_done),
    .addra(data_addr),
    .dina(buffer),
    .clkb(clk_ram),
    .enb(`TURE),
    .addrb(pc[15:2]),
    .doutb(instruction)
);


endmodule
