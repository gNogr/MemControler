module TopLevel (
	input [17:0] SW, // toggle switches
	input [3:0] KEY,
	input CLOCK_27,
	output [17:0] LEDR, // red LEDs
	output [8:0] LEDG, // green LEDs
	output [11:0] DRAM_ADDR,				//  Barramento de endereços de linha/coluna
	output DRAM_CLK,
	output DRAM_BA_1,
	output DRAM_BA_0,					//  Bank Access - Especificador de banco
	output DRAM_LDQM, 
	output DRAM_UDQM,					//  Máscara de dados para uso de endereços de 8 bits
	output DRAM_CKE,					//  Clock Enable p/ memória
	output DRAM_CS_N,				//  Chip Select p/ memória
	output DRAM_RAS_N,				//  Sinal seletor de linha
	output DRAM_CAS_N,				//  Sinal seletor de coluna
	output DRAM_WE_N,
	inout [15:0] DRAM_DQ
	);
	
	//wire [3:0] command, state;
	//wire [11:0] counter;
	//command_truth_table c (command, {2'b00, 1'b1, 2'b00, 3'd0, 1'b0, 3'd0}, {SW[16:15], SW[14:3], SW[10:3]}, LEDR[11:0], LEDR[13:12], LEDG[7:5], LEDG[4], LEDG[3], LEDG[2], LEDG[1], LEDG[0]);
	//core m (SW[17], SW[0], SW[1], command, state, counter);

	//assign LEDR[17:14] = SW[2] ? state : counter[3:0]; 
	
	//reg dclk;
	
	reg [15:0]	data_in;
	reg [21:0]	addr;
	reg 			re;
	reg			we;
	reg [1:0]	be_n;
	reg [13:0]	counter;
	
	reg [15:0]	data_out;
	
	wire valid;
	wire busy;
	wire [15:0] za_data;
	wire [3:0] state;
	
	wire [1:0] dqm;
	wire [1:0] dram_ba;
	
	
	sram_controller c (
	// Sistema --> Controlador
	.clk			(CLOCK_27),					//  clock - Velocidade de 100MHz ou 130MHz
	.reset_n		(KEY[1]),				//  Inicializa a memória
	.az_cs		(1'b1),					//  chip enable
	.az_rd_n 	(~re),				//  read op
	.az_wr_n 	(~we), 				//  write op
	.az_be_n 	(be_n),				//  byte enable mask
	.az_addr 	(addr),				//  endereço da requisição
	.az_data 	(data_in),				//  dados da requisição

	// Controlador --> Sistema
	.za_valid	(valid),			//  ????  
	.za_wait		(busy),	//  Sinaliza que a memória está ocupada
	.za_data		(za_data),				//  Output de dados

	// Controlador --> Memória
	.zs_addr 	(DRAM_ADDR),				//  Barramento de endereços de linha/coluna
	.zs_ba		(dram_ba),					//  Bank Access - Especificador de banco
	.zs_dqm		(dqm),					//  Máscara de dados para uso de endereços de 8 bits
	.zs_cke		(DRAM_CKE),					//  Clock Enable p/ memória
	.zs_cs_n		(DRAM_CS_N),				//  Chip Select p/ memória
	.zs_ras_n	(DRAM_RAS_N),				//  Sinal seletor de linha
	.zs_cas_n	(DRAM_CAS_N),				//  Sinal seletor de coluna
	.zs_we_n		(DRAM_WE_N),				//  Habilitador de Escrita
	//state,
	//LEDR[0],

	// Controlador <-> Memória
	.zs_dq		(DRAM_DQ)				//  Barramento único de dados. Nunca pode ser Reg.
	);
	
	apll a (CLOCK_27, DRAM_CLK);
	
	assign DRAM_BA_1 = dram_ba[1];
	assign DRAM_BA_0 = dram_ba[0];
	
	assign DRAM_LDQM = dqm[0];
	assign DRAM_UDQM = dqm[1];

	//always @(posedge KEY[0])
	//always @(posedge CLOCK_27) dclk = ~dclk;
	
	always @(negedge busy)
	begin
		if (!KEY[0]) begin
		addr <= {16'b0, SW[13:8]};
		data_in <= {8'b0, SW[7:0]};
		re <= SW[15];
		we <= SW[14];
		be_n <= SW[17:16];
		end
	end
	
	always @(posedge valid)
	begin
		data_out <= za_data;
	end
	
	//assign LEDG [7:0] = data_out[7:0];
	assign LEDG [7:0] = data_out[7:0];
	assign LEDR [17:16] = be_n;
	assign LEDR [15] = re;
	//assign LEDR [14:8] = addr[6:0];
	//assign LEDR [7:0] = data_in[7:0];
	assign LEDR [14] = we;
	//assign LEDG [8] = working;
endmodule
