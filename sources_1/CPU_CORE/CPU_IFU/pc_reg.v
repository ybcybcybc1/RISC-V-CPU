//һ��֧�ֶ�д�����õ�PC�Ĵ���//

`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"

module	pc_reg(

	input						clk,//ʱ������
	input						rst,//�����ź�
	
	output	reg	[`XLEN-1 : 0]	pc_addr,//�Ĵ����е�ָ���ַ
	
	input						pc_write_en,//��дpc�Ĵ�����־
	input		[`XLEN-1 : 0]	pc_write_addr//Ҫд���pc��ַ
	
);


always@(posedge	clk or posedge	rst)begin
	if(rst == `RST_ENABLE)
		pc_addr <= `BOOT_IT_ADDR;
	else if((pc_write_en == `WRITE_ENABLE) && (pc_write_addr < `BOOT_IT_ADDR+`IT_RAM_DEPTH) && (pc_write_addr >= `BOOT_IT_ADDR))//���д���ַ�Ƿ�Ϸ�
		pc_addr <= pc_write_addr;
end


	
endmodule