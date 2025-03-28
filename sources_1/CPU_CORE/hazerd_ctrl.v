//�����ж�ǰ��ָ���Ƿ�����������Բ���������·�����IDU//
`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"
module hazerd_ctrl(

	input	rs1_en_id,//������1ʹ��
	input	rs2_en_id,//������2ʹ��
	input[`XREG_ADDRWIDTH-1:0]	rs1_addr_id,//������1����
	input[`XREG_ADDRWIDTH-1:0]	rs2_addr_id,//������2����
	input[`XLEN-1:0]	rs1_data_id,//������1��ǰ�ڴ洢���е�ֵ
	input[`XLEN-1:0]	rs2_data_id,//������2��ǰ�ڴ洢���е�ֵ
	
	input	rd_en_ex,//ǰ��ָ���Ƿ���д�ؼĴ���
	input[`XREG_ADDRWIDTH-1:0]	rd_addr_ex,//ǰ��ָ���д�ؼĴ�����ַ
	input[`XLEN-1:0]	rd_data_ex,//ǰ��ָ���д������
	input[4:0]			ex_load_flag,//ǰ��ָ���Ƿ���load��ָ��->��ص�������ex�׶��޷��õ�
	
	input	rd_en_mem,//ǰǰ��ָ���Ƿ���д�ؼĴ���
	input[`XREG_ADDRWIDTH-1:0]	rd_addr_mem,//ǰǰ��ָ���д�ؼĴ�����ַ
	input[`XLEN-1:0]	rd_data_mem,//ǰǰ��ָ���д������

	input	rd_en_wb,//ǰǰǰ��ָ���Ƿ���д�ؼĴ���
	input[`XREG_ADDRWIDTH-1:0]	rd_addr_wb,//ǰǰǰ��ָ���д�ؼĴ�����ַ
	input[`XLEN-1:0]	rd_data_wb,//ǰǰǰ��ָ���д������
	
	output	load_hazerd_stall,//�Ƿ���ǰ��ָ��Ϊloadָ�����������������
	
	output [`XLEN-1:0]	rs1_out,//�ٲõõ������²�����1
	output [`XLEN-1:0]	rs2_out//�ٲõõ������²�����2
	
    );
//�ж��Ƿ���Ҫ��ͣ��ˮ��//
assign	load_hazerd_stall = (ex_load_flag != `NO_LOAD) && (rd_en_ex == `TURE) && (((rs1_addr_id == rd_addr_ex) && (rs1_en_id == rd_en_ex)) || ((rs2_addr_id == rd_addr_ex) && (rs2_en_id == rd_en_ex)));
//�жϲ�����1�Ͳ�����2//

assign rs1_out = (rs1_en_id == `FALSE) 									? `ZERO_32BIT	:
				((rd_en_ex == `TURE) && (rd_addr_ex == rs1_addr_id)) 	? rd_data_ex 	:
				((rd_en_mem == `TURE) && (rd_addr_mem == rs1_addr_id))	? rd_data_mem	:
				((rd_en_wb == `TURE) && (rd_addr_wb == rs1_addr_id)) 	? rd_data_wb 	:	
																		  rs1_data_id 	;


assign rs2_out = (rs2_en_id == `FALSE) 									? `ZERO_32BIT	:
				((rd_en_ex == `TURE) && (rd_addr_ex == rs2_addr_id)) 	? rd_data_ex 	:
				((rd_en_mem == `TURE) && (rd_addr_mem == rs2_addr_id))	? rd_data_mem	:
				((rd_en_wb == `TURE) && (rd_addr_wb == rs2_addr_id)) 	? rd_data_wb 	:	
																		  rs2_data_id 	;


endmodule