`include "../../../../global_config.h"
`include "../../isa.h"
`include "../../cpu.h"
module mem_reg(

	/*时钟和复位*/
	clk,
	reset,
	
	/*流水线控制信号*/
	stall,
	flush,
	
	/*内存访问结果*/
	out,
	miss_align,
	
	/*EX/MEM流水线寄存器*/
	ex_pc,
	ex_en,
	ex_br_flag,
	ex_ctrl_op,
	ex_dst_addr,
	ex_gpr_we_,
	ex_exp_code,
	
	/*MEM/WB流水线寄存器*/
	mem_pc,
	mem_en,
	mem_br_flag,
	mem_ctrl_op,
	mem_dst_addr,
	mem_gpr_we_,
	mem_exp_code,
	mem_out
	
);

	/*时钟和复位*/
input clk;
input reset;

/*流水线控制信号*/	
input stall;
input flush;

	/*内存访问结果*/
input [31:0] out;
input miss_align;
	
	/*EX/MEM流水线寄存器*/
input [29:0] ex_pc;
input ex_en;
input ex_br_flag;
input [1:0] ex_ctrl_op;
input [4:0] ex_dst_addr;
input ex_gpr_we_;
input [2:0] ex_exp_code;
	
	/*MEM/WB流水线寄存器*/
output [29:0] mem_pc;
output mem_en;
output mem_br_flag;
output [1:0] mem_ctrl_op;
output [4:0] mem_dst_addr;
output mem_gpr_we_;
output [2:0] mem_exp_code;
output [31:0] mem_out;


	/*MEM/WB流水线寄存器*/
reg [29:0] mem_pc;
reg mem_en;
reg mem_br_flag;
reg [1:0] mem_ctrl_op;
reg [4:0] mem_dst_addr;
reg mem_gpr_we_;
reg [2:0] mem_exp_code;
reg [31:0] mem_out;


always @(posedge clk or `RESET_EDGE reset)
	begin
		if(reset == `RESET_ENABLE)
			begin
				mem_pc <= `WORD_ADDR_W'h0;
				mem_en <= `DISABLE;
				mem_br_flag <= `DISABLE;	
				mem_ctrl_op <= `CTRL_OP_NOP;
				mem_dst_addr <= `REG_ADDR_W'h0;
				mem_gpr_we_ <= `DISABLE_;
				mem_exp_code <= `ISA_EXP_NO_EXP;
				mem_out <= `WORD_DATA_W'h0;
			end
		else
			begin
				if(stall == `DISABLE)//流水线非延迟
					if(flush == `ENABLE) //刷新流水线
						begin
							mem_pc <= `WORD_ADDR_W'h0;
							mem_en <= `DISABLE;
							mem_br_flag <= `DISABLE;	
							mem_ctrl_op <= `CTRL_OP_NOP;
							mem_dst_addr <= `REG_ADDR_W'h0;
							mem_gpr_we_ <= `DISABLE_;
							mem_exp_code <= `ISA_EXP_NO_EXP;
							mem_out <= `WORD_DATA_W'h0;
						end
					else if(miss_align == `ENABLE) //内存未对齐
						begin
							mem_pc <= ex_pc;
							mem_en <= ex_en;
							mem_br_flag <= ex_br_flag;
							mem_ctrl_op <= `CTRL_OP_NOP;
							mem_dst_addr <= `REG_ADDR_W'h0;
							mem_gpr_we_ <= `DISABLE_;
							mem_exp_code <= `ISA_EXP_MISS_ALIGN;
							mem_out <= `WORD_DATA_W'h0;
						end
					else //流水线更新到下一个数据
						begin
							mem_pc <= ex_pc;
							mem_en <= ex_en;
							mem_br_flag <= ex_br_flag;
							mem_ctrl_op <= ex_ctrl_op;
							mem_dst_addr <= ex_dst_addr;
							mem_gpr_we_ <= ex_gpr_we_;
							mem_exp_code <= ex_exp_code;
							mem_out <= out;
						end
			end
	end


























endmodule