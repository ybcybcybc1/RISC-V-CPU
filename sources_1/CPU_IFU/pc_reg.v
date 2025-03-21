//一个支持读写、重置的PC寄存器//

`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"

module	pc_reg(

	input						clk,//时钟输入
	input						rst,//重置信号
	
	input						pc_en,//使能信号
	output	reg	[`XLEN-1 : 0]	pc_addr,//寄存器中的指令地址
	
	input						pc_write_flag,//改写pc寄存器标志
	input		[`XLEN-1 : 0]	pc_write_addr//要写入的pc地址
	
);

always@(posedge	clk or posedge	rst)begin
	if(rst == `RST_ENABLE)
		pc_addr <= `BOOT_IT_ADDR;
	else if((pc_write_flag == `WRITE_ENABLE) && (pc_write_addr[1:0] == 2'b00) && (pc_write_addr < `BOOT_IT_ADDR+`IT_RAM_DEPTH))
			//检查写入的数据是否能被4整除
			pc_addr <= pc_write_addr;
	else	
		pc_addr <= pc_addr + 3'd4;
end


	
endmodule