// Módulo para instrução BEQ
module beq_operation(
    input [31:0] a,
    input [31:0] b,
    output branch
);
    assign branch = (a == b);
endmodule
