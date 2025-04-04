采用openmips五级流水线结构设计，分为取指、译码、执行、访存、写回五个部分。

取指阶段，对分支跳转指令采用静态预测。为规避可能的RAW问题，对JALR类指令默认不进行跳转，对JAL指令跳转，对条件跳转指令采取向后跳转，向前不跳转的预测方式。在每个时钟上升沿到来的时候，结合静态预测、地址自增和流水线冲洗信号对PC和指令进行更新。
译码阶段，使用组合逻辑电路，在每个时钟来临时根据更新的输入指令映射成其包含的信息，并直接连接到通用寄存器组，以保证下一时钟来到时可以把指令信息和操作数打包发送给执行模块。
执行阶段，根据译码信息对数据进行处理，并在下一时钟到来时更新执行输出寄存器。
访存阶段，根据传递的指令控制对DATA_RAM的读写，在时钟到来时更新访存输出寄存器的值。
写回阶段，根据传输的数据写回目标通用寄存器。

OPENMIPS五级流水线结构不存在WAW、WAR问题，因为其结构保证了其后级指令不会比前级指令抢先进行（或者说交付、写回）
对于其可能的RAW问题，第一出现在条件跳转指令的取指阶段，因为其需要的操作数并不明确，不能提前知道是否要跳转。解决方式是采用静态预测，根据跳转的地址决定是否跳转。对JALR指令因为目标地址也无法计算所以默认不跳转。预测错误时发出冲刷流水线信号，重启流水线。
第二会出现在译码阶段。此时译码模块需要给出指令需要的操作数，其可能在前级指令中被改写但并为写回完成。解决方法是在执行、访存、写回的组合逻辑电路后，输出寄存器前加入旁路直连通路，反馈到译码阶段。同时检测当前指令的源寄存器和前级三条指令的目标寄存器，取最相邻的旁路数据直接作为译码模块的操作数。
在第二种RAW问题中，比较特殊的是当前级指令为load类指令时，存入rd的数据在执行阶段是算不出来的。必须在访存阶段结束才能得到。此时如果下一条指令与其相关，便无法通过旁路技术解决。解决办法是增加一个模块检测这种情况，在检测到时产生一个失能信号，使执行以前的模块暂停一个周期。

undate:

3.24：
1，修正了上电时初始化逻辑不正确导致的不定态传播。
2，修正了ram滞后pc变化的bug。
3，修正了jal指令中立即数的错误译码。

3.27
1，修正了通用寄存器读数据时滞后控制信号一个周期的bug。
2，修复alu中不能正确发出load、store标志信号的bug。
3，修复访存阶段写入数据有误的bug
4，修复前级指令有load类数据相关时的死循环问题。

3.29
1，使用bram核来实现指令和数据的存储空间，解决无法综合的问题。
2，加入pll模块产生高频时钟供bram使用，解决其输出延迟一拍的问题。
3，在初始化指令前加入一条空指令，解决时钟锁定后第一条指令不能运行的问题


list to do:
1，实现CSR系统指令寄存器及相关指令。
2，完善rv32i余下的指令。
3，添加串口电路，实现对指令的快速烧录。（已完成，未仿真）
4，引出数据存储单元的读取端口。（完成）
5，优化流水线结构，实现多发射乱序执行。
6，加入乘法、除法运算单元。
