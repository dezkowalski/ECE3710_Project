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
r
module memory_FSM (clk, reset, InA, InB, outA, outB, readAddress, writeAddress, writeEnableA, writeEnableB);
	input clk, reset;
	output reg [15:0] InA, InB, outA, outB;
	output reg [9:0] readAddress, writeAddress;
	output reg writeEnableA, writeEnableB;
	
	
	parameter [2:0] s0 = 3'b000, s1 = 3'b001, s2 = 3'b010, s3 = 3'b011, s4 = 3'b100;
	
	reg [2:0] state = s0;
	
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
//				s4: state <= s4;
				default: state <= state;
			endcase
		 end
	 end

	always @(state)
	 begin
		case(state)
			s0: begin // read data
					data = 16'b 0000_0000_0000_0000; 
					readAddress = 10'b 00_0000_0001; 
					writeAddress = 10'b 00_0000_0000;
					writeEnable = 1'b 0;  
				 end  
			s1: begin // modify data
					data = 16'b 0000_0000_0000_0000; 
					readAddress = 10'b 00_0000_0000; 
					writeAddress = 10'b 00_0000_0000;
					writeEnable = 1'b 0;  
				 end			
			s2: begin // write data
					data = 16'b 0000_0000_0000_0010; 
					readAddress = 10'b 00_0000_0000; 
					writeAddress = 10'b 00_0000_0001;
					writeEnable = 1'b 1;  
				 end		
			s3: begin  // read data
					data = 16'b 0000_0000_0000_0010; 
					readAddress = 10'b 00_0000_0001; 
					writeAddress = 10'b 00_0000_0000;
					writeEnable = 1'b 0;  
				 end	
//			s4: begin 
//					data = 16'b 0000_0000_0000_0010; 
//					readAddress = 10'b 00_0000_0000; 
//					writeAddress = 10'b 00_0000_0000;
//					writeEnable = 1'b 0;  
				 end	
			default: begin 
					data = 16'b 0000_0000_0000_0010; 
					readAddress = 10'b 00_0000_0000; 
					writeAddress = 10'b 00_0000_0000;
					writeEnable = 1'b 1;  
				 end
		endcase
	 end
endmodule
