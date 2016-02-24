`timescale 1ns / 1ps

module display(
	input wire clk, reset,
	input wire [7:0] ps2_data,
	input wire ps2_new_data,
	output wire [3:0] d1, d2, d3, d4
	);
	
	// symbolic state declaration
	localparam [2:0]
		st_0d = 3'b000,
		st_1d = 3'b001,
		st_2d = 3'b010,
		st_3d = 3'b011,
		st_4d = 3'b100; //muestra la clave ingresada durante x ciclos
		
	// number of counter bits 	50MHz:	(2^(N=17) * 20ns = 40ms)
	//									100MHz:	(2^(N=27) * 10ns = 1.3seg)
	localparam N=27;
	
	// signal declaration
	reg [N-1:0] q_reg, q_next;
	reg [2:0] state_reg, state_next;
	reg [3:0] d1_reg, d2_reg, d3_reg, d4_reg;
	reg [3:0] d1_next, d2_next, d3_next, d4_next;
	
	// body
	// fsmd state & data registers
	 always @(posedge clk, posedge reset)
		 if (reset)
			 begin
				 state_reg <= st_0d;
				 q_reg <= 0;
				 d1_reg <= 4'ha;
				 d2_reg <= 4'ha;
				 d3_reg <= 4'ha;
				 d4_reg <= 4'ha;
			 end
		 else
			 begin
				 state_reg <= state_next;
				 q_reg <= q_next;
				 d1_reg <= d1_next;
				 d2_reg <= d2_next;
				 d3_reg <= d3_next;
				 d4_reg <= d4_next;
			 end
			 
// next-state logic & data path functional units/routing
	always @*
	begin
		state_next = state_reg;	// default state: the same
		q_next = q_reg;			  // default q: unchanged
		case (state_reg)
			st_0d: //no se ingresaron dígitos
				begin
				d1_next = 4'ha;
				d2_next = 4'ha;
				d3_next = 4'ha;
				d4_next = 4'ha;
				if (ps2_new_data)
					begin
					case (ps2_data)
						8'b01110000:	d1_next = 4'h0;
						8'b01101001:	d1_next = 4'h1;
						8'b01110010:	d1_next = 4'h2;
						8'b01111010:	d1_next = 4'h3;
						8'b01101011:	d1_next = 4'h4;
						8'b01110011: 	d1_next = 4'h5;
						8'b01110100:	d1_next = 4'h6;
						8'b01101100:	d1_next = 4'h7;
						8'b01110101:	d1_next = 4'h8;
						8'b01111101:	d1_next = 4'h9;
						default: 		d1_next = 4'hb;
					endcase
					state_next = st_1d;
					end
				else state_next = st_0d;
				end
				
			st_1d:
				begin
				d1_next = d1_reg;
				d2_next = d2_reg;
				d3_next = d3_reg;
				d4_next = d4_reg;
				if (ps2_new_data)
					begin
					case (ps2_data)
						8'b01110000:	d2_next = 4'h0;
						8'b01101001:	d2_next = 4'h1;
						8'b01110010:	d2_next = 4'h2;
						8'b01111010:	d2_next = 4'h3;
						8'b01101011:	d2_next = 4'h4;
						8'b01110011: 	d2_next = 4'h5;
						8'b01110100:	d2_next = 4'h6;
						8'b01101100:	d2_next = 4'h7;
						8'b01110101:	d2_next = 4'h8;
						8'b01111101:	d2_next = 4'h9;
						default: 		d2_next = 4'hb;
					endcase
					state_next = st_2d;
					end
				else state_next = st_1d;
				end
				
			st_2d:
				begin
				d1_next = d1_reg;
				d2_next = d2_reg;
				d3_next = d3_reg;
				d4_next = d4_reg;
				if (ps2_new_data)
					begin
					case (ps2_data)
						8'b01110000:	d3_next = 4'h0;
						8'b01101001:	d3_next = 4'h1;
						8'b01110010:	d3_next = 4'h2;
						8'b01111010:	d3_next = 4'h3;
						8'b01101011:	d3_next = 4'h4;
						8'b01110011: 	d3_next = 4'h5;
						8'b01110100:	d3_next = 4'h6;
						8'b01101100:	d3_next = 4'h7;
						8'b01110101:	d3_next = 4'h8;
						8'b01111101:	d3_next = 4'h9;
						default: 		d3_next = 4'hb;
					endcase
					state_next = st_3d;
					end
				else state_next = st_2d;
				end
				
			st_3d:
				begin
				d1_next = d1_reg;
				d2_next = d2_reg;
				d3_next = d3_reg;
				d4_next = d4_reg;
				if (ps2_new_data)
					begin
					case (ps2_data)
						8'b01110000:	d4_next = 4'h0;
						8'b01101001:	d4_next = 4'h1;
						8'b01110010:	d4_next = 4'h2;
						8'b01111010:	d4_next = 4'h3;
						8'b01101011:	d4_next = 4'h4;
						8'b01110011: 	d4_next = 4'h5;
						8'b01110100:	d4_next = 4'h6;
						8'b01101100:	d4_next = 4'h7;
						8'b01110101:	d4_next = 4'h8;
						8'b01111101:	d4_next = 4'h9;
						default: 		d4_next = 4'hb;
					endcase
					state_next = st_4d;
					q_next = {N{1'b1}}; // load 1..1
					end
				else state_next = st_3d;
				end
				
			st_4d:
				begin
				d1_next = d1_reg;
				d2_next = d2_reg;
				d3_next = d3_reg;
				d4_next = d4_reg;
				q_next = q_reg - 1;
				if (q_next == 0)
					state_next = st_0d;
				else state_next = st_4d;
				end
		
			default: state_next = st_0d;
	  endcase
	end
	
	assign d1 = d1_reg;
	assign d2 = d2_reg;
	assign d3 = d3_reg;
	assign d4 = d4_reg;
	
endmodule