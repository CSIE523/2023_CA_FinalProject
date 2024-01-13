module ForwardHazard(clk, rst, EXE_MEM_RD, EXE_write_enable, ID_MEM_RS1, ID_MEM_RS2, forward_1a, forward_1b);

input clk, rst;
input [4:0]EXE_MEM_RD, ID_MEM_RS1, ID_MEM_RS2;
input EXE_write_enable;

output reg forward_1a;
output reg forward_1b;

always@(posedge clk or posedge rst)begin
    if(rst)begin
        forward_1a <= 0;
        forward_1b <= 0;
    end
    else begin
    if(EXE_MEM_RD != 0 && (EXE_MEM_RD == ID_MEM_RS1) && EXE_write_enable == 1)begin
        forward_1a <= 1;
    end
    else begin
        forward_1a <= 0;
    end 

    if(EXE_MEM_RD != 0 && (EXE_MEM_RD == ID_MEM_RS2) && EXE_write_enable == 1)begin
        forward_1b <= 1;
    end
    else begin
        forward_1b <= 0;
    end 
    end
end

endmodule