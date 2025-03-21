//һ��֧�ֶ�д�����õ�PC�Ĵ���//

`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"

module	pc_reg(

	input						clk,//ʱ������
	input						rst,//�����ź�
	
	input						pc_en,//ʹ���ź�
	output	reg	[`XLEN-1 : 0]	pc_addr,//�Ĵ����е�ָ���ַ
	
	input						pc_write_flag,//��дpc�Ĵ�����־
	input		[`XLEN-1 : 0]	pc_write_addr//Ҫд���pc��ַ
	
);

always@(posedge	clk or posedge	rst)begin
	if(rst == `RST_ENABLE)
		pc_addr <= `BOOT_IT_ADDR;
	else if((pc_write_flag == `WRITE_ENABLE) && (pc_write_addr[1:0] == 2'b00) && (pc_write_addr < `BOOT_IT_ADDR+`IT_RAM_DEPTH))
			//���д��������Ƿ��ܱ�4����
			pc_addr <= pc_write_addr;
	else	
		pc_addr <= pc_addr + 3'd4;
end


	
endmodule