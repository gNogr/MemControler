// Máquina de estados que acompanha memória e envia comandos
module mem_command_issuer();

	//Registrador de estado
	reg [3:0] cur_state;
	
	//Registrador de tempo
	reg [1:0] counter;

	//Estados Locais
	//Tenho alguns problemas que devo resolver
	localparam ST_IDLE 			= 4'b0000;		// Idle
	localparam ST_ROWA 			= 4'b0001;		// Row Active
	localparam ST_READ 			= 4'b0010;		// Read
	localparam ST_WRIT 			= 4'b0011;		// Write
	localparam ST_READA 			= 4'b0100;		// Read with Auto-Precharge
	localparam ST_WRITA 			= 4'b0101;		// Write with Auto-Precharge
	localparam ST_PRE 			= 4'b0110;		// Precharging
	localparam ST_ROWNG 			= 4'b0111;		// Row Activating
	localparam ST_WREC 			= 4'b1000;		// Write Recovering
	localparam ST_WRECA 			= 4'b1001;		// Write Recovering with Auto-Precharge
	localparam ST_AUTO 			= 4'b1010;		// Auto Refreshing
	localparam ST_MRS 			= 4'b1011;		// Mode Register Setting
	localparam ST_SELF 			= 4'b1100;		// Self-Refreshing
	localparam ST_SRE 			= 4'b1101;		// Self-Refresh Recovery
	localparam ST_PWD				= 4'b1110;		// Power-Down
	//localparam ST_INIT				= 4'b1111;		// Não Utilizado, posso utilizar para fazer sequência de inicialização da memória

	always @(command or addr_in)
	begin //begin the procedural statements
			case (cur_state)//variables that affect the procedure  
			default:
				begin
				end
			ST_IDLE: 
				begin
				// Pode ir para Power Down, Auto-Refresh, Self-Refresh e MRS.
				end
			ST_ROWA:
				begin
				// Pode ir para Read, Write, Read with Precharge, Write with Precharge e Precharge
				end
			ST_READ:
				begin
				// Pode ir para Row Active, Read, Read with Precharge, Write, Write with Precharge, Precharge e Read Suspend
				cur_state = ST_ROWA; // Se não houver nenhuma operação a ser feita, retorna para este estado
				end
			ST_WRIT:
				begin
				// Pode ir para Row Active, Read, Read with Precharge, Write, Write with Precharge, Precharge e Write Suspend
				cur_state = ST_WREC; // Após uma escrita, passa por um período de "Recovery"
				end
			ST_READA:
				begin
				// Pode ir para Precharge e Read Suspend
				cur_state = ST_PRE;  // Se não houver nenhuma outra operação a ser feita, retorna para este estado
				
				end
			ST_WRITA:
				begin
				// Pode ir para Precharge e Write Suspend
				cur_state = ST_PRE;  // Se não houver nenhuma outra operação a ser feita, retorna para este estado
				end
			ST_PRE: 
				begin
				// Estado anterior ao Idle
				cur_state = ST_IDLE; // Volta para Idle após Trp
				end
			ST_ROWNG:
				begin
				// Estado intermediário antes de Row Active
				command = COM_NOP; //NOP é obrigatório
				cur_state = ST_ROWA; //Retorna para Row Active após Trcd
				end
			ST_WREC: 
				begin
				//Estado intermediário após escrita. Pode ir para Write ou para Row Active
				cur_state = ST_ROWA; // Se não houver nenhuma outra operação a ser feita, retorna para este estado após Tdpl
				end
			ST_WRECA:
				begin
				// Estado intermediário de Recuperação
				command = COM_NOP; //NOP é obrigatório
				cur_state = ST_PRE; //Retorna para Precharge após Tdpl
				end
			ST_AUTO:
				begin
				cur_state = ST_IDLE; //Entra em Idle após Trc
				end
			ST_MRS:
				begin
				cur_state = ST_IDLE; //Entra em Idle após 2 posedges de clock
				end
			ST_SELF:
				begin
				end
			ST_SRE:
				begin
				end
			ST_PWD:
				begin
				end
			endcase
		end
endmodule