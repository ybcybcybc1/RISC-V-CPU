/*********************************
**			ȫ�ֺ궨��			**
*********************************/
`define		RST_ENABLE		1'b1//��λ�ź���Ч
`define		RST_DISABLE		1'b0//��λ�ź���Ч

`define 	WRITE_ENABLE	1'b1//ʹ��д�ź�
`define 	WRITE_DISABLE	1'b0//ʧ��д�ź�

`define 	READ_ENABLE		1'b1//ʹ�ܶ��ź�
`define 	READ_DISABLE	1'b0//ʧ�ܶ��ź�

`define		ZERO_32BIT		32'h00_000_000//32λ����0

`define		TURE			1'b1//�߼���
`define		FALSE			1'b0//�߼���

`define		XLEN			6'd32//ͨ�üĴ������	



/*********************************
**			ָ������붨��			**
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






