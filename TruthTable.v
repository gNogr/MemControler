// Desabstração de comandos sendo enviados para memória
module command_truth_table (

	input 	[3:0]		command,
	input 	[21:0]	addrin,
	input 	[11:0]	mrs,
	input		[21:0]	addr_in,
	
	output	reg	[11:0]	addr_out,
	output	reg 	[1:0] 	ba_out,				//  Bank Access - Especificador de banco
	output	reg 	[3:0] 	dmq,				//  Máscara de dados para uso de endereços de 8 bits
	output	reg 				cke,				//  Clock Enable p/ memória
	output	reg 				cs,				//  Chip Select p/ memória
	output	reg				ras,				//  Sinal seletor de linha
	output	reg 				cas,				//  Sinal seletor de coluna
	output	reg 				we				//  Habilitador de Escrita
	
);

	//Wires importantes
	wire		[1:0]			ba_in		=	addr_in[21:20]; //Não parece fazer muito sentido para mim levando em conta a tabela verdade dos comandos.
	wire		[8:0]			addr_c	=	addr_in[19:10]; 
	wire		[11:0]		addr_l	=	addr_in[9:0];

	
	//Estados Locais
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
	localparam CMD_SUP 			= 4'b1101;		// Suspender / Power Down	---> Pode causar problemas, já que é o mesmo comando que COM_MRS
	localparam CMD_REC 			= 4'b1110;		// Recuperar / Power Up		---> Pode causar problemas, já que é o mesmo comando que COM_MRS
	//localparam CMD_SRE			= 4'b1111;		// Não Utilizado
	
	always @(command or addrin)
	begin //begin the procedural statements

		case (command)//variables that affect the procedure  
			default: // Cópia de NOP
			begin
				cke = 1;
				cs = 0;
				ras = 1;
				cas = 1;
				we = 1;
				ba_out = 2'b00;
				addr_out = 12'b000000000000;
			end
			CMD_DESL: //DESL
			begin
				cke = 1; //Não precisa ser alto, mas por enquanto o farei alto
				cs = 1;
				ras = 0;
				cas = 0;
				we = 0;
				ba_out = 2'b00;
				addr_out = 12'b000000000000; //Valor não precisa ser nulo, mas faço isso de qualquer forma
			end
			CMD_NOP: //NOP
			begin
				cke = 1;
				cs = 0;
				ras = 1;
				cas = 1;
				we = 1;
				ba_out = 2'b00;
				addr_out = 12'b000000000000;
			end 
			CMD_MRS: //MRS
			begin
				cke = 1;
				cs = 0;
				ras = 0;
				cas = 0;
				we = 0;
				ba_out = 2'b00;
				addr_out = mrs; //Deve ser preenchido com o valor passado para setar registradores
			end
			CMD_ACT: //ACT
			begin
				cke = 1;
				cs = 0;
				ras = 0;
				cas = 1;
				we = 1;
				ba_out = ba_in;
				addr_out = addr_l;
			end
			CMD_READ: //READ
			begin
				cke = 1;
				cs = 0;
				ras = 1;
				cas = 0;
				we = 1;
				ba_out = ba_in;
				addr_out = {4'b0000,addr_c};
			end
			CMD_READA: //READA
			begin
				cke = 1;
				cs = 0;
				ras = 1;
				cas = 0;
				we = 1;
				ba_out = ba_in;
				addr_out = {4'b0100,addr_c};
			end
			CMD_WRIT: //WRIT
			begin
				cke = 1;
				cs = 0;
				ras = 1;
				cas = 1;
				we = 0;
				ba_out = ba_in;
				addr_out = {4'b0000,addr_c};
			end
			CMD_WRITA: //WRITA
			begin
				cke = 1;
				cs = 0;
				ras = 1;
				cas = 1;
				we = 0;
				ba_out = ba_in;
				addr_out = {4'b0100,addr_c};
			end
			CMD_PRE: //PRE
			begin
				cke = 1;
				cs = 0;
				ras = 0;
				cas = 1;
				we = 0;
				ba_out = ba_in;
				addr_out = 12'b000000000000;
			end
			CMD_PALL: //PALL
			begin
				cke = 1;
				cs = 0;
				ras = 0;
				cas = 1;
				we = 0;
				ba_out = 2'b00;
				addr_out = 12'b010000000000;
			end 
			CMD_BST: //BST
			begin
				cke = 1;
				cs = 0;
				ras = 1;
				cas = 1;
				we = 0;
				ba_out = 2'b00;
				addr_out = 12'b000000000000;
			end
			CMD_REF: //REF
			begin
				cke = 1;
				cs = 0;
				ras = 0;
				cas = 0;
				we = 1;
				ba_out = 2'b00;
				addr_out = 12'b000000000000;
			end
			CMD_SELF: //SELF
			begin
				cke = 0; 
				cs = 0;
				ras = 1;
				cas = 1;
				we = 1;
				ba_out = 2'b00;
				addr_out = 12'b000000000000;
			end
			CMD_BST: //SUP
			begin
				cke = 0;
				cs = 0;
				ras = 0;
				cas = 0;
				we = 0;
				ba_out = 2'b00;
				addr_out = 12'b000000000000;
			end
			CMD_REF: //REC
			begin
				cke = 1;
				cs = 0;
				ras = 0;
				cas = 0;
				we = 0;
				ba_out = 2'b00;
				addr_out = 12'b000000000000;
			end
		endcase
	end
endmodule
