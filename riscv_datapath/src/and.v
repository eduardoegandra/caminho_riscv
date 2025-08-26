// Módulo para operação lógica AND
module and_operation(
    input [31:0] a,
    input [31:0] b,
    output [31:0] result
);
    assign result = a & b;
endmodule
