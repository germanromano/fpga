`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:56:16 06/26/2015
// Design Name:   retardador
// Module Name:   C:/Users/gromano.AD/gromano-personal/FPGA/proyecto/retardador_clock/retardador_test.v
// Project Name:  retardador
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: retardador
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module retardador_test;

	localparam T=20; //clock period
	
	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire out_clk;

	// Instantiate the Unit Under Test (UUT)
	retardador uut (
		.clk(clk), 
		.reset(reset),
		.out_clk(out_clk)
	);

	// clock
	// 20 ns clock running forever
	always
		begin
		clk = 1'b1;
		#(T/2);
		clk = 1'b0;
		#(T/2);
		end
		
	// reset for the first half cycle
	initial
	begin
		reset = 1'b1; 
		#(T/2);
		reset = 1'b0;
	end

	initial begin

		// Wait 100 ns for global reset to finish
		#100;
		
		$stop;
        
		// Add stimulus here

	end
      
endmodule

