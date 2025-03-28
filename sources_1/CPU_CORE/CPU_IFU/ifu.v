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

ram #(.MEM_BASE(`BOOT_IT_ADDR),.MEM_DEPTH(`IT_RAM_DEPTH),.MEM_WIDTH(`IT_RAM_WIDTH))
it_ram(
	.clk(clk),
	.rst(rst),
	.ram_en(`TURE),
	.read_flag(`TURE),
	.read_addr(pc[15:0]),
	.read_data(instruction),
	.write_flag(`FALSE),//������д��
	.write_addr(16'h0000),
	.write_data(`ZERO_32BIT),
	.write_size(`NO_STORE),
	.read_flag_out(),//ָ��洢��û���ⲿ����˿�
	.read_addr_out(),
	.read_data_out()

);


endmodule
