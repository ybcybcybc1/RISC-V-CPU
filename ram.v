//����һƬ�����ĵ�ַ�ռ������洢ָ�������
`include	"D:\Grade2\RISC_V\CPU\CPU.sim\config.v"

module ram(
	input					clk,//ʱ���ź�
	input					ram_en,//ʹ���ź�
		
	input					read_flag,//������־
	input					read_addr,//������ַ
	output	reg	[`XLEN-1:0]	read_data,//�������ݣ�32��λ
	
	input					write_flag,//д���־
	input					write_addr,//д���ַ
	input		[`XLEN-1:0]	write_data//д�������
			
    );

//������Ƭ�洢�ռ�
reg	[`IT_RAM_WIDTH-1 : 0]	mem [`IT_RAM_DEPTH + `DATA_RAM_DEPTH - 1 :0];

//����д����
always@(posedge	clk)begin
	if(ram_en == 1'b1)begin
		if(write_flag == `WRITE_ENABLE)begin
			mem[write_addr] <= write_data[7:0];
			mem[write_addr+1'h1] <= write_data[15:8];
			mem[write_addr+2'h2] <= write_data[23:16];
			mem[write_addr+2'h3] <= write_data[31:24];//С��ģʽ
		end
	end
end

//���ж�����
always@(posedge	clk)begin
	if(ram_en == 1'b1)begin
		if(read_flag == `READ_ENABLE)begin
			read_data[7:0] <= mem[read_addr];
			read_data[15:8] <= mem[read_addr+1'h1];
			read_data[23:16] <= mem[read_addr+2'h2];
			read_data[31:24] <= mem[read_addr+2'h3];//С��ģʽ
		end
	end
	else
		read_data <= `ZERO_32BIT;
end

	
	
	
	
endmodule
