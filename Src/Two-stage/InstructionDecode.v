module ID (clk, rst, instruction, pre_jump_flag_id,instruction_to_exe,instruction_address,instruction_address_to_exe_and_wb,ex_immediate,ex_aluop1_source,ex_aluop2_source,memory_read_enable,memory_write_enable,wb_reg_write_source, read_data1, read_data2, write_data);
input clk,rst;
input  [31:0] instruction;
//
input pre_jump_flag_id;
input [31:0] instruction_address;
output reg [31:0] instruction_to_exe;
output reg [31:0] instruction_address_to_exe_and_wb;
input [31:0]write_data;
//
reg [4:0] regs_reg1_read_address;
reg [4:0] regs_reg2_read_address;
output reg [31:0] ex_immediate;
output reg ex_aluop1_source;
output reg ex_aluop2_source;
output reg memory_read_enable;
output reg memory_write_enable;
output reg [1:0] wb_reg_write_source;
reg reg_write_enable;
reg [4:0] reg_write_address;

wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;
wire [4:0] rd;
wire [4:0] rs1;
wire [4:0] rs2;
assign opcode = instruction[6:0];
assign funct3 = instruction[14:12];
assign funct7 = instruction[31:25];
assign rd = instruction[11:7];
assign rs1 = instruction[19:15];
assign rs2 = instruction[24:20];

output [31:0]read_data1;
output [31:0]read_data2;

//RegisterFile
reg [31:0]registers[0:31];

integer i;

assign read_data1 = (regs_reg1_read_address == 0) ? 0 : registers[regs_reg1_read_address];
assign read_data2 = (regs_reg2_read_address == 0) ? 0 : registers[regs_reg2_read_address];

always@(posedge clk or posedge rst)begin
    if(rst)begin
        for (i = 0;i < 32;i = i + 1) begin
            registers[i] <= 0;
        end
    end
    else begin
        if(reg_write_enable && reg_write_address != 0)begin
            registers[reg_write_address] <= write_data;
        end
        // if(debug_read_address == 0)
        //     debug_read_data <= 0;
        // else 
        //     debug_read_data <= registers[debug_read_address];
    end
end



//

always @(posedge clk or posedge rst)begin
    if(rst)begin
        regs_reg1_read_address <= 5'd0;
        regs_reg2_read_address <= 5'd0;
        ex_immediate <= 32'd0;
        ex_aluop1_source <= 1'd0;
        ex_aluop2_source <= 1'd1;
        memory_read_enable <= 1'd0;
        memory_write_enable <= 1'd0;
        wb_reg_write_source <= 1'd0;
        reg_write_enable <= 1'd1;
        reg_write_address <= 1'd0;
        instruction_to_exe <= 32'h0000_0013;
        instruction_address_to_exe_and_wb <= 32'h00;
    end
    else begin
        regs_reg1_read_address <= (opcode == 7'b0110111)?5'd0:rs1;
        regs_reg2_read_address <= rs2;
        instruction_to_exe <= instruction;
        instruction_address_to_exe_and_wb <= instruction_address;
        case (opcode)
            7'b0010011:ex_immediate <= {{21{instruction[31]}},instruction[30:20]};                   //InstructionTypes.I
            7'b0000011:ex_immediate <= {{21{instruction[31]}},instruction[30:20]};                   //InstructionTypes.L
            7'b1100111:ex_immediate <= {{21{instruction[31]}},instruction[30:20]};                   //Instruction.jalr
            7'b0100011:ex_immediate <= {{21{instruction[31]}},instruction[30:25],instruction[11:7]}; //InstructionTypes.S
            7'b1100011:ex_immediate <= {{20{instruction[31]}},instruction[7],instruction[30:25],instruction[11:8],1'b0}; //InstructionTypes.B
            7'b0110111:ex_immediate <= {{{instruction[31:12]}},{12{1'b0}}};                            //Instruction.lui
            7'b0010111:ex_immediate <= {{{instruction[31:12]}},{12{1'b0}}};                            //Instruction.auipc
            7'b1101111:ex_immediate <= {{12{instruction[31]}},instruction[19:12],instruction[20],instruction[30:21],1'b0}; //Instruction.jal
            default:   ex_immediate <= {{20{instruction[31]}},instruction[31:20]};
        endcase
        case (opcode)
            7'b1100011:ex_aluop1_source <= 1'b1; //InstructionTypes.B
            7'b0010111:ex_aluop1_source <= 1'b1; //Instruction.auipc
            7'b1101111:ex_aluop1_source <= 1'b1; //Instruction.jal
            default:   ex_aluop1_source <= 1'b0;
        endcase
        ex_aluop2_source <= (opcode == 7'b0110011)?1'b0:1'b1; //reg:imm
        memory_read_enable <= (opcode == 7'b0000011);       //InstructionTypes.L
        memory_write_enable <= (opcode == 7'b0100011);      //InstructionTypes.S
        case (opcode)
            7'b0000011 : wb_reg_write_source <= 2'd1;       //InstructionTypes.L
            7'b1101111 : wb_reg_write_source <= 2'd3;       //InstructionTypes.jal
            7'b1100111 : wb_reg_write_source <= 2'd3;       //InstructionTypes.jalr
            default:     wb_reg_write_source <= 2'd0;       //ALU_result
        endcase
        case (opcode)
            7'b0110011:reg_write_enable <= 1'b1; //InstructionTypes.RM
            7'b0010011:reg_write_enable <= 1'b1; //InstructionTypes.I
            7'b0000011:reg_write_enable <= 1'b1; //InstructionTypes.L
            7'b0010111:reg_write_enable <= 1'b1; //Instruction.auipc
            7'b0110111:reg_write_enable <= 1'b1; //Instruction.lui
            7'b1101111:reg_write_enable <= 1'b1; //Instruction.jal
            7'b1100111:reg_write_enable <= 1'b1; //Instruction.jalr
            default:   reg_write_enable <= 1'b0;
        endcase
        reg_write_address <= rd;
        if(pre_jump_flag_id)begin
            regs_reg1_read_address <= 5'd0;
            regs_reg2_read_address <= 5'd0;
            ex_immediate <= 32'd0;
            ex_aluop1_source <= 1'd0;
            ex_aluop2_source <= 1'd1;
            memory_read_enable <= 1'd0;
            memory_write_enable <= 1'd0;
            wb_reg_write_source <= 1'd0;
            reg_write_enable <= 1'd1;
            reg_write_address <= 1'd0;
            instruction_to_exe <= 32'h0000_0013;
            instruction_address_to_exe_and_wb <= instruction_address_to_exe_and_wb;
        end
    end
end
    
endmodule