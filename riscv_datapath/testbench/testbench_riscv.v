// Testbench para simular o caminho de dados simplificado do RISC-V
module testbench_riscv;
    reg [31:0] registers [0:31];
    reg [7:0] memory [0:4095];
    integer i;

    initial begin
        // Inicialização dos registradores e memória
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 0;
        for (i = 0; i < 4096; i = i + 1)
            memory[i] = 0;

        // Exemplo de execução das instruções do grupo
    // addi x2, x0, 7
    registers[2] = 7;
    // Teste de valores hexadecimais com letras
    registers[3] = 32'hDEADBEEF;
    registers[4] = 32'hABCDEF01;
    registers[5] = 32'h1234BEEF;
        // sb x2, 4(x0)
        memory[4] = registers[2][7:0];
        // lb x1, 4(x0)
        registers[1] = memory[4];
        // add x2, x1, x0
        registers[2] = registers[1] + registers[0];
        // add x1, x1, x2
        registers[1] = registers[1] + registers[2];
        // add x1, x1, x2
        registers[1] = registers[1] + registers[2];
        // sub x1, x1, x2
        registers[1] = registers[1] - registers[2];
        // sub x1, x1, x2
        registers[1] = registers[1] - registers[2];
        // beq x1, x2, SAIDA
        if (registers[1] == registers[2]) begin
            // SAIDA:
            registers[1] = registers[1] & registers[2]; // and
            registers[1] = registers[1] | registers[0]; // or
            memory[0] = registers[1][7:0]; // sb
        end else begin
            // Caso o fluxo venha para cá, seu processador está errado
            registers[1] = registers[1] + registers[1]; // add
            memory[0] = registers[1][7:0]; // sb
        end

        // Imprime o conteúdo dos registradores
        $display("\nConteúdo dos registradores:");
        for (i = 0; i < 32; i = i + 1)
            $display("Register [%0d]: %08X", i, registers[i]);
        $finish;
    end
endmodule
