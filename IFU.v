//ʵ��ͨ��pc�Ĵ��������ĵ�ַȡָ//
//ͨ�����ֻ��������ˮ��-����ģ�����ָ���//

`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"
module IFU(
	input	clk,
	input	rst
	
	
	
	
	
	
	
	
	
    );
//��������
wire[`XLEN-1 : 0]	pc;

//�Ĵ�������
reg	pc_en;
reg	pc_write_en;
reg[`XLEN-1 : 0]	pc_write_data;
	
	
	
	
	
pc_reg	pc0(
	.clk(clk),
	.rst(rst),
	.pc_en(pc_en),
	.pc_addr(pc),
	.pc_write_flag(pc_write_en),
	.pc_write_addr(pc_write_data)
);
endmodule
