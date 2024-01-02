module ALU_Ctrl(opcode, funct3, funct7, alu_funct);

input clk, rst;
input [6:0]opcode;
input [2:0]funct3;
input [6:0]funct7;

output [3:0]alu_funct;

localparam ZERO = 0,
        ADD = 1,
        SUB = 2,
        SLL = 3,
        SLT = 4,
        XOR = 5,
        OR = 6, 
        AND = 7,
        SRL = 8,
        SRA = 9,
        SLTU= 10;

always@(*)begin
    case(opcode)
        7'b0000011:begin    //InstructionTypes.L
            alu_funct <= ADD; 
        end                  
        7'b0010011:begin    //InstructionTypes.I
            /*
                object InstructionsTypeI{
                    val addi  -> 0.U
                    val slli  -> 1.U
                    val slti  -> 2.U
                    val sltiu -> 3.U
                    val xori  -> 4.U
                    val sri   -> 5.U
                    val ori   -> 6.U
                    val andi  -> 7.U
                }
            */
            case(funct3)
                0:  alu_funct <= ADD;
                1:  alu_funct <= SLL;
                2:  alu_funct <= SLT;
                3:  alu_funct <= SLTU;
                4:  alu_funct <= XOR;
                5:  alu_funct <= (funct7[5]) ? SRA : SRL;
                6:  alu_funct <= OR;
                7:  alu_funct <= AND;
                default: alu_funct <= ZERO;
            endcase
        end
        7'b1100111:begin    //Instruction.jalr
            alu_funct <= ADD; 
        end
        7'b0100011:begin    //InstructionTypes.S
            alu_funct <= ADD; 
        end
        7'b0110011:begin    //InstructionTypes.RM
            /*
                object InstructionsTypeI{
                    val add_sub  -> 0.U
                    val sll      -> 1.U
                    val slt      -> 2.U
                    val sltu     -> 3.U
                    val xor      -> 4.U
                    val sr       -> 5.U
                    val or       -> 6.U
                    val and      -> 7.U
                }
            */
            case(funct3)
                0:  alu_funct <= (funct7[5]) ? SUB : ADD;
                1:  alu_funct <= SLL;
                2:  alu_funct <= SLT;
                3:  alu_funct <= SLTU;
                4:  alu_funct <= XOR;
                5:  alu_funct <= (funct7[5]) ? SRA : SRL;
                6:  alu_funct <= OR;
                7:  alu_funct <= AND;
                default: alu_funct <= ZERO;
            endcase
        end
        7'b1100011:begin    //InstructionTypes.B
            alu_funct <= ADD;
        end                  
        7'b0110111:begin    //Instruction.lui
            alu_funct <= ADD; 
        end
        7'b0010111:begin    //Instruction.auipc
            alu_funct <= ADD; 
        end
        7'b1101111:begin    //Instruction.jal
            alu_funct <= ADD; 
        end
        default: alu_funct <= ZERO;   
    endcase
end

endmodule