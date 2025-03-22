//定义一片连续的地址空间用来存储指令或数据
`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"

module ram(
	input					ram_en,//使能信号
		
	input					read_flag,//读出标志
	input		[`XLEN-1:0]	read_addr,//读出地址
	output	reg	[`XLEN-1:0]	read_data,//读出数据（32）位
	
	input					write_flag,//写入标志
	input		[`XLEN-1:0]	write_addr,//写入地址
	input		[`XLEN-1:0]	write_data,//写入的数据
	input		[2:0]		write_size//写入的位宽
			
    );
//设定存储器的宽度和深度,以及起始地址//
parameter	MEM_BASE = `ZERO_32BIT;
parameter	MEM_DEPTH = 16'hffff;
parameter	MEM_WIDTH = 4'h8;

//定义整片存储空间
reg	[MEM_WIDTH-1 : 0]	mem [MEM_BASE + MEM_DEPTH - 1 :MEM_BASE];

//进行写操作
always@(posedge	clk)begin
	if(ram_en == 1'b1)begin
		if((write_flag == `WRITE_ENABLE) && (write_addr >= MEM_BASE) && (write_addr <= MEM_BASE + MEM_DEPTH-1'b1))begin
			if(write_size == `STORE_W)begin//写一个word
				mem[write_addr] <= write_data[7:0];
				mem[write_addr+1'h1] <= write_data[15:8];
				mem[write_addr+2'h2] <= write_data[23:16];
				mem[write_addr+2'h3] <= write_data[31:24];//小端模式
			end
			else if(write_size == `STORE_H)begin//写一个半字
				mem[write_addr] <= write_data[7:0];
				mem[write_addr+1'h1] <= write_data[15:8];
			end
			else if(write_size == `STORE_B)begin//写一个字节
				mem[write_addr] <= write_data[7:0];
			end
		end
	end
end

//进行读操作
always@(posedge	clk)begin
	if(ram_en == 1'b1)begin
		if(read_flag == `READ_ENABLE)begin//固定读取数据位宽为四字节
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
