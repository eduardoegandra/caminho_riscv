// Módulo para operação OR imediato
module ori_operation(
    input [31:0] a,
    input [31:0] imm,
    output [31:0] result
);
    assign result = a | imm;
endmodule
