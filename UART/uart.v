//9600波特率，数据位8，停止位1，无校验位的简单串口接收模块
`include	"D:\Grade2\RISC_V\CPU\CPU.srcs\sources_1\config.v"
module uart(
    input   clk,//输入时钟
    input   rst_p,//复位信号

    input   uart_rx,
    
    output reg uart_done,//完成四一字节数据接收
    output reg [7:0]  buffer,//一字节数据缓冲
    output reg [15:0]  data_addr//要写入的指令存储地址

    );

parameter   COUNT_MAX = 5208 - 1;
parameter   COUNT_MAX_HALF = 2604 - 1;
parameter   RX_BIT_MAX = 9;


wire clk_capture = (counter_freq == COUNT_MAX_HALF);//在每个数据位中间采集

reg [12:0]counter_freq;//对系统时钟进行简单分频
reg rx_flag;//接收开始标志位
reg [3:0]rx_counter;//接收数据计数器

//信号线拉低时进入接收状态，数据计数器计数结束后复位
always@(negedge uart_rx or posedge clk_capture)begin
    if(uart_rx == 1'b0)
        rx_flag <= `TURE;
    else if(rx_counter == RX_BIT_MAX)//进入停止位
        rx_flag <= `FALSE;
end

//接收状态时，启动采集时钟
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
//在每个比特中间更新数据位索引
always@(posedge clk_capture or posedge rst_p)begin
    if(rst_p == `RST_ENABLE)
        rx_counter <= 4'b0;
    else if(rx_counter != RX_BIT_MAX)
        rx_counter <= rx_counter + 1'b1;
    else
        rx_counter <= 4'b0;

end

//把采集数据放入带偏移的缓冲区//
always@(posedge clk_capture)begin
    if((rx_counter != 4'b0) && (rx_counter != 4'h9))
        buffer[rx_counter - 1] <= uart_rx;
end
//最后一个采集信号之后更新buffer有效位
always@(posedge clk_capture or posedge rst_p)begin
    if(rst_p == `RST_ENABLE)
        uart_done <=`FALSE;
    else if(rx_counter == RX_BIT_MAX)
        uart_done <= `TURE;
    else
        uart_done <= `FALSE;
end
//信息发出后，在下一段数据的开始位刷新写入的地址
always@(posedge rst_p or negedge uart_done)begin
    if(rst_p == `RST_ENABLE)
        data_addr <= 16'b0;
    else
        data_addr <= data_addr + 1'b1;
end

endmodule
