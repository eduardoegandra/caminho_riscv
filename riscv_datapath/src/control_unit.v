// Unidade de controle simplificada
module control_unit(
    input [6:0] opcode,
    output reg [2:0] alu_control,
    output reg branch,
    output reg mem_read,
    output reg mem_write,
    output reg alu_src
);
    always @(*) begin
        // Exemplo de decodificação
        branch = 0;
        mem_read = 0;
        mem_write = 0;
        alu_src = 0;
        alu_control = 3'b000;
        case (opcode)
            7'b0000011: begin // LB
                alu_control = 3'b000; // ADD para endereço
                branch = 0;
                mem_read = 1;
                mem_write = 0;
                alu_src = 1;
            end
            7'b0100011: begin // SB
                alu_control = 3'b000; // ADD para endereço
                branch = 0;
                mem_read = 0;
                mem_write = 1;
                alu_src = 1;
            end
            7'b0110011: begin // Operações aritméticas
                alu_control = 3'b001; // ADD/SUB
                branch = 0;
                mem_read = 0;
                mem_write = 0;
                alu_src = 0;
            end
            7'b1100011: begin // BEQ
                alu_control = 3'b010; // BEQ
                branch = 1;
                mem_read = 0;
                mem_write = 0;
                alu_src = 0;
            end
            default: begin
                alu_control = 3'b000;
                branch = 0;
                mem_read = 0;
                mem_write = 0;
                alu_src = 0;
            end
        endcase
    end
endmodule
