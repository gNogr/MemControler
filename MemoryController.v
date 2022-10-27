`timescale 1ns / 100ps 

// Módulo de controlador de memória. Incorpora outros módulos
module sram_controller (

	// Sistema -> Controlador
	input 				clk,					//  clock - Velocidade de 100MHz ou 130MHz
	input 				reset_n,				//  Reinicializa placa
	input 				az_cs,				//  chip enable
	input 				az_rd_n,				//  read op
	input 				az_wr_n, 			//  write op
	input [1:0] 		az_be_n,				//  byte enable mask
	input [21:0] 		az_addr,				//  endereço da requisição
	input [15:0] 		az_data,				//  dados da requisição

	// Controlador -> Sistema
	output reg	 		za_valid,			//  ????  
	output				za_wait,				//  Sinaliza que a memória está ocupada
	output     [15:0]	za_data,				//  Output de dados

	// Controlador -> Memória
	output [11:0]	zs_addr,				//  Barramento de endereços de linha/coluna
	output [1:0] 	zs_ba,					//  Bank Access - Especificador de banco
	output [1:0] 	zs_dqm,					//  Máscara de dados para uso de endereços de 8 bits
	output 			zs_cke,					//  Clock Enable p/ memória
	output 			zs_cs_n,				//  Chip Select p/ memória
	output			zs_ras_n,				//  Sinal seletor de linha
	output 			zs_cas_n,				//  Sinal seletor de coluna
	output 			zs_we_n,				//  Habilitador de Escrita

	// Controlador <> Memória
	inout [15:0]		zs_dq					//  Barramento único de dados. Nunca pode ser Reg.

);


// Parâmetros da Memória
	parameter W_B_Length = 1'b1;				//	0: Burst		1: Single Write
	parameter Test_mode = 2'b00;				//	00: MRS. Único valor aceito
	parameter CAS_Latency = 3'd0;				//	2: 2 ciclos		3: 3 ciclos
	parameter Burst_length = 3'd0;				//	0: 1,	1: 2,	2: 4,	3: 8,	7: Página
	parameter Wrap_type = 1'b0;					//	0: Sequencial,	1: Intercalado

// Valores Importantes
	parameter RASCAS_time = 3'd2;				// tRCD = 21ns ---> 3 ciclos em 143MHz


// Wires importantes

	wire [11:0] mrs = {2'b00, W_B_Length, Test_mode, CAS_Latency, Wrap_type, Burst_length};
	wire [3:0] command;
	wire [13:0] counter;
	wire [3:0] state;
	wire w_ready;
	wire valid;

	//Estes dois módulos controlam o estado do chip de memória e os comandos sendo enviados ao mesmo
	//TODO: reaver ambos os módulos, comparar com outros contoladores existentes, compilar, otimizar temporização e voltagem, gerar test-bench, gerar testes físicos
	core m (
		.clk			(clk), 
		.rst_n		(reset_n), 
		.we_n			(az_wr_n), 
		.re_n			(az_rd_n), 
		.command		(command), 
		.cur_state	(state), 
		.counter		(counter), 
		.w_ready		(w_ready), 
		.waiting		(za_wait), 
		.valid		(valid)
		);
		
	memory_interface c (
		.command		(command), 
		.mrs			(mrs), 
		.addr_in		(az_addr),
		.be_in		(az_be_n),
		.addr_out	(zs_addr), 
		.ba_out		(zs_ba), 
		.dqm			(zs_dqm), 
		.cke			(zs_cke), 
		.cs_n			(zs_cs_n), 
		.ras_n		(zs_ras_n), 
		.cas_n		(zs_cas_n), 
		.we_n			(zs_we_n)
		);

	//Controlador de Data Bus
	assign zs_dq = (w_ready ? az_data : 16'bzzzzzzzzzzzzzzzz);
	//assign zs_dq = (1'b0 ? az_data : 16'bzzzzzzzzzzzzzzzz);
	assign za_data = zs_dq;
	
	always @(valid) #6 za_valid <= valid;


endmodule
