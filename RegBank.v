
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:24:24 09/13/2015 
// Design Name: 
// Module Name:    regbank 
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

//Each individual register
module Register(clk, reset, dataIn, writeEnable, r);
	 input clk, writeEnable, reset;
	 input [15:0] dataIn;
	 output reg [15:0] r;
	 
 always @( posedge clk )
	begin
	if (reset) r <= 16'b0000_0000_0000_0000;
	else
		begin			
			if (writeEnable)
				begin
					r <= dataIn;
				end
			else
				begin
					r <= r;
				end
		end
	end
endmodule


// Shown below is one way to implement the register file
// This is a bottom-up, structural instantiation
// Another module is described in another file...
// .... which shows two dimensional construct for regfile

// Structural Implementation of RegBank
/********/
module RegBank(clk, reset, MainBus, regEnable, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15);
	input clk, reset;
	input [15:0] MainBus;
		input [15:0] regEnable;
	output [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15;

	
Register Inst0(clk, reset, MainBus, regEnable[0], r0);
Register Inst1(clk, reset, MainBus, regEnable[1], r1);
Register Inst2(clk, reset, MainBus, regEnable[2], r2);
Register Inst3(clk, reset, MainBus, regEnable[3], r3);
Register Inst4(clk, reset, MainBus, regEnable[4], r4);
Register Inst5(clk, reset, MainBus, regEnable[5], r5);
Register Inst6(clk, reset, MainBus, regEnable[6], r6);
Register Inst7(clk, reset, MainBus, regEnable[7], r7);
Register Inst8(clk, reset, MainBus, regEnable[8], r8);
Register Inst9(clk, reset, MainBus, regEnable[9], r9);
Register Inst10(clk, reset, MainBus, regEnable[10], r10);
Register Inst11(clk, reset, MainBus, regEnable[11], r11);
Register Inst12(clk, reset, MainBus, regEnable[12], r12);
Register Inst13(clk, reset, MainBus, regEnable[13], r13);
Register Inst14(clk, reset, MainBus, regEnable[14], r14);
Register Inst15(clk, reset, MainBus, regEnable[15], r15);


endmodule
/**************/

