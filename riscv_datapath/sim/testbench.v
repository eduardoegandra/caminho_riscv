module testbench;
    reg clk;
    reg reset;
    reg [31:0] instruction;
    wire [31:0] data_out;
    wire [31:0] pc;

    // Instancia o datapath
    datapath uut (.clk(clk), .reset(reset), .instruction(instruction), .data_out(data_out), .pc(pc));

    always #5 clk = ~clk;  // Gerador de clock

    initial begin
        clk = 0;
        reset = 1;
        instruction = 32'b0;

        #10 reset = 0;  // Aplica o reset

        // Teste de lb
        instruction = 32'b0000011_00000_00001_000_00000_0000011;  // lb
        #10;

        // Teste de sb
        instruction = 32'b0100011_00001_00010_000_00000_0000011;  // sb
        #10;

        // Teste de add
        instruction = 32'b0110011_00001_00010_000_00000_0000000;  // add
        #10;

        // Outros testes de instruções
        $finish;
    end

    initial begin
        $monitor("PC: %d, Data Out: %d", pc, data_out);
    end
endmodule
