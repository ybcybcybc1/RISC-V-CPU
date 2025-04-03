//��̬������תָ�����ת��ַ

`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"

module bpu(
	input[`XLEN-1:0]	pc,//��ǰpc
	input[`XLEN:0]		instruction,//ָ��
	input				flush_flag,//��ˢ��ˮ�߱�־
	input[`XLEN-1:0]	flush_addr,//��ˢ��ˮ����װ��ַ
	
	output[`XLEN-1:0]	pc_pred//Ԥ�����һ��PC
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
