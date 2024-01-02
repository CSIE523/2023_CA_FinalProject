module CPU(clk,rst,data_out,instr_out,instr_read,data_read,instr_addr,data_addr,data_write,data_in);

input             clk;
input             rst;
input      [31:0] data_out;  //read DM
input      [31:0] instr_out; //read IM
output reg        instr_read;//inst read enable
output reg [31:0] instr_addr;//read inst addr
output reg        data_read; //data read enable
output reg [31:0] data_addr; //read data addr
output reg [3:0]  data_write;//data write enable
output reg [31:0] data_in;   //data write data



endmodule