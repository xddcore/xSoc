/*总线主控多路复用器addr:30bit data:32bit*/
`include "../../../global_config.h"
//`include "bus_master_mux.h"
module bus_master_mux(
	/*0号主控*/
	m0_addr,//地址
	m0_as_,//地址选通
	m0_rw,//读写信号
	m0_wr_data,//写入的数据
	m0_grnt_,//赋予总线
	
	/*1号主控*/
	m1_addr,//地址
	m1_as_,//地址选通
	m1_rw,//读写信号
	m1_wr_data,//写入的数据
	m1_grnt_,//赋予总线
	
	/*2号主控*/
	m2_addr,//地址
	m2_as_,//地址选通
	m2_rw,//读写信号
	m2_wr_data,//写入的数据
	m2_grnt_,//赋予总线
	
	/*3号主控*/
	m3_addr,//地址
	m3_as_,//地址选通
	m3_rw,//读写信号
	m3_wr_data,//写入的数据
	m3_grnt_,//赋予总线
	
	/*共享信号总线从属(复用器:多个主控->1个从属)*/
	s_addr,//地址
	s_as_,//地址选通
	s_rw,//读写信号
	s_wr_data//写入的数据
	
);

	/*0号主控*/
input [29:0] m0_addr;//地址
input m0_as_;//地址选通
input m0_rw;//读写信号
input [31:0] m0_wr_data;//写入的数据
input m0_grnt_;//赋予总线
	
	/*1号主控*/
input [29:0] m1_addr;//地址
input m1_as_;//地址选通
input m1_rw;//读写信号
input [31:0] m1_wr_data;//写入的数据
input m1_grnt_;//赋予总线
	
	/*2号主控*/
input [29:0] m2_addr;//地址
input m2_as_;//地址选通
input m2_rw;//读写信号
input [31:0] m2_wr_data;//写入的数据
input m2_grnt_;//赋予总线
	
	/*3号主控*/
input [29:0] m3_addr;//地址
input m3_as_;//地址选通
input m3_rw;//读写信号
input [31:0] m3_wr_data;//写入的数据
input m3_grnt_;//赋予总线
	
	/*共享信号总线从属(复用器:多个主控->1个从属)*/
output [29:0] s_addr;//地址
output s_as_;//地址选通
output s_rw;//读写信号
output [31:0] s_wr_data;//写入的数据

reg [29:0] s_addr;//30bit地址
reg s_as_;//地址选通
reg s_rw;//读写信号
reg [31:0] s_wr_data;//32bit写入的数据

always @(*)
	begin
		if(m0_grnt_ == `ENABLE_)//0号主控被赋予权限
			begin
				s_addr <= m0_addr;
				s_as_ <= m0_as_;
				s_rw <= m0_rw;
				s_wr_data <= m0_wr_data;
			end
		else if(m1_grnt_ == `ENABLE_)//1号主控被赋予权限
			begin
				s_addr <= m1_addr;
				s_as_ <= m1_as_;
				s_rw <= m1_rw;
				s_wr_data <= m1_wr_data;				
			end
		else if(m2_grnt_ == `ENABLE_)//2号主控被赋予权限
			begin
				s_addr <= m2_addr;
				s_as_ <= m2_as_;
				s_rw <= m2_rw;
				s_wr_data <= m2_wr_data;				
			end
		else if(m3_grnt_ == `ENABLE_)//3号主控被赋予权限
			begin
				s_addr <= m3_addr;
				s_as_ <= m3_as_;
				s_rw <= m3_rw;
				s_wr_data <= m3_wr_data;				
			end
		else
			begin
				s_addr <= `WORD_ADDR_W'h0;
				s_as_ <= `DISABLE_;
				s_rw <= `READ;
				s_wr_data <= `WORD_DATA_W'h0;
			end
	end










endmodule






