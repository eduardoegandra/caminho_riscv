module tb_sb;
    reg [11:0] imm;
    reg [31:0] registers [0:31];
    reg [7:0] memory [0:4095];
    integer addr;

    initial begin
        // Inicializa registradores e memória
        registers[1] = 10;
        registers[2] = 55;
        imm = 5;
        rs1 = 1;
        rs2 = 2;

        // Calcula endereço
        addr = registers[rs1] + imm;
        // Simula a operação do sb
        memory[addr] = registers[rs2][7:0];
        #1;
        $display("memory[%0d] = %0d", addr, memory[addr]);
        $finish;
    end
endmodule
