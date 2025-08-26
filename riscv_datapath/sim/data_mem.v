module data_mem(input [31:0] address, input [31:0] data_in, input write_enable, output reg [31:0] data_out);
    reg [31:0] memory [0:31];  // Memória de dados
    always @(address or write_enable) begin
        if (write_enable)
            memory[address] = data_in;  // Grava na memória
        data_out = memory[address];  // Lê da memória
    end
endmodule
