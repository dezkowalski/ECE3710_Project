`timescale 1ns/1ps

module cpu_demo_tb;

	reg clock;
	reg reset;
	wire [6:0] one, two, three, four;

initial begin

	clock = 0;
	reset = 0;
	
	#10
	
	reset = 1;
	
	#10;
	
	reset = 0;
	
end

always begin

#5 clock = ~clock;

end


CPU_demo demo1 (
		// clock, reset in?
		.clock(clock), //set up clock pin
		.reset(reset), //set up button
		 .one(one),
		 .two(two),
		 .three(three),
		 .four(four)
	);
	
endmodule 