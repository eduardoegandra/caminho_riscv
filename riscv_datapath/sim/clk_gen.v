module clk_gen(output reg clk);
    always #5 clk = ~clk;  // Gera um clock de 10ns
endmodule
