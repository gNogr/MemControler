// Módulo de controlador de memória. Incorpora outros módulos
module sram_controller (

	// Sistema -> Controlador
	input 				clk,					//  clock - Velocidade de 100MHz ou 130MHz
	input 				reset_n,				//  CKE - Determina quando a memória está ativa
	input 				az_cs,					//  chip enable
	input 				az_rd_n,				//  read op
	input 				az_wr_n, 				//  write op
	input [3:0] 		az_be_n,				//  byte enable mask
	input [21:0] 		az_addr,				//  endereço da requisição
	input [31:0] 		az_data,				//  dados da requisição

	// Controlador -> Sistema
	output reg 			za_valid,			//  ????  
	output				za_waitrequest,	//  Sinaliza que a memória está ocupada
	output     [31:0]	za_data,				//  Output de dados

	// Controlador -> Memória
	output reg [11:0]	zs_addr,				//  Barramento de endereços de linha/coluna
	output reg [1:0] 	zs_ba,					//  Bank Access - Especificador de banco
	output reg [3:0] 	zs_dmq,					//  Máscara de dados para uso de endereços de 8 bits
	output reg 			zs_cke,					//  Clock Enable p/ memória
	output reg 			zs_cs_n,				//  Chip Select p/ memória
	output reg			zs_ras_n,				//  Sinal seletor de linha
	output reg 			zs_cas_n,				//  Sinal seletor de coluna
	output reg 			zs_we_n,				//  Habilitador de Escrita

	// Controlador <> Memória
	inout [31:0]		zs_dq					//  Barramento único de dados. Nunca pode ser Reg.

);

// Parâmetros da Memória
	localparam W_B_Length = 1'b1;				//	0: Burst		1: Single Write
	localparam Test_mode = 2'b00;				//	00: MRS. Único valor aceito
	localparam CAS_Latency = 3'd0;				//	2: 2 ciclos		3: 3 ciclos
	localparam Burst_length = 3'd0;				//	0: 1,	1: 2,	2: 4,	3: 8,	7: Página
	localparam Wrap_type = 1'b0;				//	0: Sequencial,	1: Intercalado

// Valores Importantes
	localparam RASCAS_time = 3'd3;				// tRCD = 21ns ---> 3 ciclos em 143MHz


// Wires importantes

	wire [11:0] mrs = {2'b00, W_B_Length, Test_mode, CAS_Latency, Wrap_type, Burst_length};
	wire [3:0] command;
	wire [3:0] state;
	wire [11:0] counter;
	wire w_ready;

	//Estes dois módulos controlam o estado do chip de memória e os comandos sendo enviados ao mesmo
	mem_command_issuer m (clk, ~we_n, ~rd_n, command, state, counter, w_ready, input_wait);
	command_truth_table c (command, mrs, addr, zs_addr, zs_ba, zs_dmq, zs_cke, zs_cs_n, zs_ras_n, zs_cas_n, zs_we_n);

	//Controlador de Data Bus
	assign zs_dq = (w_ready) ? az_data : 'bz;
	assign za_data = zs_dq;


endmodule






















module VerilogWarmup (KEY, SW, LEDR, LEDG);
	input [17:0] SW; // toggle switches
	input [3:0] KEY;
	output [17:0] LEDR; // red LEDs
	output [8:0] LEDG; // green LEDs
	
	wire [3:0] command, state;
	wire [11:0] counter;
	command_truth_table c (command, {2'b00, 1'b1, 2'b00, 3'd0, 1'b0, 3'd0}, {SW[16:15], SW[14:3], SW[10:3]}, LEDR[11:0], LEDR[13:12], LEDG[7:5], LEDG[4], LEDG[3], LEDG[2], LEDG[1], LEDG[0]);
	mem_command_issuer m (SW[17], SW[0], SW[1], command, state, counter);

	assign LEDR[17:14] = SW[2] ? state : counter[3:0]; 
	
endmodule
