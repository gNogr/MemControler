// MÃ¡quina de estados que acompanha memÃ³ria e envia comandos
module mem_command_issuer(
	input		 				clk,
	input						we,
	input						re,
	output reg	[3:0]			command,
	output reg	[3:0]			cur_state,
	output reg	[11:0]		counter,
	output reg					w_ready,
	output reg					input_wait
);

	//Estados Locais
	localparam ST_POW1			= 4'b0000;		// Estados pertinentes a sequÃªncia de energia
	localparam ST_POW2			= 4'b0001;		// 
	localparam ST_POW3			= 4'b0010;		// 
	
	localparam ST_INIT1			= 4'b0011;		// Estados pertinentes a sequÃªncia de inicializaÃ§Ã£o
	localparam ST_INIT2	 		= 4'b0100;		// 
	localparam ST_INIT3			= 4'b0101;		// 
	
	localparam ST_IDLE			= 4'b0110;		// Estado Ocioso, Ãºnico que verifica por comandos para realizar
	localparam ST_READ			= 4'b0111;		// Executa READ Imediatamente
	localparam ST_WRITE			= 4'b1000;		// Executa WRIT Imediatamente
	localparam ST_PRE			= 4'b1001;		// Realiza prÃ©-carga de banco
	localparam ST_REF			= 4'b1010;		// Auto-Refresh
	localparam ST_NOP1			= 4'b1011;		// Nenhuma OperaÃ§Ã£o
	localparam ST_NOP2			= 4'b1100;		// Nenhuma OperaÃ§Ã£o, retorna para Idle
	//localparam ST_A 			= 4'b1101;		// NÃ£o Utilizados, posso utilizar para fazer sequÃªncia de inicializaÃ§Ã£o da memÃ³ria
	//localparam ST_B				= 4'b1110;		// 
	//localparam ST_C				= 4'b1111;		// 

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
	
	localparam PWRC = 12'd3;	//NÃºmero de ciclos necessÃ¡rio para finalizar etapa de energizaÃ§Ã£o
	localparam INTC = 12'd3;	//NÃºmero de ciclos necessÃ¡rio para finalizar etapa de inicializaÃ§Ã£o
	localparam REFC = 12'd3;	//NÃºmero de ciclos necessÃ¡rio para reiniciar a memÃ³ria
	localparam RESET = 12'd0;	//NÃºmero de ciclos necessÃ¡rio para finalizar etapa de energizaÃ§Ã£o


	//Registrador de estado
	//reg [3:0] cur_state;
	reg [3:0] nxt_state;
	reg [11:0] nxt_counter;
	reg we_a;
	reg re_a;
	reg w_incom;	//Permite saber quando uma read está prestes a ocorrer
	
	//Registrador de tempo
	//reg [11:0] counter;
	

	//TODO: Substituir initial por uma entrada Reset
	initial nxt_state = ST_POW1;
	initial cur_state = ST_POW1;
	initial nxt_counter = RESET;
	initial counter = RESET;
	initial we_a =  'b0;
	initial re_a = 'b0;
	initial w_incom = 'b0;
	initial w_ready = 'b0;
	initial input_wait = 'b1;
	
	always @(posedge clk) //Troca de estados ocorre apenas na subida de clock
	begin
		counter <= nxt_counter;
		cur_state <= nxt_state;
		we_a <= we;
		re_a <= re;
	end
		
	always @(cur_state or counter or we_a or re_a) //Incrementa contador e envia comandos apenas ao atualizar estado atual
	begin //begin the procedural statements
			case (cur_state)//variables that affect the procedure  
			default:
				begin
				command <= CMD_NOP;
				nxt_counter <= counter;
				nxt_state <= ST_REF;
				input_wait <= 'b1;
				end
			ST_POW1:
				begin
				command <= CMD_NOP;													//Executa NOP
				nxt_counter <= (counter == PWRC ? RESET : counter);				//Reinicia Counter se PWRC for atingido
				nxt_state <= (counter == PWRC ? ST_INIT1 : ST_POW2);				//Vai para ST_INIT1 se PWRC for atingido. SenÃ£o, vai para prÃ³ximo estado
				input_wait <= (counter == PWRC ? 'b0 : 'b1);
				end
			ST_POW2:
				begin
				command <= CMD_NOP;													//Executa NOP
				nxt_counter <= counter;
				nxt_state <= ST_POW3;													//Vai para prÃ³ximo estado
				input_wait <= 'b1;
				end
			ST_POW3:
				begin
				command <= CMD_NOP;													//Executa NOP
				nxt_counter <= counter + 1'd1;														//Incrementa Contador
				nxt_state <= ST_POW1;													//Volta para o primeiro estado
				input_wait <= 'b1;
				end
			ST_INIT1:
				begin
				command <= (counter == INTC ? CMD_MRS : CMD_REF);			//Executa MRS se INTC for atingido. SenÃ£o, executa REF
				nxt_counter <= (counter == INTC ? RESET : counter);					//Reinicia Counter se INTC for atingido
				nxt_state <= (counter == INTC ? ST_IDLE : ST_INIT2);		//Vai para ST_IDLE se INTC for atingido. SenÃ£o vai para o prÃ³ximo estado
				input_wait = 'b1;
				end
			ST_INIT2:
				begin
				command <= CMD_NOP;													//Executa NOP
				nxt_counter <= counter;
				nxt_state <= ST_INIT3;												//Vai para o prÃ³ximo estado
				input_wait = 'b1;
				end
			ST_INIT3:
				begin
				command <= CMD_NOP;													//Executa NOP
				nxt_counter <= counter + 1'b1;												//Incrementa Contador
				nxt_state <= ST_INIT1;												//Volta para o primeiro estado
				input_wait = 'b1;
				end
			ST_IDLE:
				begin
				//Executa REF se REFC for atingido. SenÃ£o, executa ACT se re ou we. SenÃ£o, executa NOP
				command <= (counter == REFC ? CMD_REF : (we | re ? CMD_ACT : CMD_NOP)); 
				nxt_counter <= (counter == INTC ? RESET : counter);					//Reinicia Counter se INTC for atingido
				//Vai para IDLE se INTC for atingido. SenÃ£o, vai para WRITE se we. SenÃ£o, vai para READ se re. SenÃ£o, vai para NOP1
				nxt_state <= (counter == REFC ? ST_REF : (we ? ST_WRITE : (re ? ST_READ : ST_NOP1))); 
				w_ready <= we;
				input_wait = 'b0;
				end
			ST_READ:
				begin
				command <= CMD_READ;													//Executa Read
				nxt_counter <= counter;
				nxt_state <= ST_PRE;													//Vai para PrÃ©-Carga
				input_wait = 'b1;
				end
			ST_WRITE:
				begin
				command <= CMD_WRIT;													//Executa Write
				nxt_counter <= counter;
				nxt_state <= ST_PRE;													//Vai para PrÃ©-Carga
				input_wait = 'b1;
				end
			ST_PRE:
				begin
				command <= CMD_PRE;													//Executa PrÃ©-Carga
				nxt_counter <= counter + 1'b1;									//Incrementa Contador
				nxt_state <= ST_IDLE;												//Volta para o estado IDLE
				w_ready <= we;
				input_wait = 'b1;
				end
			ST_REF:
				begin
				command <= CMD_NOP;													//Executa NOP
				nxt_counter <= counter;
				nxt_state <= ST_NOP2;												//Vai para o prÃ³ximo estado
				input_wait = 'b1;
				end
			ST_NOP1:
				begin
				//Deveria ser um NOP, mas gostaria de garantir que todos os bancos estejam prÃ©-carregados antes de realizar um refresh.
				//Desta forma consigo executar REF sem problemas mais tarde.
				command <= CMD_PALL;													
				nxt_counter <= counter;
				nxt_state <= ST_NOP2;												//Vai para o prÃ³ximo estado
				input_wait = 'b1;
				end
			ST_NOP2:
				begin
				command <= CMD_NOP;													//Executa NOP
				nxt_counter <= counter + 1'b1;									//Incrementa Contador
				nxt_state <= ST_IDLE;												//Volta para o estado IDLE
				input_wait = 'b1;
				end
			endcase
		end
endmodule
