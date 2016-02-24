`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:49:51 07/08/2015
// Design Name:   debounce_new_data
// Module Name:   C:/Users/gromano.AD/gromano-personal/FPGA/proyecto/protector/debounce_test.v
// Project Name:  protector
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: debounce_new_data
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module debounce_test;

	localparam T=20; //clock period

	// Inputs
	reg clk;
	reg reset;
	reg in;

	// Outputs
	wire out;

	// Instantiate the Unit Under Test (UUT)
	debounce_new_data uut (
		.clk(clk), 
		.reset(reset), 
		.in(in), 
		.out(out)
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
		// Initialize Inputs
		in = 0;
		
		#(T*4);
		in = 1;
		
		#(T*2);
		in = 0;
		
		#(T*2);
		in = 1;
		
		#T;
		in = 0;
		
		#(T*10);
		in = 1;
		
		#(T*2);
		in = 0;
		
		#T;
		in = 1;
		
		#T;
		in = 0;
		
		#(T*10);
		
/*		@(posedge ready);
		@(posedge clk);*/
		
		$stop;

	end
      
endmodule

