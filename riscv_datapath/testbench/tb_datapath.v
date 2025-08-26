// Testbench para o datapath integrado do RISC-V
module tb_datapath;
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

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        #10 reset = 0;

        // Inicialização conforme PDF
        // addi x2, x0, 7
        uut.registers[2] = 7;
        // sw x2, 4(x0)
        uut.memory[4] = uut.registers[2];
        // lw x1, 4(x0)
        uut.registers[1] = uut.memory[4];
        // add x2, x1, x0
        uut.registers[2] = uut.registers[1] + uut.registers[0];
        // add x1, x1, x2
        uut.registers[1] = uut.registers[1] + uut.registers[2];
        // add x1, x1, x2
        uut.registers[1] = uut.registers[1] + uut.registers[2];
        // sub x1, x1, x2
        uut.registers[1] = uut.registers[1] - uut.registers[2];
        // sub x1, x1, x2
        uut.registers[1] = uut.registers[1] - uut.registers[2];
        // beq x1, x2, SAIDA
        if (uut.registers[1] == uut.registers[2]) begin
            // SAIDA:
            uut.registers[1] = uut.registers[1] & uut.registers[2]; // and
            uut.registers[1] = uut.registers[1] | uut.registers[0]; // or
            uut.memory[0] = uut.registers[1]; // sw x1, 0(x0)
        end else begin
            // Caso o fluxo venha para cá, seu processador está errado
            uut.registers[1] = uut.registers[1] + uut.registers[1]; // add
            uut.memory[0] = uut.registers[1]; // sw x1, 0(x0)
        end

        // Imprime o conteúdo dos registradores
        $display("\nConteúdo dos registradores:");
        for (i = 0; i < 32; i = i + 1)
            $display("Register [%0d]: %0d", i, uut.registers[i]);
        $display("Memória[32] = %0d", uut.memory[32]);
        $display("PC final: %d", pc);
        $display("Saída final: %d", data_out);
        $finish;
    end
endmodule
