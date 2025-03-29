//9600�����ʣ�����λ8��ֹͣλ1����У��λ�ļ򵥴��ڽ���ģ��
`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"
module uart(
    input   clk,//����ʱ��
    input   rst_p,//��λ�ź�

    input   uart_rx,
    
    output reg uart_done,//�����һ�ֽ����ݽ���
    output reg [7:0]  buffer,//һ�ֽ����ݻ���
    output reg [15:0]  data_addr//Ҫд���ָ��洢��ַ

    );

parameter   COUNT_MAX = 5208 - 1;
parameter   COUNT_MAX_HALF = 2604 - 1;
parameter   RX_BIT_MAX = 9;


wire clk_capture = (counter_freq == COUNT_MAX_HALF);//��ÿ������λ�м�ɼ�

reg [12:0]counter_freq;//��ϵͳʱ�ӽ��м򵥷�Ƶ
reg rx_flag;//���տ�ʼ��־λ
reg [3:0]rx_counter;//�������ݼ�����

//�ź�������ʱ�������״̬�����ݼ���������������λ
always@(negedge uart_rx or posedge clk_capture)begin
    if(uart_rx == 1'b0)
        rx_flag <= `TURE;
    else if(rx_counter == RX_BIT_MAX)//����ֹͣλ
        rx_flag <= `FALSE;
end

//����״̬ʱ�������ɼ�ʱ��
always@(posedge clk or posedge rst_p)begin
    if(rst_p == `RST_ENABLE)
        counter_freq <= 1'b0;
    else if(rx_flag == `TURE)
         if(counter_freq == COUNT_MAX)
            counter_freq <= 1'b0;
         else   
            counter_freq <= counter_freq + 1'b1;
    else
        counter_freq <= 1'b0;
end
//��ÿ�������м��������λ����
always@(posedge clk_capture or posedge rst_p)begin
    if(rst_p == `RST_ENABLE)
        rx_counter <= 4'b0;
    else if(rx_counter != RX_BIT_MAX)
        rx_counter <= rx_counter + 1'b1;
    else
        rx_counter <= 4'b0;

end

//�Ѳɼ����ݷ����ƫ�ƵĻ�����//
always@(posedge clk_capture)begin
    if((rx_counter != 4'b0) && (rx_counter != 4'h9))
        buffer[rx_counter - 1] <= uart_rx;
end
//���һ���ɼ��ź�֮�����buffer��Чλ
always@(posedge clk_capture or posedge rst_p)begin
    if(rst_p == `RST_ENABLE)
        uart_done <=`FALSE;
    else if(rx_counter == RX_BIT_MAX)
        uart_done <= `TURE;
    else
        uart_done <= `FALSE;
end
//��Ϣ����������һ�����ݵĿ�ʼλˢ��д��ĵ�ַ
always@(posedge rst_p or negedge uart_done)begin
    if(rst_p == `RST_ENABLE)
        data_addr <= 16'b0;
    else
        data_addr <= data_addr + 1'b1;
end

endmodule
