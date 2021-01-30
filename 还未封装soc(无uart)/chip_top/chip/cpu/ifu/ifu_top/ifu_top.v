`include "../../../../global_config.h"
module ifu_top(
	
	/*时钟与复位*/
	clk,
	reset,
	
	/*流水线控制信号*/
	stall,//延迟
	flush,//刷新
	new_pc,//branch的新pc指针
	br_taken,//分支有效
	br_addr,//分支地址
	
	/*接下一级IF/ID流水线寄存器*/
	if_pc,//ifu的pc指针
	if_insn,//指令
	if_en,//指令是否有效
	
	/*总线接口*/
	bus_wr_data,//写入数据
	bus_rw,//读写标志
	bus_as_,//选通信号
	bus_addr,//地址
	bus_req_,//请求总线信号
	bus_grnt_,//总线授权
	bus_rdy_,//就绪信号，从属发完数据后，会拉低就绪信号，然后主控释放总线
	bus_rd_data,//读取的总线数据
	
	/*SPM接口*/
	spm_rd_data,//读取的SPM数据
	spm_rw,//读写标志
	spm_as_,//spm选通
	spm_addr,//spm地址
	spm_wr_data,
	/*总线忙信号*/
	busy

);


	/*时钟与复位*/
input clk;
input reset;
	
	/*流水线控制信号*/
input stall;//延迟
input flush;//刷新
input [29:0] new_pc;//branch的新pc指针
input br_taken;//分支有效
input [29:0] br_addr;//分支地址
	
	/*接下一级IF/ID流水线寄存器*/
output [29:0] if_pc;//ifu的pc指针
output [31:0] if_insn;//指令
output if_en;//指令是否有效
	
	/*总线接口*/
output [31:0] bus_wr_data;//写入数据
output bus_rw;//读写标志
output bus_as_;//选通信号
output [29:0] bus_addr;//地址
output bus_req_;//请求总线信号
input bus_grnt_;//总线授权
input bus_rdy_;//就绪信号，从属发完数据后，会拉低就绪信号，然后主控释放总线
input [31:0] bus_rd_data;//读取的总线数据
	
	/*SPM接口*/
input [31:0] spm_rd_data;//读取的SPM数据
output spm_rw;//读写标志
output spm_as_;//spm选通
output [29:0] spm_addr;//spm地址
output [31:0] spm_wr_data;	
	/*总线忙信号*/
output busy;

wire [31:0] spm_wr_data;
wire [31:0] rd_data_insn;

bus_if bus_if_0
(
		/*时钟复位*/
	.clk(clk),
	.reset(reset),
	
	/*流水线控制信号*/
	.stall(stall), //延迟信号
	.flush(flush), //刷新信号
	.busy(busy), //忙信号
	
	/*CPU接口*/
	.addr(if_pc), //地址
	.as_(`ENABLE), //选通
	.rw(`READ), //读写01
	.wr_data(32'h0), //写入的数据
	.rd_data(rd_data_insn), //读取的数据
	
	/*SPM接口*/
	.spm_rd_data(spm_rd_data), //读取的数据
	.spm_addr(spm_addr), //地址
	.spm_as_(spm_as_), //选通
	.spm_rw(spm_rw), //读写
	.spm_wr_data(spm_wr_data), //写入的数据
	
	/*总线接口*/
	.bus_rd_data(bus_rd_data),//读取的数据
	.bus_rdy_(bus_rdy_), //总线就绪
	.bus_grnt_(bus_grnt_), //仲裁器许可信号
	.bus_req_(bus_req_), //请求
	.bus_addr(bus_addr), //地址
	.bus_as_(bus_as_), //选通
	.bus_rw(bus_rw), //读写
	.bus_wr_data(bus_wr_data)//写入的数据
);

if_reg if_reg_0(
	/*时钟和复位*/
	.clk(clk),
	.reset(reset),
	
	/*读取数据*/
	.insn(rd_data_insn),
	
	/*流水线控制信号*/
	.stall(stall),//延迟
	.flush(flush),//刷新
	.new_pc(new_pc),//新程序计数器
	.br_taken(br_taken),//branch分支成立
	.br_addr(br_addr), //分支目标地址
	
	/*if/id流水线寄存器*/
	.if_pc(if_pc),//程序计数器
	.if_insn(if_insn),//指令
	.if_en(if_en) //流水线数据有效位
);























endmodule