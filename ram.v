//定义一片连续的地址空间用来存储指令和数据
`include	"D:\Grade2\RISC_V\CPU\CPU.sim\config.v"

module ram(
	input					clk,//时钟信号
	input					ram_en,//使能信号
		
	input					read_flag,//读出标志
	input					read_addr,//读出地址
	output	reg	[`XLEN-1:0]	read_data,//读出数据（32）位
	
	input					write_flag,//写入标志
	input					write_addr,//写入地址
	input		[`XLEN-1:0]	write_data//写入的数据
			
    );

//定义整片存储空间
reg	[`IT_RAM_WIDTH-1 : 0]	mem [`IT_RAM_DEPTH + `DATA_RAM_DEPTH - 1 :0];

//进行写操作
always@(posedge	clk)begin
	if(ram_en == 1'b1)begin
		if(write_flag == `WRITE_ENABLE)begin
			mem[write_addr] <= write_data[7:0];
			mem[write_addr+1'h1] <= write_data[15:8];
			mem[write_addr+2'h2] <= write_data[23:16];
			mem[write_addr+2'h3] <= write_data[31:24];//小端模式
		end
	end
end

//进行读操作
always@(posedge	clk)begin
	if(ram_en == 1'b1)begin
		if(read_flag == `READ_ENABLE)begin
			read_data[7:0] <= mem[read_addr];
			read_data[15:8] <= mem[read_addr+1'h1];
			read_data[23:16] <= mem[read_addr+2'h2];
			read_data[31:24] <= mem[read_addr+2'h3];//小端模式
		end
	end
	else
		read_data <= `ZERO_32BIT;
end

	
	
	
	
endmodule
