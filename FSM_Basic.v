`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:27:23 04/19/2018 
// Design Name: 
// Module Name:    FSM 
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

module FSM_Basic (clk, reset, RegEnable, MuxControlA, MuxControlB, MuxControlC, AluControl);
	input clk, reset;
	output reg [15:0] RegEnable;
	output reg [3:0] MuxControlA, MuxControlB;
	output reg MuxControlC;
	output reg [15:0] AluControl;	
	
	
	parameter [1:0] s0 = 2'b00, s1 = 2'b01, s2 = 2'b10, s3 = 2'b11;
	
	reg [1:0] state = s0;
	
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
				s3: state <= s3;
				default: state <= state;
			endcase
		 end
	 end

	always @(state)
	 begin
		case(state)
			s0: begin 
					RegEnable = 16'b 0000_0000_0000_0010; //r1 = 2 (0000_0000_0000_0010)
					MuxControlA = 4'b 0000;  // reg 0
					MuxControlB = 4'b 0000;  // doesn't matter, bc MuxC enabled
					MuxControlC = 1'b 1;    // 0 = reg, 1 = immed
					AluControl = 16'b 0101_0000_0000_0010;     // add immed. with empty reg; op 0000_0101, imm:0000_0010
				 end
			s1: begin 
					RegEnable = 16'b 0000_0000_0000_0100; // r2 = r1 - imm = 2 - 10 = -7 (1111_1111_1111_1000)
					MuxControlA = 4'b 0001; //reg 1
					MuxControlB = 4'b 0000; //doesnt matter
					MuxControlC = 1'b 1;
					AluControl = 16'b 1001_0000_0000_1010; // reg - imm. ;op 0000 1001, imm: 0000_1010
				 end			
			s2: begin 
					RegEnable = 16'b 0000_0000_0000_1000; // r3 = r1 or r2 = 1111_1111_1111_1010
					MuxControlA = 4'b 0001; //r1
					MuxControlB = 4'b 0010; //r2
					MuxControlC = 1'b 0; //no immed.
					AluControl = 16'b 0000_0000_0010_0000;  // or r2 r1; op 0000_0010, imm doesnt matter
				 end		
			s3: begin 
					RegEnable = 16'b 1000_0000_0000_0000;  // r15 = shift right 1(1111_1111_1111_1010) = 0111_1111_1111_1101
					MuxControlA = 4'b 0011;  //pass r3
					MuxControlB = 4'b 0000; // B reg doesnt matter
					MuxControlC = 1'b 0; //no imm
					AluControl = 16'b 0000_0000_1010_0000; // rshift r15; op 0000_1010, no imm
				 end	
			default: begin 
					RegEnable = 16'b 0000_0000_0000_0000; //shouldnt get here, leave as no-op
					MuxControlA = 4'b 0000;
					MuxControlB = 4'b 0000;
					MuxControlC = 1'b 0;
					AluControl = 16'b 0000_0000_0000_0000;
				 end
		endcase
	 end
endmodule
