// Módulo para instrução ADD/SUB
module add_sub_operation(
    input [31:0] a,
    input [31:0] b,
    input add_sub_flag,
    output [31:0] result
);
    assign result = add_sub_flag ? (a + b) : (a - b);
endmodule
