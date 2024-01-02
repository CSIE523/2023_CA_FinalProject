`define ZERO 0
`define ADD 1
`define SUB 2
`define SLL 3
`define SLT 4
`define XOR 5
`define OR 6
`define AND 7
`define SRL 8
`define SRA 9
`define SLTU 10

module(clk, rst, opcode, funct3, funct7, alu_funct);

input clk, rst;
input [6:0]opcode;
input [2:0]funct3;
input [6:0]funct7;

output [3:0]alu_funct;

always@(posedge clk or posedge rst)begin
    if(rst)begin
        alu_funct <= ZERO;
    end
    else begin
        case(opcode)
            7'b0000011:begin    //InstructionTypes.L
                
                
            end                  
            7'b0010011:begin    //InstructionTypes.I
                if()

            end
            7'b1100111:                   //Instruction.jalr
            7'b0100011:                   //InstructionTypes.S
            7'b1100011:                   //InstructionTypes.B
            7'b0110111:                   //Instruction.lui
            7'b0010111:                   //Instruction.auipc
            7'b1101111:                   //Instruction.jal
            default:   
        endcase
    end
end

endmodule