module WriteBack(instruction, instruction_address, alu_result, memory_read_data, regs_write_source, regs_write_data, reg_write_enable, reg_write_address, reg_write_enable_wb_to_reg, reg_write_address_wb_to_reg);
parameter DataWidth = 32;
parameter AddrWidth = 32;

input [DataWidth-1:0]instruction;
input [AddrWidth-1:0]instruction_address;
input [DataWidth-1:0]alu_result;
input [DataWidth-1:0]memory_read_data;
input [1:0]regs_write_source;

input reg_write_enable;
input [4:0]reg_write_address;

output reg [DataWidth-1:0]regs_write_data;

output reg reg_write_enable_wb_to_reg;
output reg [4:0]reg_write_address_wb_to_reg;

always@(*)begin
    reg_write_enable_wb_to_reg <= reg_write_enable;
    reg_write_address_wb_to_reg <= reg_write_address;
    
    if(regs_write_source == 2'd1)
        regs_write_data <= memory_read_data;
    else if(regs_write_source == 2'd3)
        regs_write_data <= instruction_address + 4;
    else 
        regs_write_data <= alu_result;
end

/*
object RegWriteSource{
    val ALUResult = 0.U(2.W)
    val Memory = 1.U(2.W)
    val NextInstructionAddress = 3.U(2.W)
}
*/


endmodule