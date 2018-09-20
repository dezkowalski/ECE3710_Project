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

module FSM_Fib (clk, reset, RegEnable, MuxControlA, MuxControlB, MuxControlC, AluControl);
	input clk, reset;
	output reg [15:0] RegEnable;
	output reg [3:0] MuxControlA, MuxControlB;
	output reg MuxControlC;
	output reg [15:0] AluControl;
	
	parameter [3:0] s0 = 4'b0000, s1 = 4'b0001, s2 = 4'b0010, s3 = 4'b0011, s4 = 4'b0100, 
						  s5 = 4'b0101, s6 = 4'b0110, s7 = 4'b0111, s8 = 4'b1000, s9 = 4'b1001, 
						  s10 = 4'b1010, s11 = 4'b1011, s12 = 4'b1100, s13 = 4'b1101, s14 = 4'b1110, s15 = 4'b1111; 
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
				s8: state <= s9;
				s9: state <= s10;
				s10: state <= s11;
				s11: state <= s12;
				s12: state <= s13;
				s13: state <= s14;
				s14: state <= s15;
				s15: state <= s15;
				default: state <= state;
			endcase
		 end
	 end
	
	always @(state)
	 begin
		case(state)
			s0: begin 
					RegEnable = 16'b 0000_0000_0000_0001; //r0 = 1
					MuxControlA = 4'b 0001;  // reg 1
					MuxControlB = 4'b 0000;  // doesn't matter, bc MuxC enabled
					MuxControlC = 1'b 1;    // 0 = reg, 1 = immed
					AluControl = 16'b 0101_0000_0000_0011;     // add immed. with empty reg; op 0000_0101, imm:0000_0010
				 end
			s1: begin 
					RegEnable = 16'b 0000_0000_0000_0010; // r1 = 2
					MuxControlA = 4'b 0000; //reg 0
					MuxControlB = 4'b 0000; //reg 0
					MuxControlC = 1'b 0; //add r0+r0
					AluControl = 16'b 0000_0000_0101_0000; //add 1 to r1
				 end			
			s2: begin 
					RegEnable = 16'b 0000_0000_0000_0100; // r2 = 3
					MuxControlA = 4'b 0000; //reg 0
					MuxControlB = 4'b 0001; //reg 1
					MuxControlC = 1'b 0;
					AluControl = 16'b 0000_0000_0101_0000;  // add r0 and r1 to r2
				 end		
			s3: begin 
					RegEnable = 16'b 0000_0000_0000_1000; //r3 = 5
					MuxControlA = 4'b 0001; //reg 1
					MuxControlB = 4'b 0010; //reg 2
					MuxControlC = 1'b 0;
					AluControl = 16'b 0000_0000_0101_0000; //add r1 and r2 to r3
				 end	
			s4: begin 
					RegEnable = 16'b 0000_0000_0001_0000; //r4 = 8
					MuxControlA = 4'b 0010; //reg 2
					MuxControlB = 4'b 0011; //reg 3
					MuxControlC = 1'b 0 ;
					AluControl = 16'b 0000_0000_0101_0000; //add r2 and r3 to r4 
				 end	
			s5: begin 
					RegEnable = 16'b 0000_0000_0010_0000 ; //r5 = 13
					MuxControlA = 4'b 0011; //reg 3
					MuxControlB = 4'b 0100; //reg 4
					MuxControlC = 1'b 0;
					AluControl = 16'b 0000_0000_0101_0000; //add r3 and r4 to r5
				 end	
			s6: begin 
					RegEnable = 16'b 0000_0000_0100_0000; //r6 = 21
					MuxControlA = 4'b 0100; //reg 4
					MuxControlB = 4'b 0101; //reg 5 
					MuxControlC = 1'b 0;
					AluControl = 16'b 0000_0000_0101_0000; //add r4 and r5 to r6
				 end	
			s7: begin 
					RegEnable = 16'b 0000_0000_1000_0000; //r7 = 34
					MuxControlA = 4'b 0101; //reg 5
					MuxControlB = 4'b 0110; //reg 6
					MuxControlC = 1'b 0;
					AluControl = 16'b 0000_0000_0101_0000; //add r5 and r6 to r7
				 end	
			s8: begin 
					RegEnable = 16'b 0000_0001_0000_0000; //r8 = 55
					MuxControlA = 4'b 0110; //reg 6
					MuxControlB = 4'b 0111; //reg 7
					MuxControlC = 1'b 0;
					AluControl = 16'b 0000_0000_0101_0000; //add r6 and r7 to r8
				 end
			s9: begin 
					RegEnable = 16'b 0000_0010_0000_0000; //r9 = 89
					MuxControlA = 4'b 0111; //reg 7
					MuxControlB = 4'b 1000; //reg 8
					MuxControlC = 1'b 0;
					AluControl = 16'b 0000_0000_0101_0000; //add r7 and r8 to r9
				 end
			s10: begin 
					RegEnable = 16'b 0000_0100_0000_0000; //r10 = 144
					MuxControlA = 4'b 1000; //reg 8
					MuxControlB = 4'b 1001; //reg 9
					MuxControlC = 1'b 0;
					AluControl = 16'b 0000_0000_0101_0000; //add r8 and r9 to r10
				 end
			s11: begin 
					RegEnable = 16'b 0000_1000_0000_0000; //r11 = 233
					MuxControlA = 4'b 1001; //reg 9
					MuxControlB = 4'b 1010; //reg 10
					MuxControlC = 1'b 0;
					AluControl = 16'b 0000_0000_0101_0000; //add r9 and r10 to r11
				 end
			s12: begin 
					RegEnable = 16'b 0001_0000_0000_0000; //r12 = 377
					MuxControlA = 4'b 1010; //reg 10
					MuxControlB = 4'b 1011; //reg 11
					MuxControlC = 1'b 0;
					AluControl = 16'b 0000_0000_0101_0000; //add r10 and r11 to r12
				 end
			s13: begin 
					RegEnable = 16'b 0010_0000_0000_0000; //r13 = 610
					MuxControlA = 4'b 1011; //reg 11
					MuxControlB = 4'b 1100; //reg 12
					MuxControlC = 1'b 0;
					AluControl = 16'b 0000_0000_0101_0000; //add r11 and r12 to r13
				 end
			s14: begin 
					RegEnable = 16'b 0100_0000_0000_0000; //r14 = 987
					MuxControlA = 4'b 1100; //reg 12
					MuxControlB = 4'b 1101; //reg 13
					MuxControlC = 1'b 0;
					AluControl = 16'b 0000_0000_0101_0000; //add r12 and r13 to r14
				 end
			s15: begin 
					RegEnable = 16'b 1000_0000_0000_0000; //r15 = 1597
					MuxControlA = 4'b 1101; //reg 13
					MuxControlB = 4'b 1110; //reg 14
					MuxControlC = 1'b 0;
					AluControl = 16'b 0000_0000_0101_0000; //add r13 and r14 to r15
				 end
			default: begin 
					RegEnable = 16'b 0000_0000_0000_0000; 
					MuxControlA = 4'b 0000;
					MuxControlB = 4'b 0000;
					MuxControlC = 1'b 0;
					AluControl = 16'b 0000_0000_0000_0000; //nop
				 end
		endcase
	 end
endmodule 