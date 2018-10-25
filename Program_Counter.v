module Program_Counter ( clk, reset, PC_enable, address );


input clk, reset, PC_enable;
output reg [15:0] address; //What do we want to call this??

 always @(posedge clk)
 begin
 
	 if (PC_enable == 1'b1)
	 begin
		address = address + 16'b0000_0000_0000_0001;
	 end
	 
 end


endmodule








