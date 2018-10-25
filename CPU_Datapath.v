module CPU_Datapath (clk, reset, RegEnable, MainBus MuxControlA, MuxControlB, 
							MuxControlC, AluControl, FlagEnable, AluBusA, AluBusB, AluOut);

input clk, reset;
input [15:0] RegEnable, MainBus;
input [3:0] MuxControlA, MuxControlB;
input MuxControlC;
input [15:0] AluControl;
input FlagEnable; // just one bit?
//add immediate  and change alu cnotrol to 8 bit opcode.

//output [15:0] finalOut; If need this again put it in parentesis up top
output wire [15:0] AluBusA; // 
output wire [15:0] AluBusB; //
output wire [15:0] AluOut;

reg [4:0] FlagRegister;

//wire [15:0] AluBusA;
//wire [15:0] AluBusB; 
//wire [15:0] MainBus; now an input from LD mux
wire [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15;
wire [15:0] MuxBus;
wire [4:0] Flags;


RegBank newRegBank (clk, reset, MainBus, RegEnable, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15);

Mux_16_Bit MuxA(MuxControlA, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, AluBusA);

Mux_16_Bit MuxB(MuxControlB, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, MuxBus);

Mux_Two_One MuxC(MuxControlC, MuxBus, {8'b0000_0000, AluControl[11:8], AluControl [3:0]}, AluBusB); //take in immediate now

ALU newALU (AluBusA, AluBusB, AluControl, AluOut, Flags); // no alu control, only 8 bit opcode now

//assign finalOut = r15;

always @(posedge clk)
begin

	if (FlagEnable == 1'b1)
	begin
		FlagRegister <= Flags;
	end

end


endmodule 