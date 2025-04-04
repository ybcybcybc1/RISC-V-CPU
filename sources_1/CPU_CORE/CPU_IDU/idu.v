//����ģ��//
//����ǰ��������ģ��������룬����ָ�����͡��������ͼĴ�����ַ//
//ָ���������ͬ��ʱ�����룬����ֻ��Ҫ����ӳ�����Ӧ��Ϣ������Ҫͬ��ʱ��//
//J��ָ�����JAL
//U��ָ�����LUI��AUIPC
//B��ָ�����BEQ��BNE��BLT��BGE��BLTU��BGEU
//I��ָ�������ת��JALR��������LB��LH��LW��LBU��LHU��������ADDI��SLTI��SUTIU��XORI��ORI��ANDI
//S��ָ������洢��SB��SH��SW
//R��ָ�����ʣ���R���߼�����ָ��
//CS��ָ�����λ��������������չ���Ƿ���λ��չ


//�������ˮ�ߵ�д��RD������IDģ�飬�Խ�����ڡ���һ������������RAW�����������//
`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"
module idu(
	input[`XLEN-1:0]	instruction,//�����Դ32λָ��
	input[`XLEN-1:0]	pc_in,//��ǰָ��ĵ�ַ
	
	output		rs1_en,//������1�Ĵ���ʹ��
	output[`XREG_ADDRWIDTH-1:0]	dec_rs1,//������1�Ĵ���
	output		rs2_en,//������2�Ĵ���ʹ��
	output[`XREG_ADDRWIDTH-1:0]	dec_rs2,//������2�Ĵ�����������������һ���֣�
	output		rd_en,//Ŀ��Ĵ���ʹ��
	output[`XREG_ADDRWIDTH-1:0]	dec_rd,//Ŀ��Ĵ���(ͬʱ������Ϊ��ת�ʹ洢ָ���������)
	
	output[6:0]		opcode,//������־��
	output[6:0]		func7,//func7��
	output[2:0]		func3,//func3��
	output[31:0]	imm_num,//����λ��չ���32λ������
	
	output[`XLEN-1:0]	pc_out//��ǰָ��ĵ�ַ
    );

wire [2:0]	it_type;//ָʾָ��ĸ�ʽ����
wire [6:0]	imm;//��ʾָ���ǰ7λ������

//���ո�ʽ�����������//
assign	opcode = instruction[6:0];
assign	dec_rd = instruction[11:7];
assign	func3 = instruction[14:12];
assign	dec_rs1 = instruction[19:15];
assign	dec_rs2 = instruction[24:20];
assign	imm = instruction[31:25];
assign	func7 = instruction[31:25];


//�ж�ָ���ʽ����
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
//�ж��Ƿ��дĿ��Ĵ���
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
//���ݸ�ʽ���͸���32λ��չ��������
assign	imm_num = 	(it_type == `I_TYPE) ? {{21{instruction[31]}},instruction[30:20]}											:
					(it_type == `U_TYPE) ? {instruction[31:12],12'b0}															:
					(it_type == `S_TYPE) ? {{21{instruction[31]}},instruction[30:25],instruction[11:7]}							:
					(it_type == `B_TYPE) ? {{20{instruction[31]}},instruction[7],instruction[30:25],instruction[11:8],1'b0}		:
					(it_type == `J_TYPE) ? {{12{instruction[31]}},instruction[19:12],instruction[20],instruction[30:21],1'b0}	:
											`ZERO_32BIT;
//���ݱ���ָ���PC
assign	pc_out = pc_in;

endmodule
