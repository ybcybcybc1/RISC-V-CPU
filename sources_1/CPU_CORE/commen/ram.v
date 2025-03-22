//����һƬ�����ĵ�ַ�ռ������洢ָ�������
`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"

module ram(
	input					ram_en,//ʹ���ź�
		
	input					read_flag,//������־
	input		[`XLEN-1:0]	read_addr,//������ַ
	output	reg	[`XLEN-1:0]	read_data,//�������ݣ�32��λ
	
	input					write_flag,//д���־
	input		[`XLEN-1:0]	write_addr,//д���ַ
	input		[`XLEN-1:0]	write_data,//д�������
	input		[2:0]		write_size//д���λ��
			
    );
//�趨�洢���Ŀ�Ⱥ����,�Լ���ʼ��ַ//
parameter	MEM_BASE = `ZERO_32BIT;
parameter	MEM_DEPTH = 16'hffff;
parameter	MEM_WIDTH = 4'h8;

//������Ƭ�洢�ռ�
reg	[MEM_WIDTH-1 : 0]	mem [MEM_BASE + MEM_DEPTH - 1 :MEM_BASE];

//����д����
always@(posedge	clk)begin
	if(ram_en == 1'b1)begin
		if((write_flag == `WRITE_ENABLE) && (write_addr >= MEM_BASE) && (write_addr <= MEM_BASE + MEM_DEPTH-1'b1))begin
			if(write_size == `STORE_W)begin//дһ��word
				mem[write_addr] <= write_data[7:0];
				mem[write_addr+1'h1] <= write_data[15:8];
				mem[write_addr+2'h2] <= write_data[23:16];
				mem[write_addr+2'h3] <= write_data[31:24];//С��ģʽ
			end
			else if(write_size == `STORE_H)begin//дһ������
				mem[write_addr] <= write_data[7:0];
				mem[write_addr+1'h1] <= write_data[15:8];
			end
			else if(write_size == `STORE_B)begin//дһ���ֽ�
				mem[write_addr] <= write_data[7:0];
			end
		end
	end
end

//���ж�����
always@(posedge	clk)begin
	if(ram_en == 1'b1)begin
		if(read_flag == `READ_ENABLE)begin//�̶���ȡ����λ��Ϊ���ֽ�
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
