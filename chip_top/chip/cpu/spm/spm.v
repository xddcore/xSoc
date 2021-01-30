`include "../../../global_config.h"
`include "../spm/spm.h"
module spm(
	clk,
	
	/*A端口 从内从中提取指令(IF)阶段*/
	if_spm_addr,//地址
	if_spm_as_,//选通
	if_spm_rw,//读写
	if_spm_wr_data,//写入的数据
	if_spm_rd_data,//读取的数据
	/*B端口 结果写入内存阶段(MEM)阶段*/
	mem_spm_addr,//地址
	mem_spm_as_,//选通
	mem_spm_rw,//读写
	mem_spm_wr_data,//写入的数据
	mem_spm_rd_data//读取的数据	
);

input clk;
	
	/*A端口 从内从中提取指令(IF)阶段*/
input [11:0] if_spm_addr;//地址
input if_spm_as_;//选通
input if_spm_rw;//读写
input [31:0] if_spm_wr_data;//写入的数据
output [31:0] if_spm_rd_data;//读取的数据
	/*B端口 结果写入内存阶段(MEM)阶段*/
input [11:0] mem_spm_addr;//地址
input mem_spm_as_;//选通
input mem_spm_rw;//读写
input [31:0] mem_spm_wr_data;//写入的数据
output [31:0] mem_spm_rd_data;//读取的数据	
	
reg wea;//a端口写入有效
reg web;//b端口写入有效

/*模块内部接线*/
wire [11:0] if_spm_addr;
wire [31:0] if_spm_wr_data;
wire [11:0] mem_spm_addr;
wire [31:0] mem_spm_wr_data;//写入的数据
wire [31:0] mem_spm_rd_data;//读取的数据


always @(*)
	begin
		/*A端口 从内从中提取指令(IF)阶段*/
		if((if_spm_as_ == `ENABLE_) && (if_spm_rw == `WRITE)) //写入
			begin
				wea = `MEM_ENABLE;//写入有效
			end
		else
			begin
				wea = `MEM_DISABLE;//写入有效
			end
		/*B端口 结果写入内存阶段(MEM)阶段*/
		if((mem_spm_as_ == `ENABLE_) && (mem_spm_rw == `WRITE)) //写入
			begin
				web = `MEM_ENABLE;//写入有效
			end
		else
			begin
				web = `MEM_DISABLE;//写入有效
			end
	end
	
dual_port_ram spm(
	.clock(clk),//时钟
	
	/*A端口 从内从中提取指令(IF)阶段*/
	.address_a(if_spm_addr), //地址
	.data_a(if_spm_wr_data),//写入的数据
	//.rden_a(wea),//读取有效
	.wren_a(wea),//写入有效
	.q_a(if_spm_rd_data),//读取的数据
	
	/*B端口 结果写入内存阶段(MEM)阶段*/
	.address_b(mem_spm_addr),//地址
	.data_b(mem_spm_wr_data),//写入的数据
	//.rden_b(web),//读取有效
	.wren_b(web),//写入有效
	.q_b(mem_spm_rd_data)//读取的数据
		
);
























endmodule