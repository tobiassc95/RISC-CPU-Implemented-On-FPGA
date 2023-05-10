module MUXK_v (input sel,
					input [15:0] D0,
					input [15:0] K,
					output reg [15:0] Q);
	//reg [15:0] temp;
	always@(D0 or K or sel) begin
		if(sel)
			Q <= K & 16'h01ff;
		else
			Q <= D0;
	end
endmodule