module LATCH_v (input en,
					 input [15:0] D,
					 output reg [15:0] Q);
	//reg [15:0] temp;
	always@(en or D) begin
		if(en)
			Q <= D;
	end
endmodule

//module FLIPFLOP_v (input clk, input [15:0] in, output reg [15:0] out);
//	//reg [15:0] temp;
//	always@(posedge clk) begin
//		out = in;
//	end
//endmodule