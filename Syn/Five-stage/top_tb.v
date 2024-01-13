`timescale 1ns/10ps
`define CYCLE 6.0 // Cycle time
`define MAX 150000 // Max cycle number
`define mem_word(addr) \
  {i_DM.Memory_byte3[addr], \
   i_DM.Memory_byte2[addr], \
   i_DM.Memory_byte1[addr], \
   i_DM.Memory_byte0[addr]}
`define reg_word(addr) i_CPU.i_RF.Reg_Data[addr]
`define SIM_END 'h3fff
`define SIM_END_CODE -32'd1
`define TEST_START 'h2000
`define SDFFILE "./CPU_syn.sdf"


module top_tb;

reg        clk;
reg        rst;
reg [31:0] GOLDEN [0:65535];
integer gf,
        i,
        num,
        err;
reg [31:0] counter;

always #(`CYCLE/2) clk = ~clk;

wire [31:0] instr_addr;
wire [31:0] instr_out;
wire        data_read;
wire [3:0]  data_write;
wire [31:0] data_addr;
wire [31:0] data_in;
wire [31:0] data_out;


//CPU
CPU i_CPU(
    .clk            ( clk              ),
    .rst            ( rst              ),
    .IM_addr        ( instr_addr       ),
    .IM_data_in     ( instr_out        ),
    .DM_write_en    ( data_write       ),
    .DM_addr        ( data_addr        ),
    .data_to_DM     ( data_in          ),
    .data_from_DM   ( data_out         )
);

//SRAM
SRAM i_IM( //read only
    .clk        ( clk              ),
    .rst        ( rst              ),
    .addr       ( instr_addr[13:0] ),
    .read       ( 1'b1             ),
    .write      ( 4'b0             ),
    .DI         ( 32'b0            ),
    .DO         ( instr_out        )
);

SRAM i_DM(
    .clk        ( clk             ),
    .rst        ( rst             ),
    .addr       ( data_addr[13:0] ),
    .read       ( 1'b1            ),
    .write      ( data_write      ),
    .DI         ( data_in         ),
    .DO         ( data_out        )
);
//


initial begin
    clk = 0; rst = 1;
    #(`CYCLE) rst = 0;
    $readmemh("./main0.hex", i_IM.Memory_byte0);
    $readmemh("./main0.hex", i_DM.Memory_byte0); 
    $readmemh("./main1.hex", i_IM.Memory_byte1);
    $readmemh("./main1.hex", i_DM.Memory_byte1); 
    $readmemh("./main2.hex", i_IM.Memory_byte2);
    $readmemh("./main2.hex", i_DM.Memory_byte2); 
    $readmemh("./main3.hex", i_IM.Memory_byte3);
    $readmemh("./main3.hex", i_DM.Memory_byte3); 

    num = 0;
    gf = $fopen("./golden.hex", "r");
    while (!$feof(gf))
    begin
      $fscanf(gf, "%h\n", GOLDEN[num]);
      num = num + 1;
    end
    $fclose(gf);
  
    err = 0;
    repeat(`MAX) @(negedge clk)
        if (`mem_word(`SIM_END) === `SIM_END_CODE) begin
            $display("\nDone\n");
            for (i = 0; i < num; i = i + 1) begin
                if (`mem_word(`TEST_START + i) !== GOLDEN[i]) begin
                    $display("DM[%4d] = %h, expect = %h", i, `mem_word(`TEST_START + i), GOLDEN[i]);
                    err = err + 1;
                end
                else begin
                    $display("DM[%4d] = %h, pass", i, `mem_word(`TEST_START + i));
                end
            end
            result(err);
            $finish;
        end

    @(negedge clk)
    for (i = 0; i < num; i = i + 1) begin
        if (`mem_word(`TEST_START+i) !== GOLDEN[i]) begin
            $display("DM[%4d] = %h, expect = %h", i, `mem_word(`TEST_START + i), GOLDEN[i]);
            err = err + 1;
        end
        else begin
            $display("DM[%4d] = %h, pass", i, `mem_word(`TEST_START + i));
        end
    end
    $display("SIM_END(%5d) = %h, expect = %h", `SIM_END, `mem_word(`SIM_END), `SIM_END_CODE);
    result(err);
    $finish;
end

initial begin
    #(`MAX*`CYCLE)
    $display("Simulation Failed");
    $finish;
end

always@(posedge clk or posedge rst) begin
    if(rst)
        counter <= 32'b0;
    else 
        counter <= 32'b1 + counter;
end

`ifdef SDF
initial $sdf_annotate(`SDFFILE, i_CPU);
`endif

initial
begin
  `ifdef FSDB
  $fsdbDumpfile("CPU.fsdb");
  $fsdbDumpvars(0, i_CPU);
  `elsif FSDB_ALL
  $fsdbDumpfile("CPU.fsdb");
  $fsdbDumpvars("+struct", "+mda", i_CPU);
  `endif
end

task result;
    input integer err;
    begin
        if (err === 0) begin
            $display("\n");
            $display("\n");
            $display("        ****************************               ");
            $display("        **                        **       |\__||  ");
            $display("        **  Congratulations !!    **      / O.O  | ");
            $display("        **                        **    /_____   | ");
            $display("        **  Simulation PASS!!     **   /^ ^ ^ \\  |");
            $display("        **                        **  |^ ^ ^ ^ |w| ");
            $display("        ****************************   \\m___m__|_|");
            $display("\n");
        end
        else begin
            $display("\n");
            $display("\n");
            $display("        ****************************               ");
            $display("        **                        **       |\__||  ");
            $display("        **  OOPS!!                **      / X,X  | ");
            $display("        **                        **    /_____   | ");
            $display("        **  Simulation Failed!!   **   /^ ^ ^ \\  |");
            $display("        **                        **  |^ ^ ^ ^ |w| ");
            $display("        ****************************   \\m___m__|_|");
            $display("         Totally has %d errors                     ", err); 
            $display("\n");
        end
        $display("total cycle:%d",counter);
    end
endtask

endmodule
