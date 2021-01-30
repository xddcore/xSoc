`include "../../../global_config.h"
`include "../isa.h"
`include "../cpu.h"
module mem_ctrl(
	/*EX/MEM流水线寄存器*/
	ex_en,
	ex_mem_op,
	ex_mem_wr_data,
	ex_out,
	
	/*内存访问接口*/
	rd_data,
	addr,
	as_,
	rw,
	wr_data,
	
	/*内存访问结果*/
	out,
	miss_align
);
/*字节偏移*/
wire [1:0] offset;


	/*EX/MEM流水线寄存器*/
input ex_en;
input [1:0] ex_mem_op;
input [31:0] ex_mem_wr_data;
input [31:0] ex_out;
	
	/*内存访问接口*/
input [31:0] rd_data;
output [29:0] addr;
output as_;
output rw;
output [31:0] wr_data;
	
	/*内存访问结果*/
output [31:0] out;
output miss_align;//未对齐


reg as_;
reg rw;
//reg [31:0] wr_data;
	
	/*内存访问结果*/
reg [31:0] out;
reg miss_align;//未对齐


/********输出的赋值********/

assign wr_data = ex_mem_wr_data; //写入数据
assign addr = ex_out[`WordAddrLoc]; //地址
assign offset = ex_out[`ByteOffsetLoc];//偏移 1:0

/********内存访问控制********/

/*默认值*/
always @(*)
	begin
		miss_align = `DISABLE;
		out = `WORD_DATA_W'h0;
		as_ = `DISABLE_;
		rw = `READ;
		/*内存访问*/
		if(ex_en == `ENABLE)
			begin
				case(ex_mem_op)
					`MEM_OP_LDW://字读取
						begin
							if(offset == `BYTE_OFFSET_WORD)//对齐
								begin
									out = rd_data;
									as_ = `ENABLE_;
								end
							else
								begin
									miss_align =`ENABLE;//未对齐
								end
						end
					`MEM_OP_STW: //字写入
						begin
							if(offset == `BYTE_OFFSET_WORD)//对齐
								begin
									rw = `WRITE;
									as_ =`ENABLE_;
								end
							else
								begin
									miss_align = `ENABLE;
								end
						end
					default: //无内存访问
						begin
							out = ex_out;
						end
				endcase
			end
	end

























endmodule