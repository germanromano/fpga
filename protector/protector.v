`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:08:12 06/20/2015 
// Design Name: 
// Module Name:    protector 
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
module protector(
	input wire clk, reset,
	input wire [7:0] ps2_data,
	input wire ps2_new_data,
	output wire on_out, off_out
	);
	
	//TO DO: ASIGNAR UN LED A CADA ESTADO
	
	// symbolic state declaration
	localparam [2:0]
		off_0d = 3'b000,
		off_1d = 3'b001,
		off_2d = 3'b010,
		off_3d = 3'b011,
		on_0d = 3'b100,
		on_1d = 3'b101,
		on_2d = 3'b110,
		on_3d = 3'b111;
	
	//password = 5563
	localparam [31:0] password = 32'b01110011011100110111010001111010;
	
	// signal declaration
	reg [2:0] state_reg, state_next;
	reg on_reg, on_next, off_reg, off_next;
	reg [7:0] digit1, digit2, digit3, digit4;
	
	// body
	// FSMD state & data registers
	always @ (posedge clk , posedge reset)
		if (reset)
			begin
				state_reg <= off_0d;
				on_reg <= 1'b0;
				off_reg <= 1'b1;
			end
		else
			begin
				state_reg <= state_next;
				on_reg <= on_next;
				off_reg <= off_next;
			end
	
	// FSMD next-state logic
	always @*
	begin
		state_next = state_reg;
		on_next = on_reg;
		off_next = off_reg;
		
		case (state_reg)
		
			on_0d:
				begin
				if(ps2_new_data)
					begin
					digit1 = ps2_data; //Cuando toma el dato de ps2_data => Gated clock
					state_next = on_1d;
					end
				else state_next = on_0d;
				on_next = 1'b1;
				off_next = 1'b0;
				end
				
			on_1d:
				begin
				if(ps2_new_data)
					begin
					digit2 = ps2_data;
					state_next = on_2d;
					end
				else state_next = on_1d;
				on_next = 1'b1;
				off_next = 1'b0;
				end
				
			on_2d:
				begin
				if(ps2_new_data)
					begin
					digit3 = ps2_data;
					state_next = on_3d;
					end
				else state_next = on_2d;
				on_next = 1'b1;
				off_next = 1'b0;
				end
				
			on_3d:
				begin
				if(ps2_new_data)
					begin
					digit4 = ps2_data;
					if({digit1,digit2,digit3,digit4} == password)
						begin
						state_next = off_0d;
						on_next = 1'b0;
						off_next = 1'b1;
						end
					else
						begin
						state_next = on_0d;
						on_next = 1'b1;
						off_next = 1'b0;
						end
					end
				else
					begin
					state_next = on_3d;
					on_next = 1'b1;
					off_next = 1'b0;
					end
				end

			off_0d:
				begin
				if(ps2_new_data)
					begin
					digit1 = ps2_data;
					state_next = off_1d;
					end
				else state_next = off_0d;
				on_next = 1'b0;
				off_next = 1'b1;
				end
								
			off_1d:
				begin
				if(ps2_new_data)
					begin
					digit2 = ps2_data;
					state_next = off_2d;
					end
				else state_next = off_1d;
				on_next = 1'b0;
				off_next = 1'b1;
				end
				
			off_2d:
				begin
				if(ps2_new_data)
					begin
					digit3 = ps2_data;
					state_next = off_3d;
					end
				else state_next = off_2d;
				on_next = 1'b0;
				off_next = 1'b1;
				end
				
			off_3d:
				begin
				if(ps2_new_data)
					begin
					digit4 = ps2_data;
					if({digit1,digit2,digit3,digit4} == password)
						begin
						state_next = on_0d;
						on_next = 1'b1;
						off_next = 1'b0;
						end
					else
						begin
						state_next = off_0d;
						on_next = 1'b0;
						off_next = 1'b1;
						end
					end
				else
					begin
					state_next = off_3d;
					on_next = 1'b0;
					off_next = 1'b1;
					end
				end
				
			default:
				begin
				state_next = off_0d;
				on_next = 1'b0;
				off_next = 1'b1;
				end
		endcase
	end
	
	//output
	assign on_out = on_reg;
	assign off_out = off_reg;
	
endmodule