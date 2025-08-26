module datapath (
    input clk,
    input reset,
    input [31:0] instruction,
    input [31:0] data_in,
    output reg [31:0] data_out,
    output reg [31:0] pc
);
    // Registradores e memória
    reg [31:0] registers [0:31];
    reg [31:0] memory [0:4095];

    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 0;
        for (i = 0; i < 4096; i = i + 1)
            memory[i] = 0;
    // Inicialização de teste
    registers[0] = 0;
    registers[1] = 0;
    registers[2] = 7; // x2 = 7 para sw x2, 4(x0)
    registers[3] = 0;
    registers[4] = 0;
    registers[5] = 100;
    registers[6] = 50;
    registers[7] = 0;
    registers[8] = 8'hFF;
    registers[9] = 8'h0F;
    registers[10] = 0;
    registers[11] = 8'hF0;
    registers[12] = 0;
    registers[13] = 8'h80;
    registers[14] = 2;
    registers[15] = 123;
    registers[16] = 123;
    memory[0] = 8'hAB;
    memory[4] = 0;
    end

    // Decodificação de campos
    wire [6:0] opcode = instruction[6:0];
    wire [4:0] rd    = instruction[11:7];
    wire [2:0] funct3 = instruction[14:12];
    wire [4:0] rs1   = instruction[19:15];
    wire [4:0] rs2   = instruction[24:20];
    wire [6:0] funct7 = instruction[31:25];
    wire [11:0] imm_i = instruction[31:20];
    wire [11:0] imm_s = {instruction[31:25], instruction[11:7]};
    wire [12:0] imm_b = {instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};

    // Sinais intermediários
    wire [31:0] lb_result, sb_result, add_sub_result, and_result, or_result, srl_result, ori_result;
    wire beq_branch;

    // Instanciação dos módulos
    lb_operation lb_inst(
        .mem_data(memory[registers[rs1] + imm_i]),
        .result(lb_result)
    );
    sb_operation sb_inst(
        .reg_data(registers[rs2]),
        .mem_data_out(sb_result)
    );
    add_sub_operation add_sub_inst(
        .a(registers[rs1]),
        .b(registers[rs2]),
        .add_sub_flag(funct7[5]), // 1: sub, 0: add
        .result(add_sub_result)
    );
    and_operation and_inst(
        .a(registers[rs1]),
        .b(registers[rs2]),
        .result(and_result)
    );
    or_operation or_inst(
        .a(registers[rs1]),
        .b(registers[rs2]),
        .result(or_result)
    );
    srl_operation srl_inst(
        .a(registers[rs1]),
        .shamt(registers[rs2][4:0]),
        .result(srl_result)
    );
    ori_operation ori_inst(
        .a(registers[rs1]),
        .imm({20'b0, imm_i}), // Imediato estendido para 32 bits
        .result(ori_result)
    );
    beq_operation beq_inst(
        .a(registers[rs1]),
        .b(registers[rs2]),
        .branch(beq_branch)
    );

    // Execução das instruções
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0;
        end else begin
            $display("Executando: opcode=%b funct3=%b funct7=%b rs1=%d rs2=%d rd=%d imm_i=%d", opcode, funct3, funct7, rs1, rs2, rd, imm_i);
            case (opcode)
                7'b0000011: begin // LB
                    registers[rd] <= lb_result;
                    data_out <= lb_result;
                    pc <= pc + 4;
                end
                7'b0100011: begin // SB
                    memory[registers[rs1] + $signed(imm_s)] <= sb_result;
                    pc <= pc + 4;
                end
                7'b0110011: begin // ADD/SUB/AND/OR/SRL
                    case (funct3)
                        3'b000: registers[rd] <= add_sub_result; // ADD/SUB
                        3'b111: registers[rd] <= and_result;     // AND
                        3'b110: registers[rd] <= or_result;      // OR
                        3'b101: registers[rd] <= srl_result;     // SRL
                        default: registers[rd] <= 32'b0;
                    endcase
                    pc <= pc + 4;
                end
                7'b1100011: begin // BEQ
                    if (beq_branch)
                        pc <= pc + imm_b;
                    else
                        pc <= pc + 4;
                end
                7'b0010011: begin // ORI
                    registers[rd] <= ori_result;
                    pc <= pc + 4;
                end
                default: begin
                    pc <= pc + 4;
                end
            endcase
        end
    end
endmodule
