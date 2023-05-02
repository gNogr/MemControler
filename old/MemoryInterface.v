// Desabstração de comandos sendo enviados para memória
module memory_interface (

	input		[3:0]		command,
	input		[11:0]		mrs,
	input		[21:0]		addr_in,
	input		[1:0]			be_in,
	
	output reg	[11:0]		addr_out,
	output reg	[1:0] 		ba_out,				//  Bank Access - Especificador de banco
	output reg	[1:0] 		dqm,				//  Máscara de dados para uso de endereços de 8 bits
	output 				cke,				//  Clock Enable p/ memória
	output 				cs_n,				//  Chip Select p/ memória
	output 				ras_n,				//  Sinal seletor de linha
	output 				cas_n,				//  Sinal seletor de coluna
	output 				we_n				//  Habilitador de Escrita
	
);

	//Wires importantes
	wire		[1:0]	ba_in		=	addr_in[21:20]; 
	wire		[11:0]	addr_l	=	addr_in[19:8]; 
	wire		[7:0]	addr_c	=	addr_in[7:0];
	
	//Listagem de comandos
	localparam CMD_DESL 			= 4'b0000;		// Device Deselect
	localparam CMD_NOP 			= 4'b0001;		// No Operation / Self Refresh Exit
	localparam CMD_MRS 			= 4'b0010;		// Mode Register Set
	localparam CMD_ACT 			= 4'b0011;		// Bank Activate
	localparam CMD_READ 			= 4'b0100;		// Read
	localparam CMD_READA 		= 4'b0101;		// Read with Auto Precharge
	localparam CMD_WRIT 			= 4'b0110;		// Write
	localparam CMD_WRITA 		= 4'b0111;		// Write with Auto Precharge
	localparam CMD_PRE 			= 4'b1000;		// Precharge Select Bank
	localparam CMD_PALL 			= 4'b1001;		// Precharge All Banks
	localparam CMD_BST 			= 4'b1010;		// Burst Stop
	localparam CMD_REF 			= 4'b1011;		// CBR (Auto) Refresh
	localparam CMD_SELF 			= 4'b1100;		// Self Refresh
	localparam CMD_SUP 			= 4'b1101;		// Suspender / Powe_nr Down	---> Pode causar problemas, já que é o mesmo comando que COM_MRS
	localparam CMD_REC 			= 4'b1110;		// Recuperar / Powe_nr Up		---> Pode causar problemas, já que é o mesmo comando que COM_MRS
	//localparam CMD_SRE			= 4'b1111;		// Não Utilizado. Por default, valores não utilizados são tratados como NOP.
	
	assign cke =     ~(command == CMD_DESL	|| command == CMD_SELF	|| command == CMD_SUP);
	assign cs_n = 		(command == CMD_DESL);
	assign ras_n =   ~(command == CMD_ACT	|| command == CMD_PRE	|| command == CMD_PALL || command == CMD_MRS		|| command == CMD_REF || command == CMD_SELF);
	assign cas_n =	  ~(command == CMD_READ || command == CMD_READA || command == CMD_WRIT || command == CMD_WRITA	|| command == CMD_MRS || command == CMD_REF 	|| command == CMD_SELF);
	assign we_n =		(command == CMD_NOP	|| command == CMD_READ	|| command == CMD_READA|| command == CMD_ACT		|| command == CMD_REF || command == CMD_SELF || command == CMD_SUP);

always @(command or addr_in)
	begin //begin the procedural statements

		case (command)//variables that affect the procedure  
			default: // Cópia de NOP
			begin
				dqm <= 2'b11;
			end
			CMD_NOP: //NOP
			begin
				dqm <= 2'b11;
			end 
			CMD_MRS: //MRS
			begin
				ba_out <= 2'b00;
				addr_out <= mrs; //Deve ser preenchido com o valor passado para setar registradores
			end
			CMD_ACT: //ACT
			begin
				ba_out <= ba_in;
				addr_out <= addr_l;
				dqm <= be_in;
			end
			CMD_READ: //READ
			begin
				ba_out <= ba_in;
				addr_out <= {4'b0000,addr_c};
				dqm <= be_in;
			end
			CMD_READA: //READA
			begin
				ba_out <= ba_in;
				addr_out <= {4'b0100,addr_c};
				dqm <= be_in;
			end
			CMD_WRIT: //WRIT
			begin
				ba_out <= ba_in;
				addr_out <= {4'b0000,addr_c};
				dqm <= be_in;
			end
			CMD_WRITA: //WRITA
			begin
				ba_out <= ba_in;
				addr_out <= {4'b0100,addr_c};
				dqm <= be_in;
			end
			CMD_PRE: //PRE
			begin
				ba_out <= ba_in;
				addr_out <= 12'b000000000000;
				dqm <= 2'b11;
			end
			CMD_PALL: //PALL
			begin
				//ba_out <= 2'b00;
				addr_out <= 12'b010000000000;
				dqm <= 2'b11;
			end
			CMD_REF: //REF
			begin
				ba_out <= 2'b00;
				//addr_out <= 12'b000000000000;
			end
			CMD_SELF: //SELF
			begin
				ba_out <= 2'b00;
				//addr_out <= 12'b000000000000;
			end
			CMD_SUP: //SUP
			begin
				ba_out <= 2'b00;
				addr_out <= 12'b000000000000;
			end
			CMD_REC: //REC
			begin
				ba_out <= 2'b00;
				addr_out <= 12'b000000000000;
			end
		endcase
	end
	
	
	
	/*
	always @(command or addr_in)
	begin //begin the procedural statements

		case (command)//variables that affect the procedure  
			default: // Cópia de NOP
			begin
				cke <= 1;
				cs_n <= 0;
				ras_n <= 1;
				cas_n <= 1;
				we_n <= 1;
				//ba_out <= 2'b00;
				//addr_out <= 12'b000000000000;
				dqm <= 2'b11;
			end
			CMD_DESL: //DESL
			begin
				cke <= 0; //Não precisa ser alto, mas por enquanto o farei alto
				cs_n <= 0;
				ras_n <= 1;
				cas_n <= 1;
				we_n <= 1;
				//ba_out <= 2'b00;
				//addr_out <= 12'b000000000000; //Valor não precisa ser nulo, mas faço isso de qualquer forma
			end
			CMD_NOP: //NOP
			begin
				cke <= 1;
				cs_n <= 0;
				ras_n <= 1;
				cas_n <= 1;
				we_n <= 1;
				//ba_out <= 2'b00;
				//addr_out <= 12'b000000000000;
				dqm <= 2'b11;
			end 
			CMD_MRS: //MRS
			begin
				cke <= 1;
				cs_n <= 0;
				ras_n <= 0;
				cas_n <= 0;
				we_n <= 0;
				ba_out <= 2'b00;
				addr_out <= mrs; //Deve ser preenchido com o valor passado para setar registradores
			end
			CMD_ACT: //ACT
			begin
				cke <= 1;
				cs_n <= 0;
				ras_n <= 0;
				cas_n <= 1;
				we_n <= 1;
				ba_out <= ba_in;
				addr_out <= addr_l;
				dqm <= be_in;
			end
			CMD_READ: //READ
			begin
				cke <= 1;
				cs_n <= 0;
				ras_n <= 1;
				cas_n <= 0;
				we_n <= 1;
				ba_out <= ba_in;
				addr_out <= {4'b0000,addr_c};
				dqm <= be_in;
			end
			CMD_READA: //READA
			begin
				cke <= 1;
				cs_n <= 0;
				ras_n <= 1;
				cas_n <= 0;
				we_n <= 1;
				ba_out <= ba_in;
				addr_out <= {4'b0100,addr_c};
				dqm <= be_in;
			end
			CMD_WRIT: //WRIT
			begin
				cke <= 1;
				cs_n <= 0;
				ras_n <= 1;
				cas_n <= 1;
				we_n <= 0;
				ba_out <= ba_in;
				addr_out <= {4'b0000,addr_c};
				dqm <= be_in;
			end
			CMD_WRITA: //WRITA
			begin
				cke <= 1;
				cs_n <= 0;
				ras_n <= 1;
				cas_n <= 1;
				we_n <= 0;
				ba_out <= ba_in;
				addr_out <= {4'b0100,addr_c};
				dqm <= be_in;
			end
			CMD_PRE: //PRE
			begin
				cke <= 1;
				cs_n <= 0;
				ras_n <= 0;
				cas_n <= 1;
				we_n <= 0;
				ba_out <= ba_in;
				addr_out <= 12'b000000000000;
				dqm <= 2'b11;
			end
			CMD_PALL: //PALL
			begin
				cke <= 1;
				cs_n <= 0;
				ras_n <= 0;
				cas_n <= 1;
				we_n <= 0;
				//ba_out <= 2'b00;
				addr_out <= 12'b010000000000;
				dqm <= 2'b11;
			end 
			CMD_BST: //BST
			begin
				cke <= 1;
				cs_n <= 0;
				ras_n <= 1;
				cas_n <= 1;
				we_n <= 0;
				//ba_out <= 2'b00;
				//addr_out <= 12'b000000000000;
			end
			CMD_REF: //REF
			begin
				cke <= 1;
				cs_n <= 0;
				ras_n <= 0;
				cas_n <= 0;
				we_n <= 1;
				ba_out <= 2'b00;
				//addr_out <= 12'b000000000000;
			end
			CMD_SELF: //SELF
			begin
				cke <= 0; 
				cs_n <= 0;
				ras_n <= 1;
				cas_n <= 1;
				we_n <= 1;
				ba_out <= 2'b00;
				//addr_out <= 12'b000000000000;
			end
			CMD_SUP: //SUP
			begin
				cke <= 0;
				cs_n <= 0;
				ras_n <= 0;
				cas_n <= 0;
				we_n <= 0;
				ba_out <= 2'b00;
				addr_out <= 12'b000000000000;
			end
			CMD_REC: //REC
			begin
				cke <= 1;
				cs_n <= 0;
				ras_n <= 0;
				cas_n <= 0;
				we_n <= 0;
				ba_out <= 2'b00;
				addr_out <= 12'b000000000000;
			end
		endcase
	end
	*/
endmodule
