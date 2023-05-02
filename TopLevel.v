
module dec7seg (input [3:0] ent, output reg [7:0] leds);

always@(ent)
begin
	case(ent)
		4'd0: leds <= 8'b01000000 ;
		4'd1: leds <= 8'b01111001 ;
		4'd2: leds <= 8'b00100100 ;
		4'd3: leds <= 8'b00110000 ;
		4'd4: leds <= 8'b00011001 ;
		4'd5: leds <= 8'b00010010 ;
		4'd6: leds <= 8'b00000010 ;
		4'd7: leds <= 8'b01111000 ;
		4'd8: leds <= 8'b00000000 ;
		4'd9: leds <= 8'b00010000 ;
		4'd10: leds <= 8'b00001000 ; //a
		4'd11: leds <= 8'b00000011 ; //b
		4'd12: leds <= 8'b01000110 ; //c
		4'd13: leds <= 8'b00100001 ; //d
		4'd14: leds <= 8'b00000110 ; //e
		4'd15: leds <= 8'b00001110 ; //f
	endcase
end
endmodule










module TopLevel (
	input [17:0] SW, // toggle switches
	input [3:0] KEY, // Keys
	input CLOCK_27,
	
	// LEDS
	output [17:0] LEDR, // red LEDs
	output [8:0] LEDG, // green LEDs
	
	// 7-Segment Displays
	output [7:0] HEX0, 
	output [7:0] HEX1,
	output [7:0] HEX2,
	output [7:0] HEX3,
	output [7:0] HEX4,
	output [7:0] HEX5,
	output [7:0] HEX6,
	output [7:0] HEX7,
	
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
	
	wire controller_clk;
	
	reg [21:0]	addr_in_r;
	reg [15:0]	data_in_r;
	reg			we_in_r;
	reg [1:0]	be_n;
	
	wire 			rst_n;
	assign		rst_n	= KEY[3];
	
	reg [2:0]	check_read;
	wire [15:0]	data_in, data_test, read_value;
	wire			we_in, we_test;
	wire [21:0]	addr_in, addr_test;
	wire [7:0]	error, tested;
	wire 			finish;
	wire			start;
	assign		data_in	= SW[17:16] == 2'd2 ? data_test : data_in_r;
	assign		addr_in	= SW[17:16] == 2'd2 ? addr_test : addr_in_r;
	assign		we_in		= SW[17:16] == 2'd2 ? we_test	  : we_in_r;
	assign		start		= ~KEY[1] && SW[17:16] == 2'd2;
	
	wire [15:0] data_out;
	wire [31:0] counter_out;
	wire 			valid_out; 
	wire 			busy_out;
	

	
	
	// =========================================================================================
	// =================================== ASSIGNMENTS =========================================
	// =========================================================================================
	
	wire [1:0] dqm;
	wire [1:0] dram_ba;
	
	assign DRAM_CKE = 1'b1;
	assign DRAM_CS_N = 1'b0;
	
	assign DRAM_LDQM = dqm[0];
	assign DRAM_UDQM = dqm[1];
	
	assign DRAM_BA_0 = dram_ba[0];
	assign DRAM_BA_1 = dram_ba[1];
	
	
	core_one c (
	// Sistema --> Controlador
	.clk			(controller_clk),					//  clock - Velocidade de 100MHz ou 130MHz
	.rst_n		(rst_n),				//  Inicializa a memória
	//.az_cs		(1'b1),					//  chip enable
	.az_wr_n 	(~we_in), 				//  write op
	.az_be_n 	(be_n),				//  byte enable mask
	.az_addr 	(addr_in),				//  endereço da requisição
	.az_data 	(data_in),				//  dados da requisição

	// Controlador --> Sistema
	.za_valid	(valid_out),			//  ????  
	.za_wait		(busy_out),	//  Sinaliza que a memória está ocupada
	.za_data		(data_out),				//  Output de dados

	// Controlador --> Memória
	.zs_addr 	(DRAM_ADDR),				//  Barramento de endereços de linha/coluna
	.zs_ba		(dram_ba),					//  Bank Access - Especificador de banco
	.zs_dqm		(dqm),					//  Máscara de dados para uso de endereços de 8 bits
	//.zs_cke		(DRAM_CKE),					//  Clock Enable p/ memória
	//.zs_cs_n		(DRAM_CS_N),				//  Chip Select p/ memória
	.zs_ras_n	(DRAM_RAS_N),				//  Sinal seletor de linha
	.zs_cas_n	(DRAM_CAS_N),				//  Sinal seletor de coluna
	.zs_we_n		(DRAM_WE_N),				//  Habilitador de Escrita

	// Controlador <-> Memória
	.zs_dq		(DRAM_DQ),				//  Barramento único de dados. Nunca pode ser Reg.
	
	// Sinais de depuração
	.counter		(counter_out)
	);

	
	/**
	qsys_teste_new_sdram_controller_0 new_sdram_controller_0 (
		.clk            (controller_clk),                         //   clk.clk
		.reset_n        (KEY[3]), // reset.reset_n
		.az_addr        (22'b0),                                //    s1.address
		.az_be_n        (2'b0),                                //      .byteenable_n
		.az_cs          (1'b1),                                //      .chipselect
		.az_data        (data_in),                                //      .writedata
		.az_rd_n        (we),                                //      .read_n
		.az_wr_n        (~we),                                //      .write_n
		.za_data        (za_data),                                //      .readdata
		.za_valid       (valid),                                //      .readdatavalid
		.za_waitrequest (busy),                                //      .waitrequest
		.zs_addr        (DRAM_ADDR),                                //  wire.export
		//.zs_ba          (dram_ba),                                //      .export
		.zs_cas_n       (DRAM_CAS_N),                                //      .export
		//.zs_cke         (DRAM_CKE),                                //      .export
		//.zs_cs_n        (DRAM_CS_N),                                //      .export
		.zs_dq          (DRAM_DQ),                                //      .export
		.zs_dqm         (dqm),                                //      .export
		.zs_ras_n       (DRAM_RAS_N),                                //      .export
		.zs_we_n        (DRAM_WE_N)                                 //      .export
	);
	**/
	
	apll a (
	.inclk0 (CLOCK_27),
	.c0 (DRAM_CLK),					//27 MHz -6 ns
	.c1 (controller_clk));			//27 MHz
	
	
	//------------------------------------------------------
	//--------------- INPUT REGISTER UPDATE ----------------
	//------------------------------------------------------
	

	//wire [1:0]	be_n;
	
	Teste_1 t1 (
	.clk							(controller_clk), 
	.rst							(rst_n),
	.start						(start),
	.memory_accepts_input	(~busy_out),
	.memory_results_ready	(valid_out),
	.mem_out						(data_out),
	.check_read					(check_read),
	.addr_reg					(addr_test),
	.data_reg					(data_test),
	.read_value					(read_value),
	.we							(we_test),
	.tested						(tested),
	.error						(error),
	.finish						(finish)
	);
	
	
	
	always @(negedge busy_out) // Sempre que o controlador indicar que a memória não está mais ocupada.
	begin
		if (!KEY[2]) begin
			case(SW[17:16])
				0:
				begin
					if (!SW[14]) begin
						data_in_r[7:0] <= SW[7:0];
					end
					else
					begin
						data_in_r[15:8] <= SW[7:0];
					end
					be_n <= SW[12:11];
					we_in_r <= SW[13];
				end
				1:
				begin
					if (!SW[14]) begin
						addr_in_r[10:0] <= SW[10:0];
					end
					else
					begin
						addr_in_r[21:11] <= SW[10:0];
					end
					be_n <= SW[12:11];
					we_in_r <= SW[13];
				end
				2:
				begin
						check_read <= SW[2:0];
				end
				default:
				begin
					addr_in_r <= SW[14:8];
					data_in_r <= SW[7:0];
					we_in_r <= SW[15];
				end
			endcase
		end
	end
	
	//------------------------------------------------------
	//------------------- VISUALIZAÇÃO ---------------------
	//------------------------------------------------------
	
	assign LEDG[8] = finish;
	
	assign LEDG [7] = valid_out;
	assign LEDG [6] = busy_out;
	assign LEDG [2] = we_in;
	assign LEDG [1:0] = be_n;
	
	assign LEDR	[2:0] = check_read;
	//assign LEDR [7:0]	= error;
	//assign LEDR [15:8] = tested;
	assign LEDR [17:16] = SW[17:16];
	
	reg [3:0] hex_in[7:0];
	
	//Valores entrando na memória em um write
	dec7seg h7 (hex_in[7], HEX7);
	dec7seg h6 (hex_in[6], HEX6);
	dec7seg h5 (hex_in[5], HEX5);
	dec7seg h4 (hex_in[4], HEX4);
	dec7seg h3 (hex_in[3], HEX3);
	dec7seg h2 (hex_in[2], HEX2);
	dec7seg h1 (hex_in[1], HEX1);
	dec7seg h0 (hex_in[0], HEX0);
	
	always @* begin
		case(SW[17:16])
		0:
			begin
			hex_in[7] <= data_in[15:12];
			hex_in[6] <= data_in[11:8];
			hex_in[5] <= data_in[7:4];
			hex_in[4] <= data_in[3:0];
			
			hex_in[3] <= data_out[15:12];
			hex_in[2] <= data_out[11:8];
			hex_in[1] <= data_out[7:4];
			hex_in[0] <= data_out[3:0];
			end
			
		1:
			begin
			hex_in[7] <= 'b0;
			hex_in[6] <= 'b0;
			
			hex_in[5] <= {2'b0, addr_in[21:20]};
			hex_in[4] <= addr_in[19:16];
			hex_in[3] <= addr_in[15:12];
			hex_in[2] <= addr_in[11:8];
			hex_in[1] <= addr_in[7:4];
			hex_in[0] <= addr_in[3:0];
			end
			
		2:
			begin
			//hex_in[7] <= 'b0;
			//hex_in[6] <= DRAM_ADDR[11:8];
			//hex_in[5] <= DRAM_ADDR[7:4];
			//hex_in[4] <= DRAM_ADDR[3:0];
			
			hex_in[7] <= read_value[15:12];
			hex_in[6] <= read_value[11:8];
			hex_in[5] <= read_value[7:4];
			hex_in[4] <= read_value[3:0];
			
			hex_in[3] <= 'b0;
			hex_in[2] <= counter_out[11:8];
			hex_in[1] <= counter_out[7:4];
			hex_in[0] <= counter_out[3:0];
			end
			
		default:
			begin
			hex_in[7] <= addr_in[15:12];
			hex_in[6] <= addr_in[11:8];
			hex_in[5] <= addr_in[7:4];
			hex_in[4] <= addr_in[3:0];
			
			hex_in[3] <= DRAM_DQ[15:12];
			hex_in[2] <= DRAM_DQ[11:8];
			hex_in[1] <= DRAM_DQ[7:4];
			hex_in[0] <= DRAM_DQ[3:0];
			end
		endcase
	end
endmodule
