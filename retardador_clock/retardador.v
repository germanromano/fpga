`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:39:44 06/26/2015 
// Design Name: 
// Module Name:    retardador 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: reduce la frecuencia de Clock a la mitad.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module retardador(
	input wire clk, reset,
	output wire out_clk
    );

	// symbolic state declaration
	localparam 
		high = 1'b1,
		low	= 1'b0;
	
	// signal declaration	
	reg state_reg, state_next;

	// body
	// FSMD state & data registers
	always @ (posedge clk, posedge reset)
		if(reset)
			state_reg <= high;
		else
			state_reg <= state_next;
			
	// FSMD next-state logic
	always @*
	begin
		state_next = state_reg ;
		
		case (state_reg)
			high:
				state_next = low;
			low:
				state_next = high;
				
			default: state_next = low;
		endcase
	end
	
	//output
	assign out_clk = state_reg;
	
endmodule
