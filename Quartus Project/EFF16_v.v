module EFF16_v (input en,
				    input clk,
				    input [15:0] D,
					 output reg [15:0] Q);
	always@ (posedge clk) begin
		if (en)
			Q <= D;
	end
endmodule