//负责判断前级指令是否有数据相关性并将数据旁路传输给IDU//
`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"
module hazerd_ctrl(

	input	rs1_en_id,//操作数1使能
	input	rs2_en_id,//操作数2使能
	input[`XREG_ADDRWIDTH-1:0]	rs1_addr_id,//操作数1索引
	input[`XREG_ADDRWIDTH-1:0]	rs2_addr_id,//操作数2索引
	input[`XLEN-1:0]	rs1_data_id,//操作数1当前在存储器中的值
	input[`XLEN-1:0]	rs2_data_id,//操作数2当前在存储器中的值
	
	input	rd_en_ex,//前级指令是否有写回寄存器
	input[`XREG_ADDRWIDTH-1:0]	rd_addr_ex,//前级指令的写回寄存器地址
	input[`XLEN-1:0]	rd_data_ex,//前级指令的写回数据
	input[4:0]			ex_load_flag,//前级指令是否是load类指令->相关的数据在ex阶段无法得到
	
	input	rd_en_mem,//前前级指令是否有写回寄存器
	input[`XREG_ADDRWIDTH-1:0]	rd_addr_mem,//前前级指令的写回寄存器地址
	input[`XLEN-1:0]	rd_data_mem,//前前级指令的写回数据

	input	rd_en_wb,//前前前级指令是否有写回寄存器
	input[`XREG_ADDRWIDTH-1:0]	rd_addr_wb,//前前前级指令的写回寄存器地址
	input[`XLEN-1:0]	rd_data_wb,//前前前级指令的写回数据
	
	output	load_hazerd_stall,//是否有前级指令为load指令且引起相关性问题
	
	output [`XLEN-1:0]	rs1_out,//仲裁得到的最新操作数1
	output [`XLEN-1:0]	rs2_out//仲裁得到的最新操作数2
	
    );
//判断是否需要暂停流水线//
assign	load_hazerd_stall = (ex_load_flag != `NO_LOAD) && (rd_en_ex == `TURE) && (((rs1_addr_id == rd_addr_ex) && (rs1_en_id == rd_en_ex)) || ((rs2_addr_id == rd_addr_ex) && (rs2_en_id == rd_en_ex)));
//判断操作数1和操作数2//

assign rs1_out = (rs1_en_id == `FALSE) 									? `ZERO_32BIT	:
				((rd_en_ex == `TURE) && (rd_addr_ex == rs1_addr_id)) 	? rd_data_ex 	:
				((rd_en_mem == `TURE) && (rd_addr_mem == rs1_addr_id))	? rd_data_mem	:
				((rd_en_wb == `TURE) && (rd_addr_wb == rs1_addr_id)) 	? rd_data_wb 	:	
																		  rs1_data_id 	;


assign rs2_out = (rs2_en_id == `FALSE) 									? `ZERO_32BIT	:
				((rd_en_ex == `TURE) && (rd_addr_ex == rs2_addr_id)) 	? rd_data_ex 	:
				((rd_en_mem == `TURE) && (rd_addr_mem == rs2_addr_id))	? rd_data_mem	:
				((rd_en_wb == `TURE) && (rd_addr_wb == rs2_addr_id)) 	? rd_data_wb 	:	
																		  rs2_data_id 	;


endmodule