// module IF (clk,rst,jump_flag_id,jump_address_id,instruction_read_data,instruction_valid,instruction_address,instruction);
module IF (clk,rst,jump_flag_id,jump_address_id,instruction_read_data,instruction_address);
input clk,rst;
input jump_flag_id;
input [31:0] jump_address_id;
input [31:0] instruction_read_data;
// input instruction_valid;
output reg [31:0] instruction_address;
reg [31:0] pre_instruction_address;

reg [31:0] instruction_count;

always @(posedge clk or posedge rst)begin
    if(rst)begin
        instruction_address <= 32'h0;
        // instruction <= 32'h0000_0013; //nop = addi x0,x0,0
        pre_instruction_address <= 32'h0;
        instruction_count <= 0;
    end
    else begin
        // instruction <= instruction_read_data;
        pre_instruction_address <= (jump_flag_id) ? jump_address_id: pre_instruction_address + 32'd4;
        instruction_address <= (jump_flag_id) ? jump_address_id: pre_instruction_address + 32'd4;

        instruction_count <= instruction_count + 1;
    end
end
    
endmodule