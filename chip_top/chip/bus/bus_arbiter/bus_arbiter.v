`timescale 1ps / 1ps
`include "../../../global_config.h"
`include "bus_arbiter.h"
module bus_arbiter(
	clk,
	reset,	
	m0_req_,//0号主控请求
	m0_grnt_,//0号主控赋予总线	
	m1_req_,//1号主控请求
	m1_grnt_,//1号主控赋予总线	
	m2_req_,//2号主控请求
	m2_grnt_,//2号主控赋予总线	
	m3_req_,//3号主控请求
	m3_grnt_//3号主控赋予总线
);

input clk;
input reset;
	
input m0_req_;//0号主控请求
output m0_grnt_;//0号主控赋予总线
	
input m1_req_;//1号主控请求
output m1_grnt_;//1号主控赋予总线
	
input m2_req_;//2号主控请求
output m2_grnt_;//2号主控赋予总线
	
input m3_req_;//3号主控请求
output m3_grnt_;//3号主控赋予总线


reg [1:0] owner;//总线使用者状态(2bit)

reg m0_grnt_; //0号主控赋予总线
reg m1_grnt_; //1号主控赋予总线
reg m2_grnt_; //2号主控赋予总线
reg m3_grnt_; //3号主控赋予总线

//1:无权限 0:有权限

always @(*)
	begin
		//1:无权限 0:有权限
		m0_grnt_ = `DISABLE_;
		m1_grnt_ = `DISABLE_;
		m2_grnt_ = `DISABLE_;
		m3_grnt_ = `DISABLE_;
		
		case(owner)//根据谁是总线owner变化grnt信号赋权
				`BUS_OWNER_MASTER_0:
					begin
						m0_grnt_ = `ENABLE_;
					end
				`BUS_OWNER_MASTER_1:
					begin
						m1_grnt_ = `ENABLE_;
					end
				`BUS_OWNER_MASTER_2:
					begin
						m2_grnt_ = `ENABLE_;
					end
				`BUS_OWNER_MASTER_3:
					begin
						m3_grnt_ = `ENABLE_;
					end
			endcase
	end

//1:不申请权限 0:申请权限
always @(posedge clk or `RESET_EDGE reset)
	begin
		if(reset == `RESET_ENABLE)
			begin
				owner <= `BUS_OWNER_MASTER_0; //异步复位后，把总线给0号主控
			end
		else
			begin
			/*非复位，则开始仲裁*/
				case(owner)					
						`BUS_OWNER_MASTER_0: //0号主控持有总线时
							begin
								if(m0_req_ == `ENABLE_)//0号主控申请总线
									begin
										owner <= `BUS_OWNER_MASTER_0;
									end
								else if(m1_req_ == `ENABLE)//1号主控申请总线
									begin
										owner <= `BUS_OWNER_MASTER_1;
									end
								else if(m2_req_)//2号主控申请总线
									begin
										owner <= `BUS_OWNER_MASTER_2;
									end
								else if(m3_req_)//3号主控申请总线
									begin
										owner <= `BUS_OWNER_MASTER_3;
									end
							end		
						`BUS_OWNER_MASTER_1: //1号主控持有总线时
							begin
								if(m1_req_ == `ENABLE_)//1号主控申请总线
									begin
										owner <= `BUS_OWNER_MASTER_1;
									end
								else if(m2_req_ == `ENABLE)//2号主控申请总线
									begin
										owner <= `BUS_OWNER_MASTER_2;
									end
								else if(m3_req_)//3号主控申请总线
									begin
										owner <= `BUS_OWNER_MASTER_3;
									end
								else if(m0_req_)//0号主控申请总线
									begin
										owner <= `BUS_OWNER_MASTER_0;
									end
							end
							
						`BUS_OWNER_MASTER_2: //2号主控持有总线时
							begin
								if(m2_req_ == `ENABLE_)//2号主控申请总线
									begin
										owner <= `BUS_OWNER_MASTER_2;
									end
								else if(m3_req_ == `ENABLE)//3号主控申请总线
									begin
										owner <= `BUS_OWNER_MASTER_3;
									end
								else if(m0_req_)//0号主控申请总线
									begin
										owner <= `BUS_OWNER_MASTER_0;
									end
								else if(m1_req_)//1号主控申请总线
									begin
										owner <= `BUS_OWNER_MASTER_1;
									end
							end
							
						`BUS_OWNER_MASTER_3: //3号主控持有总线时
							begin
								if(m3_req_ == `ENABLE_)//3号主控申请总线
									begin
										owner <= `BUS_OWNER_MASTER_3;
									end
								else if(m0_req_ == `ENABLE)//0号主控申请总线
									begin
										owner <= `BUS_OWNER_MASTER_0;
									end
								else if(m1_req_)//1号主控申请总线
									begin
										owner <= `BUS_OWNER_MASTER_1;
									end
								else if(m2_req_)//2号主控申请总线
									begin
										owner <= `BUS_OWNER_MASTER_2;
									end
							end
					endcase
			end
	end

endmodule	
	
	
	
	
	
	
	
	