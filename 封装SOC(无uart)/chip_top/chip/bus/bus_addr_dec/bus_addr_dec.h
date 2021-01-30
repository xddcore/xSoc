/*地址解码器*/

/*
地址与从属设备对应关系(8等分)
0号:0x0000_0000 - 0x1fff_ffff 只读存储器ROM 3'b000
1号:0x2000_0000 - 0x3fff_ffff	暂时存储器SPM 3'b001
2号:0x4000_0000 - 0x5fff_ffff	定时器 3'b010
3号:0x6000_0000 - 0x7fff_ffff	UART 3'b011
4号:0x7000_0000 - 0x9fff_ffff	GPIO 3'b100
5号:0xa000_0000 - 0xbfff_ffff	PLL 3'b101
6号:0xc000_0000 - 0xdfff_ffff	未分配 3'b110
7号:0xe000_0000 - 0xffff_ffff	未分配 3'b111
*/

`define BUS_SLAVE_INDEX_LOC 31:29 //地址总线最高3bit(8)用来选择访问哪个总线从属

`define BUS_SLAVE_INDEX 2:0 //地址总线最高3bit(8)用来选择访问哪个总线从属

/*地址线最高三位对应的设备*/
`define BUS_SLAVE_0 3'b000 //只读存储器ROM
`define BUS_SLAVE_1 3'b001	//暂时存储器SPM
`define BUS_SLAVE_2 3'b010	//定时器
`define BUS_SLAVE_3 3'b011	//UART
`define BUS_SLAVE_4 3'b100	//GPIO
`define BUS_SLAVE_5 3'b101	//PLL
`define BUS_SLAVE_6 3'b110	//未分配
`define BUS_SLAVE_7 3'b111	//未分配