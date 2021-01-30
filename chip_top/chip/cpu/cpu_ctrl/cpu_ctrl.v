`include "../../../global_config.h"
`include "../cpu.h"
`include "../isa.h"
module cpu_ctrl(
	/*时钟和复位*/
	clk,
	reset,
	
	/*CPU控制寄存器接口*/
	creg_rd_addr,
	creg_rd_data,
	exe_mode,
	
	/*中断*/
	irq,
	int_detect,
	
	/*ID/EX流水线寄存器*/
	id_pc,
	
	/*ID/EX流水线寄存器*/
	mem_pc,
	mem_en,
	mem_br_flag,
	mem_ctrl_op,
	mem_dst_addr,
	mem_gpr_we_,
	mem_exp_code,
	mem_out,
	
	/*流水线的状态*/
	if_busy,
	ld_hazard,//load冒险
	mem_busy,
	
	/*延迟信号*/
	if_stall,
	id_stall,
	ex_stall,
	mem_stall,
	
	/*刷新信号*/
	
	if_flush,
	id_flush,
	ex_flush,
	mem_flush,
	new_pc
		
);

	/*时钟和复位*/
input clk;
input reset;
	
	/*CPU控制寄存器接口*/
input [4:0] creg_rd_addr;
output [31:0] creg_rd_data;
output exe_mode;
	
	/*中断*/
input [7:0] irq;
output int_detect;
	
	/*ID/EX流水线寄存器*/
input	[29:0] id_pc;
	
	/*ID/EX流水线寄存器*/
input [29:0] mem_pc;
input mem_en;
input mem_br_flag;
input [1:0]	mem_ctrl_op;
input [4:0]	mem_dst_addr;
input mem_gpr_we_;
input [2:0] mem_exp_code;
input [31:0] mem_out;
	
	/*流水线的状态*/
input if_busy;
input ld_hazard;//load冒险
input mem_busy;
	
	/*延迟信号*/
output if_stall;
output id_stall;
output ex_stall;
output mem_stall;
	
	/*刷新信号*/
	
output if_flush;
output id_flush;
output ex_flush;
output mem_flush;
output [29:0] new_pc;


	
	/*CPU控制寄存器接口*/
reg [31:0] creg_rd_data;
reg exe_mode;
	
	/*中断*/
reg int_detect;
	

	
reg [29:0] new_pc;

/**********内部信号**********/

	/*CPU控制寄存器*/
reg int_en; //0号寄存器:中断有效
reg pre_exe_mode; //1号寄存器:中断有效
reg pre_int_en; //2号寄存器:中断有效
reg [29:0] epc; //3号寄存器:中断有效
reg [29:0] exp_vector; //4号寄存器:中断有效
reg [2:0] exp_code; //5号寄存器:中断有效
reg dly_flag; //6号寄存器:中断有效
reg [7:0] mask; //7号寄存器:中断有效

	/*内部信号*/
reg [29:0] pre_pc; 
reg br_flag;
//8-28保留
//29:ROM容量
//30:SPM容量
//31 CPU信息 8bit y/m/ver/rev


/**********流水线控制信号**********/
	
	//延迟信号
	wire stall = if_busy | mem_busy;
	assign if_stall = stall | ld_hazard;
	assign id_stall = stall;
	assign ex_stall = stall;
	assign mem_stall = stall;
	
	//刷新信号
	reg flush;
	assign if_flush = flush;
	assign id_flush = flush|ld_hazard;
	assign ex_flush = flush;
	assign mem_flush = flush;
	
	//流水线刷新控制
	always @(*)
		begin
			new_pc = `WORD_ADDR_W'h0;
			flush = `DISABLE;
			/*流水线刷新*/
			if(mem_en == `ENABLE)
				begin
					if(mem_exp_code != `ISA_EXP_NO_EXP)//发生异常
						begin
							new_pc = exp_vector;
						end
					else if(mem_ctrl_op == `CTRL_OP_EXRT)//EXRT指令(陷阱)
						begin
							new_pc = epc;
							flush = `ENABLE;
						end
					else if(mem_ctrl_op == `CTRL_OP_WRCR)//WRCR指令
						begin
							new_pc = mem_pc;
							flush = `ENABLE;
						end
				end
		end
		

/**********中断检测**********/
	always @(*)
		begin
			if((int_en == `ENABLE) && ((|((~mask) & irq)) == `ENABLE))
				begin
					int_detect = `ENABLE;
				end
			else
				begin
					int_detect = `DISABLE;
				end
		end
		
/**********读取访问**********/
	always @(*)
		begin
			case(creg_rd_addr)
				
				`CREG_ADDR_STATUS: //0号控制寄存器
					begin
						creg_rd_data = {{`WORD_DATA_W-2{1'b0}}, int_en, exe_mode};
					end
				`CREG_ADDR_PRE_STATUS ://1号寄存器
					begin
						creg_rd_data = {{`WORD_DATA_W-2{1'b0}},pre_int_en,pre_exe_mode};
					end
				`CREG_ADDR_PC://2号程序计数器
					begin
						creg_rd_data = {id_pc, `BYTE_OFFSET_W'h0};
					end
				`CREG_ADDR_EPC://3号寄存器 异常程序计数器
					begin
						creg_rd_data = {epc, `BYTE_OFFSET_W'h0};
					end
				`CREG_ADDR_EXP_VECTOR://4号寄存器 异常向量
					begin
						creg_rd_data = {exp_vector, `BYTE_OFFSET_W'h0};
					end
				`CREG_ADDR_CAUSE://5号 异常原因
					begin
						creg_rd_data = {{`WORD_DATA_W-1 - `ISA_EXP_W{1'b0}},
												dly_flag, exp_code};
					end
				`CREG_ADDR_INT_MASK : //6号 中断屏蔽
					begin
						creg_rd_data = {{`WORD_DATA_W - `CPU_IRQ_CH{1'b0}},
												mask};
					end
				`CREG_ADDR_IRQ:// 7号 中断原因
					begin
						creg_rd_data = {{`WORD_DATA_W - `CPU_IRQ_CH{1'b0}},irq};
					end
				`CREG_ADDR_ROM_SIZE:// 29号 ROM容量
					begin
						creg_rd_data = $unsigned(`ROM_SIZE);
					end
				`CREG_ADDR_SPM_SIZE:// 30号 SPM容量
					begin
						creg_rd_data = $unsigned(`SPM_SIZE);
					end
				`CREG_ADDR_CPU_INFO:// 31号 控制寄存器
					begin
						creg_rd_data = {`RELEASE_YEAR, `RELEASE_MOUTH,
											 `RELEASE_VERSION, `RELEASE_REVISON};
					end
				default: //默认值
					begin
						creg_rd_data = `WORD_DATA_W'h0;
					end
			endcase	
		end
		

/**********CPU的控制**********/
	always @(posedge clk or `RESET_EDGE reset)
		begin
		if(reset == `RESET_ENABLE)//复位
				begin
					exe_mode <= `CPU_KERNEL_MODE;
					int_en <= `DISABLE;
					pre_exe_mode <= `CPU_KERNEL_MODE;
					pre_int_en <= `DISABLE;
					exp_code <= `ISA_EXP_NO_EXP;
					mask <= {`CPU_IRQ_CH{`ENABLE}};//中断屏蔽
					dly_flag <= `DISABLE;
					epc <= `WORD_ADDR_W'h0;
					exp_vector <= `WORD_ADDR_W'h0;
					pre_pc <= `WORD_ADDR_W'h0;
					br_flag <= `DISABLE;
				end
		else//更新cpu状态
			begin
				//pc和分支标志位保存
				if((mem_en == `ENABLE) && (stall == `DISABLE))
					begin
						pre_pc <= mem_pc;
						br_flag <= mem_br_flag;
						/*cpu状态控制*/
						if(mem_exp_code != `ISA_EXP_NO_EXP)//发生异常
							begin
								exe_mode <= `CPU_KERNEL_MODE;
								int_en <= `DISABLE;
								pre_exe_mode <= exe_mode;
								pre_int_en <= int_en;
								exp_code <= mem_exp_code;
								dly_flag <= br_flag;
								epc <= pre_pc;
							end
						else if(mem_ctrl_op == `CTRL_OP_EXRT)//EXRT命令
							begin
								exe_mode <= pre_exe_mode;
								int_en <= pre_int_en;
							end
						else if(mem_ctrl_op ==`CTRL_OP_WRCR)//WRCR命令
							begin
								/*写入控制寄存器*/
								case(mem_dst_addr)
									`CREG_ADDR_STATUS://0-cpu状态
										begin
											exe_mode <= mem_out[`CregExeModeLoc];
											int_en <= mem_out[`CregIntEnableLoc];
										end
									`CREG_ADDR_PRE_STATUS://1-异常发生前的状态
										begin
											pre_exe_mode <= mem_out[`CregExeModeLoc];
											pre_int_en <= mem_out[`CregIntEnableLoc];
										end
									`CREG_ADDR_EPC://3-异常程序计数器
										begin
											epc <= mem_out[`WordAddrLoc];
										end
									`CREG_ADDR_EXP_VECTOR://4-异常向量
										begin
											exp_vector <= mem_out[`WordAddrLoc];
										end
									`CREG_ADDR_CAUSE://5-异常原因
										begin
											dly_flag <= mem_out[`CregDlyFlagLoc];
											exp_code <= mem_out[`CregExpCodeLoc];
										end
									`CREG_ADDR_INT_MASK://6-中断屏蔽
										begin
											mask <= mem_out[`CPU_IRQ_CH-1:0];
										end
								endcase
							end
					end 
			end
		end






















endmodule