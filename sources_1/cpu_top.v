`timescale 1ns / 1ps
//****************************
//	top module of cpu core
//****************************
`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"
module cpu_top(
	input	sys_clk,
	input	sys_rst_p,
	input	data_flag,
	input [15:0]	data_addr,
	output [`XLEN-1:0]	data_out
    );
wire[`XLEN-1:0]	pc_if;
wire[`XLEN-1:0] instruction_if;
wire[`XLEN-1:0]	pc_if_id;
wire[`XLEN-1:0] instruction_if_id;
wire	rs1_en_id;
wire	rs2_en_id;
wire[`XREG_ADDRWIDTH-1:0] dec_rs1_id;
wire[`XREG_ADDRWIDTH-1:0] dec_rs2_id;
wire	rd_en_id;
wire[`XREG_ADDRWIDTH-1:0] dec_rd_id;
wire[6:0]		opcode_id;
wire[6:0]		func7_id;
wire[2:0]		func3_id;
wire[31:0]		imm_num_id;
wire[`XLEN-1:0] pc_out_id;
//��id_exģ���ͳ�������
wire[`XLEN-1:0]rs1_data_ex;
wire[`XLEN-1:0]rs2_data_ex;
wire[31:0] imm_num_ex;
wire[6:0] opcode_ex;
wire[2:0] func3_ex;
wire[6:0] func7_ex;
wire[`XLEN-1:0] pc_out_ex;
wire rd_en_ex;
wire [`XREG_ADDRWIDTH-1:0]dec_rd_ex;

//��hazerdģ���͵�id_exģ��Ĳ�����
wire[`XLEN-1:0]	rs1_data;
wire[`XLEN-1:0]	rs2_data;
wire	load_hazerd;//ȫ����ˮ����ͣ��־
wire[`XLEN-1:0]	rs1_data_g;
wire[`XLEN-1:0]	rs2_data_g;
//��ˮ�߳�ϴ�ź�
wire flush_flag;
wire[`XLEN-1:0]flush_addr;
//alu������ź�
wire[`XLEN-1:0] rd_data_al;
wire rd_en_al;
wire[`XREG_ADDRWIDTH-1:0]rd_addr_al;
wire[4:0] load_flag_al;
wire[2:0] store_flag_al;
wire[`XLEN-1:0]	store_data_al;
//����memģ����ź�
wire[`XLEN-1:0] rd_data_e;
wire rd_en_e;
wire[`XREG_ADDRWIDTH-1:0] rd_addr_e;
wire[4:0] load_flag_e;
wire[2:0] store_flag_e;
wire[`XLEN-1:0] store_data_e;

wire[`XLEN-1:0] rd_mem;
wire rd_en_mem;
wire[`XREG_ADDRWIDTH-1:0]rd_addr_mem;

//����ͨ�üĴ�����д���ź�
wire[`XLEN-1:0] rd_wb;
wire rd_en_wb;
wire[`XREG_ADDRWIDTH-1:0]rd_addr_wb;

//����ȡָģ��
ifu	ifu_u(
	.clk(sys_clk),
	.rst(sys_rst_p),
	.flush_flag(flush_flag),
	.flush_addr(flush_addr),
	.load_hazerd(load_hazerd),
	.pc(pc_if),
	.instruction(instruction_if)
);

if_id if_id_u(
	.clk(sys_clk),
	.rst(sys_rst_p),
	.flush_flag(flush_flag),
	.load_hazerd(load_hazerd),
	.pc_in(pc_if),
	.instruction_in(instruction_if),
	.pc_out(pc_if_id),
	.instruction_out(instruction_if_id)
);

//��������ģ��
idu idu_u(
	.instruction(instruction_if_id),
	.pc_in(pc_if_id),
	.rs1_en(rs1_en_id),
	.dec_rs1(dec_rs1_id),
	.rs2_en(rs2_en_id),
	.dec_rs2(dec_rs2_id),
	.rd_en(rd_en_id),
	.dec_rd(dec_rd_id),
	.opcode(opcode_id),
	.func7(func7_id),
	.func3(func3_id),
	.imm_num(imm_num_id),
	.pc_out(pc_out_id)
);

id_ex id_ex_u(
	.clk(sys_clk),
	.rst(sys_rst_p),
	.load_hazerd(load_hazerd),
	.flush_flag(flush_flag),
	.opcode_in(opcode_id),
	.func3_in(func3_id),
	.func7_in(func7_id),
	.pc_in(pc_out_id),
	.rd_en_in(rd_en_id),
	.rd_addr_in(dec_rd_id),
	.imm_in(imm_num_id),
	.rs1_in(rs1_data),
	.rs2_in(rs2_data),
	
	.opcode_out(opcode_ex),
	.func3_out(func3_ex),
	.func7_out(func7_ex),
	.pc_out(pc_out_ex),
	.rd_en_out(rd_en_ex),
	.rd_addr_out(dec_rd_ex),
	.imm_out(imm_num_ex),	
	.rs1_out(rs1_data_ex),
	.rs2_out(rs2_data_ex)

);

hazerd_ctrl hazerd_ctrl_u(
	.rs1_en_id(rs1_en_id),
	.rs2_en_id(rs2_en_id),
	.rs1_addr_id(dec_rs1_id),
	.rs2_addr_id(dec_rs2_id),
	.rs1_data_id(rs1_data_g),
	.rs2_data_id(rs2_data_g),
	.rs1_out(rs1_data),
	.rs2_out(rs2_data),
	.rd_en_ex(rd_en_al),//ִ��ģ�����·����
	.rd_addr_ex(rd_addr_al),
	.rd_data_ex(rd_data_al),//
	.ex_load_flag(load_flag_al),
	.rd_en_mem(rd_en_mem),//�ô�ģ�����·����
	.rd_addr_mem(rd_addr_mem),
	.rd_data_mem(rd_mem),
	.rd_en_wb(rd_en_wb),//д�ز��ֵ���·����
	.rd_addr_wb(rd_addr_wb),
	.rd_data_wb(rd_wb),	
	.load_hazerd_stall(load_hazerd)
	


);

general_reg general_reg_u(
	.clk(sys_clk),
	.rst(sys_rst_p),
	.i_write_flag(rd_en_wb),//д�ؽӿ�
	.i_write_addr(rd_addr_wb),
	.i_write_data(rd_wb),
	
	.i_read_flag1(rs1_en_id),
	.i_read_addr1(dec_rs1_id),
	.o_read_data1(rs1_data_g),
	
	.i_read_flag2(rs2_en_id),
	.i_read_addr2(dec_rs2_id),
	.o_read_data2(rs2_data_g)
);

//����ִ��ģ��
alu alu_u(
	.rs1_in(rs1_data_ex),
	.rs2_in(rs2_data_ex),
	.opcode_in(opcode_ex),
	.func3_in(func3_ex),
	.func7_in(func7_ex),
	.pc_in(pc_out_ex),
	.rd_en_in(rd_en_ex),
	.rd_addr_in(dec_rd_ex),
	.imm_in(imm_num_ex),	
	.jalr_branch_flag(flush_flag),
	.jalr_branch_addr(flush_addr),	
	.rd_out(rd_data_al),
	.rd_en_out(rd_en_al),
	.rd_addr_out(rd_addr_al),	
	.load_flag(load_flag_al),
	.store_flag(store_flag_al),
	.store_data(store_data_al)
);

ex_mem	ex_mem_u(
	.clk(sys_clk),
	.rst(sys_rst_p),
	.rd_in(rd_data_al),
	.rd_en_in(rd_en_al),
	.rd_addr_in(rd_addr_al),
	.load_flag_in(load_flag_al),
	.store_flag_in(store_flag_al),
	.store_data_in(store_data_al),
	
	.rd_out(rd_data_e),
	.rd_en_out(rd_en_e),
	.rd_addr_out(rd_addr_e),
	.load_flag_out(load_flag_e),
	.store_flag_out(store_flag_e),
	.store_data_out(store_data_e)
);

//�����ô�ģ��
mem mem_u(
	.clk(sys_clk),
	.rst(sys_rst_p),
	.rd_in(rd_data_e),
	.rd_en_in(rd_en_e),
	.rd_addr_in(rd_addr_e),
	.load_flag_in(load_flag_e),
	.store_flag_in(store_flag_e),
	.store_data_in(store_data_e),
	
	.rd_out(rd_mem),
	.rd_en_out(rd_en_mem),
	.rd_addr_out(rd_addr_mem),
	.read_flag_out(data_flag),//�ⲿ������־
	.read_addr_out(data_addr),//�ⲿ������ַ
	.read_data_out(data_out)//�ⲿ�������ݣ�32��λ	
);

mem_wb mem_wb_u(
	.clk(sys_clk),
	.rst(sys_rst_p),
	.rd_in(rd_mem),
	.rd_en_in(rd_en_mem),
	.rd_addr_in(rd_addr_mem),
	
	.rd_out(rd_wb),
	.rd_en_out(rd_en_wb),
	.rd_addr_out(rd_addr_wb)
	
);


	

endmodule
