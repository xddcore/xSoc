/*全局宏定义*/

`define POSITIVE_RESET //高电平复位
`define NEGATIVE_RESET //低电平复位

`ifdef NEGATIVE_RESET
	`define RESET_EDGE negedge //异步复位信号下降边沿
`else 
	`define RESET_EDGE posedege //异步复位信号上升边沿
`endif

`ifdef NEGATIVE_RESET
	`define RESET_ENABLE 1'b0  //异步复位信号低电平有效
`else 
	`define RESET_ENABLE 1'b1 //异步复位信号高电平有效
`endif

`define ENABLE 1'b1 //高电平有效
`define DISABLE 1'b0 //低电平有效

`define ENABLE_ 1'b0 //有效取反
`define DISABLE_ 1'b1 //无效取反

`define WordAddrLoc 31:2 //字地址位置
`define WORD_ADDR_MSB 29 //地址最高位
`define WORD_ADDR_W 30

`define WORD_DATA_W 32
`define WordDataBus 31:0

`define BYTE_OFFSET_WORD 2'b00 //字边界
`define ByteOffsetLoc 1:0 //字节位移位移
`define BYTE_OFFSET_W 2 //字节偏移宽度

`define WRITE 1'b1
`define READ 1'b0

`define LOW 1'b0
`define HIGHT 1'b0

