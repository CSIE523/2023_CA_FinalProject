module CPU(clk,rst,data_out,instr_out,instr_read,data_read,instr_addr,data_addr,data_write,data_in);
`define PhysicalRegisterAddrWidth 5
`define DataWidth 8

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

wire clk;
wire rst;

REG U_REG(
    .write_enable(write_enable), 
    .write_address(write_address), 
    .write_data(write_data), 
    .read_address1(read_address1), 
    .read_address2(read_address2), 
    .read_data1(read_data1), 
    .read_data2(read_data2), 
    .debug_read_address(debug_read_address), 
    .debug_read_data(debug_read_data)
    );

wire write_enable;
wire [PhysicalRegisterAddrWidth-1:0]write_address;
wire [DataWidth-1:0]write_data;

wire [PhysicalRegisterAddrWidth-1:0]read_address1;
wire [PhysicalRegisterAddrWidth-1:0]read_address2;

wire [DataWidth-1:0]read_data1;
wire [DataWidth-1:0]read_data2;

wire [PhysicalRegisterAddrWidth-1:0]debug_read_address;

wire [DataWidth-1:0]debug_read_data;

IF U_IF(
    clk(clk),
    rst(rst),
    jump_flag_id(jump_flag_id),
    jump_address_id(jump_address_id),
    instruction_read_data(instruction_read_data),
    instruction_valid(instruction_valid),
    instruction_address(instruction_address),
    instruction(instruction)
    );

wire jump_flag_id;
wire [31:0] jump_address_id;
wire [31:0] instruction_read_data;
wire instruction_valid;
wire [31:0] instruction_address;
wire [31:0] instruction;

ID U_ID(
    instruction(instruction),
    regs_reg1_read_address(regs_reg1_read_address),
    regs_reg2_read_address(regs_reg2_read_address),
    ex_immediate(ex_immediate),
    ex_aluop1_source(ex_aluop1_source),
    ex_aluop2_source(ex_aluop2_source),
    memory_read_enable(memory_read_enable),
    memory_write_enable(memory_write_enable),
    wb_reg_write_source(wb_reg_write_source),
    reg_write_enable(reg_write_enable),
    reg_write_address(reg_write_address)
    );

wire [4:0] regs_reg1_read_address;
wire [4:0] regs_reg2_read_address;
wire [31:0] ex_immediate;
wire ex_aluop1_source;
wire ex_aluop2_source;
wire memory_read_enable;
wire memory_write_enable;
wire [1:0] wb_reg_write_source;
wire reg_write_enable;
wire [4:0] reg_write_address;


EXE U_EXE(instruction(instruction),
    instruction_address(instruction_address),
    reg1_data(),
    reg2_data,
    immediate,
    aluop1_source,
    aluop2_source,
    mem_alu_result,
    if_jump_flag,
    if_jump_address);

input [31:0]instruction;
input [31:0]instruction_address;
input [31:0]reg1_data;
input [31:0]reg2_data;
input [31:0]immediate;
input aluop1_source;
input aluop2_source;
output [31:0]mem_alu_result;
output if_jump_flag;
output [31:0]if_jump_address;

WriteBack U_WB(clk, rst, instruction_address, alu_result, memory_read_data, regs_write_source, regs_write_data);
input clk, rst;
input [AddrWidth-1:0]instruction_address;
input [DataWidth-1:0]alu_result;
input [DataWidth-1:0]memory_read_data;
input [1:0]regs_write_source;

output [DataWidth-1:0]regs_write_data;


// inst_fetch.io.jump_address_id       := ex.io.if_jump_address
// inst_fetch.io.jump_flag_id          := ex.io.if_jump_flag
// inst_fetch.io.instruction_valid     := io.instruction_valid
// inst_fetch.io.instruction_read_data := io.instruction
// io.instruction_address              := inst_fetch.io.instruction_address

// regs.io.write_enable  := id.io.reg_write_enable
// regs.io.write_address := id.io.reg_write_address
// regs.io.write_data    := wb.io.regs_write_data
// regs.io.read_address1 := id.io.regs_reg1_read_address
// regs.io.read_address2 := id.io.regs_reg2_read_address

// regs.io.debug_read_address := io.debug_read_address
// io.debug_read_data         := regs.io.debug_read_data

// id.io.instruction := inst_fetch.io.instruction

// // lab3(cpu) begin
// ex.io.aluop1_source := id.io.ex_aluop1_source
// ex.io.aluop2_source := id.io.ex_aluop2_source
// ex.io.reg1_data := regs.io.read_data1
// ex.io.reg2_data := regs.io.read_data2
// ex.io.immediate := id.io.ex_immediate
// ex.io.instruction_address := inst_fetch.io.instruction_address
// ex.io.instruction := inst_fetch.io.instruction
// // lab3(cpu) end

// mem.io.alu_result          := ex.io.mem_alu_result
// mem.io.reg2_data           := regs.io.read_data2
// mem.io.memory_read_enable  := id.io.memory_read_enable
// mem.io.memory_write_enable := id.io.memory_write_enable
// mem.io.funct3              := inst_fetch.io.instruction(14, 12)

// io.memory_bundle.address := Cat(
// 0.U(Parameters.SlaveDeviceCountBits.W),
// mem.io.memory_bundle.address(Parameters.AddrBits - 1 - Parameters.SlaveDeviceCountBits, 0)
// )
// io.memory_bundle.write_enable  := mem.io.memory_bundle.write_enable
// io.memory_bundle.write_data    := mem.io.memory_bundle.write_data
// io.memory_bundle.write_strobe  := mem.io.memory_bundle.write_strobe
// mem.io.memory_bundle.read_data := io.memory_bundle.read_data

// wb.io.instruction_address := inst_fetch.io.instruction_address
// wb.io.alu_result          := ex.io.mem_alu_result
// wb.io.memory_read_data    := mem.io.wb_memory_read_data
// wb.io.regs_write_source   := id.io.wb_reg_write_source


endmodule