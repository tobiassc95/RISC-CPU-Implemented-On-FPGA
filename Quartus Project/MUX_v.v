module MUX_v (input sel,
				  input [15:0] D0,
				  input [15:0] D1,
				  output reg [15:0] Q);
	//reg [15:0] temp;
	always@(D0 or D1 or sel) begin
		if(sel)
			Q <= D1;
		else
			Q <= D0;
	end
endmodule