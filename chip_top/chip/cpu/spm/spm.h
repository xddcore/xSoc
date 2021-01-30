//`define SPM_SIZE 16384 //spm容量
`define SPM_DEPTH 4096 //spm容量
`define SPM_ADDR_W 12 //spm位宽
`define SpmAddrBus 11:0 //spmz总线
`define SpmAddrLoc 11:0 //spm地址位置

//`define READ 1'b0 //0读1写
//`define WRITE 1'b1 //0读1写

`define MEM_ENABLE 1'b1 //写入有效
`define MEM_DISABLE 1'b0 //写入有效