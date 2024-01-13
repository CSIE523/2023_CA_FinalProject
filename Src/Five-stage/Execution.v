module EXE (clk, rst, instruction,instruction_address,reg1_data,reg2_data,immediate,aluop1_source,aluop2_source,mem_alu_result,if_jump_flag,if_jump_address, instruction_exe_to_mem, instruction_address_exe_to_mem, reg_write_enable, reg_write_address, reg_write_enable_exe_to_mem, reg_write_address_exe_to_mem);

input clk, rst;
input [31:0]instruction;
input [31:0]instruction_address;
input [31:0]reg1_data;
input [31:0]reg2_data;
input [31:0]immediate;
input aluop1_source;
input aluop2_source;
input reg_write_enable;
input [4:0]reg_write_address;
output reg [31:0]mem_alu_result;
output reg if_jump_flag;
output reg [31:0]if_jump_address;

wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;
wire [4:0] rd;
wire [4:0] uimm;
assign opcode = instruction[6:0];
assign funct3 = instruction[14:12];
assign funct7 = instruction[31:25];
assign rd = instruction[11:7];
assign uimm = instruction[19:15];

wire [3:0] func;
wire [31:0] op1;
wire [31:0] op2;
wire [31:0] result;
ALU u_ALU(.func(func), .op1(op1), .op2(op2), .result(result));
ALU_Ctrl u_ALU_Ctrl(.opcode(opcode), .funct3(funct3), .funct7(funct7), .alu_funct(func));

assign op1 = (aluop1_source == 0) ? reg1_data : instruction_address;
assign op2 = (aluop2_source == 0) ? reg2_data : immediate;
// assign mem_alu_result = result;
// assign if_jump_address = immediate + ((opcode == 7'b1100111) ? reg1_data : instruction_address);

output reg [31:0]instruction_exe_to_mem;
output reg [31:0]instruction_address_exe_to_mem;

output reg reg_write_enable_exe_to_mem;
output reg [4:0]reg_write_address_exe_to_mem;

// always @(posedge clk or posedge rst) begin
//     if(rst)begin
//         mem_alu_result <= 32'd0;
//         if_jump_flag <= 1'd0;
//         if_jump_address <= 32'd0;
//         instruction_exe_to_mem <= 32'h0000_0013;
//         instruction_address_exe_to_mem <= 32'd0;
//         reg_write_enable_exe_to_mem <= 1'd0;
//         reg_write_address_exe_to_mem <= 5'd0;

//     end
//     else begin
always@(*)begin
        mem_alu_result <= result;
        if_jump_address <= immediate + ((opcode == 7'b1100111) ? reg1_data : instruction_address);

        if((opcode == 7'b1101111) || 
           (opcode == 7'b1100111) || 
           ((opcode == 7'b1100011) && (
           (funct3 == 3'b000 && reg1_data == reg2_data) || 
           (funct3 == 3'b001 && reg1_data != reg2_data) ||
           (funct3 == 3'b100 && ($signed(reg1_data) < $signed(reg2_data)))  ||
           (funct3 == 3'b101 && ($signed(reg1_data) >= $signed(reg2_data))) ||
           (funct3 == 3'b110 && reg1_data < reg2_data) ||
           (funct3 == 3'b111 && reg1_data >= reg2_data)))
        )
        begin
            if_jump_flag <= 1'b1;
        end
        else 
            if_jump_flag <= 1'b0;
        

        instruction_exe_to_mem <= instruction;
        instruction_address_exe_to_mem <= instruction_address;

        reg_write_enable_exe_to_mem <= reg_write_enable;
        reg_write_address_exe_to_mem <= reg_write_address;
    end
// end

endmodule

// object InstructionsTypeB {
//   val beq  = "b000".U
//   val bne  = "b001".U
//   val blt  = "b100".U
//   val bge  = "b101".U
//   val bltu = "b110".U
//   val bgeu = "b111".U
// }