`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:28:02 06/06/2015 
// Design Name: 
// Module Name:    ps2_test 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ps2_test(
	input wire clk, reset, 
	inout wire ps2_clk,
	inout wire ps2_data,
	output wire [7:0] sseg_out,
	output wire [3:0] an_out
    );
	 
	wire [7:0] bin_out;
	wire [3:0] bcd3, bcd2, bcd1, bcd0;
	wire clk_50, ps2_new_data;
	
	retardador retardador_module (.clk(clk), .reset(reset), .out_clk(clk_50));
	
	PS2_Controller PS2_Controller_module (.CLOCK_50(clk_50), .reset(reset),
			.the_command(8'b0), .send_command(1'b0), .PS2_CLK(ps2_clk),
			.PS2_DAT(ps2_data), .command_was_sent(), .error_communication_timed_out(),
			.received_data(bin_out), .received_data_en(ps2_new_data));

	bin2bcd bin2bcd_module (.clk(clk), .reset(reset), .start(ps2_new_data),
									.bin({5'b0, bin_out}), .ready(), .done_tick(), .bcd3(bcd3),
									.bcd2(bcd2), .bcd1(bcd1), .bcd0(bcd0));

	wire[7:0] disp_mux_in0, disp_mux_in1, disp_mux_in2, disp_mux_in3;

	hex_to_sseg hex2sseg_3 (.hex(bcd3), .dp(1'b1), .sseg(disp_mux_in3));

	hex_to_sseg hex2sseg_2 (.hex(bcd2), .dp(1'b1), .sseg(disp_mux_in2));

	hex_to_sseg hex2sseg_1 (.hex(bcd1), .dp(1'b1), .sseg(disp_mux_in1));

	hex_to_sseg hex2sseg_0 (.hex(bcd0), .dp(1'b1), .sseg(disp_mux_in0));

	disp_mux disp_mux_module (.in0(disp_mux_in0), .in1(disp_mux_in1), .in2(disp_mux_in2),
									.in3(disp_mux_in3), .clk(clk), .reset(reset), .sseg(sseg_out),
									.an(an_out));

endmodule
