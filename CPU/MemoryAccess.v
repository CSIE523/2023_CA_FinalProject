module MemoryAccess(alu_result, reg2_data, memory_read_enable, memory_write_enable, funct3, wb_memory_read_data, address, write_data, write_strobe, read_data); 
// module MemoryAccess(alu_result, reg2_data, memory_read_enable, memory_write_enable, funct3, wb_memory_read_data, address, write_data, write_enable, write_strobe, read_data); 
parameter DataWidth = 32;
parameter AddrWidth = 32;
parameter WordSize = 4;
parameter ByteBits = 8;


input [DataWidth-1:0]alu_result;
input [DataWidth-1:0]reg2_data;
input memory_read_enable;
input memory_write_enable;
input [2:0]funct3;

output reg [DataWidth-1:0]wb_memory_read_data;

//RAMBundle
output [AddrWidth-1:0]address;
output reg [DataWidth-1:0]write_data;
// output write_enable;
output reg [WordSize-1:0]write_strobe;
input [DataWidth-1:0]read_data;

wire [1:0]mem_address_index = alu_result[1:0];
wire [DataWidth-1:0]data = read_data;
assign address = alu_result;

integer i;

// always@(posedge clk or posedge rst)begin
//     if(rst)begin
//         write_enable <= 0;
//         write_data <= 0;
//         address <= alu_result;
//         write_strobe <= 0;
//         wb_memory_read_data <= 0;
//     end
//     else begin
always@(*)begin
    if(memory_read_enable)begin
        case(funct3)
            3'b000:begin
                case(mem_address_index)
                    0:begin
                        wb_memory_read_data <= {{24{data[7]}}, data[7:0]};
                    end
                    1:begin
                        wb_memory_read_data <= {{24{data[15]}}, data[15:8]};
                    end
                    2:begin
                        wb_memory_read_data <= {{24{data[23]}}, data[23:16]};
                    end
                    default: wb_memory_read_data <= {{24{data[31]}}, data[31:24]};
                endcase
            end
            3'b100:begin
                case(mem_address_index)
                    0:begin
                        wb_memory_read_data <= {{24{0}}, data[31:24], {24{0}}, data[7:0]};
                    end
                    1:begin
                        wb_memory_read_data <= {{24{0}}, data[31:24], {24{0}}, data[15:8]};
                    end
                    2:begin
                        wb_memory_read_data <= {{24{0}}, data[31:24], {24{0}}, data[23:16]};
                    end
                    default: wb_memory_read_data <= {{24{0}}, data[31:24]};
                endcase
            end
            3'b001:begin
                if(mem_address_index == 0)
                    wb_memory_read_data <= {{16{data[15]}}, data[15:0]};
                else
                    wb_memory_read_data <= {{16{data[31]}}, data[31:16]};
            end
            3'b101:begin
                if(mem_address_index == 0)
                    wb_memory_read_data <= {{16{0}}, data[15:0]};
                else
                    wb_memory_read_data <= {{16{0}}, data[31:16]};
            end
            3'b010:begin
                wb_memory_read_data <= data;
            end
            default: wb_memory_read_data <= 0;
        endcase
      end
      else if(memory_write_enable)begin
        write_data <= reg2_data;
        // write_enable <= 1;
        write_strobe <= 0;
        if(funct3 == 3'b000)begin
            write_strobe[mem_address_index] <= 1;
            write_data <= reg2_data[ByteBits:0] << (mem_address_index << 3);
        end
        else if(funct3 == 3'b001)begin
            if(mem_address_index == 0)begin
                for(i=0;i<2;i=i+1)
                    write_strobe[i] <= 1;
                    
                write_data <= reg2_data[15:0];
            end
            else begin
                for(i=2;i<4;i=i+1)begin
                    write_strobe[i] <= 1;
                end
                
                write_data <= (reg2_data[15:0] << 16);
            end
        end
        else if(funct3 == 3'b010)begin
            for(i=0;i<4;i=i+1)
                write_strobe[i] <= 1;
        end
      end
    end
// end


endmodule