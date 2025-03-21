//ͨ�üĴ���ͬʱ���д��һ������ȡ����//
`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"


module general_reg(

	input	clk,//ʱ���ź�
	input	rst,//��λ�ź�
	
	input			i_write_flag,//д��Ч��־
	input	[`XREG_ADDRWIDTH-1:0]	i_write_addr,//д��Ĵ�����ַ
	input	[`XLEN-1:0]	i_write_data,//д��Ĵ�������
	
	input			i_read_flag1,//����Ч��־
	input	[`XREG_ADDRWIDTH-1:0]	i_read_addr1,//���Ĵ�����ַ
	output reg	[`XLEN-1:0]	o_read_data1,//д��Ĵ�������
	
	input			i_read_flag2,//����Ч��־
	input	[`XREG_ADDRWIDTH-1:0]	i_read_addr2,//���Ĵ�����ַ
	output reg	[`XLEN-1:0]	o_read_data2//д��Ĵ�������
	
    );
	
reg	[`XLEN-1:0]	x[31:0];//����ָ��λ���ļĴ���32��


//����д����//
always@(posedge	clk)begin
	if(rst != 1'b1)begin
		if((i_write_flag == `WRITE_ENABLE) && (i_write_addr != 5'b00000))begin
			x[i_write_addr] <= i_write_data;
		end
	end
end		

//���ƶ�����1//
always@(posedge	clk)begin
	if(rst != 1'b1)begin
		if(i_read_flag1 == `READ_ENABLE)begin
			o_read_data1 <=	x[i_read_addr1];
		end
	end
end

//���ƶ�����2//
always@(posedge	clk)begin
	if(rst != 1'b1)begin
		if(i_read_flag2 == `READ_ENABLE)begin
			o_read_data2 <=	x[i_read_addr2];
		end
	end
end

//��λ����Ĵ���//
integer i;
always@(posedge	rst)begin
	if(rst == 1'b1)begin
		for (i = 0; i < 6'd32 ; i = i + 1) begin
			x[i] <= 32'b0;
        end		
	end
end

endmodule
