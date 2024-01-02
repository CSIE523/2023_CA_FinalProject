module ID (instructionregs_reg1_read_address,regs_reg2_read_address,ex_immediate,ex_aluop1_sourceex_aluop2_source,memory_read_enable,memory_write_enable,wb_reg_write_source,reg_write_enable,reg_write_address);

input  [31:0] instruction;
output [4:0] regs_reg1_read_address;
output [4:0] regs_reg2_read_address;
output [31:0] ex_immediate;
output ex_aluop1_source;
output ex_aluop2_source;
output memory_read_enable;
output memory_write_enable;
output [1:0] wb_reg_write_source;
output reg_write_enable;
output [4:0] reg_write_address;

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

// always @(posedge clk or posedge rst)begin
    // if(rst)begin
    //     regs_reg1_read_address <= ;
    //     val regs_reg2_read_address <= ;
    //     ex_immediate;
    //     ex_aluop1_source;
    //     ex_aluop2_source;
    //     memory_read_enable;
    //     memory_write_enable;
    //     wb_reg_write_source;
    //     reg_write_enable;
    //     reg_write_address;
    // end
    // else begin
always @(*)begin
        regs_reg1_read_address <= (opcode == 7'b0110111)?5'd0:rs1;
        regs_reg2_read_address <= rs2;
        case (opcode)
            7'b0010011:ex_immediate <= {21{instruction[31]},instruction[30:20]};                   //InstructionTypes.I
            7'b0000011:ex_immediate <= {21{instruction[31]},instruction[30:20]};                   //InstructionTypes.L
            7'b1100111:ex_immediate <= {21{instruction[31]},instruction[30:20]};                   //Instruction.jalr
            7'b0100011:ex_immediate <= {21{instruction[31]},instruction[30:25],instruction[11:7]}; //InstructionTypes.S
            7'b1100011:ex_immediate <= {20{instruction[31]},instruction[7],instruction[30:25],instruction[11:8],1'b0}; //InstructionTypes.B
            7'b0110111:ex_immediate <= {{instruction[31:12]},12{1'b0}};                            //Instruction.lui
            7'b0010111:ex_immediate <= {{instruction[31:12]},12{1'b0}};                            //Instruction.auipc
            7'b1101111:ex_immediate <= {12{instruction[31]},instruction[19:12],instruction[20],instruction[30:21],1'b0}; //Instruction.jal
            default:   ex_immediate <= {20{instruction[31]},instruction[31:20]};
        endcase
        case (opcode)
            7'b1100011:ex_aluop1_source <= 1'b1; //InstructionTypes.B
            7'b0010111:ex_aluop1_source <= 1'b1; //Instruction.auipc
            7'b1101111:ex_aluop1_source <= 1'b1; //Instruction.jal
            default:   ex_aluop1_source <= 1'b0;
        endcase
        ex_aluop2_source <= (opcode == b0110011)?1'b0:1'b1; //reg:imm
        memory_read_enable <= (opcode == 7'b0000011);       //InstructionTypes.L
        memory_write_enable <= (opcode == 7'b0100011);      //InstructionTypes.S
        case (opcode)
            7'b0000011 : wb_reg_write_source <= 2'd1;       //InstructionTypes.L
            7'b1101111 : wb_reg_write_source <= 2'd3;       //InstructionTypes.jal
            7'b1100111 : wb_reg_write_source <= 2'd2;       //InstructionTypes.jalr
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
    end
// end
    
endmodule