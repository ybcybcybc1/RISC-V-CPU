//实现对译码模块输出数据的算数与逻辑运算//
`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"
module alu(
	
	input signed	[`XLEN-1:0]			rs1_in,
	input signed	[`XLEN-1:0]			rs2_in,
	input[6:0]			opcode_in,
	input[2:0]			func3_in,
	input[6:0]			func7_in,
	input[`XLEN-1:0]	pc_in,
	input				rd_en_in,
	input[`XREG_ADDRWIDTH-1:0]rd_addr_in,
	input signed		[31:0]			imm_in,
	
	output				jalr_branch_flag,//提示是预测失败的jalr或分支跳转信号
	output[`XLEN-1:0]	jalr_branch_addr,//jalr或分支指令跳转的目标
	
	output[`XLEN-1:0]			rd_out,//计算出的写回结果
	output				rd_en_out,//指示是否有写回结果(B/S类指令没有)
	output[`XREG_ADDRWIDTH-1:0]rd_addr_out,	//传递写回的寄存器索引
	
	output[4:0]			load_flag,//提示是否为load指令以及类型
	output[2:0]			store_flag,//提示是否为store类指令以及类型
	output[`XLEN-1:0]	store_data//store类指令存入的数据
	
    );
//store类指令标识符
assign	store_flag = (opcode_in == `OPCODE_STORE) ?		((func3_in == `FUNC3_000) ? `STORE_B 	:
														(func3_in == `FUNC3_001) ? `STORE_H 	:
														(func3_in == `FUNC3_010) ? `STORE_W		:
																					`NO_LOAD)	:
																						`NO_LOAD;
//传递rs2操作数为存储数据
assign	store_data = rs2_in;
//load指令标识符
assign	load_flag = (opcode_in == `OPCODE_LOAD) ?		((func3_in == `FUNC3_000) ? `LOAD_B 	:
														(func3_in == `FUNC3_001) ? `LOAD_H 		:
														(func3_in == `FUNC3_010) ? `LOAD_W 		:
														(func3_in == `FUNC3_100) ? `LOAD_BU		:
														(func3_in == `FUNC3_101) ? `LOAD_HU		:
																					`NO_LOAD)	:
																						`NO_LOAD;
																				
//定义一个内部的信号，用于判断条件跳转是否执行
wire	b_valid;
assign b_valid = ((func3_in == `FUNC3_000) && (rs1_in == rs2_in))	?	`TURE	://BEQ
			  	  ((func3_in == `FUNC3_001) && (rs1_in != rs2_in))	?	`TURE	://BNE
			  	  ((func3_in == `FUNC3_100) && (rs1_in <  rs2_in))	?	`TURE	://BLT
				  ((func3_in == `FUNC3_101) && (rs1_in >= rs2_in))	?	`TURE	://BGE
				  ((func3_in == `FUNC3_110) && ({1'b0,rs1_in} <  {1'b0,rs2_in}))	?	`TURE	://BLTU
				  ((func3_in == `FUNC3_111) && ({1'b0,rs1_in} >= {1'b0,rs2_in}))	?	`TURE	://BGEU
																						`FALSE	;
//判断是否需要冲刷流水线->JALR指令或是向前跳转的条件跳转//
assign	jalr_branch_flag = 	(opcode_in == `OPCODE_JALR)	    	      				?	`TURE	:
   	((b_valid == `TURE) && (opcode_in == `OPCODE_BREACH) && (imm_in[31] == 1'b0))	?	`TURE	:
																						`FALSE	;

//旁路给出冲刷流水线的地址
assign	jalr_branch_addr = (opcode_in == `OPCODE_JALR)	?	((rs1_in + imm_in) & 32'd1)	:
					       (opcode_in == `OPCODE_JALR)	?	(pc_in + imm_in)			:
																			 `ZERO_32BIT;						

//传递rd寄存器索引和使能标志
assign	rd_addr_out = rd_addr_in;	
assign	rd_en_out = rd_en_in;

//指令写回结果														
assign	rd_out = (opcode_in == `OPCODE_JAL)	?	(pc_in + 3'd4)	://JAR
				 (opcode_in == `OPCODE_JALR)	?	(pc_in + 3'd4) & ~1	://JALR
				 (opcode_in == `OPCODE_AUIPC)	?	(pc_in + (imm_in[31:12] << 12))	://AUIPC
				 (opcode_in == `OPCODE_LUI)	?	(imm_in[31:12] << 12)	://LUI
				 ((opcode_in == `OPCODE_ALI) && (func3_in == `FUNC3_000))	?	(rs1_in + imm_in)	://ADDI
				 ((opcode_in == `OPCODE_ALI) && (func3_in == `FUNC3_010))	?	(rs1_in < imm_in)		://SLTI
				 ((opcode_in == `OPCODE_ALI) && (func3_in == `FUNC3_011))	?	({1'b0,rs1_in} < {1'b0,imm_in})	://SLTIU
				 ((opcode_in == `OPCODE_ALI) && (func3_in == `FUNC3_100))	?	(rs1_in ^ imm_in)		://XORI
				 ((opcode_in == `OPCODE_ALI) && (func3_in == `FUNC3_110))	?	(rs1_in | imm_in)		://ORI
				 ((opcode_in == `OPCODE_ALI) && (func3_in == `FUNC3_111))	?	(rs1_in & imm_in)		://ANDI
				 ((opcode_in == `OPCODE_ALI) && (func3_in == `FUNC3_001) && (func7_in == `FUNC7_0_000_000))	?	(rs1_in <<< imm_in[4:0])://SLLI
				 ((opcode_in == `OPCODE_ALI) && (func3_in == `FUNC3_101) && (func7_in == `FUNC7_0_000_000))	?	(rs1_in >>> imm_in[4:0])://SRLI	
				 ((opcode_in == `OPCODE_ALI) && (func3_in == `FUNC3_101) && (func7_in == `FUNC7_0_100_000))	?	(rs1_in >> imm_in[4:0])	://SRAI
				 ((opcode_in == `OPCODE_ALR) && (func3_in == `FUNC3_000) && (func7_in == `FUNC7_0_000_000))	?	(rs1_in + rs2_in)		://ADD
				 ((opcode_in == `OPCODE_ALR) && (func3_in == `FUNC3_000) && (func7_in == `FUNC7_0_100_000))	?	(rs1_in - rs2_in)		://SUB
				 ((opcode_in == `OPCODE_ALR) && (func3_in == `FUNC3_000) && (func7_in == `FUNC7_0_100_000))	?	(rs1_in <<< rs2_in)		://SLL
				 ((opcode_in == `OPCODE_ALR) && (func3_in == `FUNC3_010) && (func7_in == `FUNC7_0_000_000))	?	(rs1_in < rs2_in)		://SLT
				 ((opcode_in == `OPCODE_ALR) && (func3_in == `FUNC3_011) && (func7_in == `FUNC7_0_000_000))	?	({1'b0,rs1_in} < {1'b0,rs2_in})		://SLTU
				 ((opcode_in == `OPCODE_ALR) && (func3_in == `FUNC3_100) && (func7_in == `FUNC7_0_000_000))	?	({1'b0,rs1_in} ^ {1'b0,rs2_in})		://XOR
				 ((opcode_in == `OPCODE_ALR) && (func3_in == `FUNC3_101) && (func7_in == `FUNC7_0_000_000))	?	(rs1_in >>> rs2_in)		://SRL
				 ((opcode_in == `OPCODE_ALR) && (func3_in == `FUNC3_101) && (func7_in == `FUNC7_0_100_000))	?	(rs1_in >> rs2_in)		://SRA
				 ((opcode_in == `OPCODE_ALR) && (func3_in == `FUNC3_110) && (func7_in == `FUNC7_0_000_000))	?	(rs1_in | rs2_in)		://OR
				 ((opcode_in == `OPCODE_ALR) && (func3_in == `FUNC3_111) && (func7_in == `FUNC7_0_000_000))	?	(rs1_in & rs2_in)		://AND
				 (opcode_in == `OPCODE_LOAD)	?	(rs1_in + imm_in)			://LOAD类指令的访问地址
				 (opcode_in == `OPCODE_STORE)	?	(rs1_in + imm_in)			://STORE类指令的访问地址
				 
																	`ZERO_32BIT	;

	
endmodule
