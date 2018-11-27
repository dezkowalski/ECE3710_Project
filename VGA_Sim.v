`timescale 1ns / 1 ps

module VGA_TB;

  reg clock;
  
  VGA_Controller uut (
  
		.clock(clock)
  );
  
  initial begin
  
	clock = 0;
	
	
  end
  
  
  always@(*)
  begin
	#1 clock <= ~clock;
  end
  
  endmodule

