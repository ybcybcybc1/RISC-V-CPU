//实例化一个数据ram模块，进行访存
`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"
module mem(
	input	clk_ram,
	input	[`XLEN-1:0]	rd_in,
	input 	rd_en_in,
	input	[`XREG_ADDRWIDTH-1:0]rd_addr_in,	
	
	input	[4:0]	load_flag_in,
	input	[3:0]	store_flag_in,
	input	[`XLEN-1:0] store_data_in,
	
	output	[`XLEN-1:0]	rd_out,
	output	rd_en_out,
	output	[`XREG_ADDRWIDTH-1:0]rd_addr_out,

	input				read_flag_out,//外部读出标志
	input		[15:0]	read_addr_out,//外部读出地址
	output[`XLEN-1:0]	read_data_out//外部读出数据（32）位
	
    );
	
wire[`XLEN-1:0]	read_out;//存储器读出数据

assign	rd_en_out = rd_en_in;//判断是否有写回数据
assign	rd_addr_out = rd_addr_in;
assign	rd_out = 	(rd_en_in == `TURE)	?	((load_flag_in == `NO_LOAD)	?	rd_in					://非读取类有写回指令
											(load_flag_in == `LOAD_B)	?	{{24{read_out[7]}} , read_out[7:0]}	://写回符号位拓展的一字节
											(load_flag_in == `LOAD_H)	?	{{24{read_out[15]}} , read_out[15:0]}	://写回符号位拓展的两字节
											(load_flag_in == `LOAD_W)	?	read_out				://写回四字节
											(load_flag_in == `LOAD_BU)	?	(read_out & 32'hff)		://写回零扩展的一字节
											(load_flag_in == `LOAD_HU)	?	(read_out & 32'hffff)	://写回零扩展的两字节
																						`ZERO_32BIT):
																						`ZERO_32BIT;
																						

data_ram data_ram_u (
  .clka(clk_ram),    // input wire clka
  .ena(`TURE),      // input wire ena
  .wea(store_flag_in),      // input wire [3 : 0] wea
  .addra(rd_in[15:2]),  // input wire [13 : 0] addra
  .dina(store_data_in),    // input wire [31 : 0] dina
  .douta(read_out),  // output wire [31 : 0] douta
  //端口二供外部数据读取
  .clkb(clk_ram),    // input wire clkb
  .enb(read_flag_out),      // input wire enb
  .web(4'b0000),      // input wire [3 : 0] web
  .addrb(read_addr_out[15:2]),  // input wire [13 : 0] addrb
  .dinb(`ZERO_32BIT),    // input wire [31 : 0] dinb
  .doutb(read_data_out)  // output wire [31 : 0] doutb
);


endmodule
