/*********************************
**			全局宏定义			**
*********************************/
`define		RST_ENABLE		1'b1//复位信号有效
`define		RST_DISABLE		1'b0//复位信号无效

`define 	WRITE_ENABLE	1'b1//使能写信号
`define 	WRITE_DISABLE	1'b0//失能写信号

`define 	READ_ENABLE		1'b1//使能读信号
`define 	READ_DISABLE	1'b0//失能读信号

`define		ZERO_32BIT		32'h00_000_000//32位数据0

`define		TURE			1'b1//逻辑真
`define		FALSE			1'b0//逻辑假

`define		XLEN			6'd32//通用寄存器宽度	



/*********************************
**			指令操作码定义			**
*********************************/
`define		OPCODE_AUIPC	7'b0010111//指令AUIPC的操作码
`define		OPCODE_LUI		7'b0110111//指令LUI的操作码
`define		OPCODE_JAL		7'b1101111//指令JAL的操作码
`define		OPCODE_JALR		7'b1100111//指令JALR	的操作码
`define		OPCODE_LOAD		7'b0000011//LOAD类指令的操作码
`define		OPCODE_STORE	7'b0100011//STORE类指令的操作码
`define		OPCODE_ALI		7'b0010011//I型逻辑运算类指令
`define		OPCODE_ALR		7'b0110011//R型逻辑运算类指令
`define		OPCODE_BREACH	7'b1100011//逻辑跳转类指令






