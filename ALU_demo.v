



module ALU_demo (
		 input [3:0]lowerOpcode,
		 input [4:0] higherA,
		 input [4:0] higherB,
		 output reg [4:0]flagLEDs,
		 output reg [6:0] one,
		 output reg [6:0] two,
		 output reg [6:0] three,
		 output reg [6:0] four
	);


	reg [15:0] aluControl;

	reg [15:0] A;
	reg [15:0] B;
	reg [15:0] out;
	
	// Outputs
	wire [15:0] C;
	wire [4:0] Flags;
	
	//Displays
	wire [6:0] first, second, third, fourth;

always@(lowerOpcode, higherA, higherB, C)
begin

	//aluControl = {{12'b0000_0000_0000_0000}, {lowerOpcode}};
	
	//A = {{higherA}, {11'b0000_0000_000}};
	//B = {{higherB}, {11'b0000_0000_000}};
	
//	if(higherA[4])
//		first = 4'b0011;
//	else
//		one = 4'b0000;
	
	flagLEDs = Flags;
	
	out = C;
	
	one = first;
	two = second;
	three = third;
	four = fourth;

end


ALU alu(

		.In1({{higherA}, {11'b0000_0000_000}}), 
		.In2({{higherB}, {11'b0000_0000_000}}), 
		.aluControl({{8'b0000_0000}, {lowerOpcode}, {4'b0000}}),
		.Out(C), 
		.Flags(Flags)
	);
	
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