// MÃ¡quina de estados que acompanha memÃ³ria e envia comandos
module core(
	input		 				clk,			// Clock
	input						rst_n,			// Reset
	input						we_n,				// write enable
	input						re_n,				// Read enable

	output reg	[3:0]			command,		// Command Output
	output reg [3:0]			cur_state,		// Current State
	output reg [3:0]			nxt_state,		// Current State
	output reg [31:0]			counter,		// Current Counter
	output						w_ready,		// Controller of IOBus
	output						waiting,	// Quando esperar antes de mandar um comando ao controlador
	output						valid,			// Quando uma leitura está pronta
	output reg					rd_incom
);

	//Registrador de estado
	//reg [3:0] cur_state;
	//reg [3:0] nxt_state;
	reg [31:0] nxt_counter;
	assign valid = (rd_incom && cur_state == ST_IDLE);
	assign w_ready = (cur_state == ST_WRITE);
	assign waiting = ~(cur_state == ST_STAL2 || cur_state == ST_PRE);

	//Estados Locais
	localparam ST_POW			= 4'b0000;		// Estados inicial
	
	localparam ST_INIT1			= 4'b0001;		// Estados pertinentes a sequÃªncia de inicializaÃ§Ã£o
	localparam ST_INIT2	 		= 4'b0010;		// 
	localparam ST_INIT3			= 4'b0011;		// 
	
	localparam ST_IDLE			= 4'b0100;		// Estado Ocioso, Ãºnico que verifica por comandos para realizar
	localparam ST_READ			= 4'b0101;		// Executa READ Imediatamente
	localparam ST_WRITE			= 4'b0110;		// Executa WRIT Imediatamente
	localparam ST_PRE				= 4'b0111;		// Realiza prÃ©-carga de banco
	localparam ST_REF				= 4'b1000;		// Auto-Refresh
	localparam ST_STAL1			= 4'b1001;		// Nenhuma OperaÃ§Ã£o
	localparam ST_STAL2			= 4'b1010;		// Nenhuma OperaÃ§Ã£o, retorna para Idle
	//localparam ST_A 			= 4'b1101;		// NÃ£o Utilizados, posso utilizar para fazer sequÃªncia de inicializaÃ§Ã£o da memÃ³ria

	//Listagem de Comandos
	localparam CMD_DESL			= 4'b0000;		// Device Deselect
	localparam CMD_NOP			= 4'b0001;		// No Operation / Self Refresh Exit
	localparam CMD_MRS			= 4'b0010;		// Mode Register Set
	localparam CMD_ACT			= 4'b0011;		// Bank Activate
	localparam CMD_READ			= 4'b0100;		// Read
	localparam CMD_READA 		= 4'b0101;		// Read with Auto Precharge
	localparam CMD_WRIT			= 4'b0110;		// Write
	localparam CMD_WRITA 		= 4'b0111;		// Write with Auto Precharge
	localparam CMD_PRE			= 4'b1000;		// Precharge Select Bank
	localparam CMD_PALL			= 4'b1001;		// Precharge All Banks
	localparam CMD_BST			= 4'b1010;		// Burst Stop
	localparam CMD_REF			= 4'b1011;		// CBR (Auto) Refresh
	localparam CMD_SELF			= 4'b1100;		// Self Refresh
	localparam CMD_SUP			= 4'b1101;		// Suspender / Power Down	---> Pode causar problemas, jÃ¡ que Ã© o mesmo comando que COM_MRS
	localparam CMD_REC			= 4'b1110;		// Recuperar / Power Up		---> Pode causar problemas, jÃ¡ que Ã© o mesmo comando que COM_MRS
	//localparam CMD_SRE			= 4'b1111;		// NÃ£o Utilizado. Por default, valores nÃ£o utilizados sÃ£o tratados como NOP.


	
	// Parâmetros de Temporização
	parameter CLK_FREQUENCY = 27; // Mhz
	parameter REF_TIME = 64; //ms
	parameter REF_COUNT = 4096;
	parameter PWR_TIME = 200; //us

	parameter ROW_SIZE = 4096;
	parameter COL_SIZE = 512;
	parameter NUM_BANK = 4;
	
	localparam PWRC = 5600;		// clk_frequency * pwr_time = 5400
	localparam INTC = 8;			// Número de ciclos necessários para finalizar etapa de inicialização
	localparam REFC = 120;		// (clk_frequency * 1_000 * ref_time) / (cycle_time * ref_count) = 140
	
	//Registrador de tempo
	//reg [11:0] counter;
	localparam RESET = 32'd0;	
	
	

	always @(posedge clk) //Troca de estados ocorre apenas na subida de clock
	begin
		counter <= (rst_n ? nxt_counter : RESET);
		cur_state <= (rst_n ? nxt_state  : ST_POW);
	end
		
	always @(cur_state or counter) //Incrementa contador e envia comandos apenas ao atualizar estado atual
	begin //begin the procedural statements
			case (cur_state)  //variables that affect the procedure  
			default:
				begin
				command <= CMD_NOP;
				nxt_counter <= RESET;
				nxt_state <= ST_POW;
				//w_ready <= 'b0;
				rd_incom <= 'b0;
				end
			ST_POW:
				begin
				command <= (counter == PWRC ? CMD_PALL : (counter == RESET | counter=='b1 ? CMD_DESL : CMD_NOP));	//Executa NOP
				nxt_counter <= (counter == PWRC ? RESET : counter + 1'd1);				//Reinicia Counter se PWRC for atingido
				nxt_state <= (counter == PWRC ? ST_INIT1 : ST_POW);				//Vai para ST_INIT1 se PWRC for atingido. SenÃ£o, vai para prÃ³ximo estado
				//waiting <= 'b1;
				//w_ready <= 'b0;
				rd_incom <= 'b0;
				//valid <= 'b0;
				end
			ST_INIT1:
				begin
				command <= (counter == INTC ? CMD_MRS : CMD_REF);			//Executa MRS se INTC for atingido. SenÃ£o, executa REF
				nxt_counter <= (counter == INTC ? RESET : counter);		//Reinicia Counter se INTC for atingido
				nxt_state <= (counter == INTC ? ST_IDLE : ST_INIT2);		//Vai para ST_IDLE se INTC for atingido. SenÃ£o vai para o prÃ³ximo estado
				//waiting <= (counter == INTC ? 1'b1 : 1'b0);
				end
			ST_INIT2:
				begin
				command <= CMD_NOP;													//Executa NOP
				nxt_counter <= counter;
				nxt_state <= ST_INIT3;												//Vai para o prÃ³ximo estado
				end
			ST_INIT3:
				begin
				command <= CMD_NOP;													//Executa NOP
				nxt_counter <= counter + 1'b1;												//Incrementa Contador
				nxt_state <= ST_INIT1;												//Volta para o primeiro estado
				end
			ST_IDLE:
				begin
				//Executa REF se REFC for atingido. SenÃ£o, executa ACT se re ou we. SenÃ£o, executa NOP
				command <= (counter == REFC ? CMD_REF : (we_n & re_n ? CMD_NOP : CMD_ACT)); 
				nxt_counter <= (counter == REFC ? RESET : counter);					//Reinicia Counter se REFC for atingido
				//Vai para IDLE se INTC for atingido. SenÃ£o, vai para WRITE se we. SenÃ£o, vai para READ se re. SenÃ£o, vai para NOP1
				nxt_state <= (counter == REFC ? ST_REF : (we_n ?  ST_READ : ST_WRITE)); 
				//waiting <= 'b1;
				//valid <= rd_incom;
				//w_ready <= 'b0;
				end
			ST_READ:
				begin
				command <= CMD_READ;													//Executa Read
				nxt_counter <= counter;
				nxt_state <= ST_PRE;													//Vai para PrÃ©-Carga
				rd_incom <= 'b1;
				//valid <= 'b0;
				end
			ST_WRITE:
				begin
				command <= CMD_WRIT;													//Executa Write
				nxt_counter <= counter;
				nxt_state <= ST_PRE;													//Vai para PrÃ©-Carga
				rd_incom <= 'b0;
				//w_ready <= 'b1;
				//valid <= 'b0;
				end
			ST_PRE:
				begin
				command <= CMD_PRE;													//Executa PrÃ©-Carga
				nxt_counter <= counter + 1'b1;									//Incrementa Contador
				nxt_state <= ST_IDLE;												//Volta para o estado IDLE
				//w_ready <= 'b0;
				//waiting <= 'b0;
				end
			ST_REF:
				begin
				command <= CMD_NOP;													//Executa NOP
				nxt_counter <= counter;
				nxt_state <= ST_STAL2;												//Vai para o prÃ³ximo estado
				rd_incom <= 'b0;
				//valid <= 'b0;
				end
			ST_STAL1:
				begin
				//Deveria ser um NOP, mas gostaria de garantir que todos os bancos estejam prÃ©-carregados antes de realizar um refresh.
				//Desta forma consigo executar REF sem problemas mais tarde.
				command <= CMD_PALL;													
				nxt_counter <= counter;
				nxt_state <= ST_STAL2;												//Vai para o prÃ³ximo estado
				rd_incom <= 'b0;
				//valid <= 'b0;
				end
			ST_STAL2:
				begin
				command <= CMD_NOP;													//Executa NOP
				nxt_counter <= counter + 1'b1;									//Incrementa Contador
				nxt_state <= ST_IDLE;												//Volta para o estado IDLE
				//waiting = 'b0;
				end
			endcase
		end
endmodule
