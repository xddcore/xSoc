`include "./gpio.h"
`include "../../global_config.h"
module gpio(

	/*时钟复位*/
	clk,
	reset,
	
	/*总线接口*/
	cs_,
	as_,
	rw,
	addr,
	wr_data,
	rd_data,
	rdy_,
	
	/*输入输出端口*/
	gpio_io

);

	/*时钟复位*/
input clk;
input reset;
	
	/*总线接口*/
input cs_;
input as_;
input rw;
input [1:0] addr;
input [31:0] wr_data;
output [31:0] rd_data;
output rdy_;
output [15:0] gpio_io;

reg [31:0] rd_data;
reg rdy_;	
/*内部信号*/
	/*输入输出端口*/
wire [15:0] gpio_io;

/***********输入输出信号***********/
wire [`GPIO_IO_CH-1 :0]  io_in;
reg [`GPIO_IO_CH-1 :0] io_out;
reg [`GPIO_IO_CH-1 :0] io_dir;
reg [`GPIO_IO_CH-1 :0] io;
integer i;

/***********输入输出信号的连续赋值***********/
assign io_in = gpio_io; //输入的数据
assign gpio_io = io; //输入输出

/***********输入输出方向控制***********/
always @(*)
	begin
		for(i=0;i<`GPIO_IO_CH;i = i + 1)
			begin 
				io[i] = (io_dir[i] == `GPIO_DIR_IN) ? 1'bz : io_out[i];
			end
	end


/***********总线对GPIO的控制***********/
always @(posedge clk or `RESET_EDGE reset)
	begin
		if(reset == `RESET_ENABLE)
			begin
				rd_data <= `WORD_DATA_W'h0;
				rdy_ <= `DISABLE_;
				io_out <= {`GPIO_IO_CH{`LOW}};
				io_dir <= {`GPIO_IO_CH{`GPIO_DIR_IN}};
			end
		else //BUS控制
			begin
				if((cs_ == `ENABLE_) && (as_ == `ENABLE_))
					begin
						rdy_ <= `ENABLE_;
					end
				else
					begin
						rdy_ <= `DISABLE_;
					end
				/*读取访问*/
				if((cs_ == `ENABLE_) && (as_ == `ENABLE_) && (rw == `READ))
					begin
						case(addr)	
							`GPIO_ADDR_IO_DATA:
								begin
									rd_data <= {{`WORD_DATA_W-`GPIO_IO_CH{1'b0}},io_in};
								end
							`GPIO_ADDR_IO_DIR:
								begin
									rd_data <= {{`WORD_DATA_W-`GPIO_IO_CH{1'b0}},io_dir};
								end
						endcase
					end
				
				/*写入访问*/
				if((cs_ == `ENABLE_) && (as_ == `ENABLE_) && (rw == `WRITE))
					begin
						case(addr)
							`GPIO_ADDR_IO_DATA:
								begin
									io_out <= wr_data[`GPIO_IO_CH-1 :0];
								end
							`GPIO_ADDR_IO_DIR:
								begin
									io_dir <= wr_data[`GPIO_IO_CH-1 :0];
								end
						endcase
					end
			end
	end











endmodule