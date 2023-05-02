// qsys_teste.v

// Generated using ACDS version 13.0sp1 232 at 2023.03.09.23:05:03

`timescale 1 ps / 1 ps
module qsys_teste (
		input  wire  clk_clk,       //   clk.clk
		input  wire  reset_reset_n  // reset.reset_n
	);

	wire    rst_controller_reset_out_reset; // rst_controller:reset_out -> new_sdram_controller_0:reset_n

	qsys_teste_new_sdram_controller_0 new_sdram_controller_0 (
		.clk            (clk_clk),                         //   clk.clk
		.reset_n        (~rst_controller_reset_out_reset), // reset.reset_n
		.az_addr        (),                                //    s1.address
		.az_be_n        (),                                //      .byteenable_n
		.az_cs          (),                                //      .chipselect
		.az_data        (),                                //      .writedata
		.az_rd_n        (),                                //      .read_n
		.az_wr_n        (),                                //      .write_n
		.za_data        (),                                //      .readdata
		.za_valid       (),                                //      .readdatavalid
		.za_waitrequest (),                                //      .waitrequest
		.zs_addr        (),                                //  wire.export
		.zs_ba          (),                                //      .export
		.zs_cas_n       (),                                //      .export
		.zs_cke         (),                                //      .export
		.zs_cs_n        (),                                //      .export
		.zs_dq          (),                                //      .export
		.zs_dqm         (),                                //      .export
		.zs_ras_n       (),                                //      .export
		.zs_we_n        ()                                 //      .export
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS        (1),
		.OUTPUT_RESET_SYNC_EDGES ("deassert"),
		.SYNC_DEPTH              (2),
		.RESET_REQUEST_PRESENT   (0)
	) rst_controller (
		.reset_in0  (~reset_reset_n),                 // reset_in0.reset
		.clk        (clk_clk),                        //       clk.clk
		.reset_out  (rst_controller_reset_out_reset), // reset_out.reset
		.reset_req  (),                               // (terminated)
		.reset_in1  (1'b0),                           // (terminated)
		.reset_in2  (1'b0),                           // (terminated)
		.reset_in3  (1'b0),                           // (terminated)
		.reset_in4  (1'b0),                           // (terminated)
		.reset_in5  (1'b0),                           // (terminated)
		.reset_in6  (1'b0),                           // (terminated)
		.reset_in7  (1'b0),                           // (terminated)
		.reset_in8  (1'b0),                           // (terminated)
		.reset_in9  (1'b0),                           // (terminated)
		.reset_in10 (1'b0),                           // (terminated)
		.reset_in11 (1'b0),                           // (terminated)
		.reset_in12 (1'b0),                           // (terminated)
		.reset_in13 (1'b0),                           // (terminated)
		.reset_in14 (1'b0),                           // (terminated)
		.reset_in15 (1'b0)                            // (terminated)
	);

endmodule