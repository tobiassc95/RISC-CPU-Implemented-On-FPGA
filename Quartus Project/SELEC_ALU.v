module SELEC_ALU (input [3:0] op, 
				  input [15:0] A, B, RES_ADD_SUB, RES_AND, RES_OR, RES_NOT_A, RES_DIV, RES_MOD, RES_XOR,
				  input [31:0] RES_MULT,
				  input RES_SETC,RES_CLRC, OVERFLOW, CIN,
				  output reg signed [15:0] C,
				  output reg ADD_SUB, 
				  output reg [3:0] CCR);

	parameter NOPA = 4'b0000,
				 NOPB = 4'b0001,
				 NOTA = 4'b0010,
				 AND = 4'b0011, 						
				 OR = 4'b0100,
				 XOR = 4'b0101,
				 ADD = 4'b0110,
				 SUB = 4'b0111, 
				 MUL = 4'b1000,
				 DIV = 4'b1001,
				 MOD = 4'b1010,
				 CLRC = 4'b1011,
				 SETC = 4'b1100;

	always@ (A, B, op) begin
		CCR = 0;
		case (op)
		   NOPA: C <= A;
		   NOPB: C <= B;
			NOTA: C <= RES_NOT_A;
			AND : C <= RES_AND;
			OR : C <= RES_OR;
			XOR : C <= RES_XOR;
			ADD : begin 
				ADD_SUB <= 1;
				C <= RES_ADD_SUB;
				CCR = (CCR | CIN);
				CCR =  CCR | ( OVERFLOW << 1 );
			end
			SUB : begin
				ADD_SUB <= 0;
				C <= RES_ADD_SUB;
				CCR = (CCR | CIN);
				CCR =  CCR | ( OVERFLOW << 1 );
			end
			MUL : begin
				C <=  16'b1111111111111111 & RES_MULT;
			end
			DIV : C <= RES_DIV;
		   MOD : C <= RES_MOD;
		   CLRC: CCR = (CCR & RES_CLRC);
			SETC: CCR = (CCR | RES_SETC);
			default : C <= 0;
		endcase	
		if(C == 0)
			CCR = CCR | 4'b0100;
		else if(C < 0)
			CCR = CCR | 4'b1000;
	end
endmodule