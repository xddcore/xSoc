module memu_top(

	/*时钟和复位*/
	clk,
	reset,
	
	/*流水线控制信号*/
	stall,
	flush,
	
	/*数据直通*/
	fwd_data,
	
	/*MEM/WB 流水线寄存器(out)*/
	mem_pc,
	mem_en,
	mem_br_flag,
	mem_ctrl_op,
	mem_dst_addr,
	mem_gpr_we_,
	mem_exp_code,
	mem_out,
	
	/*EX/MEM 流水线寄存器(out)*/
	
	ex_exp_code,
	ex_gpr_we_,
	ex_dst_addr,
	ex_ctrl_op,
	ex_br_flag,
	ex_pc,
	ex_out,
	ex_mem_wr_data,
	ex_mem_op,
	ex_en,
	
	/*总线接口*/
	bus_wr_data,
	bus_rw,
	bus_as_,
	bus_addr,
	bus_req_,
	bus_grnt_,
	bus_rdy_,
	bus_rd_data,
	
	/*SPM接口*/
	spm_wr_data,
	spm_rw,
	spm_as_,
	spm_addr,
	spm_rd_data,
	
	/*忙信号*/
	busy
	
);


	/*时钟和复位*/
input clk;
input reset;
	
	/*流水线控制信号*/
input stall;
input flush;
	
output [31:0] fwd_data;
	
	/*MEM/WB 流水线寄存器(out)*/
output [29:0] mem_pc;
output mem_en;
output mem_br_flag;
output [1:0] mem_ctrl_op;
output [4:0] mem_dst_addr;
output mem_gpr_we_;
output [2:0] mem_exp_code;
output [31:0] mem_out;
	
	/*EX/MEM 流水线寄存器(out)*/
	
input [2:0] ex_exp_code;
input ex_gpr_we_;
input [4:0] ex_dst_addr;
input [1:0] ex_ctrl_op;
input ex_br_flag;
input [29:0] ex_pc;
input [31:0] ex_out;
input [31:0] ex_mem_wr_data;
input [1:0] ex_mem_op;
input ex_en;
	
	/*总线接口*/
output [31:0] bus_wr_data;
output bus_rw;
output bus_as_;
output [29:0] bus_addr;
output bus_req_;
input bus_grnt_;
input bus_rdy_;
input [31:0] bus_rd_data;
	
	/*SPM接口*/
output [31:0] spm_wr_data;
output spm_rw;
output spm_as_;
output [29:0] spm_addr;
input [31:0] spm_rd_data;
	
	/*忙信号*/
output busy;

/*module之间连线*/
wire [29:0] addr;
wire as_;
wire rw;
wire [31:0] wr_data;
wire [31:0] rd_data;
wire miss_align;
wire [29:0] mem_pc;
wire [1:0] mem_ctrl_op;
wire [4:0] mem_dst_addr;
wire [2:0] mem_exp_code;
wire [31:0] mem_out;
wire [31:0] spm_rd_data;
wire [31:0] spm_wr_data;
wire [29:0] spm_addr;


bus_if bus_if_2(
	/*时钟复位*/
	.clk(clk),
	.reset(reset),
	
	/*流水线控制信号*/
	.stall(stall), //延迟信号
	.flush(flush), //刷新信号
	.busy(busy), //忙信号
	
	/*CPU接口*/
	.addr(addr), //地址
	.as_(as_), //选通
	.rw(rw), //读写01
	.wr_data(wr_data), //写入的数据
	.rd_data(rd_data), //读取的数据
	
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



mem_ctrl mem_ctrl_0(
	
	/*EX/MEM流水线寄存器*/
	.ex_en(ex_en),
	.ex_mem_op(ex_mem_op),
	.ex_mem_wr_data(ex_mem_wr_data),
	.ex_out(ex_out),
	
	/*内存访问接口*/
	.rd_data(rd_data),
	.addr(addr),
	.as_(as_),
	.rw(rw),
	.wr_data(wr_data),
	
	/*内存访问结果*/
	.out(fwd_data),
	.miss_align(miss_align)
	
);


mem_reg mem_reg_0(

	/*时钟和复位*/
	.clk(clk),
	.reset(reset),
	
	/*流水线控制信号*/
	.stall(stall),
	.flush(flush),
	
	/*内存访问结果*/
	.out(fwd_data),
	.miss_align(miss_align),
	
	/*EX/MEM流水线寄存器*/
	.ex_pc(ex_pc),
	.ex_en(ex_en),
	.ex_br_flag(ex_br_flag),
	.ex_ctrl_op(ex_ctrl_op),
	.ex_dst_addr(ex_dst_addr),
	.ex_gpr_we_(ex_gpr_we_),
	.ex_exp_code(ex_exp_code),
	
	/*MEM/WB流水线寄存器*/
	.mem_pc(mem_pc),
	.mem_en(mem_en),
	.mem_br_flag(mem_br_flag),
	.mem_ctrl_op(mem_ctrl_op),
	.mem_dst_addr(mem_dst_addr),
	.mem_gpr_we_(mem_gpr_we_),
	.mem_exp_code(mem_exp_code),
	.mem_out(mem_out)


);


























endmodule