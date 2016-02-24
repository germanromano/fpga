`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:05:02 06/24/2015 
// Design Name: 
// Module Name:    interfaz 
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
module interfaz(
	input wire clk, reset, 
	inout wire ps2_clk,
	inout wire ps2_data,
	output wire on_out, off_out,
	output wire [7:0] sseg_out,
	output wire [3:0] an_out
    );
	 
	wire [7:0] ps2_bin_data;
	wire clk_50, ps2_new_data, ps2_new_data_db;
	
	retardador retardador_module (.clk(clk), .reset(reset), .out_clk(clk_50));
	
	PS2_Controller PS2_Controller_module (.CLOCK_50(clk_50), .reset(reset),
			.the_command(8'b0), .send_command(1'b0), .PS2_CLK(ps2_clk),
			.PS2_DAT(ps2_data), .command_was_sent(), .error_communication_timed_out(),
			.received_data(ps2_bin_data), .received_data_en(ps2_new_data));
			
	debounce_new_data debounce_nd_module (.clk(clk), .reset(reset), .in(ps2_new_data),
			.out(ps2_new_data_db));

	protector protector_module (.clk(clk), .reset(reset), .ps2_data(ps2_bin_data),
			.ps2_new_data(ps2_new_data_db), .on_out(on_out), .off_out(off_out));
	
	wire[3:0] digit1, digit2, digit3, digit4;
	
	display display_module(.clk(clk), .reset(reset), .ps2_data(ps2_bin_data),
			.ps2_new_data(ps2_new_data_db), .d1(digit1), .d2(digit2), .d3(digit3),
			.d4(digit4));
			
	wire[7:0] disp_mux_in0, disp_mux_in1, disp_mux_in2, disp_mux_in3;
	
	hex_to_sseg hex2sseg_3 (.hex(digit1), .dp(1'b1), .sseg(disp_mux_in3));

	hex_to_sseg hex2sseg_2 (.hex(digit2), .dp(1'b1), .sseg(disp_mux_in2));

	hex_to_sseg hex2sseg_1 (.hex(digit3), .dp(1'b1), .sseg(disp_mux_in1));

	hex_to_sseg hex2sseg_0 (.hex(digit4), .dp(1'b1), .sseg(disp_mux_in0));

	disp_mux disp_mux_module (.in0(disp_mux_in0), .in1(disp_mux_in1), .in2(disp_mux_in2),
									.in3(disp_mux_in3), .clk(clk), .reset(reset), .sseg(sseg_out),
									.an(an_out));

endmodule