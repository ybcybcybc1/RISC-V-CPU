//译码模块//
//根据前级给出的模块进行译码，给出指令类型、立即数和寄存器地址//
//指令的输入是同步时钟输入，译码只需要将其映射出相应信息，不需要同步时序//
//J类指令包括JAL
//U类指令包括LUI、AUIPC
//B类指令包括BEQ、BNE、BLT、BGE、BLTU、BGEU
//I类指令包括跳转类JALR、加载类LB、LH、LW、LBU、LHU、运算类ADDI、SLTI、SUTIU、XORI、ORI、ANDI
//S类指令包括存储类SB、SH、SW
//R类指令包括剩余的R类逻辑运算指令
//CS类指令的五位立即数进行零扩展而非符号位扩展


//加入后级流水线的写入RD反馈至ID模块，以解决相邻、隔一级、隔两级的RAW数据相关问题//
`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"
module idu(
	input[`XLEN-1:0]	instruction,//输入的源32位指令
	input[`XLEN-1:0]	pc_in,//当前指令的地址
	
	output		rs1_en,//操作数1寄存器使能
	output[`XREG_ADDRWIDTH-1:0]	dec_rs1,//操作数1寄存器
	output		rs2_en,//操作数2寄存器使能
	output[`XREG_ADDRWIDTH-1:0]	dec_rs2,//操作数2寄存器（可能是立即数一部分）
	output		rd_en,//目标寄存器使能
	output[`XREG_ADDRWIDTH-1:0]	dec_rd,//目标寄存器(同时可能作为跳转和存储指令的立即数)
	
	output[6:0]		opcode,//操作标志码
	output[6:0]		func7,//func7码
	output[2:0]		func3,//func3码
	output[31:0]	imm_num,//符号位拓展后的32位立即数
	
	output[`XLEN-1:0]	pc_out//当前指令的地址
    );

wire [2:0]	it_type;//指示指令的格式类型
wire [6:0]	imm;//表示指令的前7位立即数

//按照格式分离各段数据//
assign	opcode = instruction[6:0];
assign	dec_rd = instruction[11:7];
assign	func3 = instruction[14:12];
assign	dec_rs1 = instruction[19:15];
assign	dec_rs2 = instruction[24:20];
assign	imm = instruction[31:25];
assign	func7 = instruction[31:25];


//判断指令格式类型
assign	it_type = 	(opcode == `OPCODE_AUIPC)	?	`U_TYPE	:
					(opcode == `OPCODE_LUI)		?	`U_TYPE	:
					(opcode == `OPCODE_JAL)		?	`J_TYPE	:
					(opcode == `OPCODE_JALR)	?	`I_TYPE	:
					(opcode == `OPCODE_LOAD)	?	`I_TYPE	:
					(opcode == `OPCODE_STORE)	?	`S_TYPE	:
					(opcode == `OPCODE_ALI)		?	`I_TYPE	:
					(opcode == `OPCODE_ALR)		?	`R_TYPE	:
					(opcode == `OPCODE_BREACH)	?	`B_TYPE	:
													`ERR_TYPE;
//判断是否读写目标寄存器
assign	rs1_en = 	(it_type == `B_TYPE	||
					 it_type == `R_TYPE	||
					 it_type == `S_TYPE	||
					 it_type == `I_TYPE	);
assign	rd_en = 	(it_type == `U_TYPE	||
					 it_type == `R_TYPE	||
					 it_type == `J_TYPE	||
					 it_type == `I_TYPE	);
assign	rs2_en = 	(it_type == `S_TYPE	||
					 it_type == `R_TYPE	||
					 it_type == `B_TYPE	);					 
//根据格式类型给出32位拓展后立即数
assign	imm_num = 	(it_type == `I_TYPE) ? {{21{instruction[31]}},instruction[30:20]}											:
					(it_type == `U_TYPE) ? {instruction[31:12],12'b0}															:
					(it_type == `S_TYPE) ? {{21{instruction[31]}},instruction[30:25],instruction[11:7]}							:
					(it_type == `B_TYPE) ? {{20{instruction[31]}},instruction[7],instruction[30:25],instruction[11:8],1'b0}		:
					(it_type == `J_TYPE) ? {{12{instruction[31]}},instruction[19:12],instruction[20],instruction[30:21],1'b0}	:
											`ZERO_32BIT;
//传递本条指令的PC
assign	pc_out = pc_in;

endmodule
