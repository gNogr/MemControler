module core_one(
	// Sistema -> Controlador
	input 				clk,					//  clock - Velocidade de 100MHz ou 130MHz
	input 				rst_n,				//  Reinicializa placa
	input 				az_wr_n, 			//  write op
	input					az_be_n,				//  byte enable
	input [15:0] 		az_data,				//  dados da requisição
	input [21:0] 		az_addr,				//  endereço da requisição

	// Controlador -> Sistema
	output				za_valid,
	output     [15:0]	za_data,				//  Output de dados
	output				za_wait,				//  Sinaliza que a memória está ocupada
	output	[1:0]		zs_ba,

	// Controlador -> Memória
	output [11:0]	zs_addr,				//  Barramento de endereços de linha/coluna
	//output			zs_cs_n,
	output [1:0]	zs_dqm,
	output			zs_ras_n,				//  Sinal seletor de linha
	output 			zs_cas_n,				//  Sinal seletor de coluna
	output 			zs_we_n,				//  Habilitador de Escrita

	// Controlador <> Memória
	inout [15:0]		zs_dq,					//  Barramento único de dados. Nunca pode ser Reg.
	
	// Controle
	output reg [32:0]	counter,
	output reg error
	);
	
	// =========================================================================================
	// ============================== PARÂMETROS DE TEMPORIZAÇÃO ===============================
	// =========================================================================================
	
	parameter CLK_FREQUENCY = 27; // Mhz
	parameter REF_TIME = 64; //ms
	parameter REF_COUNT = 4096;
	parameter PWR_TIME = 200; //us

	parameter ROW_SIZE = 4096;
	parameter COL_SIZE = 512;
	parameter NUM_BANK = 4;
	
	
	// =========================================================================================
	// ================================ PARÂMETROS DA MEMÓRIA ==================================
	// =========================================================================================
	
	parameter W_B_Length = 1'b0;					//	0: Burst		1: Single Write
	parameter Test_mode = 2'b00;					//	00: MRS. Único valor admissível
	parameter CAS_Latency = 3'd2;					//	2: 2 ciclos		3: 3 ciclos
	parameter Wrap_type = 1'b0;					//	0: Sequencial,	1: Intercalado
	parameter Burst_length = 3'd0;				//	0: 1,	 1: 2,	2: 4,	 3: 8,	7: Página

	localparam PWRC = 5401;		// clk_frequency * pwr_time = 5400
	localparam INTC = 8;			// Número de ciclos necessários para finalizar etapa de inicialização
	localparam REFC = 64;		// (clk_frequency * 1_000 * ref_time) / (cycle_time * ref_count) = 105
	
	localparam RESET = 16'd0;	
	
	
	// =========================================================================================
	// ================================ ESTADOS LOCAIS =========================================
	// =========================================================================================
	
	localparam ST_POW				= 4'b0000;		// Estados inicial
	localparam ST_INIT1			= 4'b0001;		// Estados pertinentes a sequÃªncia de inicializaÃ§Ã£o
	localparam ST_INIT2	 		= 4'b0010;		// 
	localparam ST_INIT3			= 4'b0011;		// 
	localparam ST_ACT				= 4'b0100;		// 
	localparam ST_REF				= 4'b0101;		// Auto-Refresh
	localparam ST_STAL			= 4'b0110;		// 
	
	localparam ST_READ1			= 4'b0111;		// 
	localparam ST_READ2			= 4'b1000;		// 
	localparam ST_READ3			= 4'b1001;		// 
	localparam ST_READ4			= 4'b1010;		// 
	
	localparam ST_WRIT1			= 4'b1011;		// Executa WRIT Imediatamente
	localparam ST_WRIT2			= 4'b1100;		// 
	//localparam ST_WRIT3			= 4'b1101;		//

	localparam ST_PREP			= 4'b1111;		// Armazena informação nos registradores de input
	
	reg [3:0] state;
	
	// =========================================================================================
	// ================================= COMANDOS LOCAIS =======================================
	// =========================================================================================
	
	//   1 1 1 x --> CMD_NOP
	// -----------------
	//   R C W A
	//   A A E 1
	//   S S   0
	
	localparam CMD_NOP			= 4'b1110;		// No Operation / Self Refresh Exit - Whatever
	localparam CMD_MRS			= 4'b0000;		// Mode Register Set						- mrs
	localparam CMD_ACT			= 4'b0110;		// Bank Activate							- addr_l
	localparam CMD_READ			= 4'b1011;		// Read										- addr_r
	localparam CMD_WRIT			= 4'b1001;		// Write										- addr_r
	localparam CMD_PALL			= 4'b0101;		// Precharge All Banks					- Whatever
	localparam CMD_REF			= 4'b0010;		// CBR (Auto) Refresh					- Whatever
	
	reg [3:0] command; //Registrador de comandos
	reg az_wr_n_r;
	wire a10;
	
	assign zs_ras_n = command[3];				//  Sinal seletor de linha
	assign zs_cas_n = command[2];				//  Sinal seletor de coluna
	assign zs_we_n = 	command[1];				//  Habilitador de Escrita
	assign a10 = 		command[0];				//  Sinal em A10 é revelante para alguns comandos
	
	//Alto quando dados de escrita estão para serem colocados no bus de dados do chip de memória
	assign za_wait = ~(state == ST_INIT1 && counter == REFC || state == ST_READ4 || state == ST_WRIT2);	//Baixo quando uma nova operação pode ser realizada
	assign za_valid = state == ST_READ4;
	
	
	// =========================================================================================
	// ================================= ENDEREÇAMENTO =========================================
	// =========================================================================================
	reg		[21:0]	az_addr_r;
	reg		[11:0]	zs_addr_r;
	assign 				zs_addr = zs_addr_r;
	assign 				zs_ba	=	state == ST_PREP ? 2'd0 : az_addr_r[21:20];
	
	wire		[11:0]	addr_l	=	az_addr_r[19:8]; 																			// Endereço de Linha
	wire		[11:0]	addr_c	=	{1'b0, a10, 2'b0 ,az_addr_r[7:0]};														// Endereço de coluna
	wire		[11:0]	mrs		=	{2'b0, W_B_Length, Test_mode, CAS_Latency, Wrap_type, Burst_length};		// Mode Register Set
	
	
	// =========================================================================================
	// ================================= LEITURA / ESCRITA =====================================
	// =========================================================================================
	
	reg [1:0] az_be_n_r;
	reg [15:0] za_data_r, az_data_r;
	assign zs_dq = (state == ST_WRIT2 ? az_data_r : 16'bzzzzzzzzzzzzzzzz);
	assign za_data = za_data_r;
	assign zs_dqm = az_be_n_r;
	//assign zs_dqm = az_be_n;
	
	// =========================================================================================
	// ================================= MÁQUINA DE ESTADOS ====================================
	// =========================================================================================
	
	always @(posedge clk or negedge rst_n) //Troca de estados ocorre apenas na subida de clock
	begin
		// Reinicializa registradores
		if(!rst_n) begin
			counter <= RESET;
			command <= CMD_NOP;
			state <= ST_POW;
			error <= 1'b0;
		end
		else 
		begin //begin the procedural statements
			case (state)  //variables that affect the procedure  
			ST_POW:
				begin
				zs_addr_r <= mrs;
				command <= (counter == PWRC ? CMD_PALL : CMD_NOP);					//Executa NOP
				counter <= (counter == PWRC ? RESET : counter + 'b1);		//Reinicia Counter se PWRC for atingido
				state <= (counter == PWRC ? ST_INIT1 : ST_POW);				//Vai para ST_INIT1 se PWRC for atingido. SenÃ£o, vai para prÃ³ximo estado
				end
			ST_INIT1:
				begin
				command <= (counter == INTC ? CMD_MRS : CMD_REF);			//Executa MRS se INTC for atingido. SenÃ£o, executa REF
				counter <= (counter == INTC ? RESET : counter);		//Reinicia Counter se INTC for atingido
				state <= (counter == INTC ? ST_PREP : ST_INIT2);		//Vai para ST_IDLE se INTC for atingido. SenÃ£o vai para o prÃ³ximo estado
				end
			ST_INIT2:
				begin
				command <= CMD_NOP;													//Executa NOP
				state <= ST_INIT3;												//Vai para o prÃ³ximo estado
				end
			ST_INIT3:
				begin
				command <= CMD_NOP;													//Executa NOP
				state <= ST_INIT1;												//Volta para o primeiro estado
				counter <= counter + 'b1;
				end
			ST_ACT:			//ADDR = ADDR1
				begin
				zs_addr_r = addr_l;
				if (counter >= REFC)
					begin
					command <= CMD_REF;
					counter <= RESET;
					state <= ST_REF;
					end
				else 
					begin
					command <= CMD_ACT;
					counter <= counter;
					state <= (az_wr_n ? ST_READ1 : ST_WRIT1);
					end
				error <= 1'b0;
				end
			ST_REF:
				begin
				command <= CMD_NOP;													//Executa NOP
				state <= ST_STAL;												//Vai para o prÃ³ximo estado
				error <= 1'b1;
				end
			ST_STAL:
				begin
				command <= CMD_NOP;													//Executa NOP
				state <= ST_ACT;												//Volta para o estado IDLE
				end
			ST_READ1:		//ADDR = ADDR2
				begin
				command <= CMD_READ;													//Executa Read
				state <= ST_READ2;													//Vai para PrÃ©-Carga
				zs_addr_r <= addr_c;
				end
			ST_READ2:
				begin
				command <= CMD_NOP;													//Executa PrÃ©-Carga
				state <= ST_READ3;												//Volta para o estado IDLE
				end
			ST_READ3:
				begin
				command <= CMD_NOP;													//Executa NOP
				state <= ST_READ4;														//
				za_data_r <= zs_dq;													//Isso deve funcionar melhor que o registrador que eu tenho.
				end
			ST_READ4:
				begin
				command <= CMD_NOP;													//Executa NOP
				state <= ST_PREP;														//
				end
			ST_WRIT1:	//ADDR = ADDR2
				begin
				command <= CMD_WRIT;													//Executa Write
				state <= ST_WRIT2;													//Vai para PrÃ©-Carga
				zs_addr_r <= addr_c;
				end
			ST_WRIT2:	//ADDR = ADDR2
				begin
				command <= CMD_NOP;													//Executa Write
				state <= ST_PREP;													//Vai para PrÃ©-Carga
				end
			ST_PREP:
				begin
				command <= CMD_NOP;													//Executa PrÃ©-Carga
				state <= ST_ACT;														//Volta para o estado IDLE
				az_addr_r <= az_addr;												//Registrador de endereço é atualizado
				az_data_r <= az_data;												//Registrador de dados é atualizado
				az_wr_n_r <= az_wr_n;												//Registrador de Operação é atualizado
				az_be_n_r <= az_be_n;
				counter <= counter + 'b1;
				end
			endcase
		end
	end
	
endmodule
