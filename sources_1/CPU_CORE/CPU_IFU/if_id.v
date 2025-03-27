`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"
module if_id(
	input	clk,
	input	rst,
	input	load_hazerd,//��ͣ��ˮ�߱�־
	input	flush_flag,//��ˢ��ˮ�߱�־
	
	input[`XLEN-1:0]	pc_in,
	input[`XLEN-1:0]	instruction_in,
	
	output reg[`XLEN-1:0]	pc_out,
	output reg[`XLEN-1:0]	instruction_out
    );
	
	
always@(posedge clk or posedge rst )begin
	if(rst == `RST_ENABLE || flush_flag == `TURE)begin//��ϴʱ�����ָ��
		pc_out <= `ZERO_32BIT;
		instruction_out <= `ZERO_32BIT;
	end
	else if(load_hazerd == `TURE)begin
		pc_out <= pc_out;
		instruction_out <= instruction_out;
	end
	else begin
		pc_out <= pc_in;
		instruction_out <= instruction_in;
	end
end
endmodule
