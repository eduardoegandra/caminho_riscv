// Módulo para operação lógica SRL
module srl_operation(
    input [31:0] a,
    input [4:0] shamt,
    output [31:0] result
);
    assign result = a >> shamt;
endmodule
