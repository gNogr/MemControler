// Módulo de controlador de memória. Incorpora outros módulos
module sram_controller (

	// Sistema -> Controlador
	input 				clk,					//  clock - Velocidade de 100MHz ou 130MHz
	input 				reset_n,				//  reset de memória
	input 				az_cs,				//  chip enable
	input 				az_rd_n,				//  read op
	input 				az_wr_n, 			//  write op
	input [3:0] 		az_be_n,				//  byte enable mask
	input [21:0] 		az_addr,				//  endereço da requisição
	input [31:0] 		az_data,				//  dados da requisição

	// Controlador -> Sistema
	output reg 			za_valid,			//  ????  
	output reg			za_waitrequest,	//  ????
	output reg [31:0]	za_data,				//  Output de dados

	// Controlador -> Memória
	output reg [11:0]	zs_addr,				//  Barramento de endereços de linha/coluna
	output reg [1:0] 	zs_ba,				//  Bank Access - Especificador de banco
	output reg [3:0] 	zs_dmq,				//  Máscara de dados para uso de endereços de 8 bits
	output reg 			zs_cke,				//  Clock Enable p/ memória
	output reg 			zs_cs_n,				//  Chip Select p/ memória
	output reg			zs_ras_n,			//  Sinal seletor de linha
	output reg 			zs_cas_n,			//  Sinal seletor de coluna
	output reg 			zs_we_n,				//  Habilitador de Escrita

	// Controlador <> Memória
	inout [31:0]		zs_dq				//  Barramento único de dados

);

// Parâmetros da Memória
	localparam CAS_Latency = 3'b010;
	localparam Burst_length = 3'b000;
	localparam Wrap_type = 1'b0;

// Wires importantes

	wire [11:0] mrs = {5'b00000, CAS_Latency, Wrap_type, Burst_length};


	
	


endmodule






















module VerilogWarmup (SW, LEDR, LEDG);
input [17:0] SW; // toggle switches
output [17:0] LEDR; // red LEDs
output [7:0] LEDG; // green LEDs
wire S;
wire [7:0]X;
wire [7:0]Y;
wire [7:0]M;

assign s = SW[17];
assign x = SW[7:0];
assign y = SW[15:8];

assign m=(~s & x) | (s & y);

assign LEDR = SW;
assign LEDG = m;
endmodule
