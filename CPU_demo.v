module CPU_demo (
		input clock,
		input reset, 
		output reg [6:0] one,
		output reg [6:0] two,
		output reg [6:0] three,
		output reg [6:0] four
	);

	reg [15:0] out;
	wire [15:0] C, fsmRegEn, fsmAluControl;
	wire [6:0] first, second, third, fourth;
	wire [3:0] fsmMuxA, fsmMuxB;
	wire fsmMuxC;

//FSM_Basic BasicTester(
//		.clk(clock),
//		.reset(reset),
//		.RegEnable(fsmRegEn),
//		.MuxControlA(fsmMuxA),
//		.MuxControlB(fsmMuxB),
//		.MuxControlC(fsmMuxC),
//		.AluControl(fsmAluControl)  
//	);
	
FSM_Fib FibTester(
		.clk(clock),
		.reset(reset),
		.RegEnable(fsmRegEn),
		.MuxControlA(fsmMuxA),
		.MuxControlB(fsmMuxB),
		.MuxControlC(fsmMuxC),
		.AluControl(fsmAluControl)  
	);

//FSM_Edge EdgeTester(
//		.clk(clock),
//		.reset(reset),
//		.RegEnable(fsmRegEn),
//		.MuxControlA(fsmMuxA),
//		.MuxControlB(fsmMuxB),
//		.MuxControlC(fsmMuxC),
//		.AluControl(fsmAluControl)  
//	);

CPU_Datapath datapath (
		.clk(clock),
		.reset(reset),
		.RegEnable(fsmRegEn),
		.MuxControlA(fsmMuxA),
		.MuxControlB(fsmMuxB),
		.MuxControlC(fsmMuxC),
		.AluControl(fsmAluControl),
		.finalOut(C)
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