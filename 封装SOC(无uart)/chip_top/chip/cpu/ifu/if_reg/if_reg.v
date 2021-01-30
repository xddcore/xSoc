/*流水线寄存器-控制PC指针+1*/
`include "../../global_config.h"
`include "../cpu/isa.h"
`include "../cpu/cpu.h"
module if_reg(
	/*时钟和复位*/
	clk,
	reset,
	
	/*读取数据*/
	insn,
	
	/*流水线控制信号*/
	stall,//延迟
	flush,//刷新
	new_pc,//新程序计数器
	br_taken,//branch分支成立
	br_addr, //分支目标地址
	
	/*if/id流水线寄存器*/
	if_pc,//程序计数器
	if_insn,//指令
	if_en //流水线数据有效位	
);

	/*时钟和复位*/
input clk;
input reset;
	
	/*读取数据*/
input [31:0] insn;
	
	/*流水线控制信号*/
input stall;//延迟
input flush;//刷新
input [29:0] new_pc;//新程序计数器
input br_taken;//branch分支成立
input [29:0] br_addr; //分支目标地址
	
	/*if/id流水线寄存器*/
output [29:0] if_pc;//程序计数器
output [31:0] if_insn;//指令
output if_en; //流水线数据有效位

/*if/id流水线寄存器*/
reg [29:0] if_pc;//程序计数器
reg [31:0] if_insn;//指令
reg if_en; //流水线数据有效位


/*IF流水线寄存器*/

always @(posedge clk or `RESET_EDGE reset)
	begin
		if(reset == `RESET_ENABLE)
			begin
				if_pc <= `RESET_VECTOR;
				if_insn <= `ISA_NOP;
				if_en <= `DISABLE;
			end
		else
			begin
				/*更新流水线寄存器*/
				if(stall == `DISABLE)//流水线非延迟
					begin
						if(flush == `ENABLE)//流水线刷新
							begin
								if_pc <= new_pc;//将PC地址更新为新地址
								if_insn <= `ISA_NOP; //清除指令寄存器
								if_en <= `DISABLE;
							end
						else if(br_taken == `ENABLE)//分支成立
							begin
								if_pc <= br_addr;//分支地址传给pc
								if_insn <= insn;//读取命令
								if_en <= `ENABLE;//数据有效
							end
						else //更新pc地址
							begin
								if_pc <= if_pc + 1'd1;//pc地址+1
								if_insn <= insn; //读取指令
								if_en <= `ENABLE;
							end
					end
			end
	end

endmodule