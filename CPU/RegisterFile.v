module REG(rst,write_enable, write_address, write_data, read_address1, read_address2, read_data1, read_data2);
parameter PhysicalRegisterAddrWidth = 5;
parameter DataWidth = 32;

input rst,write_enable;
input [PhysicalRegisterAddrWidth-1:0]write_address;
input [DataWidth-1:0]write_data;

input [PhysicalRegisterAddrWidth-1:0]read_address1;
input [PhysicalRegisterAddrWidth-1:0]read_address2;


output reg [DataWidth-1:0]read_data1;
output reg [DataWidth-1:0]read_data2;

// input [PhysicalRegisterAddrWidth-1:0]debug_read_address;

// output [DataWidth-1:0]debug_read_data;

reg [DataWidth-1:0]registers[0:PhysicalRegisterAddrWidth-1];


// always@(posedge clk or posedge rst)begin
//     if(rst)begin
//         registers <= 0;
//     end
//     else begin
always @(*) begin
    if(rst)begin
        for (i = 0;i < 32;i = i + 1) begin
            registers[i] <= 0;
        end
    end
    else begin
        if(write_enable && write_address != 0)begin
            registers[write_address] <= write_data;
        end

        if(read_address1 == 0)
            read_data1 <= 0;
        else 
            read_data1 <= registers[read_address1];

        if(read_address2 == 0)
            read_data2 <= 0;
        else 
            read_data2 <= registers[read_address2];
        // if(debug_read_address == 0)
        //     debug_read_data <= 0;
        // else 
        //     debug_read_data <= registers[debug_read_address];
    end
end
// end


endmodule