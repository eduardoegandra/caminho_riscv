

lb x3, 0(x1)          # Carrega byte da memória para x3
sb x3, 4(x2)          # Armazena byte de x3 na memória
sub x4, x5, x6        # Subtrai x6 de x5 e armazena em x4
and x7, x8, x9        # AND entre x8 e x9, resultado em x7
ori x10, x11, 15      # OR imediato entre x11 e 15, resultado em x10
srl x12, x13, x14     # Shift right lógico de x13 por x14, resultado em x12
beq x15, x16, label   # Se x15 == x16, salta para 'label'

label:
	sb x0, 8(x1)    # Exemplo de instrução após o salto
