module idu_top(
	/*时钟复位*/
	clk,
	reset,
	
	/*流水线控制信号(input)*/
	stall,
	flush,
	
	/*ID/EX信号*/
	id_pc,
	id_en,
	id_alu_op,
	id_alu_in_0,
	id_alu_in_1,
	id_br_flag,
	id_mem_op,
	id_mem_wr_data,
	id_ctrl_op,
	id_dst_addr,
	id_gpr_we_,
	id_exp_code,
	
	/*流水线控制信号(output)*/
	ld_hazard,
	br_taken,
	br_addr,
	
	/*直通*/
	mem_fwd_data,
	ex_gpr_we_,
	ex_dst_addr,
	ex_fwd_data,
	
	/*控制寄存器访问*/
	creg_rd_addr,
	creg_rd_data,
	exe_mode,
	
	/*通用寄存器访问*/
	gpr_rd_addr_1,
	gpr_rd_addr_0,
	gpr_rd_data_1,
	gpr_rd_data_0,
	
	/*IF/ID流水线寄存器*/
	if_en,
	if_pc,
	if_insn
	
);

	/*时钟复位*/
input clk;
input reset;
	
	/*流水线控制信号(input)*/
input stall;
input flush;
	
	/*ID/EX信号*/
output [29:0] id_pc;
output id_en;
output [3:0] id_alu_op;
output [31:0] id_alu_in_0;
output [31:0] id_alu_in_1;
output id_br_flag;
output [1:0] id_mem_op;
output [31:0] id_mem_wr_data;
output [1:0] id_ctrl_op;
output [4:0] id_dst_addr;
output id_gpr_we_;
output [2:0] id_exp_code;
	
	/*流水线控制信号(output)*/
output ld_hazard;
output br_taken;
output [29:0] br_addr;
	
	/*直通*/
input [31:0] mem_fwd_data;
input ex_gpr_we_;
input [4:0] ex_dst_addr;
input [31:0] ex_fwd_data;
	
	/*控制寄存器访问*/
output [4:0] creg_rd_addr;
input [31:0] creg_rd_data;
input [0:0] exe_mode;
	
	/*通用寄存器访问*/
output [4:0] gpr_rd_addr_1;
output [4:0] gpr_rd_addr_0;
input [31:0] gpr_rd_data_1;
input [31:0] gpr_rd_data_0;
	
	/*IF/ID流水线寄存器*/
input if_en;
input [29:0] if_pc;
input [31:0] if_insn;

/*module之间连线*/
wire ex_en;
wire [3:0] alu_op;
wire [31:0] alu_in_0;
wire [31:0] alu_in_1;
wire [1:0] id_mem_op;
wire [31:0] id_mem_wr_data;
wire br_flag;
wire [1:0] mem_op;
wire [31:0] mem_wr_data;
wire [1:0] ctrl_op;
wire [4:0] dst_addr;
wire gpr_we_;
wire [2:0] exp_code;

decoder decode_0(
		/*IF/ID流水线寄存器*/
	.if_pc(if_pc),
	.if_insn(if_insn),
	.if_en(if_en),
	
	/*GPR通用寄存器接口*/
	.gpr_rd_data_0(gpr_rd_data_0),//读取地址0
	.gpr_rd_data_1(gpr_rd_data_1),
	
	.gpr_rd_addr_0(gpr_rd_addr_0),
	.gpr_rd_addr_1(gpr_rd_addr_1),
	
	/*来自ID阶段的数据直通*/
	.id_en(id_en), //流水线数据有效
	.id_dst_addr(id_dst_addr), //写入地址
	.id_gpr_we_(id_gpr_we_), //写入有效
	.id_mem_op(id_mem_op), //内存操作
	
	/*来自EX阶段的数据直通*/
	.ex_en(ex_en), //流水线数据有效
	.ex_dst_addr(ex_dst_addr),//写入地址
	.ex_gpr_we_(ex_gpr_we_),//写入有效
	.ex_fwd_data(ex_fwd_data),//数据直通
	
	/*来自MEM阶段的数据直通*/
	.mem_fwd_data(mem_fwd_data),
	
	/*ID控制寄存器接口*/
	.exe_mode(exe_mode),//执行模式
	.creg_rd_data(creg_rd_data),//读取数据
	.creg_rd_addr(creg_rd_addr),//读取的地址
	
	/*解码结果*/
	.alu_op(alu_op),//alu操作
	.alu_in_0(alu_in_0),//alu输入0
	.alu_in_1(alu_in_1),//alu输入1
	.br_addr(br_addr),//分支地址
	.br_taken(br_taken),//分支成立
	.br_flag(br_flag),//分支标志位
	.mem_op(mem_op),//内存操作
	.mem_wr_data(mem_wr_data),//内存写入数据
	.ctrl_op(ctrl_op),//控制操作
	.dst_addr(dst_addr),//通用寄存器地址
	.gpr_we_(gpr_we_),//通用寄存器有效
	.exp_code(exp_code),//异常代码
	.ld_hazard(ld_hazard)//load冒险

);




id_reg id_reg_0(
	/*时钟与复位*/
	.clk(clk),
	.reset(reset),
	
	/*解码结果*/
	.alu_op(alu_op),
	.alu_in_0(alu_in_0),
	.alu_in_1(alu_in_1),
	.br_flag(br_flag),
	.mem_op(mem_op),
	.mem_wr_data(mem_wr_data),
	.ctrl_op(ctrl_op),
	.dst_addr(dst_addr),
	.gpr_we_(gpr_we_),
	.exp_code(exp_code),
	
	/*流水线控制信号*/
	.stall(stall),
	.flush(flush),
	
	/*if/id流水线寄存器*/
	.if_pc(if_pc),
	.if_en(if_en),
	
	/*id/ex流水线寄存器*/
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
	.id_exp_code(id_exp_code)	
);






















endmodule