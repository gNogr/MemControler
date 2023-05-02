module sm(input clk, output reg [1:0] state, output reg [31:0] counter);

endmodule

module 3states(
	input [17:0] SW, // toggle switches
	input [3:0] KEY,
	input CLOCK_27,
	
	output [17:0] LEDR, // red LEDs
	output [8:0] LEDG, // green LEDs
	output [7:0] HEX0, 
	output [7:0] HEX1,
	output [7:0] HEX2,
	output [7:0] HEX3,);

endmodule