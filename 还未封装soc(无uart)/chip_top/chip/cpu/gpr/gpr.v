`include "../../../global_config.h"
`include "../cpu.h"
module gpr(
	clk,//时钟
	reset,//复位信号
	
	/*读取端口0*/
	rd_addr_0, //地址线
	rd_data_0, //数据线
	
	/*读取端口1*/
	rd_addr_1, //地址线
	rd_data_1, //数据线
	
	/*写入端口*/
	we_, //有效信号
	wr_addr,//写入的地址
	wr_data
);

input clk;
input reset;

input [4:0] rd_addr_0;
output [31:0] rd_data_0;

input [4:0] rd_addr_1;
output [31:0] rd_data_1;

input we_;
input [4:0] wr_addr;
input [31:0] wr_data;

wire [4:0] wr_addr;
wire [31:0] wr_data;

reg [31:0] gpr [31:0];//通用寄存器序列32* 32bits
integer i = 0;

/*GPR读取*/
//如果在读取时的地址(rd_addr_0)和写入的地址相同，则直接将写入的数据(wr_data)输出
//否则输出gpr寄存器内部地址的数据
assign rd_data_0 = ((we_ ==`ENABLE_) && (wr_addr == rd_addr_0)) ? 
						wr_data : gpr[rd_addr_0];

assign rd_data_1 = ((we_ ==`ENABLE_) && (wr_addr == rd_addr_1)) ?
						wr_data : gpr[rd_addr_1];

always @(posedge clk or `RESET_EDGE reset)
	begin
		if(reset == `RESET_ENABLE)
			begin
				for(i=0;i<`REG_NUM;i=i+1)
					begin
						gpr[i] <= `WORD_DATA_W'h0;//通用寄存器清零
					end
			end
		else
			begin
				if(we_ == `ENABLE_)
					begin
						gpr[wr_addr] <= wr_data;//写入数据到gpr
					end
			end
	end

	
	
endmodule