module memory_Demo (
		input clock,
		input reset, 
		output reg [6:0] one,
		output reg [6:0] two,
		output reg [6:0] three,
		output reg [6:0] four
	);

	reg [15:0] out;
	wire [15:0] C, d;
	wire [6:0] first, second, third, fourth;
	wire [9:0] readAdd, writeAdd;
	wire writeEn;

memory_FSM BasicTester(
		.clk(clock),
		.reset(reset),
		.data(d),
		.data
		.readAddress(readAdd),
		.writeAddress(writeAdd),
		.writeEnable(writeEn),
	);
	
	DualPortMemory mem (
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

always@(C) 
begin
	
	out = C;	
	one = first;
	two = second;
	three = third;
	four = fourth;

end

	
hexTo7Seg firstDisplay(
		.hex_input(out[15:12]),
		.seven_seg_out(first)
	);
	
hexTo7Seg secondDisplay(
		.hex_input(out[11:8]),
		.seven_seg_out(second)
	);
	
hexTo7Seg thirdDisplay(
		.hex_input(out[7:4]),
		.seven_seg_out(third)
	);
	
hexTo7Seg fourthDisplay(
		.hex_input(out[3:0]),
		.seven_seg_out(fourth)
	);	

endmodule 