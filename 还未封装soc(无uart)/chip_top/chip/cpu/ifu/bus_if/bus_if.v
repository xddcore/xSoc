`include "../ifu/bus_if/bus_if.h"
`include "../cpu.h"
`include "../../../global_config.h"
module bus_if(
	/*时钟复位*/
	clk,
	reset,
	
	/*流水线控制信号*/
	stall, //延迟信号
	flush, //刷新信号
	busy, //忙信号
	
	/*CPU接口*/
	addr, //地址
	as_, //选通
	rw, //读写01
	wr_data, //写入的数据
	rd_data, //读取的数据
	
	/*SPM接口*/
	spm_rd_data, //读取的数据
	spm_addr, //地址
	spm_as_, //选通
	spm_rw, //读写
	spm_wr_data, //写入的数据
	
	/*总线接口*/
	bus_rd_data,//读取的数据
	bus_rdy_, //总线就绪
	bus_grnt_, //仲裁器许可信号
	bus_req_, //请求
	bus_addr, //地址
	bus_as_, //选通
	bus_rw, //读写
	bus_wr_data//写入的数据

);

	/*时钟复位*/
input clk;
input reset;
	
	/*流水线控制信号*/
input stall; //延迟信号
input flush; //刷新信号
output busy; //忙信号
	
	/*CPU接口*/
input [29:0] addr; //地址
input as_; //选通
input rw; //读写01
input [31:0] wr_data; //写入的数据
output [31:0] rd_data; //读取的数据
	
	/*SPM接口*/
input [31:0] spm_rd_data; //读取的数据
output [29:0] spm_addr; //地址
output spm_as_; //选通
output spm_rw; //读写
output [31:0] spm_wr_data; //写入的数据
	
	/*总线接口*/
input [31:0] bus_rd_data;//读取的数据
input bus_rdy_; //总线就绪
input bus_grnt_; //仲裁器许可信号
output bus_req_; //请求
output [29:0] bus_addr; //地址
output bus_as_; //选通
output bus_rw; //读写
output [31:0] bus_wr_data; //写入的数据


	
/*流水线控制信号*/
wire stall; //延迟信号
wire flush; //刷新信号	
reg busy;//忙信号

	/*CPU接口*/
wire [29:0] addr; //地址
wire as_; //选通
wire rw; //读写01
wire [31:0] wr_data; //写入的数据
reg [31:0] rd_data; //读取的数据

	/*SPM接口*/
wire [31:0] spm_rd_data; //读取的数据
wire [29:0] spm_addr; //地址
reg spm_as_; //选通
wire spm_rw; //读写
wire [31:0] spm_wr_data; //写入的数据

	/*总线接口*/
wire [31:0] bus_rd_data;//读取的数据
wire bus_rdy_; //总线就绪
wire bus_grnt_; //仲裁器许可信号
reg bus_req_;//请求
reg [29:0] bus_addr; //地址
reg bus_as_; //选通
reg bus_rw; //读写
reg [31:0] bus_wr_data; //写入的数据

/*总线接口*/	
reg [1:0] state; //接口状态
/*内部信号*/
reg [31:0] rd_buf; //读取缓冲
wire[2:0] s_index;//从属设备索引

//从CPU控制器里面的PC寄存器最高三位获得从属索引
assign s_index = addr[`BusSlaveIndexLoc];

/*CPU->SPM输出赋值*/
assign spm_addr = addr;
assign spm_rw = rw;
assign spm_wr_data = wr_data;

/*16KB ROM访问控制*/
always @(*)
	begin
		/*初始化值*/
		rd_data = `WORD_DATA_W'h0; 
		spm_as_ = `DISABLE_;
		busy = `DISABLE;
		/*总线接口状态控制*/
		case(state)
			`BUS_IF_STATE_IDLE: //总线空闲
				begin
					if((flush == `DISABLE) && (as_ == `ENABLE_))
						begin
							if(s_index == `BUS_SLAVE_1)//访问SPM
								begin
									if(stall == `DISABLE)//检测延迟
										begin
											spm_as_ = `ENABLE_;//选通spm
											if(rw == `READ)//读取spm
												begin
													rd_data = spm_rd_data;
												end
										end
								end
							else
								begin
									busy = `ENABLE;
								end
						end
				end
				
			`BUS_IF_STATE_ACCESS:
				begin
					if(bus_rdy_ == `ENABLE_)//总线就绪信号
						begin
							if(rw == `READ)
								begin
									rd_data = bus_rd_data; //把总线上的数据传给CPU
								end
						end
					else //就绪信号未达到
						begin
							busy = `ENABLE;//总线忙
						end
				end
				
			`BUS_IF_STATE_STALL: //总线延迟
				begin
					if(rw == `READ)
						begin
							rd_data = rd_buf;//延迟访问，把读取缓冲里的数据给CPU
						end
				end
			default:
				begin
					
				end
		endcase	
	end

/*总线接口状态控制*/
always @(posedge clk or `RESET_EDGE reset)
	begin
		if(reset == `RESET_ENABLE)
			begin
				state <= `BUS_IF_STATE_IDLE;//复位时总线状态为空闲
				bus_req_ <= `DISABLE_;
				bus_addr <= `WORD_ADDR_W'h0;
				bus_as_ <= `DISABLE_;
				bus_rw <= `READ;
				bus_wr_data <= `WORD_DATA_W'h0;
				rd_buf <= `WORD_DATA_W'h0;
			end
		else
			begin
				case(state)//总线接口的状态
					
					`BUS_IF_STATE_IDLE://总线空闲状态
						begin
						//流水线不刷新+CPU选通
						if((flush == `DISABLE) && (as_ == `ENABLE_))
								begin
									/*选择访问目标*/
									if(s_index != `BUS_SLAVE_1)//spm不用过总线,非spm的从属
										begin
											//状态切换到请求访问总线
											state <= `BUS_IF_STATE_REQ;
											bus_req_ <= `ENABLE_;
											bus_addr <= addr;
											bus_rw <= rw;
											bus_wr_data <= wr_data;
										end
								end
						end
					
					`BUS_IF_STATE_REQ://请求访问总线状态
						begin
							//请求总线许可
							if(bus_grnt_ == `ENABLE_)//仲裁器许可访问总线
								begin
									state <= `BUS_IF_STATE_ACCESS;//开始访问总线状态
									bus_as_ <= `ENABLE_; //选通信号
								end
						end
						
					`BUS_IF_STATE_ACCESS://访问总线状态
						begin
							bus_as_ <= `DISABLE_;//选通地址无效
							/*等待就绪信号*/
							if(bus_rdy_ ==`ENABLE_)
								begin
									bus_req_ <= `DISABLE_;
									bus_addr <= `WORD_ADDR_W'h0;
									bus_rw <= `READ;
									bus_wr_data <= `WORD_DATA_W'h0;
									
									if(bus_rw == `READ)//读取访问的话，将数据存入缓存
										begin
											rd_buf <= bus_rd_data;
										end
									if(stall == `ENABLE)//检测是否总线延迟
										begin
											state <= `BUS_IF_STATE_STALL;
										end
									else
										begin
										state <= `BUS_IF_STATE_IDLE;//不延迟就切换到空闲状态
										end
								end
						end
						
					`BUS_IF_STATE_STALL://总线延迟状态
						begin
							if(stall == `DISABLE)//当延迟信号消除时，切换为空闲状态
								begin
									state <= `BUS_IF_STATE_IDLE;
								end
						end
				endcase
			end
	end























endmodule