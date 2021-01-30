`include "./timer.h"
`include "../../global_config.h"
module timer(
	/*时钟与复位*/
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
	
	/*控制寄存器*/
	irq
);

	/*时钟与复位*/
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
	
output irq;

reg [31:0] rd_data;
reg rdy_;
	
reg irq;


/*内部信号*/

//控制寄存器0
reg mode;
reg start;
//控制寄存器2
reg [31:0] expr_val;
reg [31:0] counter;





/*计时完成标志位*/
//控制寄存器3
wire expr_flag = ((start ==`ENABLE) && (counter == expr_val))?
						`ENABLE : `DISABLE;
						


/*定时器控制*/

always @(posedge clk or `RESET_EDGE reset)
	begin
		if(reset == `RESET_ENABLE)
			begin
				rd_data <= `WORD_DATA_W'h0;
				rdy_ <= `DISABLE_;
				start <= `DISABLE;
				mode <= `TIMER_MODE_ONE_SHOT;
				irq <= `DISABLE;
				expr_val <= `WORD_DATA_W'h0;
				counter <= `WORD_DATA_W'h0;
			end
		else 
			begin
				//就绪信号生成
				if((cs_ == `ENABLE_) && (as_ == `ENABLE_))
					begin
						rdy_ <= `ENABLE_;
					end
				else
					begin
						rdy_ <= `DISABLE_;
					end
				//读取访问
				if((cs_ == `ENABLE_) && (as_ == `ENABLE_) && (rw == `READ))
					begin
						case(addr)
							`TIMER_ADDR_CTRL :
								begin
									rd_data <= {{`WORD_DATA_W-2{1'b0}},mode,start};
								end
							`TIMER_ADDR_INTR:
								begin
									rd_data <= {{`WORD_DATA_W-1{1'b0}},irq};
								end
							`TIMER_ADDR_EXPR:
								begin
									rd_data <= expr_val;
								end
							`TIMER_ADDR_COUNTER:
								begin
									rd_data <= counter;
								end
						endcase
					end
				else //无访问，输出0
					begin
						rd_data <= `WORD_DATA_W'h0;
					end
					
				//写入访问
				//控制寄存器0
				if((cs_ == `ENABLE_) && (as_ == `ENABLE_) && (rw == `WRITE)
					&&(addr == `TIMER_ADDR_CTRL))
					begin
						start <= wr_data[`TimerStartLoc];
						mode <= wr_data[`TimerModeLoc];
					end
				else if((expr_flag ==`ENABLE)	&&(mode == `TIMER_MODE_ONE_SHOT))
					begin
						start <= `DISABLE; //单次计时
					end
				//控制寄存器1
				if(expr_flag == `ENABLE)
					begin
						irq <= `ENABLE;
					end
				else if((cs_ == `ENABLE_) && (as_ == `ENABLE_) && (rw == `WRITE)
					&&(addr == `TIMER_ADDR_INTR))
					begin
						irq <= wr_data[`TimerIrqLoc];
					end
				
				//控制寄存器2
				if((cs_ == `ENABLE_) && (as_ == `ENABLE_) && (rw == `WRITE)
					&&(addr == `TIMER_ADDR_EXPR))
					begin
						expr_val <= wr_data;
					end
				
				//控制寄存器3
				if((cs_ == `ENABLE_) && (as_ == `ENABLE_) && (rw == `WRITE)
					&&(addr == `TIMER_ADDR_COUNTER))
					begin
						counter <= wr_data;
					end
				else if(expr_flag == `ENABLE)
					begin
						counter <= `WORD_DATA_W'h0;//达到最大值时，清零
					end
				else if(start == `ENABLE)
					begin
						counter = counter +1'd1; //clk计数
					end
			end
	end











endmodule