/*地址解码器*/
`timescale 1ps/1ps
`include "bus_addr_dec.h"
`include "../../../global_config.h"
module bus_addr_dec(
	/*总线共享地址线*/
	s_addr,
	
	/*0号从属片选*/
	s0_cs_,
	
	/*1号从属片选*/
	s1_cs_,
	
	/*2号从属片选*/
	s2_cs_,
	
	/*3号从属片选*/
	s3_cs_,
	
	/*4号从属片选*/
	s4_cs_,
	
	/*5号从属片选*/
	s5_cs_,
	
	/*6号从属片选*/
	s6_cs_,
	
	/*7号从属片选*/
	s7_cs_
);

	/*总线共享地址线*/
input [31:0] s_addr;
	
	/*0号从属片选*/
output s0_cs_;
	
	/*1号从属片选*/
output s1_cs_;
	
	/*2号从属片选*/
output s2_cs_;
	
	/*3号从属片选*/
output s3_cs_;
	
	/*4号从属片选*/
output s4_cs_;
	
	/*5号从属片选*/
output s5_cs_;
	
	/*6号从属片选*/
output s6_cs_;
	
	/*7号从属片选*/
output s7_cs_;

reg s0_cs_;
reg s1_cs_;
reg s2_cs_;
reg s3_cs_;
reg s4_cs_;
reg s5_cs_;
reg s6_cs_;
reg s7_cs_;

//提取地址线的最高三位用于片选从属设备
wire [`BUS_SLAVE_INDEX] s_index = s_addr[`BUS_SLAVE_INDEX_LOC];

always @(*)
	begin
		/*初始化片选信号*/
		s0_cs_ <= `DISABLE_;
		s1_cs_ <= `DISABLE_;
		s2_cs_ <= `DISABLE_;
		s3_cs_ <= `DISABLE_;
		s4_cs_ <= `DISABLE_;
		s5_cs_ <= `DISABLE_;
		s6_cs_ <= `DISABLE_;
		s7_cs_ <= `DISABLE_;
		
		/*根据地址线最高三位片选响应的从属设备*/
		case(s_index)
			`BUS_SLAVE_0://片选0号从属设备
				begin
					s0_cs_ <= `ENABLE_;
				end
			`BUS_SLAVE_1://片选1号从属设备
				begin
					s1_cs_ <= `ENABLE_;
				end
			`BUS_SLAVE_2://片选2号从属设备
				begin
					s2_cs_ <= `ENABLE_;
				end				
			`BUS_SLAVE_3://片选3号从属设备
				begin
					s3_cs_ <= `ENABLE_;
				end				
			`BUS_SLAVE_4://片选4号从属设备
				begin
					s4_cs_ <= `ENABLE_;
				end				
			`BUS_SLAVE_5://片选5号从属设备
				begin
					s5_cs_ <= `ENABLE_;
				end				
			`BUS_SLAVE_6://片选6号从属设备
				begin
					s6_cs_ <= `ENABLE_;
				end				
			`BUS_SLAVE_7://片选7号从属设备
				begin
					s7_cs_ <= `ENABLE_;
				end							
		endcase
	end
endmodule