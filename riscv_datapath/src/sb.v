// Módulo para instrução SB
module sb_operation(
    input [31:0] reg_data,
    output [31:0] mem_data_out
);
    assign mem_data_out = reg_data;
endmodule
