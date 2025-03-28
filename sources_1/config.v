/*********************************
**			ȫ�ֺ궨��			**
*********************************/

`define		ZERO_32BIT		32'h00_000_000//32λ����0
`define		XLEN			6'd32//ͨ�üĴ������	
`define		XREG_ADDRWIDTH	3'h5//ͨ�üĴ�����ַ���

`define		BOOT_IT_ADDR	16'h0000//ָ��洢������ַ
`define		IT_RAM_DEPTH	13'h1000	//ָ��洢�����
`define		IT_RAM_WIDTH	4'h8	//ָ��洢�����

`define		BOOT_DATA_ADDR	16'h1000//���ݴ洢������ַ
`define		DATA_RAM_DEPTH	13'h1000	//���ݴ洢�����
`define		DATA_RAM_WIDTH	4'h8		//���ݴ洢�����



/*********************************
**			ͨ�ñ�ʶ������			**
*********************************/
`define		TURE			1'b1//�߼���
`define		FALSE			1'b0//�߼���

`define		RST_ENABLE		1'b1//��λ�ź���Ч
`define		RST_DISABLE		1'b0//��λ�ź���Ч

`define 	WRITE_ENABLE	1'b1//ʹ��д�ź�
`define 	WRITE_DISABLE	1'b0//ʧ��д�ź�

`define 	READ_ENABLE		1'b1//ʹ�ܶ��ź�
`define 	READ_DISABLE	1'b0//ʧ�ܶ��ź�
/*********************************
**			ָ���ʶ������			**
*********************************/
`define		OPCODE_AUIPC	7'b0010111//ָ��AUIPC�Ĳ�����
`define		OPCODE_LUI		7'b0110111//ָ��LUI�Ĳ�����
`define		OPCODE_JAL		7'b1101111//ָ��JAL�Ĳ�����
`define		OPCODE_JALR		7'b1100111//ָ��JALR	�Ĳ�����
`define		OPCODE_LOAD		7'b0000011//LOAD��ָ��Ĳ�����
`define		OPCODE_STORE	7'b0100011//STORE��ָ��Ĳ�����
`define		OPCODE_ALI		7'b0010011//I���߼�������ָ��
`define		OPCODE_ALR		7'b0110011//R���߼�������ָ��
`define		OPCODE_BREACH	7'b1100011//�߼���ת��ָ��
//func3��ʶ��
`define		FUNC3_000		3'b000//funct3��	000
`define		FUNC3_001		3'b001//funct3��	001	
`define		FUNC3_010		3'b010//funct3��	010
`define		FUNC3_011		3'b011//funct3��	011
`define		FUNC3_100		3'b100//funct3��	100
`define		FUNC3_101		3'b101//funct3��	101
`define		FUNC3_110		3'b110//funct3��	110
`define		FUNC3_111		3'b111//funct3��	111
//func7��ʶ��
`define		FUNC7_0_000_000	7'b0_000_000//funct7��0_000_000
`define		FUNC7_0_100_000	7'b0_100_000//funct7��0_100_000
//ָ���ʽ��ʶ��
`define		ERR_TYPE		3'b000
`define		I_TYPE			3'b001
`define		S_TYPE			3'b010
`define		U_TYPE			3'b011
`define		R_TYPE			3'b100
`define		B_TYPE			3'b101
`define		J_TYPE			3'b110
`define		CSR_TYPE		3'b111
//LOADָ���ʶ��
`define 	NO_LOAD				5'b00000
`define		LOAD_B				5'b00001
`define		LOAD_H				5'b00010
`define		LOAD_W				5'b00100
`define		LOAD_BU				5'b01000
`define		LOAD_HU				5'b10000
//STOREָ���ʶ��
`define		NO_STORE		3'b000
`define		STORE_B			3'b001
`define		STORE_H			3'b010
`define		STORE_W			3'b100





