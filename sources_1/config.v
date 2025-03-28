/*********************************
**			全局宏定义			**
*********************************/

`define		ZERO_32BIT		32'h00_000_000//32位数据0
`define		XLEN			6'd32//通用寄存器宽度	
`define		XREG_ADDRWIDTH	3'h5//通用寄存器地址宽度

`define		BOOT_IT_ADDR	16'h0000//指令存储器基地址
`define		IT_RAM_DEPTH	13'h1000	//指令存储器深度
`define		IT_RAM_WIDTH	4'h8	//指令存储器宽度

`define		BOOT_DATA_ADDR	16'h1000//数据存储器基地址
`define		DATA_RAM_DEPTH	13'h1000	//数据存储器深度
`define		DATA_RAM_WIDTH	4'h8		//数据存储器宽度



/*********************************
**			通用标识符定义			**
*********************************/
`define		TURE			1'b1//逻辑真
`define		FALSE			1'b0//逻辑假

`define		RST_ENABLE		1'b1//复位信号有效
`define		RST_DISABLE		1'b0//复位信号无效

`define 	WRITE_ENABLE	1'b1//使能写信号
`define 	WRITE_DISABLE	1'b0//失能写信号

`define 	READ_ENABLE		1'b1//使能读信号
`define 	READ_DISABLE	1'b0//失能读信号
/*********************************
**			指令标识符定义			**
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
//func3标识符
`define		FUNC3_000		3'b000//funct3码	000
`define		FUNC3_001		3'b001//funct3码	001	
`define		FUNC3_010		3'b010//funct3码	010
`define		FUNC3_011		3'b011//funct3码	011
`define		FUNC3_100		3'b100//funct3码	100
`define		FUNC3_101		3'b101//funct3码	101
`define		FUNC3_110		3'b110//funct3码	110
`define		FUNC3_111		3'b111//funct3码	111
//func7标识符
`define		FUNC7_0_000_000	7'b0_000_000//funct7码0_000_000
`define		FUNC7_0_100_000	7'b0_100_000//funct7码0_100_000
//指令格式标识符
`define		ERR_TYPE		3'b000
`define		I_TYPE			3'b001
`define		S_TYPE			3'b010
`define		U_TYPE			3'b011
`define		R_TYPE			3'b100
`define		B_TYPE			3'b101
`define		J_TYPE			3'b110
`define		CSR_TYPE		3'b111
//LOAD指令标识符
`define 	NO_LOAD				5'b00000
`define		LOAD_B				5'b00001
`define		LOAD_H				5'b00010
`define		LOAD_W				5'b00100
`define		LOAD_BU				5'b01000
`define		LOAD_HU				5'b10000
//STORE指令标识符
`define		NO_STORE		3'b000
`define		STORE_B			3'b001
`define		STORE_H			3'b010
`define		STORE_W			3'b100





