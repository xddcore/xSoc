module exu_top(
	/*时钟和复位*/
	clk,
	reset,
	
	/*中断检测信号*/
	int_detect,
	
	/*流水线控制信号*/
	stall,
	flush,
	
	/*EX/MEM寄存器*/
	ex_pc,
	ex_en,
	ex_br_flag,
	ex_mem_op,
	ex_mem_wr_data,
	ex_ctrl_op,
	ex_dst_addr,
	ex_gpr_we_,
	ex_exp_code,
	ex_out,
	
	/*ID/EX寄存器*/
	id_exp_code,
	id_gpr_we_,
	id_dst_addr,
	id_ctrl_op,
	id_mem_wr_data,
	id_mem_op,
	id_br_flag,
	id_alu_in_1,
	id_alu_in_0,
	id_alu_op,
	id_en,
	id_pc,
	/*直通*/
	fwd_data
);


	/*时钟和复位*/
input clk;
input reset;
	
	/*中断检测信号*/
input int_detect;
	
	/*流水线控制信号*/
input stall;
input flush;
	
	/*EX/MEM寄存器*/
output [29:0] ex_pc;
output ex_en;
output ex_br_flag;
output [1:0] ex_mem_op;
output [31:0] ex_mem_wr_data;
output [1:0] ex_ctrl_op;
output [4:0] ex_dst_addr;
output ex_gpr_we_;
output [2:0] ex_exp_code;
output [31:0] ex_out;
	
	/*ID/EX寄存器*/
input [2:0] id_exp_code;
input id_gpr_we_;
input [4:0] id_dst_addr;
input [1:0] id_ctrl_op;
input [31:0] id_mem_wr_data;
input [1:0] id_mem_op;
input id_br_flag;
input [31:0] id_alu_in_1;
input [31:0] id_alu_in_0;
input [3:0] id_alu_op;
input id_en;
input [29:0] id_pc;
	/*直通*/
output [31:0] fwd_data;

/*module之间连线*/
wire alu_of;
wire [29:0] ex_pc;
wire [1:0] ex_mem_op;
wire [31:0] ex_mem_wr_data;
wire [1:0] ex_ctrl_op;
wire [2:0] ex_exp_code;
wire [31:0] ex_out;




ex_reg ex_reg_0(
		/*系统与复位*/
	.clk(clk),
	.reset(reset),
	
	/*ALU输入*/
	.alu_out(fwd_data),
	.alu_of(alu_of),
	
	/*流水线控制信号*/
	.stall(stall),
	.flush(flush),
	.int_detect(int_detect), //中断检测
	
	/*ID/IE流水线寄存器输入*/
	.id_pc(id_pc),
	.id_en(id_en),
	.id_br_flag(id_br_flag),
	.id_mem_op(id_mem_op),
	.id_mem_wr_data(id_mem_wr_data),
	.id_ctrl_op(id_ctrl_op),
	.id_dst_addr(id_dst_addr),
	.id_gpr_we_(id_gpr_we_),
	.id_exp_code(id_exp_code),
	
	/*EX/ME流水线寄存器输出*/
	.ex_pc(ex_pc),
	.ex_en(ex_en),
	.ex_br_flag(ex_br_flag),
	.ex_mem_op(ex_mem_op),
	.ex_mem_wr_data(ex_mem_wr_data),
	.ex_ctrl_op(ex_ctrl_op),
	.ex_dst_addr(ex_dst_addr),
	.ex_gpr_we_(ex_gpr_we_),
	.ex_exp_code(ex_exp_code),
	.ex_out(ex_out)
);



alu alu_0(
	/*输入*/
	.in_0(id_alu_in_0), //输入1
	.in_1(id_alu_in_1), //输入2
	.op(id_alu_op), //操作码
	
	/*运算结果*/
	.out(fwd_data), //输出
	.of(alu_of) //溢出
);

























endmodule