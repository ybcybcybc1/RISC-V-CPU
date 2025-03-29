//根据简答译码结果计算跳转指令的跳转地址
//pc计算使用专用计算模块，不占用后续资源
//对

`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"

module bpu(
	input[`XLEN-1:0]	pc,//当前pc
	input[31:0]			imm,//计算需要的立即数
	input[6:0]			opcode,//指令操作码
	
	input				flush_flag,//冲刷流水线标志
	input[`XLEN-1:0]	flush_addr,//冲刷流水线重装地址
	
	output[`XLEN-1:0]	pc_pred//预测的下一个PC
    );
	
assign	pc_pred	=	(flush_flag == `TURE)	? (flush_addr)						:
					(opcode == `OPCODE_JAL) ? (pc + imm)						: 
					((opcode == `OPCODE_BREACH) && (imm[31] == 1)) ?(pc + imm)	:
																   (pc + 3'b100);

endmodule
