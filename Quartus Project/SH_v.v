module SH_v (input [1:0] op, input [15:0] C, output reg [15:0] C_);
//	reg [31:0] temp;
//	parameter NOP = 2'b00,
//				 SHL = 2'b01,
//				 SHR = 2'b10;
	always@ (op or C) begin
		case (op)
			2'b00 : C_ <= C;
			2'b01 : C_ <= C << 1;
			2'b10 : C_ <= C >> 1;
			default : C_ <= C; 
		endcase
	end
endmodule