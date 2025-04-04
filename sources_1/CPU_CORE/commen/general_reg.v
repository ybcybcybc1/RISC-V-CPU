//通用寄存器同时最多写入一个，读取两个//
`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"


module general_reg(

	input	clk,//时钟信号
	input	rst,//复位信号
	
	input			i_write_flag,//写有效标志
	input	[`XREG_ADDRWIDTH-1:0]	i_write_addr,//写入寄存器地址
	input	[`XLEN-1:0]	i_write_data,//写入寄存器数据
	
	input			i_read_flag1,//读有效标志
	input	[`XREG_ADDRWIDTH-1:0]	i_read_addr1,//读寄存器地址
	output reg	[`XLEN-1:0]	o_read_data1,//写入寄存器数据
	
	input			i_read_flag2,//读有效标志
	input	[`XREG_ADDRWIDTH-1:0]	i_read_addr2,//读寄存器地址
	output reg	[`XLEN-1:0]	o_read_data2//写入寄存器数据
	
    );
	
reg	[`XLEN-1:0]	x[31:0];//定义指定位数的寄存器32个

integer i;
//控制写操作//
always@(posedge	clk or posedge rst)begin
	if(rst == `RST_ENABLE)begin
		for (i = 0; i < 6'd32 ; i = i + 1) begin
			x[i] <= 32'b0;
        end		
	end
	else if((i_write_flag == `WRITE_ENABLE) && (i_write_addr != 5'b00000))begin
			x[i_write_addr] <= i_write_data;
	end
end		

//控制读操作1//
always@(*)begin
	if(rst == `RST_ENABLE)
		o_read_data1 <=  `ZERO_32BIT;
	else if(i_read_flag1 == `READ_ENABLE)
		o_read_data1 <=	x[i_read_addr1];
	else
		o_read_data1 <=  `ZERO_32BIT;//不读出时，给出的数据全0；
	
end

//控制读操作2//
always@(*)begin
	if(rst == `RST_ENABLE)
		o_read_data2 <=  `ZERO_32BIT;
	else if(i_read_flag2 == `READ_ENABLE)
		o_read_data2 <=	x[i_read_addr2];
	else
		o_read_data2 <=  `ZERO_32BIT;//不读出时，给出的数据全0；
	
end


endmodule
