//静态计算跳转指令的跳转地址

`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"

module bpu(
	input[`XLEN-1:0]	pc,//当前pc
	input[`XLEN:0]		instruction,//指令
	input				flush_flag,//冲刷流水线标志
	input[`XLEN-1:0]	flush_addr,//冲刷流水线重装地址
	
	output[`XLEN-1:0]	pc_pred//预测的下一个PC
    );

wire	jal_flag;
wire	breach_flag;
wire[31:0]	imm;


assign	jal_flag = (instruction[6:0] == `OPCODE_JAL);
assign	breach_flag = (instruction[6:0] == `OPCODE_BREACH);
assign  imm = jal_flag     ?  {{12{instruction[31]}},instruction[19:12],instruction[20],instruction[30:21],1'b0}  :
              breach_flag  ?  {{20{instruction[31]}},instruction[7],instruction[30:25],instruction[11:8],1'b0}    :
                                                                                                    `ZERO_32BIT   ;

assign	pc_pred	=	(flush_flag == `TURE)			? (flush_addr)		:
					jal_flag			   		    ? (pc + imm)		: 
					(breach_flag && (imm[31] == 1)) ? (pc + imm)		:
												   (pc + 3'b100)		;

endmodule
