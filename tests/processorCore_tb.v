module processorCore_tb ();

  reg clk, rst;
  wire halt;
  wire [31:0] result;

  processorCore rv32i (
    .clk_in(clk),
    .rst(rst),
    .halt(halt),
    .final_data(result)
  );

  initial
  begin
    clk = 0;
    rst = 1;
    #100 rst = 0;
    #9999  $display("time=%0t, halt=%d, result=%d", $time, halt, result);
    #10000 $finish;
  end

  always
  begin
    #50 clk = ~clk;
  end

endmodule
