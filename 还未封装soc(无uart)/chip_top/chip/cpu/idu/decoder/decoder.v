`include "../isa.h"
`include "../cpu.h"
`include "../../../global_config.h"
/*操作码6bit;ra,rb,rc 5bit;imm 16bit*/
module decoder(
	/*IF/ID流水线寄存器*/
	if_pc,
	if_insn,
	if_en,
	
	/*GPR通用寄存器接口*/
	gpr_rd_data_0,//读取地址0
	gpr_rd_data_1,
	
	gpr_rd_addr_0,
	gpr_rd_addr_1,
	
	/*来自ID阶段的数据直通*/
	id_en, //流水线数据有效
	id_dst_addr, //写入地址
	id_gpr_we_, //写入有效
	id_mem_op, //内存操作
	
	/*来自EX阶段的数据直通*/
	ex_en, //流水线数据有效
	ex_dst_addr,//写入地址
	ex_gpr_we_,//写入有效
	ex_fwd_data,//数据直通
	
	/*来自MEM阶段的数据直通*/
	mem_fwd_data,
	
	/*ID控制寄存器接口*/
	exe_mode,//执行模式
	creg_rd_data,//读取数据
	creg_rd_addr,//读取的地址
	
	/*解码结果*/
	alu_op,//alu操作
	alu_in_0,//alu输入0
	alu_in_1,//alu输入1
	br_addr,//分支地址
	br_taken,//分支成立
	br_flag,//分支标志位
	mem_op,//内存操作
	mem_wr_data,//内存写入数据
	ctrl_op,//控制操作
	dst_addr,//通用寄存器地址
	gpr_we_,//通用寄存器有效
	exp_code,//异常代码
	ld_hazard//load冒险
	
);

	/*IF/ID流水线寄存器*/
input [29:0] if_pc;
input [31:0] if_insn;
input if_en;
	
	/*GPR通用寄存器接口*/
input [31:0] gpr_rd_data_0;//读取地址0
input	[31:0] gpr_rd_data_1;
	
output [4:0] gpr_rd_addr_0;
output [4:0] gpr_rd_addr_1;
	
	/*来自ID阶段的数据直通*/
input id_en; //流水线数据有效
input [4:0] id_dst_addr; //写入地址
input id_gpr_we_; //写入有效
input [1:0] id_mem_op; //内存操作
	
	/*来自EX阶段的数据直通*/
input ex_en; //流水线数据有效
input [4:0]ex_dst_addr;//写入地址
input	ex_gpr_we_;//写入有效
input [31:0] ex_fwd_data;//数据直通

	/*来自MEM阶段的数据直通*/
input [31:0] mem_fwd_data;
	
	/*ID控制寄存器接口*/
input exe_mode;//执行模式
input [31:0] creg_rd_data;//读取数据
output [4:0] creg_rd_addr;//读取的地址
	
	/*解码结果*/
output [3:0] alu_op;//alu操作
output [31:0] alu_in_0;//alu输入0
output [31:0] alu_in_1;//alu输入1
output [29:0] br_addr;//分支地址
output br_taken;//分支成立
output br_flag;//分支标志位
output [1:0] mem_op;//内存操作
output [31:0] mem_wr_data;//内存写入数据
output [1:0] ctrl_op;//控制操作
output [4:0] dst_addr;//通用寄存器地址
output gpr_we_;//通用寄存器有效
output [2:0]exp_code;//异常代码
output ld_hazard;//load冒险


	/*IF/ID流水线寄存器*/
//reg [29:0] if_pc;
//reg [31:0] if_insn;
//reg if_en;
		
	/*解码结果*/
reg [3:0] alu_op;//alu操作
reg [31:0] alu_in_0;//alu输入0
reg [31:0] alu_in_1;//alu输入1
reg [29:0] br_addr;//分支地址
reg br_taken;//分支成立
reg br_flag;//分支标志位
reg [1:0] mem_op;//内存操作
reg [1:0] ctrl_op;//控制操作
reg [4:0] dst_addr;//通用寄存器地址
reg gpr_we_;//通用寄存器有效
reg [2:0]exp_code;//异常代码
reg ld_hazard;//load冒险 
	
/********内部信号*********/

/********指令字段提取*********/
wire [`IsaOpBus] op = if_insn[`IsaOpLoc];//操作码
wire [`IsaRegAddrBus] ra_addr = if_insn[`IsaRaAddrLoc];//ra地址
wire [`IsaRegAddrBus] rb_addr = if_insn[`IsaRbAddrLoc];//rb地址
wire [`IsaRegAddrBus] rc_addr = if_insn[`IsaRcAddrLoc];//rc地址
wire [`IsaImmBus] imm = if_insn[`IsaImmLoc];

/********立即数(扩充到32bit)*********/
	/*立即数(扩充到32bit)*/
wire [31:0] imm_s = {{`ISA_EXT_W{imm[`ISA_IMM_MSB]}},imm};//MSB符号位填充满32bit
wire [31:0] imm_u = {{`ISA_EXT_W{1'b0}},imm};//0填充满32bit;

/********寄存器读取地址*********/
assign gpr_rd_addr_0 = ra_addr;//通用寄存器地址0
assign gpr_rd_addr_1 = rb_addr;//通用寄存器地址1
assign creg_rd_addr = ra_addr;//控制寄存器读取地址

/********通用寄存器读取数据*********/

reg [31:0] ra_data;//ra寄存器数据(无符号)
wire signed [31:0] s_ra_data = $signed(ra_data); //ra寄存器数据(有符号)
reg [31:0] rb_data;//ra寄存器数据(无符号)
wire signed [31:0] s_rb_data = $signed(rb_data); //ra寄存器数据(有符号)

assign mem_wr_data = rb_data;//内存写入数据

/********地址*********/

wire [29:0] ret_addr = if_pc + 1'b1;//返回地址
wire [29:0] br_target = if_pc + imm_s[`WORD_ADDR_MSB:0];//分支目标地址
wire [29:0] jr_target = ra_data[`WordAddrLoc];//条件目标地址


/********数据直通*********/
always @(*)
	begin
		/*ra寄存器*/
		if((id_en == `ENABLE) && (id_gpr_we_ == `ENABLE_)&&
			(id_dst_addr == ra_addr))
			begin
				ra_data = ex_fwd_data; //来自EX的数据直通
			end
		else if((ex_en == `ENABLE) && (ex_gpr_we_ == `ENABLE_)&&
					(ex_dst_addr == ra_addr))
			begin
				ra_data = mem_fwd_data;//来自MEM阶段的数据直通
			end
		else
			begin
				ra_data = gpr_rd_data_0;//从寄存器读取
			end
			
			
		/*rb寄存器*/
		if((id_en == `ENABLE) && (id_gpr_we_ == `ENABLE_)&&
			(id_dst_addr == rb_addr))
			begin
				rb_data = ex_fwd_data; //来自EX的数据直通
			end
		else if((ex_en == `ENABLE) && (ex_gpr_we_ == `ENABLE_)&&
					(ex_dst_addr == rb_addr))
			begin
				rb_data = mem_fwd_data;//来自MEM阶段的数据直通
			end
		else
			begin
				rb_data = gpr_rd_data_1;//从寄存器读取
			end
	end
	
/********Load冒险检测*********/
always @(*)
	begin
		if((id_en == `ENABLE) && (id_mem_op == `MEM_OP_LDW)&&
			(id_dst_addr == ra_addr) || (id_dst_addr == rb_addr))
			begin
				ld_hazard = `ENABLE;//发生load冒险
			end
		else
			begin
				ld_hazard = `DISABLE;//未发生load冒险
			end
	end
	
/********指令解码*********/
always @(*)
	begin
		/*初始化为默认值*/
		alu_op = `ALU_OP_NOP;
		alu_in_0 = ra_data;
		alu_in_1 = rb_data;
		br_taken = `DISABLE;
		br_flag = `DISABLE;
		br_addr = {`WORD_ADDR_W{1'b0}};
		mem_op = `MEM_OP_NOP;
		ctrl_op = `CTRL_OP_NOP;
		dst_addr = rb_addr;
		gpr_we_ = `DISABLE;
		exp_code = `ISA_EXP_NO_EXP;
		
		/*操作码解码*/
		case(op)
			/*逻辑运算指令*/
			`ISA_OP_ANDR:
				begin
					alu_op = `ALU_OP_AND;
					dst_addr = rc_addr;
					gpr_we_ = `ENABLE_;
				end
			`ISA_OP_ADDI:
				begin
					alu_op = `ALU_OP_AND;
					alu_in_1 = imm_u;
					gpr_we_ = `ENABLE_;
				end
			`ISA_OP_ORR:
				begin
					alu_op = `ALU_OP_OR;
					dst_addr = rc_addr;
					gpr_we_ =`ENABLE_;
				end
			`ISA_OP_ORI:
				begin
					alu_op = `ALU_OP_OR;
					alu_in_1 = imm_u;
					gpr_we_ = `ENABLE_;
				end
			`ISA_OP_XORR:
				begin
					alu_op = `ALU_OP_XOR;
					dst_addr = rc_addr;
					gpr_we_ =`ENABLE_;
				end
			`ISA_OP_XORI:
				begin
					alu_op = `ALU_OP_XOR;
					alu_in_1 = imm_u;
					gpr_we_ = `ENABLE_;
				end
				
			/*算术运算指令*/
			`ISA_OP_ADDSR:
				begin
					alu_op = `ALU_OP_ADDS;
					dst_addr = rc_addr;
					gpr_we_ = `ENABLE_;
				end
			`ISA_OP_ADDSI:
				begin
					alu_op = `ALU_OP_ADDS;
					alu_in_1 = imm_s;
					gpr_we_ =`ENABLE_;
				end
			`ISA_OP_ADDUR:
				begin
					alu_op = `ALU_OP_ADDU;
					dst_addr = rc_addr;
					gpr_we_ =`ENABLE_;
				end
			`ISA_OP_ADDUI:
				begin
					alu_op = `ALU_OP_ADDU;
					alu_in_1 = imm_s;
					gpr_we_ =`ENABLE_;
				end
			`ISA_OP_SUBSR:
				begin
					alu_op = `ALU_OP_SUBS;
					dst_addr = rc_addr;
					gpr_we_ = `ENABLE_;
				end
			`ISA_OP_SUBUR:
				begin
					alu_op = `ALU_OP_SUBU;
					dst_addr = rc_addr;
					gpr_we_ = `ENABLE_;
				end
				
			/*移位指令*/
			`ISA_OP_SHRLR:
				begin
					alu_op = `ALU_OP_SHRL;
					dst_addr = rc_addr;
					gpr_we_ = `ENABLE_;
				end
			`ISA_OP_SHRLI:
				begin
					alu_op = `ALU_OP_SHRL;
					alu_in_1 = imm_u;
					gpr_we_ = `ENABLE_;
				end
			`ISA_OP_SHLLR:
				begin
					alu_op = `ALU_OP_SHLL;
					dst_addr = rc_addr;
					gpr_we_ = `ENABLE_;
				end
			`ISA_OP_SHLLI:
				begin
					alu_op = `ALU_OP_SHLL;
					alu_in_1 = imm_u;
					gpr_we_ = `ENABLE_;
				end
				
			/*分支指令*/
			`ISA_OP_BE:
				begin
					br_addr = br_target;
					br_taken =  (ra_data == rb_data) ? `ENABLE : `DISABLE;
					br_flag = `ENABLE;
				end
			`ISA_OP_BNE:
				begin
					br_addr = br_target;
					br_taken =  (ra_data != rb_data) ? `ENABLE : `DISABLE;
					br_flag = `ENABLE;					
				end
			`ISA_OP_BSGT:
				begin
					br_addr = br_target;
					br_taken =  (s_ra_data < s_rb_data) ? `ENABLE : `DISABLE;
					br_flag = `ENABLE;
				end
			`ISA_OP_BUGT:
				begin
					br_addr = br_target;
					br_taken =  (ra_data < rb_data) ? `ENABLE : `DISABLE;
					br_flag = `ENABLE;
				end
			`ISA_OP_JMP:
				begin
					br_addr = jr_target;
					br_taken = `ENABLE;
					br_flag = `ENABLE;
				end
			`ISA_OP_CALL:
				begin
					alu_in_0 = {ret_addr,{`BYTE_OFFSET_WORD{1'b0}}};
					br_addr = jr_target;
					br_taken = `ENABLE;
					br_flag = `ENABLE;
					dst_addr = `REG_ADDR_W'd31;
					gpr_we_ = `ENABLE_;
				end
				
			/*内存访问指令*/
			`ISA_OP_LDW:
				begin
					alu_op = `ALU_OP_ADDU;
					alu_in_1 = imm_s;
					mem_op = `MEM_OP_LDW;
					gpr_we_ = `ENABLE;
				end
			`ISA_OP_STW:
				begin
					alu_op = `ALU_OP_ADDU;
					alu_in_1 = imm_s;
					mem_op = `MEM_OP_STW;
				end
				
			/*系统调用指令*/
			`ISA_OP_TRAP://陷阱
				begin
					exp_code = `ISA_EXP_TRAP;
				end
			
				
			/*特权指令*/
			`ISA_OP_RDCR:
				begin
					if(exe_mode == `CPU_KERNEL_MODE)
						begin
							alu_in_0 = creg_rd_data;
							gpr_we_ = `ENABLE;
						end
					else
						begin
							exp_code = `ISA_EXP_PRV_VIO;
						end
				end
			`ISA_OP_WRCR:
				begin
					if(exe_mode == `CPU_KERNEL_MODE)
						begin
							ctrl_op = `CTRL_OP_WRCR;
						end
					else
						begin
							exp_code = `ISA_EXP_PRV_VIO;
						end					
				end
			`ISA_OP_EXRT:
				begin
					if(exe_mode == `CPU_KERNEL_MODE)
						begin
							ctrl_op = `CTRL_OP_EXRT;
						end
					else
						begin
							exp_code = `ISA_EXP_PRV_VIO;
						end					
				end
			default :
				begin
					exp_code = `ISA_EXP_UNDEF_INSN;
				end
		endcase
		
	end






























endmodule