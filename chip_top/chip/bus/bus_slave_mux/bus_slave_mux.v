/*总线从属多路复用器*/
`timescale 1ps/1ps
`include "../../../global_config.h"
//`include "bus_slave_mux.h"
module bus_slave_mux(
	/*0号从属*/
	s0_cs_,//片选
	s0_rd_data,//读出的数据
	s0_rdy_,//就绪信号
	
	/*1号从属*/
	s1_cs_,//片选
	s1_rd_data,//读出的数据
	s1_rdy_,//就绪信号
	
	/*2号从属*/
	s2_cs_,//片选
	s2_rd_data,//读出的数据
	s2_rdy_,//就绪信号

	/*3号从属*/
	s3_cs_,//片选
	s3_rd_data,//读出的数据
	s3_rdy_,//就绪信号
	
	/*4号从属*/
	s4_cs_,//片选
	s4_rd_data,//读出的数据
	s4_rdy_,//就绪信号
	
	/*5号从属*/
	s5_cs_,//片选
	s5_rd_data,//读出的数据
	s5_rdy_,//就绪信号
	
	/*6号从属*/
	s6_cs_,//片选
	s6_rd_data,//读出的数据
	s6_rdy_,//就绪信号
	
	/*7号从属*/
	s7_cs_,//片选
	s7_rd_data,//读出的数据
	s7_rdy_,//就绪信号
	
	/*总线从属共享信号*/
	m_rd_data,//读出的数据
	m_rdy_//就绪信号
);


	/*0号从属*/
input s0_cs_;//片选
input [31:0] s0_rd_data;//读出的数据
input s0_rdy_;//就绪信号
	
	/*1号从属*/
input s1_cs_;//片选
input [31:0] s1_rd_data;//读出的数据
input s1_rdy_;//就绪信号
	
	/*2号从属*/
input s2_cs_;//片选
input [31:0] s2_rd_data;//读出的数据
input s2_rdy_;//就绪信号

	/*3号从属*/
input s3_cs_;//片选
input [31:0] s3_rd_data;//读出的数据
input s3_rdy_;//就绪信号
	
	/*4号从属*/
input s4_cs_;//片选
input [31:0] s4_rd_data;//读出的数据
input s4_rdy_;//就绪信号
	
	/*5号从属*/
input s5_cs_;//片选
input [31:0] s5_rd_data;//读出的数据
input s5_rdy_;//就绪信号
	
	/*6号从属*/
input s6_cs_;//片选
input [31:0] s6_rd_data;//读出的数据
input s6_rdy_;//就绪信号
	
	/*7号从属*/
input s7_cs_;//片选
input [31:0] s7_rd_data;//读出的数据
input s7_rdy_;//就绪信号
	
	/*总线从属共享信号*/
output [31:0] m_rd_data;//读出的数据
output m_rdy_;//就绪信号
 
reg [31:0] m_rd_data;
reg m_rdy_;

always @(*)
	begin
		if(s0_cs_ == `ENABLE_)//0号从属片选
			begin
				m_rd_data <= s0_rd_data;
				m_rdy_ <= s0_rdy_;
			end
		else if(s1_cs_ == `ENABLE_)//1号从属片选
			begin
				m_rd_data <= s1_rd_data;
				m_rdy_ <= s1_rdy_;
			end
		else if(s2_cs_ == `ENABLE_)//2号从属片选
			begin
				m_rd_data <= s2_rd_data;
				m_rdy_ <= s2_rdy_;
			end
		else if(s3_cs_ == `ENABLE_)//3号从属片选
			begin
				m_rd_data <= s3_rd_data;
				m_rdy_ <= s3_rdy_;
			end
		else if(s4_cs_ == `ENABLE_)//4号从属片选
			begin
				m_rd_data <= s4_rd_data;
				m_rdy_ <= s4_rdy_;
			end
		else if(s5_cs_ == `ENABLE_)//5号从属片选
			begin
				m_rd_data <= s5_rd_data;
				m_rdy_ <= s5_rdy_;
			end
		else if(s6_cs_ == `ENABLE_)//6号从属片选
			begin
				m_rd_data <= s6_rd_data;
				m_rdy_ <= s6_rdy_;
			end
		else if(s7_cs_ == `ENABLE_)//7号从属片选
			begin
				m_rd_data <= s7_rd_data;
				m_rdy_ <= s7_rdy_;
			end
		else
			begin
				m_rd_data <= `WORD_DATA_W'h0;
				m_rdy_ <= `DISABLE_;
			end
	end



endmodule