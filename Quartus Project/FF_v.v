module FF_v (input clk,
				 input [32:0] D,
				 output reg [32:0] Q);
	always@ (posedge clk) begin
		Q <= D;
	end
endmodule