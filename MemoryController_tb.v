`timescale 1ns / 100ps

module sram_controller_tb ();


	//	az
	reg [22:0] counter;
	reg clk;
	reg rst;
	reg [1:0] be;
	
	wire [21:0] addr;
	wire [15:0] data_in;
	wire we;
	wire re;
	
	// za
	wire valid;
	wire busy;
	wire za_data;

	//zs
	wire	[11:0] ADDR_out;				//  Barramento de endereços de linha/coluna
	wire	BA_1;
	wire	BA_0;					//  Bank Access - Especificador de banco
	wire	LDQM;
	wire	UDQM;					//  Máscara de dados para uso de endereços de 8 bits
	wire	CKE;					//  Clock Enable p/ memória
	wire	CS_N;				//  Chip Select p/ memória
	wire	RAS_N;				//  Sinal seletor de linha
	wire	CAS_N;				//  Sinal seletor de coluna
	wire	WE_N;
	wire	[15:0] DQ;
	
		sram_controller sram_controllert (
	// Sistema --> Controlador
	.clk			(clk),				//  clock - Velocidade de 100MHz ou 130MHz
	.reset_n		(~rst),				//  Inicializa a memória
	.az_cs		(1'b1),				//  chip enable
	.az_rd_n 	(~re),				//  read op
	.az_wr_n 	(~we), 				//  write op
	.az_be_n 	(be),				//  byte enable mask
	.az_addr 	(addr),				//  endereço da requisição
	.az_data 	(data_in),				//  dados da requisição

	// Controlador --> Sistema
	.za_valid	(valid),			//  ????  
	.za_wait		(busy),	//  Sinaliza que a memória está ocupada
	.za_data		(za_data),				//  Output de dados

	// Controlador --> Memória
	.zs_addr 	(ADDR_out),				//  Barramento de endereços de linha/coluna
	.zs_ba		(dram_ba),					//  Bank Access - Especificador de banco
	.zs_dqm		(dqm),					//  Máscara de dados para uso de endereços de 8 bits
	.zs_cke		(CKE),					//  Clock Enable p/ memória
	.zs_cs_n		(CS_N),				//  Chip Select p/ memória
	.zs_ras_n	(RAS_N),				//  Sinal seletor de linha
	.zs_cas_n	(CAS_N),				//  Sinal seletor de coluna
	.zs_we_n		(WE_N),				//  Habilitador de Escrita
	//state,
	//LEDR[0],

	// Controlador <-> Memória
	.zs_dq		(DQ)				//  Barramento único de dados. Nunca pode ser Reg.
	);
	
	initial begin
		clk = 0; //initial value
		rst = 1;
		counter = 'b0;
		be = 'b0;
		 
		#40 
		rst = 0; //release reset
		
		#1000
		rst = 1; //Try to reset once more to test modelsim
		
		#40 
		rst = 0; //release reset
   end
	always #19 clk = ~clk; //tick the clock every 19ns (clk period = 38 ns)
	



	assign addr = counter[22:1];
	assign data_in = counter[16:1];
	assign we = ~counter[0];
	assign re = counter[0];
	
    always@(negedge busy) begin
        counter = counter + 'b1;
    end

	

endmodule