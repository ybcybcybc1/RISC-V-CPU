//ʵ����һ������ramģ�飬���зô�
`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"
module mem(
	input	clk,
	input	rst,
	input	[`XLEN-1:0]	rd_in,
	input 	rd_en_in,
	input	[`XREG_ADDRWIDTH-1:0]rd_addr_in,	
	
	input	[4:0]	load_flag_in,
	input	[2:0]	store_flag_in,
	input	[`XLEN-1:0] store_data_in,
	
	output	[`XLEN-1:0]	rd_out,
	output	rd_en_out,
	output	[`XREG_ADDRWIDTH-1:0]rd_addr_out,

	input				read_flag_out,//�ⲿ������־
	input		[15:0]	read_addr_out,//�ⲿ������ַ
	output[`XLEN-1:0]	read_data_out//�ⲿ�������ݣ�32��λ
	
    );
	
wire	write_en;
wire	read_en;	
wire[`XLEN-1:0]	read_out;//�洢����������

assign	write_en = (store_flag_in != `NO_STORE);//�洢��д��ʹ��
assign	read_en = (load_flag_in != `NO_LOAD);//�洢������ʹ��
assign	rd_en_out = rd_en_in;//�ж��Ƿ���д������
assign	rd_addr_out = rd_addr_in;
assign	rd_out = 	(rd_en_in == `TURE)	?	((read_en == `FALSE)			?	rd_in					://�Ƕ�ȡ����д��ָ��
											(load_flag_in == `LOAD_B)	?	{{24{read_out[7]}} , read_out[7:0]}	://д�ط���λ��չ��һ�ֽ�
											(load_flag_in == `LOAD_H)	?	{{24{read_out[15]}} , read_out[15:0]}	://д�ط���λ��չ�����ֽ�
											(load_flag_in == `LOAD_W)	?	read_out				://д�����ֽ�
											(load_flag_in == `LOAD_BU)	?	(read_out & 32'hff)		://д������չ��һ�ֽ�
											(load_flag_in == `LOAD_HU)	?	(read_out & 32'hffff)	://д������չ�����ֽ�
																						`ZERO_32BIT):
																						`ZERO_32BIT;
																						


	
ram #(.MEM_BASE(`BOOT_DATA_ADDR) , .MEM_DEPTH(`DATA_RAM_DEPTH) , .MEM_WIDTH(`DATA_RAM_WIDTH))
data_ram(
	.clk(clk),
	.rst(rst),
	.ram_en(`TURE),
	.read_flag(read_en),
	.read_addr(rd_in[15:0]),
	.read_data(read_out),
	.write_flag(write_en),
	.write_addr(rd_in[15:0]),
	.write_data(store_data_in),
	.write_size(store_flag_in),
	.read_flag_out(read_flag_out),//�ⲿ������־
	.read_addr_out(read_addr_out),//�ⲿ������ַ
	.read_data_out(read_data_out)//�ⲿ�������ݣ�32��λ
);


endmodule
