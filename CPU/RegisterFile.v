`define PhysicalRegisterAddrWidth 5
`define DataWidth 32

module REG(write_enable, write_address, write_data, read_address1, read_address2, read_data1, read_data2);
input write_enable;
input [PhysicalRegisterAddrWidth-1:0]write_address;
input [DataWidth-1:0]write_data;

input [PhysicalRegisterAddrWidth-1:0]read_address1;
input [PhysicalRegisterAddrWidth-1:0]read_address2;


output [DataWidth-1:0]read_data1;
output [DataWidth-1:0]read_data2;

// input [PhysicalRegisterAddrWidth-1:0]debug_read_address;

// output [DataWidth-1:0]debug_read_data;

reg [DataWidth-1:0]registers[0:PhysicalRegisterAddrWidth-1];


// always@(posedge clk or posedge rst)begin
//     if(rst)begin
//         registers <= 0;
//     end
//     else begin
always @(*) begin
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
// end


endmodule