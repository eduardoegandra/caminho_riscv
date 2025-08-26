// Testbench para validar o datapath real do RISC-V

module tb_riscv_hw;
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

    integer i, f;
    reg [31:0] programa [0:15]; // até 16 instruções
    integer num_inst = 0;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Carrega instruções do programa.bin
    // Conta o número de instruções válidas
    num_inst = 0;
    $readmemb("riscv_datapath/bin/programa.bin", programa);
    while (programa[num_inst] !== 32'bx && num_inst < 16) num_inst = num_inst + 1;

        reset = 1;
        instruction = 32'b0;
        data_in = 32'b0;
        #10 reset = 0;

    // Inicialização agora é feita no módulo datapath

        // Executa instruções sequencialmente
        for (i = 0; i < num_inst; i = i + 1) begin
            instruction = programa[i];
            #10; // espera 2 ciclos de clock
        end

        // Imprime o conteúdo dos registradores
        $display("\nConteúdo dos registradores:");
        for (i = 0; i < 32; i = i + 1)
            $display("Register [%0d]: %h", i, uut.registers[i]);
        $display("Memória[0] = %h", uut.memory[0]);

        // Exporta a memória para arquivo
        f = $fopen("riscv_datapath/bin/estado.memoria.txt", "w");
        for (i = 0; i < 32; i = i + 1) begin
            $fdisplay(f, "%08x: %08x", i, uut.memory[i]);
        end
        $fclose(f);
        $finish;
    end
endmodule
