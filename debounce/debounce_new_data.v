module debounce_new_data
	(
	 input wire clk, reset,
	 input wire in,
	 output reg out
	);
	
	// symbolic state declaration
	localparam [1:0]
				idle  = 2'b00,
				waiting0 = 2'b01,
				waiting1 = 2'b10;
				
	// number of counter bits 	50MHz:	(2^(N=17) * 20ns = 40ms)
	//									100MHz:	(2^(N=26) * 10ns = 0.6seg)
	localparam N=26;
	
	// signal declaration
	reg [N-1:0] q_reg, q_next;
	reg [1:0] state_reg, state_next;
	
	// body
	// fsmd state & data registers
	 always @(posedge clk, posedge reset)
		 if (reset)
			 begin
				 state_reg <= idle;
				 q_reg <= 0;
			 end
		 else
			 begin
				 state_reg <= state_next;
				 q_reg <= q_next;
			 end
		  
// next-state logic & data path functional units/routing
	always @*
	begin
		state_next = state_reg;	// default state: the same
		q_next = q_reg;			  // default q: unchnaged
		out = 1'b0;			  // default output: 0
		case (state_reg)
			idle: //input permanece baja
				begin
				out = 1'b0;
				if (in)
					begin
					state_next = waiting0;
					q_next = {N{1'b1}}; // load 1..1
					end
				end
				
			waiting0: //la salida out se levanta durante un ciclo de clock
				begin
				out = 1'b1;
				state_next = waiting1;
				q_next = q_reg - 1;
				end
				
			waiting1: //se bloquea durante q ciclos de clock
				begin
				out = 1'b0;
				q_next = q_reg - 1;
					if (q_next == 0)
						state_next = idle;
					else state_next = waiting1;
				end
			
			default: state_next = idle;
	  endcase
	end
	
endmodule