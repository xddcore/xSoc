module bus_top(
	
	/*总线系统*/
	clk,//总线时钟信号
	reset,//总线复位
	
	/*总线通信线路*/
	wires_rdy_,//共享从属输出就绪信号
	wires_as_,//共享主控输入选通信号
	wires_rw_,//共享主控读写信号
	wires_m_addr,//地址线:m->s,接s
	wires_m_data,//数据线:m->s,接s
	wires_s_data,//数据线:s->m,接m
	
	/*0号主控*/
	wires_m0_req_,//0号主控请求	
	wires_m0_addr,//0号主控地址线
	wires_m0_as_,//0号主控选通线
	wires_m0_rw,//0号主控读写线
	wires_m0_wr_data,//0号主控写入数据线
	wires_m0_grnt_,
	/*1号主控*/
	wires_m1_req_,//1号主控请求	
	wires_m1_addr,//1号主控地址线
	wires_m1_as_,//1号主控选通线
	wires_m1_rw,//1号主控读写线
	wires_m1_wr_data,//1号主控写入数据线
	wires_m1_grnt_,
	/*2号主控*/
	wires_m2_req_,//2号主控请求	
	wires_m2_addr,//2号主控地址线
	wires_m2_as_,//2号主控选通线
	wires_m2_rw,//2号主控读写线
	wires_m2_wr_data,//2号主控写入数据线
	wires_m2_grnt_,
	/*3号主控*/
	wires_m3_req_,//3号主控请求	
	wires_m3_addr,//3号主控地址线
	wires_m3_as_,//3号主控选通线
	wires_m3_rw,//3号主控读写线
	wires_m3_wr_data,//3号主控写入数据线
	wires_m3_grnt_,
	
	/*0号从属*/
	wires_s0_rd_data,//读出的数据
	wires_s0_rdy_,//就绪信号
	wires_s0_cs_,
	/*1号从属*/
	wires_s1_rd_data,//读出的数据
	wires_s1_rdy_,//就绪信号
	wires_s1_cs_,
	/*2号从属*/
	wires_s2_rd_data,//读出的数据
	wires_s2_rdy_,//就绪信号
	wires_s2_cs_,
	/*3号从属*/
	wires_s3_rd_data,//读出的数据
	wires_s3_rdy_,//就绪信号
	wires_s3_cs_,
	/*4号从属*/
	wires_s4_rd_data,//读出的数据
	wires_s4_rdy_,//就绪信号
	wires_s4_cs_,
	/*5号从属*/
	wires_s5_rd_data,//读出的数据
	wires_s5_rdy_,//就绪信号
	wires_s5_cs_,
	/*6号从属*/
	wires_s6_rd_data,//读出的数据
	wires_s6_rdy_,//就绪信号
	wires_s6_cs_,
	/*7号从属*/
	wires_s7_rd_data,//读出的数据
	wires_s7_rdy_,//就绪信号
	wires_s7_cs_
);


/*端口定义*/
	/*总线系统*/
input clk;//总线时钟信号
input reset;//总线复位
	
	/*总线通信线路*/
output wires_rdy_;//共享从属输出就绪信号
output wires_as_;//共享主控输入选通信号
output wires_rw_;//共享主控读写信号
output [29:0] wires_m_addr;//地址线:m->s,接s
output [31:0] wires_m_data;//数据线:m->s,接s
output [31:0] wires_s_data;//数据线:s->m,接m
	
	/*0号主控*/
input wires_m0_req_;//0号主控请求	
input [31:0] wires_m0_addr;//0号主控地址线
input wires_m0_as_;//0号主控选通线
input wires_m0_rw;//0号主控读写线
input [31:0] wires_m0_wr_data;//0号主控写入数据线
output wires_m0_grnt_;
	/*1号主控*/
input wires_m1_req_;//1号主控请求	
input [31:0] wires_m1_addr;//1号主控地址线
input wires_m1_as_;//1号主控选通线
input wires_m1_rw;//1号主控读写线
input [31:0] wires_m1_wr_data;//1号主控写入数据线
output wires_m1_grnt_;
	/*2号主控*/
input wires_m2_req_;//2号主控请求	
input [31:0] wires_m2_addr;//2号主控地址线
input wires_m2_as_;//2号主控选通线
input wires_m2_rw;//2号主控读写线
input [31:0] wires_m2_wr_data;//2号主控写入数据线
output wires_m2_grnt_;
	/*3号主控*/
input wires_m3_req_;//3号主控请求	
input [31:0] wires_m3_addr;//3号主控地址线
input wires_m3_as_;//3号主控选通线
input wires_m3_rw;//3号主控读写线
input [31:0] wires_m3_wr_data;//3号主控写入数据线
output wires_m3_grnt_;
	
	/*0号从属*/
input [31:0] wires_s0_rd_data;//读出的数据
input wires_s0_rdy_;//就绪信号
output wires_s0_cs_;
	/*1号从属*/
input [31:0] wires_s1_rd_data;//读出的数据
input wires_s1_rdy_;//就绪信号
output wires_s1_cs_;
	/*2号从属*/
input [31:0] wires_s2_rd_data;//读出的数据
input wires_s2_rdy_;//就绪信号
output wires_s2_cs_;
	/*3号从属*/
input [31:0] wires_s3_rd_data;//读出的数据
input wires_s3_rdy_;//就绪信号
output wires_s3_cs_;
	/*4号从属*/
input [31:0] wires_s4_rd_data;//读出的数据
input wires_s4_rdy_;//就绪信号
output wires_s4_cs_;
	/*5号从属*/
input [31:0] wires_s5_rd_data;//读出的数据
input wires_s5_rdy_;//就绪信号
output wires_s5_cs_;
	/*6号从属*/
input [31:0] wires_s6_rd_data;//读出的数据
input wires_s6_rdy_;//就绪信号
output wires_s6_cs_;
	/*7号从属*/
input [31:0] wires_s7_rd_data;//读出的数据
input wires_s7_rdy_;//就绪信号
output wires_s7_cs_;


/*内部连线*/
wire wires_m0_grnt_;//0号主控赋予总线
wire wires_m1_grnt_;//1号主控赋予总线
wire wires_m2_grnt_;//2号主控赋予总线
wire wires_m3_grnt_;//3号主控赋予总线





wire wires_s0_cs_;//0号从属片选线
wire wires_s1_cs_;//1号从属片选线
wire wires_s2_cs_;//2号从属片选线
wire wires_s3_cs_;//3号从属片选线
wire wires_s4_cs_;//4号从属片选线
wire wires_s5_cs_;//5号从属片选线
wire wires_s6_cs_;//6号从属片选线
wire wires_s7_cs_;//7号从属片选线

/*总线仲裁器*/
bus_arbiter bus_arbiter_(
	.clk(clk),
	.reset(reset),	
	
	.m0_req_(wires_m0_req_),//0号主控请求
	.m0_grnt_(wires_m0_grnt_),//0号主控赋予总线
	
	.m1_req_(wires_m1_req_),//1号主控请求
	.m1_grnt_(wires_m1_grnt_),//1号主控赋予总线	
	
	.m2_req_(wires_m2_req_),//2号主控请求
	.m2_grnt_(wires_m2_grnt_),//2号主控赋予总线	
	
	.m3_req_(wires_m3_req_),//3号主控请求
	.m3_grnt_(wires_m3_grnt_)//3号主控赋予总线
);

/*总线主控多路复用器*/
bus_master_mux bus_master_mux_(
	/*0号主控*/
	.m0_addr(wires_m0_addr),//地址
	.m0_as_(wires_m0_as_),//地址选通
	.m0_rw(wires_m0_rw),//读写信号
	.m0_wr_data(wires_m0_wr_data),//写入的数据
	.m0_grnt_(wires_m0_grnt_),//赋予总线
	
	/*1号主控*/
	.m1_addr(wires_m1_addr),//地址
	.m1_as_(wires_m1_as_),//地址选通
	.m1_rw(wires_m1_rw),//读写信号
	.m1_wr_data(wires_m1_wr_data),//写入的数据
	.m1_grnt_(wires_m1_grnt_),//赋予总线
	
	/*2号主控*/
	.m2_addr(wires_m2_addr),//地址
	.m2_as_(wires_m2_as_),//地址选通
	.m2_rw(wires_m2_rw),//读写信号
	.m2_wr_data(wires_m2_wr_data),//写入的数据
	.m2_grnt_(wires_m2_grnt_),//赋予总线
	
	/*3号主控*/
	.m3_addr(wires_m3_addr),//地址
	.m3_as_(wires_m3_as_),//地址选通
	.m3_rw(wires_m3_rw),//读写信号
	.m3_wr_data(wires_m3_wr_data),//写入的数据
	.m3_grnt_(wires_m3_grnt_),//赋予总线
	
	/*共享信号总线从属(复用器:多个主控->1个从属)*/
	.s_addr(wires_m_addr),//地址
	.s_as_(wires_as_),//地址选通
	.s_rw(wires_rw_),//读写信号
	.s_wr_data(wires_m_data)//写入的数据
);

/*总线从属多路复用器*/

bus_slave_mux bus_slave_mux_(
	/*0号从属*/
	.s0_cs_(wires_s0_cs_),//片选
	.s0_rd_data(wires_s0_rd_data),//读出的数据
	.s0_rdy_(wires_s0_rdy_),//就绪信号
	
	/*1号从属*/
	.s1_cs_(wires_s1_cs_),//片选
	.s1_rd_data(wires_s1_rd_data),//读出的数据
	.s1_rdy_(wires_s1_rdy_),//就绪信号
	
	/*2号从属*/
	.s2_cs_(wires_s2_cs_),//片选
	.s2_rd_data(wires_s2_rd_data),//读出的数据
	.s2_rdy_(wires_s2_rdy_),//就绪信号

	/*3号从属*/
	.s3_cs_(wires_s3_cs_),//片选
	.s3_rd_data(wires_s3_rd_data),//读出的数据
	.s3_rdy_(wires_s3_rdy_),//就绪信号
	
	/*4号从属*/
	.s4_cs_(wires_s4_cs_),//片选
	.s4_rd_data(wires_s4_rd_data),//读出的数据
	.s4_rdy_(wires_s4_rdy_),//就绪信号
	
	/*5号从属*/
	.s5_cs_(wires_s5_cs_),//片选
	.s5_rd_data(wires_s5_rd_data),//读出的数据
	.s5_rdy_(wires_s5_rdy_),//就绪信号
	
	/*6号从属*/
	.s6_cs_(wires_s6_cs_),//片选
	.s6_rd_data(wires_s6_rd_data),//读出的数据
	.s6_rdy_(wires_s6_rdy_),//就绪信号
	
	/*7号从属*/
	.s7_cs_(wires_s7_cs_),//片选
	.s7_rd_data(wires_s7_rd_data),//读出的数据
	.s7_rdy_(wires_s7_rdy_),//就绪信号
	
	/*总线从属共享信号*/
	.m_rd_data(wires_s_data),//读出的数据
	.m_rdy_(wires_rdy_)//就绪信号
);

/*地址解码器*/

bus_addr_dec bus_addr_dec_(
	/*总线共享地址线*/
	.s_addr(wires_m_addr),
	
	/*0号从属片选*/
	.s0_cs_(wires_s0_cs_),
	
	/*1号从属片选*/
	.s1_cs_(wires_s1_cs_),
	
	/*2号从属片选*/
	.s2_cs_(wires_s2_cs_),
	
	/*3号从属片选*/
	.s3_cs_(wires_s3_cs_),
	
	/*4号从属片选*/
	.s4_cs_(wires_s4_cs_),
	
	/*5号从属片选*/
	.s5_cs_(wires_s5_cs_),
	
	/*6号从属片选*/
	.s6_cs_(wires_s6_cs_),
	
	/*7号从属片选*/
	.s7_cs_(wires_s7_cs_)
);





endmodule