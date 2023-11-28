module processorCore_tb ();

  reg clk;
  wire halt;
  wire [31:0] result;

  processorCore rv32i (
    .clk_in(clk),
    .halt(halt),
    .final_data(result)
  );

  initial
  begin
    clk = 0;
    #999999  $display("time=%0t, halt=%d, result=%d", $time, halt, result);
    #1000000 $finish;
  end

  always
  begin
    #5000 clk = ~clk;
  end

endmodule
