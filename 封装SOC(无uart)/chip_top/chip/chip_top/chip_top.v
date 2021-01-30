module chip_top(

	/*时钟与复位*/
	clk,
	clk_,
	reset,
	/*外设输出端口*/
	gpio_io
);

	/*时钟与复位*/
input clk;
input clk_;
input reset;
	/*外设输出端口*/
output [15:0] gpio_io;
	
wire clk;
wire clk_;
wire reset;

wire [15:0] gpio_io;
wire irq_timer;

wire [31:0] m_rd_data;
wire m_rdy_;
wire m0_req_;
wire [29:0] m0_addr;
wire m0_as_;
wire m0_rw;
wire [31:0] m0_wr_data;
wire m0_grnt_;
wire m1_req_;
wire m1_grnt_;
wire [29:0] m1_addr;
wire m1_as_;
wire m1_rw;
wire [31:0] m1_wr_data;
wire m1_grnt;

wire s_as_;
wire s_rw;
wire [29:0] s_addr;
wire [31:0] s_wr_data;

wire [31:0] s0_rd_data;
wire s0_rdy_;
wire s0_cs_;

wire [31:0] s2_rd_data;
wire s2_rdy_;
wire s2_cs_;

wire [31:0] s3_rd_data;
wire s3_rdy_;
wire s3_cs_;
cpu_top cpu_top_0(

	/*时钟与复位*/
	.clk(clk),
	.reset(reset),
	.clk_(clk_),//180度反相时钟
	
	/*IF阶段总线接口*/
	.if_bus_rd_data(m_rd_data),
	.if_bus_rdy_(m_rdy_),
	.if_bus_grnt_(m0_grnt_),
	.if_bus_req_(m0_req_),
	.if_bus_addr(m0_addr),
	.if_bus_as_(m0_as_),
	.if_bus_rw(m0_rw),
	.if_bus_wr_data(m0_wr_data),
	
	/*中断请求*/
	.irq(irq_timer),
	
	/*MEM阶段总线接口*/
	.mem_bus_rd_data(m_rd_data),
	.mem_bus_rdy_(m_rdy_),
	.mem_bus_grnt_(m1_grnt_),
	.mem_bus_req_(m1_req_),
	.mem_bus_addr(m1_addr),
	.mem_bus_as_(m1_as_),
	.mem_bus_rw(m1_rw),
	.mem_bus_wr_data(m1_wr_data)
);

bus_top bus_top_0(

	/*总线系统*/
	.clk(clk),//总线时钟信号
	.reset(reset),//总线复位
	
	/*总线通信线路*/
	.wires_rdy_(m_rdy_),//共享从属输出就绪信号
	.wires_as_(s_as_),//共享主控输入选通信号
	.wires_rw_(s_rw),//共享主控读写信号
	.wires_m_addr(s_addr),//地址线:m->s,接s
	.wires_m_data(s_wr_data),//数据线:m->s,接s
	.wires_s_data(m_rd_data),//数据线:s->m,接m
	
	/*0号主控*/
	.wires_m0_req_(m0_req_),//0号主控请求	
	.wires_m0_addr(m0_addr),//0号主控地址线
	.wires_m0_as_(m0_as_),//0号主控选通线
	.wires_m0_rw(m0_rw),//0号主控读写线
	.wires_m0_wr_data(m0_wr_data),//0号主控写入数据线
	.wires_m0_grnt_(m0_grnt_),
	/*1号主控*/
	.wires_m1_req_(m1_req_),//1号主控请求	
	.wires_m1_addr(m1_addr),//1号主控地址线
	.wires_m1_as_(m1_as_),//1号主控选通线
	.wires_m1_rw(m1_rw),//1号主控读写线
	.wires_m1_wr_data(m1_wr_data),//1号主控写入数据线
	.wires_m1_grnt_(m1_grnt_),
	/*2号主控*/
	.wires_m2_req_(`DISABLE),//2号主控请求	
	.wires_m2_addr(`WORD_ADDR_W'h0),//2号主控地址线
	.wires_m2_as_(`DISABLE_),//2号主控选通线
	.wires_m2_rw(`READ),//2号主控读写线
	.wires_m2_wr_data(`WORD_DATA_W'h0),//2号主控写入数据线
	.wires_m2_grnt_(),
	/*3号主控*/
	.wires_m3_req_(`DISABLE),//3号主控请求	
	.wires_m3_addr(`WORD_ADDR_W'h0),//3号主控地址线
	.wires_m3_as_(`DISABLE_),//3号主控选通线
	.wires_m3_rw(`READ),//3号主控读写线
	.wires_m3_wr_data(`WORD_DATA_W'h0),//3号主控写入数据线
	.wires_m3_grnt_(),
	
	/*0号从属*/
	.wires_s0_rd_data(s0_rd_data),//读出的数据
	.wires_s0_rdy_(s0_rdy_),//就绪信号
	.wires_s0_cs_(s0_cs_),
	/*1号从属*///-SPM 不走总线，但是要保留地址映射
	.wires_s1_rd_data(),//读出的数据
	.wires_s1_rdy_(),//就绪信号
	.wires_s1_cs_(),
	/*2号从属*///-GPIO
	.wires_s2_rd_data(s2_rd_data),//读出的数据
	.wires_s2_rdy_(s2_rdy_),//就绪信号
	.wires_s2_cs_(s2_cs_),
	/*3号从属*///-timer
	.wires_s3_rd_data(s3_rd_data),//读出的数据
	.wires_s3_rdy_(s3_rdy_),//就绪信号
	.wires_s3_cs_(s3_cs_),
	/*4号从属*/
	.wires_s4_rd_data(`WORD_DATA_W'h0),//读出的数据
	.wires_s4_rdy_(`DISABLE_),//就绪信号
	.wires_s4_cs_(),
	/*5号从属*/
	.wires_s5_rd_data(`WORD_DATA_W'h0),//读出的数据
	.wires_s5_rdy_(`DISABLE_),//就绪信号
	.wires_s5_cs_(),
	/*6号从属*/
	.wires_s6_rd_data(`WORD_DATA_W'h0),//读出的数据
	.wires_s6_rdy_(`DISABLE_),//就绪信号
	.wires_s6_cs_(),
	/*7号从属*/
	.wires_s7_rd_data(`WORD_DATA_W'h0),//读出的数据
	.wires_s7_rdy_(`DISABLE_),//就绪信号
	.wires_s7_cs_()


);

rom rom_0(

	.xsoc_rom_addr(s_addr),	//地址线12bit
	.xsoc_rom_clock(clk),	//时钟线
	.xsoc_rom_data(s0_rd_data),	//数据线32bit
	
	.rdy_(s0_rdy_), //就绪信号
	.cs_(s0_cs_),//片选信号(地址解码器控制）
	.as_(s_as_),//选通信号(主控控制）
	.reset(reset)//复位信号
);


gpio gpio_0(
	/*时钟复位*/
	.clk(clk),
	.reset(reset),
	
	/*总线接口*/
	.cs_(s2_cs_),
	.as_(s_as_),
	.rw(s_rw),
	.addr(s_addr),
	.wr_data(s_wr_data),
	.rd_data(s2_rd_data),
	.rdy_(s2_rdy_),
	
	/*输入输出端口*/
	.gpio_io(gpio_io)
);


timer timer_0(
	/*时钟与复位*/
	.clk(clk),
	.reset(reset),
	
	/*总线接口*/
	.cs_(s3_cs_),
	.as_(s_as_),
	.rw(s_rw),
	.addr(s_addr),
	.wr_data(s_wr_data),
	.rd_data(s3_rd_data),
	.rdy_(s3_rdy_),
	
	/*控制寄存器*/
	.irq(irq_timer)

);




















endmodule