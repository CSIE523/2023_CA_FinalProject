`define DataWidth 8
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

module ALU(clk, rst, func, op1, op2, result);

input clk;
input func;
input [DataWidth-1:0] op1;
input [DataWidth-1:0] op2;

output [DataWidth-1:0] result;

always@(posedge clk or posedge rst)begin
    if(rst)begin
        result <= 0;
    end
    else begin
        case(func)
            ADD:begin
                result <= op1 + op2;
            end
            SUB:begin
                result <= op1 - op2;
            end
            SLL:begin
                result <= (op1 << op2[4:0]);
            end
            SLT:begin
                result <= ((signed)op1 < (signed)op2);
            end
            XOR:begin
                result <= op1 ^ op2;
            end
            OR:begin
                result <= op1 | op2;
            end
            AND:begin
                result <= op1 & op2;
            end
            SRL:begin
               result <= (op1 >> op2[4:0]); 
            end
            SRA:begin
                result <= (op1 >>> op2[4:0]);
            end
            SLTU:begin
                result <= op1 < op2;
            end
        endcase
    end
end


endmodule