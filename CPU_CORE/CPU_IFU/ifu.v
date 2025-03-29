//1-ͨ��pc�Ĵ��������ĵ�ַȡָ
//2-����תָ����о�̬Ԥ�⣺
//	��������תԤ��Ϊ��
//	��jalָ��Ԥ��Ϊ����
//	��jalrָ��Ԥ��Ϊ������������ݳ�ͻ���⣨�������Ż���
//3-���biuԤ����������ˮ�߳�ϴ�źţ�����PC��ֵ
//�ݲ�ʵ�ֳ�ˢ��ˮ�߹���


`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"
module ifu(
	input	clk,//�ṩ��pc�Ĵ�����ͬ��ʱ��
	input	rst,//�ṩ��pc�Ĵ�����ͬ����λ

	input	clk_ram,//�ṩ��bram�Ŀ���ʱ��
	input	uart_done,//�����һ�ֽ����ݽ���
    input[7:0]	buffer,//һ�ֽ����ݻ���
    input[15:0]  data_addr,//Ҫд���ָ��洢��ַ

	
	input				flush_flag,//��ˢ��ˮ�߱�־
	input[`XLEN-1:0]	flush_addr,//��ˢ��ˮ����װ��ַ
	input				load_hazerd,//��ˮ����ͣ��־
	
	output[`XLEN-1:0]	pc,//��ǰָ��pc
	output[`XLEN-1:0]	instruction
	
    );
//��������
wire[6:0]		opcode;//biu��Ҫ�Ĳ�����
wire[31:0]		imm;//biu��Ҫ��������
wire[`XLEN-1 : 0]	next_pc;
wire	pc_write_en;//PC�Ĵ���д��ʹ��
wire[`XLEN-1 : 0]	pc_write_data;

assign	pc_write_en = ~load_hazerd;//��ͣ�ź�����ʱ��������pc����
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
