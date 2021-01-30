`define ISA_NOP 32'h0
`define ISA_OP_W 6 //操作码宽
`define IsaOpBus 5:0 //操作码总线
`define IsaOpLoc 31:26 //操作码位置

// 16种操作，所以op [2^4] 4位op [3:0]
`define ISA_OP_ANDR 6'h00 //寄存器间的逻辑与
`define ISA_OP_ADDI 6'h01 //寄存器与立即数的逻辑与

`define ISA_OP_ORR 6'h02
`define ISA_OP_ORI 6'h03

`define ISA_OP_XORR 6'h04
`define ISA_OP_XORI 6'h05

`define ISA_OP_ADDSR 6'h06
`define ISA_OP_ADDSI 6'h07
`define ISA_OP_ADDUR 6'h08
`define ISA_OP_ADDUI 6'h09

`define ISA_OP_SUBSR 6'h0a
`define ISA_OP_SUBUR 6'h0b

`define ISA_OP_SHRLR 6'h0c //寄存器右移
`define ISA_OP_SHRLI 6'h0d //寄存器常数右移

`define ISA_OP_SHLLR 6'h0e //寄存器左移
`define ISA_OP_SHLLI 6'h0f //寄存器常数左移

`define ISA_OP_BE 6'h10 //寄存器间==比较
`define ISA_OP_BNE 6'h11 //寄存器间!=比较
`define ISA_OP_BSGT 6'h12 //寄存器间有符号<比较
`define ISA_OP_BUGT 6'h13 //寄存器间有符号<比较

`define ISA_OP_JMP 6'h14 //寄存器指定绝对分支
`define ISA_OP_CALL 6'h15 //寄存器指定子程序调用

`define ISA_OP_LDW 6'h16 //字读取
`define ISA_OP_STW 6'h17 //字写入

`define ISA_OP_TRAP 6'h18 //陷阱
`define ISA_OP_RDCR 6'h19 //读取控制寄存器
`define ISA_OP_WRCR 6'h1a //写入控制寄存器

`define ISA_OP_EXRT 6'h1b //从异常恢复

`define ISA_REG_ADDR_W 5 //寄存器地址宽
`define IsaRegAddrBus 4:0 //寄存器地址总线
`define IsaRaAddrLoc 25:21 //寄存器Ra的位置
`define IsaRbAddrLoc 20:16 //寄存器Rb的位置
`define IsaRcAddrLoc 15:11 //寄存器Rc的位置

`define ISA_IMM_W 16 //立即数位宽
`define ISA_EXT_W 16 //符号拓展后的立即数位宽
`define ISA_IMM_MSB 15 //立即数最高有效位
`define IsaImmBus 15:0 //立即数总线
`define IsaImmLoc 15:0 //立即数位置

`define ISA_EXP_W 3 //异常代码宽
`define IsaExpBus 2:0 //异常代码总线
`define ISA_EXP_NO_EXP 3'h0 //无异常
`define ISA_EXP_EXT_INT 3'h1 //外部中断
`define ISA_EXP_UNDEF_INSN 3'h2 //未定义指令
`define ISA_EXP_OVERFLOW 3'h3 //溢出
`define ISA_EXP_MISS_ALIGN 3'h4 //地址未对其
`define ISA_EXP_TRAP 3'h5 //陷阱
`define ISA_EXP_PRV_VIO 3'h6 //违反权限

















