`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:27:23 04/19/2018 
// Design Name: 
// Module Name:    FSM_Edge
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module FSM_Edge (clk, reset, RegEnable, MuxControlA, MuxControlB, MuxControlC, AluControl);
	input clk, reset;
	output reg [15:0] RegEnable;
	output reg [3:0] MuxControlA, MuxControlB;
	output reg MuxControlC;
	output reg [15:0] AluControl;	
	
	
	parameter [3:0] s0 = 4'b0000, s1 = 4'b0001, s2 = 4'b0010, s3 = 4'b0011, s4 = 4'b0100, 
						  s5 = 4'b0101, s6 = 4'b0110, s7 = 4'b0111, s8 = 4'b1000;
	reg [3:0] state = s0;
	
	// Define the next state combinational circuit
	always @(posedge clk)
	 begin
		if(reset == 1'b1)
		 begin
			state <= s0;
		 end
		else
		 begin
			case(state)
				s0: state <= s1;
				s1: state <= s2;
				s2: state <= s3;
				s3: state <= s4;
				s4: state <= s5;
				s5: state <= s6;
				s6: state <= s7;
				s7: state <= s8;
				s8: state <= s8;
				default: state <= state;
			endcase
		 end
	 end
	
	always @(state)
	 begin
		case(state)
			s0: begin 
					RegEnable = 16'b 0000_0000_0000_0010; //r1 =  (0000_0000_0001_0001) = 17 = 0x11
					MuxControlA = 4'b 0000;  // reg 0
					MuxControlB = 4'b 0000;  // doesn't matter, bc MuxC enabled
					MuxControlC = 1'b 1;    // 0 = reg, 1 = immed
					AluControl = 16'b 0001_0001_0000_0000;     // addcui immed. empty reg + 16 + carry = 17
				 end
			s1: begin 
					RegEnable = 16'b 0000_0000_0000_0100; // r2 = (0000_0000_0100_0100) = 68 = 0x44
					MuxControlA = 4'b 0001; //reg 1 = 17
					MuxControlB = 4'b 0000; //doesnt matter
					MuxControlC = 1'b 1; 
					AluControl = 16'b 0011_0000_0000_0010; // LSHI by 2  
				 end			
			s2: begin 
					RegEnable = 16'b 0000_0000_0000_1000; // r3 = (0000_0000_0010_0010) = 34 = 0x22
					MuxControlA = 4'b 0010; //r2
					MuxControlB = 4'b 0000; //r0
					MuxControlC = 1'b 0; //no immed.
					AluControl = 16'b 0000_0000_1110_0000;  // ARSH
				 end		
			s3: begin 
					RegEnable = 16'b 0000_0000_0001_0000;  // r4 = (1111_1111_1101_1101) = 65,501 0xFFDD
					MuxControlA = 4'b 0011;  //r3
					MuxControlB = 4'b 0000; // B reg doesnt matter
					MuxControlC = 1'b 0; //no imm
					AluControl = 16'b 0000_0000_1111_0000; // Not r3
				 end	
			s4: begin 
					RegEnable = 16'b 0000_0000_0010_0000;  // r5 = (0000_0000_0000_0001)
					MuxControlA = 4'b 0100;  //r4
					MuxControlB = 4'b 0011; // r3
					MuxControlC = 1'b 0; //no imm
					AluControl = 16'b 0000_0000_1011_0000; // signed cmp r4
				 end	
			s5: begin 
					RegEnable = 16'b 0000_0000_0100_0000;  // r6 = (0000_0000_0101_0101) = 85 = 0x55
					MuxControlA = 4'b 0001;  //r1
					MuxControlB = 4'b 0010; // r2
					MuxControlC = 1'b 0; //no imm
					AluControl = 16'b 0000_0000_0101_0000; // add
				 end	
			s6: begin 
					RegEnable = 16'b 0000_0000_1000_0000;  // r7 = (0000_0000_0111_0111) = 119 = 0x77
					MuxControlA = 4'b 0110;  //r6
					MuxControlB = 4'b 0011; // r3
					MuxControlC = 1'b 0; //no imm
					AluControl = 16'b 0000_0000_0101_0000; // add
				 end	
			s7: begin 
					RegEnable = 16'b 0000_0001_0000_0000;  // r8 = (1111_1111_1101_1110) = 65,502 = 0xFFDE
					MuxControlA = 4'b 0100;  //r4
					MuxControlB = 4'b 0101; // r5
					MuxControlC = 1'b 0; //no imm
					AluControl = 16'b 0000_0000_0101_0000; // add
				 end	
			s8: begin 
					RegEnable = 16'b 1000_0000_0000_0000;  // r15 = (0000_0000_0101_0101) = 85 = 0x55
					MuxControlA = 4'b 1000;  //r8
					MuxControlB = 4'b 0111; // r7
					MuxControlC = 1'b 0; //no imm
					AluControl = 16'b 0000_0000_0110_0000; // addu
				 end	
//			default: begin 
//					RegEnable = 16'b 0000_0000_0000_0000; //shouldnt get here, leave as no-op
//					MuxControlA = 4'b 0000;
//					MuxControlB = 4'b 0000;
//					MuxControlC = 1'b 0;
//					AluControl = 16'b 0000_0000_0000_0000;
//				 end
		endcase
	 end
endmodule
