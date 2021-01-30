`include "../../global_config.h"
`include "../cpu/isa.h"
`include "../cpu/cpu.h"
module ex_reg(
	/*系统与复位*/
	clk,
	reset,
	
	/*ALU输出*/
	alu_out,
	alu_of,
	
	/*流水线控制信号*/
	stall,
	flush,
	int_detect, //中断检测
	
	/*ID/IE流水线寄存器输入*/
	id_pc,
	id_en,
	id_br_flag,
	id_mem_op,
	id_mem_wr_data,
	id_ctrl_op,
	id_dst_addr,
	id_gpr_we_,
	id_exp_code,
	
	/*EX/ME流水线寄存器输出*/
	ex_pc,
	ex_en,
	ex_br_flag,
	ex_mem_op,
	ex_mem_wr_data,
	ex_ctrl_op,
	ex_dst_addr,
	ex_gpr_we_,
	ex_exp_code,
	ex_out
);

	/*系统与复位*/
input clk;
input reset;
	
	/*ALU输出*/
input [31:0] alu_out;
input alu_of;
	
	/*流水线控制信号*/
input stall;
input flush;
input int_detect; //中断检测
	
	/*ID/IE流水线寄存器输入*/
input [29:0] id_pc;
input id_en;
input id_br_flag;
input [1:0] id_mem_op;
input [31:0] id_mem_wr_data;
input [1:0] id_ctrl_op;
input [4:0] id_dst_addr;
input id_gpr_we_;
input [2:0] id_exp_code;
	
	/*EX/ME流水线寄存器输出*/
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

reg [29:0] ex_pc;
reg ex_en;
reg ex_br_flag;
reg [1:0] ex_mem_op;
reg [31:0] ex_mem_wr_data;
reg [1:0] ex_ctrl_op;
reg [4:0] ex_dst_addr;
reg ex_gpr_we_;
reg [2:0] ex_exp_code;
reg [31:0] ex_out;


/********EX流水线寄存器********/

always @(negedge clk or `RESET_EDGE reset)
	begin
		if(reset == `RESET_ENABLE)
			begin
				ex_pc <= `WORD_ADDR_W'h0;
				ex_en <= `DISABLE;
				ex_br_flag <= `DISABLE;
				ex_mem_op <= `MEM_OP_NOP;
				ex_mem_wr_data <= `WORD_DATA_W'h0;
				ex_ctrl_op <= `CTRL_OP_NOP;
				ex_dst_addr <= `REG_ADDR_W'd0;
				ex_gpr_we_ <= `DISABLE;
				ex_exp_code <= `ISA_EXP_NO_EXP;
				ex_out <= `WORD_DATA_W'h0;
			end
		else
		/*流水线更新*/
			begin
				if(stall == `DISABLE)//延迟
					begin
						if(flush == `ENABLE)//刷新流水线
							begin
								ex_pc <= `WORD_ADDR_W'h0;
								ex_en <= `DISABLE;
								ex_br_flag <= `DISABLE;
								ex_mem_op <= `MEM_OP_NOP;
								ex_mem_wr_data <= `WORD_DATA_W'h0;
								ex_ctrl_op <= `CTRL_OP_NOP;
								ex_dst_addr <= `REG_ADDR_W'd0;
								ex_gpr_we_ <= `DISABLE;
								ex_exp_code <= `ISA_EXP_NO_EXP;
								ex_out <= `WORD_DATA_W'h0;
							end
						else if(int_detect == `ENABLE) //中断检测
							begin
								ex_pc <= id_pc;
								ex_en <= id_en;
								ex_br_flag <= id_br_flag;
								ex_mem_op <= `MEM_OP_NOP;
								ex_mem_wr_data <= `WORD_DATA_W'h0;
								ex_ctrl_op <= `CTRL_OP_NOP;
								ex_dst_addr <= `REG_ADDR_W'd0;
								ex_gpr_we_ <= `DISABLE;
								ex_exp_code <= `ISA_EXP_EXT_INT;
								ex_out <= `WORD_DATA_W'h0;								
							end
						else if(alu_of == `ENABLE)//算术溢出
							begin
								ex_pc <= id_pc;
								ex_en <= id_en;
								ex_br_flag <= id_br_flag;
								ex_mem_op <= `MEM_OP_NOP;
								ex_mem_wr_data <= `WORD_DATA_W'h0;
								ex_ctrl_op <= `CTRL_OP_NOP;
								ex_dst_addr <= `REG_ADDR_W'd0;
								ex_gpr_we_ <= `DISABLE;
								ex_exp_code <= `ISA_EXP_OVERFLOW;
								ex_out <= `WORD_DATA_W'h0;
							end
						else //流水线更新到下一个数据
							begin
								ex_pc <= id_pc;
								ex_en <= id_en;
								ex_br_flag <= id_br_flag;
								ex_mem_op <= id_mem_op;
								ex_mem_wr_data <= id_mem_wr_data;
								ex_ctrl_op <= id_ctrl_op;
								ex_dst_addr <= id_dst_addr;
								ex_gpr_we_ <= id_gpr_we_;
								ex_exp_code <= id_exp_code;
								ex_out <= alu_out;
							end
					end
			end
	end




























endmodule