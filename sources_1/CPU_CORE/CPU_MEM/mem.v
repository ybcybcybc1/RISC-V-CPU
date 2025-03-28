//实例化一个数据ram模块，进行访存
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

	input				read_flag_out,//外部读出标志
	input		[15:0]	read_addr_out,//外部读出地址
	output[`XLEN-1:0]	read_data_out//外部读出数据（32）位
	
    );
	
wire	write_en;
wire	read_en;	
wire[`XLEN-1:0]	read_out;//存储器读出数据

assign	write_en = (store_flag_in != `NO_STORE);//存储器写入使能
assign	read_en = (load_flag_in != `NO_LOAD);//存储器读出使能
assign	rd_en_out = rd_en_in;//判断是否有写回数据
assign	rd_addr_out = rd_addr_in;
assign	rd_out = 	(rd_en_in == `TURE)	?	((read_en == `FALSE)			?	rd_in					://非读取类有写回指令
											(load_flag_in == `LOAD_B)	?	{{24{read_out[7]}} , read_out[7:0]}	://写回符号位拓展的一字节
											(load_flag_in == `LOAD_H)	?	{{24{read_out[15]}} , read_out[15:0]}	://写回符号位拓展的两字节
											(load_flag_in == `LOAD_W)	?	read_out				://写回四字节
											(load_flag_in == `LOAD_BU)	?	(read_out & 32'hff)		://写回零扩展的一字节
											(load_flag_in == `LOAD_HU)	?	(read_out & 32'hffff)	://写回零扩展的两字节
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
	.read_flag_out(read_flag_out),//外部读出标志
	.read_addr_out(read_addr_out),//外部读出地址
	.read_data_out(read_data_out)//外部读出数据（32）位
);


endmodule
