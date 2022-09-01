// Temporização e multiplexação na comunicação com memória
module mem_interface(
	input 	[19:0]	addr_in, 
	input 	[1:0] 	ba_in,				//  Bank Access - Especificador de banco
	input 	[3:0] 	dmq_in,				//  Máscara de dados para uso de endereços de 8 bits
	input 	[1:0]		cke_in,				//  Clock Enable p/ memória
	input 				cs_in,				//  Chip Select p/ memória
	input					ras_in,				//  Sinal seletor de linha
	input 				cas_in,				//  Sinal seletor de coluna
	input 				we_in,				//  Habilitador de Escrita		
	input 				control, 
	
	output	[11:0]	addr_out,
	output 	[1:0] 	ba_out,				//  Bank Access - Especificador de banco
	output 	[3:0] 	dmq_out,				//  Máscara de dados para uso de endereços de 8 bits
	output 				cke_out,				//  Clock Enable p/ memória
	output 				cs_out,				//  Chip Select p/ memória
	output				ras_out,				//  Sinal seletor de linha
	output 				cas_out,				//  Sinal seletor de coluna
	output 				we_out,				//  Habilitador de Escrita
);

	
	
	
endmodule
