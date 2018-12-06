`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:40:35 04/12/2018 
// Design Name: 
// Module Name:    MusicGeneratorLogic 
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
module MusicGeneration(
    input externalClock,
    input S,
    output reg music
    );
	
	wire a4, b4;
	//will hold the different frequencies of the musical notes
	A4 U1(externalClock, a4);
	B4 U2(externalClock, b4);
	  
always @(posedge externalClock)
	begin
	if(S == 0)
		begin
		music <= a4;
		end
	else if(S == 1)
		begin
		music <= b4;
		end
	end
endmodule
	
module A4(
input clk,
output reg fq
);

	//used to convert 50MHz time to 440Hz timing
	integer startCount = 0;
	integer maxCount = 56817;
	always@(posedge clk)
	begin
	startCount <= startCount+1;
	if(startCount >= maxCount)
		begin
		startCount <= 0;
		fq <= !fq;
		end	
	end
endmodule
	
module B4(
input clk,
output reg fq
);

	//used to convert 50MHz time to 493.88Hz timing
	integer startCount = 0;
	integer maxCount = 50619;
	
	always@(posedge clk)
	begin
	startCount = startCount+1;
	if(startCount == maxCount)
		begin
		startCount = 0;
		fq = !fq;
		end	
	end
endmodule