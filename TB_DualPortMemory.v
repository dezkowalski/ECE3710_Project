`timescale 1ns / 1ps

module dualPortMemoryTest;

	reg [15:0] data;
	reg [9:0] writeAddress;
	reg [9:0] readAddress;
	reg writeEnable;
	reg clock;
	
	wire [15:0] out_a;
	wire [15:0] out_b;
	
	DualPortMemory uut (
		.data_a(data),
		.data_b(data),	
		.addr_a(readAddress),
		.addr_b(readAddress),
		.we_a(writeEnable),
		.we_b(writeEnable),
		.clk(clock),
		.q_a(out_a),
		.q_b(out_b)
	);
	
	initial begin
	clock = 1;
	
	#20
	
	
	data = 16'b0000_0000_0000_0000;
	writeAddress = 10'b0000_0000_00;
	readAddress = 10'b0000_0000_00;
	writeEnable = 0;
	
	#10
	
	//Write 1 to the first memory address.
	data = 16'b0000_0000_0000_0001;
	writeAddress = 10'b0000_0000_01;
	readAddress = 10'b0000_0000_01;
	writeEnable = 1'b1;

	
	#10
	
	
	$display(out_a);
	
	data = 16'b0000_0000_0000_0010;
	writeAddress = 10'b0000_0001_00;
	readAddress = 10'b0000_0001_00;
	writeEnable = 1'b1;

	
	#10
	
	$display(out_a);
	
	end
	
	always@(*)
	begin
		#1 clock <= ~clock;
	end
	endmodule