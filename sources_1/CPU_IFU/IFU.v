//1-ͨ��pc�Ĵ��������ĵ�ַȡָ
//2-����תָ����о�̬Ԥ�⣺
//	��������תԤ��Ϊ��
//	��jalָ��Ԥ��Ϊ����
//	��jalrָ��Ԥ��Ϊ������������ݳ�ͻ���⣨�������Ż���
//3-���biuԤ����������ˮ�߳�ϴ�źţ�����PC��ֵ
//�ݲ�ʵ�ֳ�ˢ��ˮ�߹���


`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"
module ifu(
	input	clk,
	input	rst,
	
//	input				flush_flag,//��ˢ��ˮ�߱�־
//	input[`XLEN-1:0]	flush_addr,//��ˢ��ˮ����װ��ַ
	input[`XLEN-1:0]	instruction_in,//�洢������ָ��
	
	output[`XLEN-1:0]	pc,//��ǰָ��pc
	output[`XLEN-1:0]	instruction_out//��������ģ���ԭʼָ��
	
    );
//��������
wire[6:0]		opcode;//biu��Ҫ�Ĳ�����
wire[31:0]		imm;//biu��Ҫ��������
wire[`XLEN-1 : 0]	next_pc;

//�Ĵ�������
reg	pc_en;//PC�Ĵ���ʹ��
reg	pc_write_en;//PC�Ĵ���д��ʹ��
reg[`XLEN-1 : 0]	pc_write_data;


always@(posedge clk or	posedge	rst)begin
	if(rst == `RST_ENABLE)begin
		pc_en <= `CMD_ENABLE;
		pc_write_en <= `WRITE_ENABLE;
		pc_write_data <= `BOOT_IT_ADDR;//��λʱд��ָ��洢������ַ
	end
	else begin
		pc_en <= `CMD_ENABLE;
		pc_write_en <= `WRITE_ENABLE;
		pc_write_data <= next_pc;//д��Ԥ����һ����ַ
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
