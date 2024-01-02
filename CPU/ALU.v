`define DataWidth 8

module ALU(clk, rst, func, op1, op2, result);

input clk;
input func;
input [DataWidth-1:0] op1;
input [DataWidth-1:0] op2;

output [DataWidth-1:0] result;

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