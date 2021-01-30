/*cpu顶层*/
module cpu_top(

	/*时钟与复位*/
	clk,
	reset,
	clk_,//180度反相时钟
	
	/*IF阶段总线接口*/
	if_bus_rd_data,
	if_bus_rdy_,
	if_bus_grnt_,
	if_bus_req_,
	if_bus_addr,
	if_bus_as_,
	if_bus_rw,
	if_bus_wr_data,
	
	/*中断请求*/
	irq,
	
	/*MEM阶段总线接口*/
	mem_bus_rd_data,
	mem_bus_rdy_,
	mem_bus_grnt_,
	mem_bus_req_,
	mem_bus_addr,
	mem_bus_as_,
	mem_bus_rw,
	mem_bus_wr_data
);

/***********cpu_top端口输入输出***********/
	/*时钟与复位*/
input clk;
input reset;
input clk_;//180度反相时钟
	
	/*IF阶段总线接口*/
input [31:0] if_bus_rd_data;
input if_bus_rdy_;
input if_bus_grnt_;
output if_bus_req_;
output [29:0] if_bus_addr;
output if_bus_as_;
output if_bus_rw;
output [31:0] if_bus_wr_data;
	
	/*中断请求*/
input [7:0] irq;
	
	/*MEM阶段总线接口*/
input [31:0] mem_bus_rd_data;
input mem_bus_rdy_;
input mem_bus_grnt_;
output mem_bus_req_;
output [29:0] mem_bus_addr;
output mem_bus_as_;
output mem_bus_rw;
output [31:0] mem_bus_wr_data;

/***********module之间连线***********/

wire clk;
wire reset;
wire clk_;//180度反相时钟
	
	/*IF阶段总线接口*/
wire [31:0] if_bus_rd_data;
wire if_bus_rdy_;
wire if_bus_grnt_;
wire if_bus_req_;
wire [29:0] if_bus_addr;
wire if_bus_as_;
wire if_bus_rw;
wire [31:0] if_bus_wr_data;
	
	/*中断请求*/
wire [7:0] irq;
	
	/*MEM阶段总线接口*/
wire [31:0] mem_bus_rd_data;
wire mem_bus_rdy_;
wire mem_bus_grnt_;
wire mem_bus_req_;
wire [29:0] mem_bus_addr;
wire mem_bus_as_;
wire mem_bus_rw;
wire [31:0] mem_bus_wr_data;

//以下为内部模块
wire if_stall;
wire if_flush;
wire [29:0] new_pc;
wire br_taken;
wire [29:0] br_addr;
wire [29:0] if_pc;
wire [31:0] if_insn;
wire if_en;
wire [31:0] if_spm_rd_data;
wire if_spm_rw;
wire if_spm_as_;
wire [11:0] if_spm_addr;
wire if_busy;
wire id_stall;
wire id_flush;
wire [29:0] id_pc;
wire id_en;
wire [3:0] id_alu_op;
wire [31:0] id_alu_in_0;
wire [31:0] id_alu_in_1;
wire id_br_flag;
wire [1:0] id_mem_op;
wire [31:0] id_mem_wr_data;
wire [1:0] id_ctrl_op;
wire [4:0] id_dst_addr;
wire id_gpr_we_;
wire [2:0] id_exp_code;
wire ld_hazard;
wire [31:0] mem_fwd_data;
wire ex_gpr_we_;
wire [4:0] ex_dst_addr;
wire [31:0] ex_fwd_data;
wire [4:0] creg_rd_addr;
wire [31:0] creg_rd_data;
wire exe_mode;
wire [4:0] gpr_rd_addr_0;
wire [31:0] gpr_rd_data_0;
wire [4:0] gpr_rd_addr_1;
wire [31:0] gpr_rd_data_1;
wire [31:0] if_spm_wr_data;
wire [11:0] spm_addr;
wire spm_as_;
wire spm_rw;
wire [31:0] spm_wr_data;
wire [31:0] spm_rd_data;
wire int_detect;
wire ex_stall;
wire ex_flush;
wire [29:0] ex_pc;
wire ex_en;
wire ex_br_flag;
wire [1:0] ex_mem_op;
wire [31:0] ex_mem_wr_data;
wire [1:0] ex_ctrl_op;
wire [2:0] ex_exp_code;
wire [31:0] ex_out;
wire mem_gpr_we_;
wire [4:0] mem_dst_addr;
wire [31:0] mem_out;
wire mem_stall;
wire mem_flush;
wire [29:0] mem_pc;
wire mem_en;
wire mem_br_flag;
wire [1:0] mem_ctrl_op;
wire [2:0] mem_exp_code;
wire mem_busy;

ifu_top ifu_top_0(
	/*时钟与复位*/
	.clk(clk),
	.reset(reset),
	
	/*流水线控制信号*/
	.stall(if_stall),//延迟
	.flush(if_flush),//刷新
	.new_pc(new_pc),//branch的新pc指针
	.br_taken(br_taken),//分支有效
	.br_addr(br_addr),//分支地址
	
	/*接下一级IF/ID流水线寄存器*/
	.if_pc(if_pc),//ifu的pc指针
	.if_insn(if_insn),//指令
	.if_en(if_en),//指令是否有效
	
	/*总线接口*/
	.bus_wr_data(if_bus_wr_data),//写入数据
	.bus_rw(if_bus_rw),//读写标志
	.bus_as_(if_bus_as_),//选通信号
	.bus_addr(if_bus_addr),//地址
	.bus_req_(if_bus_req_),//请求总线信号
	.bus_grnt_(if_bus_grnt_),//总线授权
	.bus_rdy_(if_bus_rdy_),//就绪信号，从属发完数据后，会拉低就绪信号，然后主控释放总线
	.bus_rd_data(if_bus_rd_data),//读取的总线数据
	
	/*SPM接口*/
	.spm_rd_data(if_spm_rd_data),//读取的SPM数据
	.spm_rw(if_spm_rw),//读写标志
	.spm_as_(if_spm_as_),//spm选通
	.spm_addr(if_spm_addr),//spm地址
	.spm_wr_data(if_spm_wr_data),
	/*总线忙信号*/
	.busy(if_busy)
);

idu_top idu_top_0(

	/*时钟复位*/
	.clk(clk),
	.reset(reset),
	
	/*流水线控制信号(input)*/
	.stall(id_stall),
	.flush(id_flush),
	
	/*ID/EX信号*/
	.id_pc(id_pc),
	.id_en(id_en),
	.id_alu_op(id_alu_op),
	.id_alu_in_0(id_alu_in_0),
	.id_alu_in_1(id_alu_in_1),
	.id_br_flag(id_br_flag),
	.id_mem_op(id_mem_op),
	.id_mem_wr_data(id_mem_wr_data),
	.id_ctrl_op(id_ctrl_op),
	.id_dst_addr(id_dst_addr),
	.id_gpr_we_(id_gpr_we_),
	.id_exp_code(id_exp_code),
	
	/*流水线控制信号(output)*/
	.ld_hazard(ld_hazard),
	.br_taken(br_taken),
	.br_addr(br_addr),
	
	/*直通*/
	.mem_fwd_data(mem_fwd_data),
	.ex_gpr_we_(ex_gpr_we_),
	.ex_dst_addr(ex_dst_addr),
	.ex_fwd_data(ex_fwd_data),
	
	/*控制寄存器访问*/
	.creg_rd_addr(creg_rd_addr),
	.creg_rd_data(creg_rd_data),
	.exe_mode(exe_mode),
	
	/*通用寄存器访问*/
	.gpr_rd_addr_1(gpr_rd_addr_1),
	.gpr_rd_addr_0(gpr_rd_addr_0),
	.gpr_rd_data_1(gpr_rd_data_1),
	.gpr_rd_data_0(gpr_rd_data_0),
	
	/*IF/ID流水线寄存器*/
	.if_en(if_en),
	.if_pc(if_pc),
	.if_insn(if_insn)
	
);

spm spm_0(

	.clk(clk_),
	
	/*A端口 从内从中提取指令(IF)阶段*/
	.if_spm_addr(if_spm_addr),//地址
	.if_spm_as_(if_spm_as_),//选通
	.if_spm_rw(if_spm_rw),//读写
	.if_spm_wr_data(if_spm_wr_data),//写入的数据
	.if_spm_rd_data(if_spm_rd_data),//读取的数据
	/*B端口 结果写入内存阶段(MEM)阶段*/
	.mem_spm_addr(spm_addr),//地址
	.mem_spm_as_(spm_as_),//选通
	.mem_spm_rw(spm_rw),//读写
	.mem_spm_wr_data(spm_wr_data),//写入的数据
	.mem_spm_rd_data(spm_rd_data)//读取的数据	
);


exu_top exu_top_0(

	/*时钟和复位*/
	.clk(clk),
	.reset(reset),
	
	/*中断检测信号*/
	.int_detect(int_detect),
	
	/*流水线控制信号*/
	.stall(ex_stall),
	.flush(ex_flush),
	
	/*EX/MEM寄存器*/
	.ex_pc(ex_pc),
	.ex_en(ex_en),
	.ex_br_flag(ex_br_flag),
	.ex_mem_op(ex_mem_op),
	.ex_mem_wr_data(ex_mem_wr_data),
	.ex_ctrl_op(ex_ctrl_op),
	.ex_dst_addr(ex_dst_addr),
	.ex_gpr_we_(ex_gpr_we_),
	.ex_exp_code(ex_exp_code),
	.ex_out(ex_out),
	
	/*ID/EX寄存器*/
	.id_exp_code(id_exp_code),
	.id_gpr_we_(id_gpr_we_),
	.id_dst_addr(id_dst_addr),
	.id_ctrl_op(id_ctrl_op),
	.id_mem_wr_data(id_mem_wr_data),
	.id_mem_op(id_mem_op),
	.id_br_flag(id_br_flag),
	.id_alu_in_1(id_alu_in_1),
	.id_alu_in_0(id_alu_in_0),
	.id_alu_op(id_alu_op),
	.id_en(id_en),
	.id_pc(id_pc),
	/*直通*/
	.fwd_data(ex_fwd_data)
);
 
 
gpr gpr_0(

	.clk(clk),//时钟
	.reset(reset),//复位信号
	
	/*读取端口0*/
	.rd_addr_0(gpr_rd_addr_0), //地址线
	.rd_data_0(gpr_rd_data_0), //数据线
	
	/*读取端口1*/
	.rd_addr_1(gpr_rd_addr_1), //地址线
	.rd_data_1(gpr_rd_data_1), //数据线
	
	/*写入端口*/
	.we_(mem_gpr_we_), //有效信号
	.wr_addr(mem_dst_addr),//写入的地址
	.wr_data(mem_out)
	
);

memu_top memu_top_0(


	/*时钟和复位*/
	.clk(clk),
	.reset(reset),
	
	/*流水线控制信号*/
	.stall(mem_stall),
	.flush(mem_flush),
	
	/*数据直通*/
	.fwd_data(mem_fwd_data),
	
	/*MEM/WB 流水线寄存器(out)*/
	.mem_pc(mem_pc),
	.mem_en(mem_en),
	.mem_br_flag(mem_br_flag),
	.mem_ctrl_op(mem_ctrl_op),
	.mem_dst_addr(mem_dst_addr),
	.mem_gpr_we_(mem_gpr_we_),
	.mem_exp_code(mem_exp_code),
	.mem_out(mem_out),
	
	/*EX/MEM 流水线寄存器(out)*/
	
	.ex_exp_code(ex_exp_code),
	.ex_gpr_we_(ex_gpr_we_),
	.ex_dst_addr(ex_dst_addr),
	.ex_ctrl_op(ex_ctrl_op),
	.ex_br_flag(ex_br_flag),
	.ex_pc(ex_pc),
	.ex_out(ex_out),
	.ex_mem_wr_data(ex_mem_wr_data),
	.ex_mem_op(ex_mem_op),
	.ex_en(ex_en),
	
	/*总线接口*/
	.bus_wr_data(mem_bus_wr_data),
	.bus_rw(mem_bus_rw),
	.bus_as_(mem_bus_as_),
	.bus_addr(mem_bus_addr),
	.bus_req_(mem_bus_req_),
	.bus_grnt_(mem_bus_grnt_),
	.bus_rdy_(mem_bus_rdy_),
	.bus_rd_data(mem_bus_rd_data),
	
	/*SPM接口*/
	.spm_wr_data(spm_wr_data),
	.spm_rw(spm_rw),
	.spm_as_(spm_as_),
	.spm_addr(spm_addr),
	.spm_rd_data(spm_rd_data),
	
	/*忙信号*/
	.busy(mem_busy)
);


cpu_ctrl cpu_ctrl_0(
	/*时钟和复位*/
	.clk(clk),
	.reset(reset),
	
	/*CPU控制寄存器接口*/
	.creg_rd_addr(creg_rd_addr),
	.creg_rd_data(creg_rd_data),
	.exe_mode(exe_mode),
	
	/*中断*/
	.irq(irq),
	.int_detect(int_detect),
	
	/*ID/EX流水线寄存器*/
	.id_pc(id_pc),
	
	/*ID/EX流水线寄存器*/
	.mem_pc(mem_pc),
	.mem_en(mem_en),
	.mem_br_flag(mem_br_flag),
	.mem_ctrl_op(mem_ctrl_op),
	.mem_dst_addr(mem_dst_addr),
	.mem_gpr_we_(mem_gpr_we_),
	.mem_exp_code(mem_exp_code),
	.mem_out(mem_out),
	
	/*流水线的状态*/
	.if_busy(if_busy),
	.ld_hazard(ld_hazard),//load冒险
	.mem_busy(mem_busy),
	
	/*延迟信号*/
	.if_stall(if_stall),
	.id_stall(id_stall),
	.ex_stall(ex_stall),
	.mem_stall(mem_stall),
	
	/*刷新信号*/
	
	.if_flush(if_flush),
	.id_flush(id_flush),
	.ex_flush(ex_flush),
	.mem_flush(mem_flush),
	.new_pc(new_pc)
);

endmodule