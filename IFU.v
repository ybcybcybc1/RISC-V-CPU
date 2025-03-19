//实现通过pc寄存器给出的地址取指//
//通过握手机制与后级流水线-译码模块进行指令传递//

`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"
module IFU(
	input	clk,
	input	rst
	
	
	
	
	
	
	
	
	
    );
//线网定义
wire[`XLEN-1 : 0]	pc;

//寄存器定义
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
