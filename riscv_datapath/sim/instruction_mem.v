module instruction_mem(input [31:0] address, output reg [31:0] instruction);
    reg [31:0] memory [0:31];  // Memória de 32 palavras
    always @(address) begin
        instruction = memory[address];
    end
endmodule
