module Teste_1(
	// Sistema -> Controlador
	input 				clk,					//  clock - Velocidade de 100MHz ou 130MHz
	input					rst,
	input					memory_accepts_input,
	input					memory_results_ready,
	input		[15:0]	mem_out,
	input			[2:0]	check_read,
	input					start,
	
	output reg [21:0]	addr_reg,
	output reg [15:0]	data_reg,
	output     [7:0]	error,
	output reg [7:0]	tested,
	output 	  [15:0]	read_value,
	output reg 			we,
	output reg 			oe,
	output reg			finish
	
);
reg old_input;
reg [2:0] step, prev_step;
reg [1:0] phase;
wire [21:0] test_addrs[7:0];
wire [15:0] test_data[7:0];
reg  [15:0] read_value_r[7:0];
reg [3:0] i;
/*
assign test_addrs[0] = 22'h000000;
assign test_addrs[1] = 22'h111111;
assign test_addrs[2] = 22'h222222;
assign test_addrs[3] = 22'h333333;
assign test_addrs[4] = 22'h444444;
assign test_addrs[5] = 22'h555555;
assign test_addrs[6] = 22'h666666;
assign test_addrs[7] = 22'h777777;
*/

assign test_addrs[0] = 22'h000002;
assign test_addrs[1] = 22'h000012;
assign test_addrs[2] = 22'h000022;
assign test_addrs[3] = 22'h000032;
assign test_addrs[4] = 22'h000042;
assign test_addrs[5] = 22'h000052;
assign test_addrs[6] = 22'h000062;
assign test_addrs[7] = 22'h000072;

assign test_data[0] = 16'h11C1;
assign test_data[1] = 16'hAACA;
assign test_data[2] = 16'h55C5;
assign test_data[3] = 16'h77C7;
assign test_data[4] = 16'hEECE;
assign test_data[5] = 16'hBBCB;
assign test_data[6] = 16'h88C8;
assign test_data[7] = 16'hFFCF;


assign read_value = read_value_r[check_read];

assign error[0] = read_value_r[0] == test_data[0];
assign error[1] = read_value_r[1] == test_data[1];
assign error[2] = read_value_r[2] == test_data[2];
assign error[3] = read_value_r[3] == test_data[3];
assign error[4] = read_value_r[4] == test_data[4];
assign error[5] = read_value_r[5] == test_data[5];
assign error[6] = read_value_r[6] == test_data[6];
assign error[7] = read_value_r[7] == test_data[7];

always @(posedge clk)
begin
	if (!rst) 
	begin
		phase <= 0;
		finish <= 'b0;
		step <= 0;
		prev_step <= 0;
		old_input <= 0;
		we <= 0;
		oe <= 0;
		for(i='b0; i<8; i=i+1) begin
			read_value_r[i] <= 16'hFFFF;
			tested[i] <= 'b0;
		end
	end
	else
	begin
		old_input <= memory_accepts_input;
		if (memory_accepts_input && !old_input) begin
			case (phase)
			2'd0:
				begin
				phase <= start ? phase + 'b1 : phase;
				we <= 1;
				oe <= 1;
				end
			2'd1:
				begin
				addr_reg <= test_addrs[step];
				data_reg <= test_data[step];
				we <= 1;
				phase <= step == 'b111 ? phase + 'b1 : phase;
				step <= step + 1'd1;
				end
			2'd2:
				begin
				addr_reg <= test_addrs[step];
				we <= 0;
				phase <= step == 'b111 ? phase + 'b1 : phase;
				step <= step + 1'd1;
				end
			2'd3:
				begin
				finish <= 'b1;
				end
		endcase
		end
		if (memory_results_ready && phase > 2'd1 && !finish) begin
				read_value_r[prev_step] <= mem_out;
				tested[prev_step] <= 'b1;
				prev_step <= prev_step + 1'd1;
		end
	end
end
endmodule