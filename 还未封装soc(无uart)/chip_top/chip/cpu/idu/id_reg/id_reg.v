`include "../../../global_config.h"
`include "../isa.h"
`include "../cpu.h"
module id_reg(

	/*时钟与复位*/
	clk,
	reset,
	
	/*解码结果*/
	alu_op,
	alu_in_0,
	alu_in_1,
	br_flag,
	mem_op,
	mem_wr_data,
	ctrl_op,
	dst_addr,
	gpr_we_,
	exp_code,
	
	/*流水线控制信号*/
	stall,
	flush,
	
	/*if/id流水线寄存器*/
	if_pc,
	if_en,
	
	/*id/ex流水线寄存器*/
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
	id_exp_code	
);

	/*时钟与复位*/
input clk;
input reset;
	
	/*解码结果*/
input [3:0] alu_op;
input [31:0] alu_in_0;
input [31:0] alu_in_1;
input br_flag;
input [1:0] mem_op;
input [31:0] mem_wr_data;
input [1:0] ctrl_op;
input [4:0] dst_addr;
input gpr_we_;
input [2:0] exp_code;
	
	/*流水线控制信号*/
input stall;
input flush;
	
	/*if/id流水线寄存器*/
input [29:0] if_pc;
input if_en;
	
	/*id/ex流水线寄存器*/
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
output [2:0]id_exp_code;	

	

	
	/*id/ex流水线寄存器*/
reg [29:0] id_pc;
reg id_en;
reg [3:0] id_alu_op;
reg [31:0] id_alu_in_0;
reg [31:0] id_alu_in_1;
reg id_br_flag;
reg [1:0] id_mem_op;
reg [31:0] id_mem_wr_data;
reg [1:0] id_ctrl_op;
reg [4:0] id_dst_addr;
reg id_gpr_we_;
reg [2:0]id_exp_code;	


/***********id流水线寄存器***********/

always @(posedge clk or `RESET_EDGE reset)
	begin
		if(reset == `RESET_ENABLE)
			begin
				id_pc <= `WORD_ADDR_W'h0;
				id_en <= `DISABLE;
				id_alu_op <= `ALU_OP_NOP;
				id_alu_in_0 <= `WORD_DATA_W'h0;
				id_alu_in_1 <= `WORD_DATA_W'h0;
				id_br_flag <= `DISABLE;
				id_mem_op <= `MEM_OP_NOP;
				id_mem_wr_data <= `WORD_DATA_W'h0;
				id_ctrl_op <= `CTRL_OP_NOP;
				id_dst_addr <= `REG_ADDR_W'd0;
				id_gpr_we_ <= `DISABLE_;
				id_exp_code <= `ISA_EXP_NO_EXP;			
			end
		else
			begin
				if(stall == `DISABLE)
					begin
						if(flush == `ENABLE)//刷新流水线
							begin
								id_pc <= `WORD_ADDR_W'h0;
								id_en <= `DISABLE;
								id_alu_op <= `ALU_OP_NOP;
								id_alu_in_0 <= `WORD_DATA_W'h0;
								id_alu_in_1 <= `WORD_DATA_W'h0;
								id_br_flag <= `DISABLE;
								id_mem_op <= `MEM_OP_NOP;
								id_mem_wr_data <= `WORD_DATA_W'h0;
								id_ctrl_op <= `CTRL_OP_NOP;
								id_dst_addr <= `REG_ADDR_W'd0;
								id_gpr_we_ <= `DISABLE_;
								id_exp_code <= `ISA_EXP_NO_EXP;
							end
						else
							begin
								id_pc <= if_pc;
								id_en <= if_en;
								id_alu_op <= alu_op;
								id_alu_in_0 <= alu_in_0;
								id_alu_in_1 <= alu_in_1;
								id_br_flag <= br_flag;
								id_mem_op <= mem_op;
								id_mem_wr_data <= mem_wr_data;
								id_ctrl_op <= ctrl_op;
								id_dst_addr <= dst_addr;
								id_gpr_we_ <= gpr_we_;
								id_exp_code <= exp_code;								
							end
					end
			end
	end

























endmodule