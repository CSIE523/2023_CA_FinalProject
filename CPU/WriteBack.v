`define DataWidth 8
`define AddrWidth 32

module WriteBack(instruction_address, alu_result, memory_read_data, regs_write_source, regs_write_data);

input [AddrWidth-1:0]instruction_address;
input [DataWidth-1:0]alu_result;
input [DataWidth-1:0]memory_read_data;
input [1:0]regs_write_source;

output [DataWidth-1:0]regs_write_data;

always@(*)begin
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