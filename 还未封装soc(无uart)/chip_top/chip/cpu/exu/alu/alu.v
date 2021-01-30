`include "../../../global_config.h"
`include "../isa.h"
`include "../cpu.h"
module alu(
	
	/*输入*/
	in_0, //输入1
	in_1, //输入2
	op, //操作码
	
	/*运算结果*/
	out, //输出
	of //溢出
	
);

input [31:0] in_0;
input [31:0] in_1;
input [3:0] op;

output [31:0] out;
output of;

reg [31:0] out;
reg of;
 


	/*有符号输入输出信号*/
wire signed [`WordDataBus] s_in_0 = $signed(in_0); //有符号输入0
wire signed [`WordDataBus] s_in_1 = $signed(in_1); //有符号输入1
wire signed [`WordDataBus] s_out = $signed(out); //有符号输出

	
/*算数逻辑运算(ALu)*/
always @(*)
	begin
		case(op)//根据操作码选择运算
		
			`ALU_OP_AND:
				begin
					out = in_0 & in_1;
				end
			
			`ALU_OP_OR:
				begin
					out = in_0 | in_1;
				end
			`ALU_OP_XOR:
				begin
					out = in_0 ^ in_1;
				end
			`ALU_OP_ADDS:
				begin
					out = in_0 + in_1;
				end
			`ALU_OP_ADDU:
				begin
					out = in_0 + in_1;
				end
			`ALU_OP_SUBS:
				begin
					out = in_0 - in_1;
				end
			`ALU_OP_SUBU:
				begin
					out = in_0 - in_1;
				end
			`ALU_OP_SHRL:
				begin
					out = in_0 >> in_1[`ShAmountLoc];
				end
			`ALU_OP_SHLL:
				begin
					out = in_0 << in_1[`ShAmountLoc];
				end
			default:
				begin
					out = in_0;
				end
		endcase
	end

/*溢出检测*/
always @(*)
	begin
		case(op)
			`ALU_OP_ADDS://加法溢出检测
				begin
					if( ((s_in_0 > 0) && (s_in_1 >0) && (s_out < 0)) || //两个正数相加,结果为负数则溢出
					    ((s_in_0 < 0) && (s_in_1 <0) && (s_out > 0)) ) //两个负数相加,结果为正数则溢出
						begin
							of = `ENABLE; //溢出
						end
					else
						begin
							of = `DISABLE; //非溢出
						end
				end
			`ALU_OP_SUBS:
				begin
					if( ((s_in_0 < 0) && (s_in_1 >0) && (s_out > 0)) || //负数减正数,结果为正数则溢出
					    ((s_in_0 > 0) && (s_in_1 <0) && (s_out < 0)) ) //正数减负数,结果为负数则溢出
						 begin
							of = `ENABLE; //溢出
						 end
					else
						begin
							of = `DISABLE; //非溢出
						end
				end
			default:
				begin
					of = `DISABLE; //非溢出
				end
		endcase
	end
































endmodule