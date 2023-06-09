module ROM_v (input clk,
				  input [15:0] IR, //Instruction.
				  output reg [32:0] MIR); //Memory address.
	reg [32:0] ROM0 [0:6];
	reg [32:0] ROM1 [0:11];
	reg [32:0] ROM2 [0:8];
	reg [32:0] ROM3 [0:10];
	reg [32:0] ROM4 [0:6];
	reg [15:0] temp; ///
	initial begin
		ROM0[0] = 33'b000000000000000000001000110000000; //JMP X
		ROM0[1] = 33'b000000000000000000001000111000000; //JZE X
		ROM0[2] = 33'b000000000000000000001000111000000; //JNE X
		ROM0[3] = 33'b000000000000000000001000111010000; //JCY X
		ROM0[4] = 33'b000000000000010000001000100000010; //MER W,Y
		ROM0[5] = 33'b100010000000100000001000110000001; //MEW Y,W
		ROM0[6] = 33'b000000000000000000001000110000000; //BSR S
		ROM1[0] = 33'b000000000000000001000000000001100; //EQR Ri,Rj //EQR POi,Rj //EQR Ri,PIj //EQR POi,PIj
		ROM1[1] = 33'b100010000000000000000000000001001; //EQR Ri,W //EQR POi,W
		ROM1[2] = 33'b100010000000000011000000000001101; //ANR Ri,Rj
		ROM1[3] = 33'b100010000000000100000000000001101; //ORR Ri,Rj
		ROM1[4] = 33'b100010000000000101000000000001101; //XOR Ri,Rj
		ROM1[5] = 33'b100010000000000110000000000111101; //ADR Ri,Rj
		ROM1[6] = 33'b100010000000000111000000000111101; //SUR Ri,Rj
		ROM1[7] = 33'b100010000000001000000000000001101; //MUR Ri,Rj
		ROM1[8] = 33'b100010000000001001000000000001101; //DIR Ri,Rj
		ROM1[9] = 33'b100010000000001010000000000001101; //MOR Ri,Rj
		ROM1[10] = 33'b100010000000000000010000000001001; //SLR Ri,W
		ROM1[11] = 33'b100010000000000000100000000001001; //SRR Ri,W
		ROM2[0] = 33'b000000000001000001001000100000010; //EQK W,K
		ROM2[1] = 33'b100010000001000011001000100000011; //ANK W,K
		ROM2[2] = 33'b100010000001000100001000100000011; //ORK W,K
		ROM2[3] = 33'b100010000001000101001000100000011; //XOK W,K
		ROM2[4] = 33'b100010000001000110001000100110011; //ADK W,K
		ROM2[5] = 33'b100010000001000111001000100110011; //SUK W,K
		ROM2[6] = 33'b100010000001001000001000100000011; //MUK W,K
		ROM2[7] = 33'b100010000001001001001000100000011; //DIK W,K
		ROM2[8] = 33'b100010000001001010001000100000011; //MOK W,K
		ROM3[0] = 33'b000000000000000001001000100000110; //EQW W,Rj //EQW W,PIj
		ROM3[1] = 33'b100010000000000011001000100000111; //ANW W,Rj
		ROM3[2] = 33'b100010000000000100001000100000111; //ORW W,Rj
		ROM3[3] = 33'b100010000000000101001000100000111; //XOW W,Rj
		ROM3[4] = 33'b100010000000000110001000100110111; //ADW W,Rj
		ROM3[5] = 33'b100010000000000111001000100110111; //SUW W,Rj
		ROM3[6] = 33'b100010000000001000001000100000111; //MUW W,Rj
		ROM3[7] = 33'b100010000000001001001000100000111; //DIW W,Rj
		ROM3[8] = 33'b100010000000001010001000100000111; //MOW W,Rj
		ROM3[9] = 33'b000000000000000001011000100000110; //SLW W,Rj
		ROM3[10] = 33'b000000000000000001101000100000110; //SRW W,Rj
		ROM4[0] = 33'b100010000000000010001000100000011; //NOT W
		ROM4[1] = 33'b100010000000000000011000100000011; //SHL W
		ROM4[2] = 33'b100010000000000000101000100000011; //SHR W
		ROM4[3] = 33'b000000000000001011001000110100000; //CLR CY
		ROM4[4] = 33'b000000000000001100001000110100000; //SET CY
		ROM4[5] = 33'b000000000000000000001000110000000; //RET
		ROM4[6] = 33'b000000000000000000001000110000000; //NOP
	end
	always@ (negedge clk) begin
		temp = IR;
		if (temp < 16'h8000) begin
			temp = temp << 1;
			if (temp < 16'h8000) begin
				temp = temp << 1;
				if (temp < 16'h8000) begin
					temp = temp << 1;
					if (temp < 16'h8000) begin
						temp = temp << 1;
						if (temp < 16'h8000) begin
							MIR <= ROM4[6]; //NOP
						end
						else begin //ROM4
							temp = temp << 1; //get rid of the MSB.
							temp = temp >> 13;
							MIR <= ROM4[temp];
						end
					end
					else begin //ROM3
						temp = temp << 1; //get rid of the MSB.
						temp = temp >> 12;
						MIR = IR & 16'h001f; //get Rj
						MIR = MIR << 22;
						MIR <= MIR | ROM3[temp];
					end
				end
				else begin //ROM2
					temp = temp << 1; //get rid of the MSB.
					temp = temp >> 12;
					MIR <= ROM2[temp];
				end
			end
			else begin //ROM1
				temp = temp << 1; //get rid of the MSB.
				temp = temp >> 12;
				MIR = IR & 16'h001f; //get Rj
				MIR = MIR << 20;
				MIR = MIR | (IR & 16'h03e0); //get Ri
				MIR = MIR << 2;
				MIR <= MIR | ROM1[temp];
			end
		end
		else begin //ROM0
			temp = temp << 1; //get rid of the MSB.
			temp = temp >> 13;
			MIR <= ROM0[temp];
		end
	end
endmodule

//module ROM_v (input clk,
//				  input [15:0] IR, //Instruction.
//				  output reg [32:0] MIR); //Memory address.
//	reg [32:0] ROM0 [0:6];
//	reg [32:0] ROM1 [0:11];
//	reg [32:0] ROM2 [0:8];
//	reg [32:0] ROM3 [0:10];
//	reg [32:0] ROM4 [0:6];
//	reg [15:0] temp; ///
//	reg [33:0] temp_; ///
//	initial begin
//		ROM0[0] = 33'b000000000000000000001000110000000; //JMP X
//		ROM0[1] = 33'b000000000000000000001000111000001; //JZE X
//		ROM0[2] = 33'b000000000000000000001000111000001; //JNE X ///
//		ROM0[3] = 33'b000000000000000000001000111010000; //JCY X
//		ROM0[4] = 33'b000000000000010000001000100000010; //MER W,Y
//		ROM0[5] = 33'b100010000000100000001000110000001; //MEW Y,W
//		ROM0[6] = 33'b000000000000000000001000110000000; //BSR S
//		ROM1[0] = 33'b000000000000000001000000000001100; //EQR Ri,Rj //EQR POi,Rj //EQR Ri,PIj //EQR POi,PIj
//		ROM1[1] = 33'b100010000000000001000000000001001; //EQR Ri,W //EQR POi,W
//		ROM1[2] = 33'b100010000000000100000000000001101; //ANR Ri,Rj
//		ROM1[3] = 33'b100010000000000101000000000001101; //ORR Ri,Rj
//		ROM1[4] = 33'b100010000000000110000000000001101; //XOR Ri,Rj
//		ROM1[5] = 33'b100010000000000111000000000111101; //ADR Ri,Rj
//		ROM1[6] = 33'b100010000000001000000000000111101; //SUR Ri,Rj
//		ROM1[7] = 33'b100010000000001001000000000101101; //MUR Ri,Rj
//		ROM1[8] = 33'b100010000000001010000000000101101; //DIR Ri,Rj
//		ROM1[9] = 33'b100010000000001011000000000101101; //MOR Ri,Rj
//		ROM1[10] = 33'b100010000000000000010000000001001; //SLR Ri,W
//		ROM1[11] = 33'b100010000000000000100000000001001; //SRR Ri,W
//		ROM2[0] = 33'b000000000001000001001000100000010; //EQK W,K
//		ROM2[1] = 33'b100010000001000100001000100000011; //ANK W,K
//		ROM2[2] = 33'b100010000001000101001000100000011; //ORK W,K
//		ROM2[3] = 33'b100010000001000110001000100000011; //XOK W,K
//		ROM2[4] = 33'b100010000001000111001000100110011; //ADK W,K
//		ROM2[5] = 33'b100010000001001000001000100110011; //SUK W,K
//		ROM2[6] = 33'b100010000001001001001000100100011; //MUK W,K
//		ROM2[7] = 33'b100010000001001010001000100100011; //DIK W,K
//		ROM2[8] = 33'b100010000001001011001000100100011; //MOK W,K
//		ROM3[0] = 33'b000000000000000001001000100000110; //EQW W,Rj //EQW W,PIj
//		ROM3[1] = 33'b100010000000000100001000100000111; //ANR W,Rj
//		ROM3[2] = 33'b100010000000000101001000100000111; //ORR W,Rj
//		ROM3[3] = 33'b100010000000000110001000100000111; //XOR W,Rj
//		ROM3[4] = 33'b100010000000000111000000000111101; //ADR Ri,Rj
//		ROM3[5] = 33'b100010000000001000001000100110111; //SUR W,Rj
//		ROM3[6] = 33'b100010000000001001001000100100111; //MUR W,Rj
//		ROM3[7] = 33'b100010000000001010001000100100111; //DIR W,Rj
//		ROM3[8] = 33'b100010000000001011001000100100111; //MOW W,Rj
//		ROM3[9] = 33'b000000000000000001011000100000110; //SLR W,Rj
//		ROM3[10] = 33'b000000000000000001101000100000110; //SRR W,Rj
//		ROM4[0] = 33'b100010000000000010001000100000011; //NOT W
//		ROM4[1] = 33'b100010000000000000011000100000011;	//SHL W
//		ROM4[2] = 33'b100010000000000000101000100000011; //SHR W
//		ROM4[3] = 33'b000000000000001100001000110100000; //CLR CY
//		ROM4[4] = 33'b000000000000001101001000110100000; //SET CY
//		ROM4[5] = 33'b000000000000000000001000110000000; //RET
//		ROM4[6] = 33'b000000000000000000001000110000000; //NOP
//	end
//	always@ (negedge clk) begin
//		temp = IR;
//		temp_ = 0;
//		if (temp < 16'h8000) begin
//			temp = temp << 1;
//			if (temp < 16'h8000) begin
//				temp = temp << 1;
//				if (temp < 16'h8000) begin
//					temp = temp << 1;
//					if (temp < 16'h8000) begin
//						temp = temp << 1;
//						if (temp < 16'h8000) begin
//							MIR <= ROM4[6]; //NOP
//						end
//						else begin //ROM4
//							temp = temp << 1; //get rid of the MSB.
//							temp = temp >> 13;
//							MIR <= ROM4[temp];
//						end
//					end
//					else begin //ROM3
//						temp = temp << 1; //get rid of the MSB.
//						temp = temp >> 12;
//						temp_ = IR & 16'h001f; //get Rj
//						temp_ = temp_ << 22;
//						MIR <= temp_ | ROM3[temp];
//					end
//				end
//				else begin //ROM2
//					temp = temp << 1; //get rid of the MSB.
//					temp = temp >> 12;
//					MIR <= ROM2[temp];
//				end
//			end
//			else begin //ROM1
//				temp = temp << 1; //get rid of the MSB.
//				temp = temp >> 12;
//				temp_ = IR & 16'h001f; //get Rj
//				temp_ = temp_ << 20;
//				temp_ = temp_ | (IR & 16'h03e0); //get Ri
//				temp_ = temp_ << 2;
//				MIR <= temp_ | ROM1[temp];
//			end
//		end
//		else begin //ROM0
//			temp = temp << 1; //get rid of the MSB.
//			temp = temp >> 13;
//			MIR <= ROM0[temp];
//		end
//	end
//endmodule

//module ROM_v (input clk,
//				  input [15:0] IR, //Instruction.
//				  output reg [32:0] MIR); //Memory address.
//	reg [32:0] ROM0 [0:6];
//	reg [32:0] ROM1 [0:11];
//	reg [32:0] ROM2 [0:8];
//	reg [32:0] ROM3 [0:10];
//	reg [32:0] ROM4 [0:6];
//	reg [15:0] temp; ///
//	integer i;
//	initial begin
//		ROM0[0] = 33'b000000000000000000001000110000000; //JMP X
//		ROM0[1] = 33'b000000000000000000001000111000001; //JZE X
//		ROM0[2] = 33'b000000000000000000001000111000001; //JNE X ///
//		ROM0[3] = 33'b000000000000000000001000111010000; //JCY X
//		ROM0[4] = 33'b000000000000010000001000100000010; //MER W,Y
//		ROM0[5] = 33'b100010000000100000001000110000001; //MEW Y,W
//		ROM0[6] = 33'b000000000000000000001000110000000; //BSR S
//		ROM1[0] = 33'b000000000000000001000000000001100; //EQR Ri,Rj //EQR POi,Rj //EQR Ri,PIj //EQR POi,PIj
//		ROM1[1] = 33'b100010000000000001000000000001001; //EQR Ri,W //EQR POi,W
//		ROM1[2] = 33'b100010000000000100000000000001101; //ANR Ri,Rj
//		ROM1[3] = 33'b100010000000000101000000000001101; //ORR Ri,Rj
//		ROM1[4] = 33'b100010000000000110000000000001101; //XOR Ri,Rj
//		ROM1[5] = 33'b100010000000000111000000000111101; //ADR Ri,Rj
//		ROM1[6] = 33'b100010000000001000000000000111101; //SUR Ri,Rj
//		ROM1[7] = 33'b100010000000001001000000000101101; //MUR Ri,Rj
//		ROM1[8] = 33'b100010000000001010000000000101101; //DIR Ri,Rj
//		ROM1[9] = 33'b100010000000001011000000000101101; //MOR Ri,Rj
//		ROM1[10] = 33'b100010000000000000010000000001001; //SLR Ri,W
//		ROM1[11] = 33'b100010000000000000100000000001001; //SRR Ri,W
//		ROM2[0] = 33'b000000000001000001001000100000010; //EQK W,K
//		ROM2[1] = 33'b100010000001000100001000100000011; //ANK W,K
//		ROM2[2] = 33'b100010000001000101001000100000011; //ORK W,K
//		ROM2[3] = 33'b100010000001000110001000100000011; //XOK W,K
//		ROM2[4] = 33'b100010000001000111001000100110011; //ADK W,K
//		ROM2[5] = 33'b100010000001001000001000100110011; //SUK W,K
//		ROM2[6] = 33'b100010000001001001001000100100011; //MUK W,K
//		ROM2[7] = 33'b100010000001001010001000100100011; //DIK W,K
//		ROM2[8] = 33'b100010000001001011001000100100011; //MOK W,K
//		ROM3[0] = 33'b000000000000000001001000100000110; //EQW W,Rj //EQW W,PIj
//		ROM3[1] = 33'b100010000000000100001000100000111; //ANR W,Rj
//		ROM3[2] = 33'b100010000000000101001000100000111; //ORR W,Rj
//		ROM3[3] = 33'b100010000000000110001000100000111; //XOR W,Rj
//		ROM3[4] = 33'b100010000000000111000000000111101; //ADR Ri,Rj
//		ROM3[5] = 33'b100010000000001000001000100110111; //SUR W,Rj
//		ROM3[6] = 33'b100010000000001001001000100100111; //MUR W,Rj
//		ROM3[7] = 33'b100010000000001010001000100100111; //DIR W,Rj
//		ROM3[8] = 33'b100010000000001011001000100100111; //MOW W,Rj
//		ROM3[9] = 33'b000000000000000001011000100000110; //SLR W,Rj
//		ROM3[10] = 33'b000000000000000001101000100000110; //SRR W,Rj
//		ROM4[0] = 33'b100010000000000010001000100000011; //NOT W
//		ROM4[1] = 33'b100010000000000000011000100000011;	//SHL W
//		ROM4[2] = 33'b100010000000000000101000100000011; //SHR W
//		ROM4[3] = 33'b000000000000001100001000110100000; //CLR CY
//		ROM4[4] = 33'b000000000000001101001000110100000; //SET CY
//		ROM4[5] = 33'b000000000000000000001000110000000; //RET
//		ROM4[6] = 33'b000000000000000000001000110000000; //NOP
//	end
//	always@ (negedge clk) begin //always@ (IR) begin
//		if (IR > 0) begin
//			temp = IR;
//			for(i = 0; temp < 16'h8000 && i < 5; i = i + 1) begin
//				temp = temp << 1;
//			end
//			temp = temp << 1; //get rid of the MSB.
//			case (i)
//				0 : begin
//					temp = temp >> 13;
//					MIR <= ROM0[temp];
//				end
//				1 : begin
//					temp = temp >> 12;
//					MIR <= IR & 16'h001f; //get Rj
//					MIR <= MIR << 20;
//					MIR <= MIR | (IR & 16'h03e0); //get Ri
//					MIR <= MIR << 2;
//					MIR <= MIR | ROM1[temp];
//				end
//				2 : begin
//					temp = temp >> 12;
//					MIR <= ROM2[temp];
//				end
//				3 : begin
//					temp = temp >> 12;
//					MIR <= IR & 16'h001f; //get Rj
//					MIR <= MIR << 22;
//					MIR <= MIR | ROM3[temp];
//				end
//				4 : begin
//					temp = temp >> 13;
//					MIR <= ROM4[temp];
//				end
//				default : MIR <= ROM4[5]; //NOP
//			endcase
//		end
//	end
//endmodule

//module ROM_v (input clk,
//				  input [15:0] IR, //Instruction.
//				  output reg [32:0] MIR); //Memory address.
//	reg [32:0] ROM0 [0:6];
//	reg [32:0] ROM1 [0:11];
//	reg [32:0] ROM2 [0:8];
//	reg [32:0] ROM3 [0:10];
//	reg [32:0] ROM4 [0:6];
//	reg [15:0] temp; ///
//	integer i;
//	initial begin
//		ROM0[0] = 33'b000000000000000000001000110000000; //JMP X
//		ROM0[1] = 33'b000000000000000000001000111000001; //JZE X
//		ROM0[2] = 33'b000000000000000000001000111000001; //JNE X ///
//		ROM0[3] = 33'b000000000000000000001000111010000; //JCY X
//		ROM0[4] = 33'b000000000000010000001000100000010; //MER W,Y
//		ROM0[5] = 33'b100010000000100000001000110000001; //MEW Y,W
//		ROM0[6] = 33'b000000000000000000001000110000000; //BSR S
//		ROM1[0] = 33'b000000000000000001000000000001100; //EQR Ri,Rj //EQR POi,Rj //EQR Ri,PIj //EQR POi,PIj
//		ROM1[1] = 33'b100010000000000001000000000001001; //EQR Ri,W //EQR POi,W
//		ROM1[2] = 33'b100010000000000100000000000001101; //ANR Ri,Rj
//		ROM1[3] = 33'b100010000000000101000000000001101; //ORR Ri,Rj
//		ROM1[4] = 33'b100010000000000110000000000001101; //XOR Ri,Rj
//		ROM1[5] = 33'b100010000000000111000000000111101; //ADR Ri,Rj
//		ROM1[6] = 33'b100010000000001000000000000111101; //SUR Ri,Rj
//		ROM1[7] = 33'b100010000000001001000000000101101; //MUR Ri,Rj
//		ROM1[8] = 33'b100010000000001010000000000101101; //DIR Ri,Rj
//		ROM1[9] = 33'b100010000000001011000000000101101; //MOR Ri,Rj
//		ROM1[10] = 33'b100010000000000000010000000001001; //SLR Ri,W
//		ROM1[11] = 33'b100010000000000000100000000001001; //SRR Ri,W
//		ROM2[0] = 33'b000000000001000001001000100000010; //EQK W,K
//		ROM2[1] = 33'b100010000001000100001000100000011; //ANK W,K
//		ROM2[2] = 33'b100010000001000101001000100000011; //ORK W,K
//		ROM2[3] = 33'b100010000001000110001000100000011; //XOK W,K
//		ROM2[4] = 33'b100010000001000111001000100110011; //ADK W,K
//		ROM2[5] = 33'b100010000001001000001000100110011; //SUK W,K
//		ROM2[6] = 33'b100010000001001001001000100100011; //MUK W,K
//		ROM2[7] = 33'b100010000001001010001000100100011; //DIK W,K
//		ROM2[8] = 33'b100010000001001011001000100100011; //MOK W,K
//		ROM3[0] = 33'b000000000000000001001000100000110; //EQW W,Rj //EQW W,PIj
//		ROM3[1] = 33'b100010000000000100001000100000111; //ANR W,Rj
//		ROM3[2] = 33'b100010000000000101001000100000111; //ORR W,Rj
//		ROM3[3] = 33'b100010000000000110001000100000111; //XOR W,Rj
//		ROM3[4] = 33'b100010000000000111000000000111101; //ADR Ri,Rj
//		ROM3[5] = 33'b100010000000001000001000100110111; //SUR W,Rj
//		ROM3[6] = 33'b100010000000001001001000100100111; //MUR W,Rj
//		ROM3[7] = 33'b100010000000001010001000100100111; //DIR W,Rj
//		ROM3[8] = 33'b100010000000001011001000100100111; //MOW W,Rj
//		ROM3[9] = 33'b000000000000000001011000100000110; //SLR W,Rj
//		ROM3[10] = 33'b000000000000000001101000100000110; //SRR W,Rj
//		ROM4[0] = 33'b100010000000000010001000100000011; //NOT W
//		ROM4[1] = 33'b100010000000000000011000100000011;	//SHL W
//		ROM4[2] = 33'b100010000000000000101000100000011; //SHR W
//		ROM4[3] = 33'b000000000000001100001000110100000; //CLR CY
//		ROM4[4] = 33'b000000000000001101001000110100000; //SET CY
//		ROM4[5] = 33'b000000000000000000001000110000000; //RET
//		ROM4[6] = 33'b000000000000000000001000110000000; //NOP
//	end
//	always@ (negedge clk) begin //always@ (IR) begin
//		if (IR > 0) begin
//			temp = IR;
//			for(i = 0; temp < 16'h8000 && i < 5; i = i + 1) begin
//				temp = temp << 1;
//			end
//			temp = temp << 1; //get rid of the MSB.
//			case (i)
//				0 : begin
//					temp = temp >> 13;
//					MIR <= ROM0[temp];
//				end
//				1 : begin
//					temp = temp >> 12;
//					MIR <= IR & 16'h001f; //get Rj
//					MIR <= MIR << 20;
//					MIR <= MIR | (IR & 16'h03e0); //get Ri
//					MIR <= MIR << 2;
//					MIR <= MIR | ROM1[temp];
//				end
//				2 : begin
//					temp = temp >> 12;
//					MIR <= ROM2[temp];
//				end
//				3 : begin
//					temp = temp >> 12;
//					MIR <= IR & 16'h001f; //get Rj
//					MIR <= MIR << 22;
//					MIR <= MIR | ROM3[temp];
//				end
//				4 : begin
//					temp = temp >> 13;
//					MIR <= ROM4[temp];
//				end
//				default : MIR <= ROM4[5]; //NOP
//			endcase
//		end
//	end
//endmodule