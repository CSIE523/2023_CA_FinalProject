module IF (clk,rst,jump_flag_id,jump_address_id,instruction_read_data,instruction_valid,instruction_address,instruction);

input jump_flag_id;
input [31:0] jump_address_id;
input [31:0] instruction_read_data;
input instruction_valid;
output [31:0] instruction_address;
output [31:0] instruction;

always @(posedge clk or posedge rst)begin
    if(rst)begin
        instruction_address <= 32'h0;
        instruction <= 32'h0000_0013; //nop = addi x0,x0,0
    end
    else begin
        if(instruction_valid)begin
            instruction <= instruction_read_data;
            instr_addr <= (jump_flag_id)?jump_address_id:instr_addr + 32'd4;
        end
        else begin
            instruction <= 32'h0000_0013; //nop
        end
    end
end
    
endmodule