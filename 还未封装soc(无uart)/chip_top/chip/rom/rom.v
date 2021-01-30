/*ROM使用Altera ROM:1-PORT IP Core进行生成*/
/*
Altera EP4CE15F23C8N
//功能存储程序，只读
ROM大小:16kb(可自行生成IP Core修改)

*/
`include "../../global_config.h"
module rom(
	xsoc_rom_addr,	//地址线12bit
	xsoc_rom_clock,	//时钟线
	xsoc_rom_data,	//数据线32bit
	
	rdy_, //就绪信号
	cs_,//片选信号(地址解码器控制）
	as_,//选通信号(主控控制）
	reset//复位信号
);

input reset;
input [11:0] xsoc_rom_addr;
input xsoc_rom_clock;
input cs_;
input as_;

output [31:0]  xsoc_rom_data;
output rdy_;

reg rdy_;

ip_rom_1  xSoc_rom(
	.address(xsoc_rom_addr), //地址线12bit
	.clock(xsoc_rom_clock), //时钟线
	.q(xsoc_rom_data)	//数据线32bit
);

always @(posedge xsoc_rom_clock or `RESET_EDGE reset)
	begin
		if(reset == `ENABLE_)
			begin
				rdy_ <= `DISABLE_;
			end
		else if((cs_ == `ENABLE_) && (as_ == `ENABLE_))//选通和片选都被激活
			begin
				rdy_ <= `ENABLE_;//使能就绪信号
			end
		else
			begin
				rdy_ <= `DISABLE_;//关闭就绪信号
			end
	end
endmodule