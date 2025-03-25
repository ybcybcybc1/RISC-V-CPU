//���ݼ��������������תָ�����ת��ַ
//pc����ʹ��ר�ü���ģ�飬��ռ�ú�����Դ
//��

`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"

module bpu(
	input[`XLEN-1:0]	pc,//��ǰpc
	input[31:0]			imm,//������Ҫ��������
	input[6:0]			opcode,//ָ�������
	
	input				flush_flag,//��ˢ��ˮ�߱�־
	input[`XLEN-1:0]	flush_addr,//��ˢ��ˮ����װ��ַ
	
	output[`XLEN-1:0]	pc_pred//Ԥ�����һ��PC
    );
	
assign	pc_pred	=	(flush_flag == `TURE)	? (flush_addr)						:
					(opcode == `OPCODE_JAL) ? (pc + imm)						: 
					((opcode == `OPCODE_BREACH) && (imm[31] == 1)) ?(pc + imm)	:
																   (pc + 3'b100);

endmodule
