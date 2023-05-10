module ELATCH_v (input en,
					 input en_,
					 input [15:0] D,
					 output reg [15:0] Q);
	//reg [15:0] temp;
	always@(en or en_ or D) begin
		if(en & en_)
			Q <= D;
	end
endmodule