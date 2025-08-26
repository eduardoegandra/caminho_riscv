// Testbench para validar o datapath real do RISC-V usando apenas sinais
module tb_riscv_hw_signals;
    reg clk, reset;
    reg [31:0] instruction;
    reg [31:0] data_in;
    wire [31:0] data_out;
    wire [31:0] pc;

    // Instancia o datapath
    datapath uut (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .data_in(data_in),
        .data_out(data_out),
        .pc(pc)
    );

    integer i;
    integer memfile;
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        instruction = 0;
        data_in = 0;
        #10 reset = 0;

        // Envia instruções via sinal, aguardando ciclo de clock para cada uma
        // Exemplo: lb x3, 0(x1)
        instruction = 32'b00000000000000001000000011000011; #10;
        instruction = 32'b00000000010000010000000110100011; #10;
        instruction = 32'b01000000011000101000001000110011; #10;
        instruction = 32'b00000000100101000111001110110011; #10;
        instruction = 32'b00000000011101011110010100001001; #10;
        instruction = 32'b00000000111001101101011000110011; #10;
        instruction = 32'b0000000100000111100001111100011; #10;
        instruction = 32'b00000000100000001000000000100011; #10;

        // Imprime o conteúdo dos registradores
        $display("\nConteúdo dos registradores:");
        for (i = 0; i < 32; i = i + 1)
            $display("Register [%0d]: %08X", i, uut.registers[i]);
        $display("Memória[32] = %08X", uut.memory[32]);

        // Exporta a memória para arquivo
        $display("Exportando memória para estado.memoria.txt...");
        memfile = $fopen("../bin/estado.memoria.txt", "w");
        $fdisplay(memfile, "// endereço: valor (hexadecimal)");
        for (i = 0; i < 64; i = i + 1)
            $fdisplay(memfile, "%08x: %08x", i, uut.memory[i]);
        $fclose(memfile);
        $finish;
    end
endmodule
