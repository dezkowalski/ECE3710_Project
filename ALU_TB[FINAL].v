`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:25:01 08/30/2011
// Design Name:   alu
// Module Name:   C:/Documents and Settings/Administrator/ALU/alutest.v
// Project Name:  ALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module alutest;

	// Inputs
	reg [15:0] A;
	reg [15:0] B;
		
	reg [15:0] aluControl;

	// Outputs
	wire [15:0] C;
	wire [4:0] Flags;		//Z C F N L
	
	//Pass/fail statistics.
	integer numPass;
	integer numFail;
	
	integer i;
	integer seed;
	integer passed;
	
	wire res[31:0];
	
	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.In1(A), 
		.In2(B), 
		.Out(C), 
		.aluControl(aluControl), 
		.Flags(Flags)
	);

	initial begin
	
	numPass = 0;
	numFail = 0;
	A = 0;
	B = 0;
	aluControl = 0;
	i = 0;
	seed = 1567;
	passed = 0;
	
	#10;
	
	//Test ADD.
	aluControl = 16'b0000_0000_0101_0000;
	
	for(i = 0; i < 10; i = i+1)
	begin
		#10;
		A = $random(seed) % 65535;
		B = $random(seed) % 65535;
		#10;
		
		passed = 1;		//Assume success.
		
				
		if($signed(A) + $signed(B) != $signed(C))		//If result is wrong.
		begin
			
			passed = 0;
			$display("ADD failed: %h + %h != %h, should be %h", A, B, C, $signed(A) + $signed(B));
		end
		
		if($signed(A) > 0 && $signed(B) > 0 && $signed(C) < 0)	//Overflowed into negative.
		begin
			
			if(Flags[2] != 1)
			begin
				passed = 0;
				$display("ADD failed for %h + %h = %h.", A, B, C);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		if($signed(A) < 0 && $signed(B) < 0 && $signed(C) > 0)	//Overflowed into positive.
		begin
			
			if(Flags != 5'b01100)
			begin
				passed = 0;
				$display("ADD failed for %h + %h = %h.", A, B, C);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		if($signed(A) + $signed(B) == 0)
		begin
			
			if(Flags != 5'b10000)
			begin
				passed = 0;
				$display("ADD failed for %h + %h = %h.", A, B, C);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
		
	end
	
	//Test ADDI, 0101_xxxx
	aluControl = 16'b0101_0000_0000_0000;
	
	for(i = 0; i < 10; i = i+1)
	begin
		#10
		A = $random(seed) % 65535;
		B = $unsigned($random(seed)) % 255;
		
		B = {{8{B[7]}}, {B[7:0]}};		
		
		aluControl[11:8] = B[7:4];
		aluControl[3:0] = B[3:0];
		#10;
		
		passed = 1;		//Assume success.

		if($signed(A) + {{8{B[7]}}, {B[7:0]}} != $signed(C))		//If result is wrong.
		begin
			
			passed = 0;
			$display("ADDI failed: %h + %h != %h, should be %h", A, B, C, $signed(A) + $signed(B));
		end
		
		if($signed(A) > 0 && $signed(B) > 0 && $signed(C) < 0)	//Overflowed into negative.
		begin
			
			if(Flags != 5'b00100)
			begin
				passed = 0;
				$display("ADDI failed for %h + %h = %h.", A, B, C);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		if($signed(A) < 0 && $signed(B) < 0 && $signed(C) > 0)	//Overflowed into positive.
		begin
			
			if(Flags != 5'b00100)
			begin
				passed = 0;
				$display("ADDI failed for %h + %h = %h.", A, B, C);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		if($signed(A) + $signed(B) == 0)		//Zeroes.
		begin
			
			if(Flags != 5'b10000)
			begin
				passed = 0;
				$display("ADDI failed for %h + %h = %h.", A, B, C);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
		
	end
	
	//Test ADDU.
	aluControl = 16'b0000_0000_0110_0000;
	
	for(i = 0; i < 10; i = i+1)
	begin
		#10;
		A = $unsigned($random(seed)) % 65535;
		B = $unsigned($random(seed)) % 65535;
		#10;
		passed = 1;		//Assume success.
		
		
		
		if(A + B != C)		//If result is wrong.
		begin
			
			passed = 0;
			$display("ADD failed: %h + %h != %h, should be %h", A, B, C, A + B);
		end
		
		if(A + B > C)	//Overflowed.
		begin	
			if(Flags != 5'b01100)
			begin
				passed = 0;
				$display("ADDU failed for %h + %h = %h.", A, B, C);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		if(A + B == 0)
		begin
			
			if(Flags != 5'b10000)
			begin
				passed = 0;
				$display("ADDU failed for %h + %h = %h.", A, B, C);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
		
	end
	
	//Test ADDUI. 0110_xxxx
	aluControl = 16'b0110_0000_0101_0000;
	
	for(i = 0; i < 10; i = i+1)
	begin
		#10
		A = $unsigned($random(seed)) % 65535;
		B = $unsigned($random(seed)) % 255;
		
		aluControl[11:8] = B[7:4];
		aluControl[3:0] = B[3:0];
		#10;
		
		
		passed = 1;		//Assume success.
		
		if(A + B != C)		//If result is wrong.
		begin
			
			passed = 0;
			$display("ADDUI failed: %h + %h != %h, should be %h", A, B, C, (A+B));
		end
		
		if(A + B > C)	//Overflowed.
		begin
			if(Flags != 5'b01100)
			begin
				passed = 0;
				$display("ADDUI failed for %h + %h = %h.", A, B, C);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		if(A + B == 0)
		begin
			
			if(Flags != 5'b10000)
			begin
				passed = 0;
				$display(" failed for %h + %h = %h.", A, B, C);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
		
	end
	
	//Test ADDC.
	aluControl = 16'b0000_0000_0111_1010;
	
	for(i = 0; i < 10; i = i+1)
	begin
		
		#10;
		A = $random(seed) % 65535;
		B = $random(seed) % 65535;
		#10;
		
		passed = 1;		//Assume success.
		
	
		if($signed(A) + $signed(B) + 1 != $signed(C) && Flags[2] == 0)		//If result is wrong without overflow:
		begin
			
			passed = 0;
			$display("ADDC failed: %h + %h != %h, should be %h", A, B, C, ($signed(A) + $signed(B) + 1));
		end
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
		
	end
	
	//Test ADDCU.
	aluControl = 16'b0000_1111_0100_0101;
	
	for(i = 0; i < 10; i = i+1)
	begin
		
		#10;
		A = $unsigned($random(seed)) % 65535;
		B = $unsigned($random(seed)) % 65535;
		#10;
		
		passed = 1;		//Assume success.
		
		
		
		if(A + B + 1 != C)	//Overflowed.
		begin
			
			if(Flags != 5'b01100)
			begin
				passed = 0;
				$display("ADDCU failed for %h + %h = %h.", A, B, C);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		if(A + B + 1 == 0)
		begin
			
			if(Flags != 5'b10000)
			begin
				passed = 0;
				$display("ADDC failed for %h + %h = %h.", A, B, C);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
	
	end
	
	//Test ADDCUI. 0001_xxxx.
	aluControl = 16'b0001_0000_1010_1111;
	
	for(i = 0; i < 10; i = i+1)
	begin
		
		#10;
		A = $random(seed) % 65535;
		B = $unsigned($random(seed)) % 255;

		
		aluControl[11:8] = B[7:4];
		aluControl[3:0] = B[3:0];
		
		#10;
		
		passed = 1;		//Assume success.
		
		
		
		if(A + B + 1 != C)		//If result is wrong.
		begin
			
			passed = 0;
			$display("ADDCUI failed: %h + %h != %h, should be %h", A, B, C, A + B + 1);
			$display("ADDCUI failed: %b + %b != %b, should be %h", A, B, C, A + B + 1);

		end
		
		if(A + B + 1 != C)	//Overflowed.
		begin
			
			if(Flags != 5'b01100)
			begin
				passed = 0;
				$display("ADDCUI failed for %h + %h = %h.", A, B, C);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		if(A + B + 1 == 0)
		begin
			
			if(Flags != 5'b10000)
			begin
				passed = 0;
				$display("ADDCUI failed for %h + %h = %h.", A, B, C);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
	
	end
	
	//Test ADDCI 0111_xxxx.
	aluControl = 16'b0111_1111_0101_0000;
	
	for(i = 0; i < 10; i = i+1)
	begin
		
		#10;
		A = $random(seed) % 65535;
		B = ($random(seed)) % 255;
		

		B = {{8{B[7]}}, {B[7:0]}};		
		
		aluControl[11:8] = B[7:4];
		aluControl[3:0] = B[3:0];
		
		#10;
		
		passed = 1;		//Assume success.
		
		
		
		if($signed(A) + $signed(B) + 1 != $signed(C))		//If result is wrong.
		begin
			
			passed = 0;
			$display("ADDCI failed: %h + %h != %h, should be %h", A, $signed(B), C, $signed(A) + $signed(B) + 1);
		end
		
		if($signed(A) + $signed(B) + 1 != $signed(C))	//Overflowed.
		begin
			
			if(Flags != 5'b00100)
			begin
				passed = 0;
				$display("ADDCI failed for %h + %h = %h.", A, $signed(B), C);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		if($signed(A) + $signed(B) + 1 == 0)
		begin
			
			if(Flags != 5'b10000)
			begin
				passed = 0;
				$display("ADDCI failed for %h + %h = %h.", A, $signed(B), C);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
	
	end
		
	//Test SUB.
	aluControl = 16'b0000_1111_1001_0000;
	
	for(i = 0; i < 10; i = i+1)
	begin
		
		#10;
		A = $random(seed) % 65535;
		B = $random(seed) % 65535;
		#10;
		
		passed = 1;		//Assume success.
				
		
		if($signed(A) - $signed(B) != $signed(C))		//If result is wrong.
		begin
			
			passed = 0;
			$display("SUB failed: %h + %h != %h, should be %h", A, B, C, $signed(A) + $signed(B));
		end
		
		if($signed(A) - $signed(B) != $signed(C))	//Overflowed.
		begin
			
			if(Flags != 5'b00100)
			begin
				passed = 0;
				$display("SUB failed for %h + %h = %h.", A, B, C);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		if($signed(A) + $signed(B) == 0)
		begin
			
			if(Flags != 5'b10000)
			begin
				passed = 0;
				$display("SUB failed for %h + %h = %h.", A, B, C);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
	
	end
	
	//Test SUBI. 1001_xxxx
	aluControl = 16'b1001_1111_0000_0000;
	
	for(i = 0; i < 10; i = i+1)
	begin
		
		#10;
		A = $random(seed) % 65535;
		B = $unsigned($random(seed)) % 255;
		B = {{8{B[7]}}, {B[7:0]}};		
		
		
		aluControl[11:8] = B[7:4];
		aluControl[3:0] = B[3:0];
		
		#10;
		
		passed = 1;		//Assume success.
		
		
		
		if($signed(A) - $signed(B) != $signed(C))		//If result is wrong.
		begin
			
			passed = 0;
			$display("SUBI failed: %h + %h != %h, should be %h", A, B, C, $signed(A) + $signed(B));
		end
		
		if($signed(A) - $signed(B) != $signed(C))	//Overflowed.
		begin
			
			if(Flags != 5'b00100)
			begin
				passed = 0;
				$display("SUBI failed for %h + %h = %h.", A, B, C);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		if($signed(A) + $signed(B) == 0)
		begin
			
			if(Flags != 5'b10000)
			begin
				passed = 0;
				$display("SUBI failed for %h + %h = %h.", A, B, C);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
	
	end
	
	//Test CMP.
	aluControl = 16'b0000_1111_1011_0000;
	
	for(i = 0; i < 10; i = i+1)
	begin
		
		#10;
		A = $random(seed) % 65535;
		B = $random(seed) % 65535;
		#10;
		
		passed = 1;		//Assume success.
		
		
		
		if($signed(A) < $signed(B))
		begin
			
			if(Flags != 5'b00011)
			begin
				passed = 0;
				$display("%h compared to %h failed.", A, B);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		if($signed(A) > $signed(B))
		begin
			
			if(Flags != 5'b00000)
			begin
				passed = 0;
				$display("%h compared to %h failed.", A, B);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		if(A == B)
		begin
			
			if(Flags != 5'b10000)
			begin
				passed = 0;
				$display("%h compared to %h failed.", A, B);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
		
	end
	
	//Test CMPI. 1011_xxxx
	aluControl = 16'b1011_0000_1100_1111;
	
	for(i = 0; i < 10; i = i+1)
	begin
		
		#10;
		A = $random(seed) % 65535;
		B = $unsigned($random(seed)) % 255;
		B = {{8{B[7]}}, {B[7:0]}};		


		
		aluControl[11:8] = B[7:4];
		aluControl[3:0] = B[3:0];
		
		#10;
		
		
		passed = 1;		//Assume success.
		
		
		
		if($signed(A) < $signed(B))
		begin
			
			if(Flags != 5'b00011)
			begin
				passed = 0;
				$display("%h CMPI to %h failed.", A, B);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		if($signed(A) > $signed(B))
		begin
			
			if(Flags != 5'b00000)
			begin
				passed = 0;
				$display("%h CMPI to %h failed.", A, B);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		if(A == B)
		begin
			
			if(Flags != 5'b10000)
			begin
				passed = 0;
				$display("%h CMPI to %h failed.", A, B);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
		
	end
	
	//Test CMPU.
	aluControl = 16'b0000_0000_1101_1111;
	
	for(i = 0; i < 10; i = i+1)
	begin
		
		#10;
		A = $random(seed) % 65535;
		B = $random(seed) % 65535;
		#10;
		
		passed = 1;		//Assume success.
		
		
		
		if(A < B)
		begin
			
			if(Flags != 5'b00011)
			begin
				passed = 0;
				$display("%h CMPU to %h failed.", A, B);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		if(A > B)
		begin
			
			if(Flags != 5'b00000)
			begin
				passed = 0;
				$display("%h CMPU to %h failed.", A, B);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		if(A == B)
		begin
			
			if(Flags != 5'b10000)
			begin
				passed = 0;
				$display("%h CMPU to %h failed.", A, B);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
		
	end
	
	//Test CMPUI. 0010_xxxx
	aluControl = 16'b0010_1111_0011_0000;
	
	for(i = 0; i < 10; i = i+1)
	begin
		
		#10;
		A = $random(seed) % 65535;
		B = $unsigned($random(seed)) % 255;
		
		aluControl[11:8] = B[7:4];
		aluControl[3:0] = B[3:0];
		
		#10;
		
		
		passed = 1;		//Assume success.
		
		

		if(A < B)
		begin
			
			if(Flags != 5'b00011)
			begin
				passed = 0;
				$display("%h CMPUI to %h failed.", A, B);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		if(A > B)
		begin
			
			if(Flags != 5'b00000)
			begin
				passed = 0;
				$display("%h CMPUI to %h failed.", A, B);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		if(A == B)
		begin
			
			if(Flags != 5'b10000)
			begin
				passed = 0;
				$display("%h CMPUI to %h failed.", A, B);
			   $display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
			end	
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
		
	end
	
	//Test AND.
	aluControl = 16'b0000_0000_0001_1111;
	
	for(i = 0; i < 10; i = i+1)
	begin
		
		#10;
		A = $random(seed) % 65535;
		B = $random(seed) % 65535;
		#10;
		
		passed = 1;		//Assume success.
		
		
		if(C == 0 && Flags != 5'b10000)		//If the flags are set incorrectly.
		begin
			passed = 0;
		   $display("%h AND %h failed.", A, B);
			$display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
		end
		
		if(C != 0 && Flags != 5'b00000)		//If the flags are set incorrectly.
		begin
			passed = 0;
		   $display("%h AND %h failed.", A, B);
			$display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
		
	end
	
	//Test OR.
	aluControl = 16'b0000_0000_0010_1111;
	
	for(i = 0; i < 10; i = i+1)
	begin
		
		#10;
		A = $random(seed) % 65535;
		B = $random(seed) % 65535;
		#10;
		
		passed = 1;		//Assume success.
		
		
		
		if(C == 0 && Flags != 5'b10000)		//If the flags are set incorrectly.
		begin
			passed = 0;
		   $display("%h OR %h failed.", A, B);
			$display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
		end
		
		if(C != 0 && Flags != 5'b00000)		//If the flags are set incorrectly.
		begin
			passed = 0;
		   $display("%h OR %h failed.", A, B);
			$display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
		
	end
	
	//Test XOR.
	aluControl = 16'b0000_1111_0011_0000;
	
	for(i = 0; i < 10; i = i+1)
	begin
		
		#10;
		A = $random(seed) % 65535;
		B = $random(seed) % 65535;
		#10;
		
		passed = 1;		//Assume success.
		
		
		if(C == 0 && Flags != 5'b10000)		//If the flags are set incorrectly.
		begin
			passed = 0;
		   $display("%h XOR %h failed.", A, B);
			$display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
		end
		
		if(C != 0 && Flags != 5'b00000)		//If the flags are set incorrectly.
		begin
			passed = 0;
		   $display("%h XOR %h failed.", A, B);
			$display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
		
	end
	
	//Test NOT.
	aluControl = 16'b0000_1111_1111_0000;
	
	for(i = 0; i < 10; i = i+1)
	begin
		
		#10;
		A = $random(seed) % 65535;
		B = $random(seed) % 65535;
		#10;
		
		passed = 1;		//Assume success.
		
		
		if(C == 0 && Flags != 5'b10000)		//If the flags are set incorrectly.
		begin
			passed = 0;
		   $display("!%h failed.", A);
			$display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
		end
		
		if(C != 0 && Flags != 5'b00000)		//If the flags are set incorrectly.
		begin
			passed = 0;
		   $display("!%h failed.", A);
			$display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
		
	end
	
	//Test LSH.
	aluControl = 16'b0000_1111_1000_0000;
	
	for(i = 0; i < 10; i = i+1)
	begin
		
		#10;
		A = $random(seed) % 65535;
		B = $random(seed) % 65535;
		#10;
		
		passed = 1;		//Assume success.
		
		
		
		if(A << 1 != C)		//If the result is incorrect:
		begin
			passed = 0;
		   $display("%h LSH, is incorrect: %h.", A, C);
		end
		
		if(C == 0 && Flags != 5'b10000)		//If the flags are set incorrectly.
		begin
			passed = 0;
		   $display("%h LSH, is incorrect: %h.", A, C);
			$display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
		end
		
		if(C != 0 && Flags != 5'b00000)		//If the flags are set incorrectly.
		begin
			passed = 0;
		   $display("%h LSH, is incorrect: %h.", A, C);
			$display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
		
	end
	
	//Test LSHI. 0011_xxxx
	aluControl = 16'b0011_0000_1010_1111;
	
	for(i = 0; i < 10; i = i+1)
	begin
		
		#10;
		A = $random(seed) % 65535;
		B = $unsigned($random(seed)) % 255;
		
		aluControl[11:8] = B[7:4];
		aluControl[3:0] = B[3:0];
		
		#10;
		
		passed = 1;		//Assume success.
		
		
		
		if(A << B != C)		//If the result is incorrect:
		begin
			passed = 0;
		   $display("%h << %h, is incorrect: %h.", A, B, C);
		end
		
		if(C == 0 && Flags != 5'b10000)		//If the flags are set incorrectly.
		begin
			passed = 0;
		   $display("%h << %h, is incorrect: %h.", A, B, C);
			$display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
		end
		
		if(C != 0 && Flags != 5'b00000)		//If the flags are set incorrectly.
		begin
			passed = 0;
		   $display("%h << %h, is incorrect: %h.", A, B, C);
			$display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
		
	end
	
	//Test RSH.
	aluControl = 16'b0000_1111_1010_0000;
	
	for(i = 0; i < 10; i = i+1)
	begin
		
		#10;
		A = $random(seed) % 65535;
		B = $random(seed) % 65535;
		#10;
		
		passed = 1;		//Assume success.
		
		
		
		if(A >> 1 != C)		//If the result is incorrect:
		begin
			passed = 0;
		   $display("%h RSH, is incorrect: %h.", A, C);
		end
		
		if(C == 0 && Flags != 5'b10000)		//If the flags are set incorrectly.
		begin
			passed = 0;
		   $display("%h RSH, is incorrect: %h.", A, C);
			$display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
		end
		
		if(C != 0 && Flags != 5'b00000)		//If the flags are set incorrectly.
		begin
			passed = 0;
		   $display("%h RSH, is incorrect: %h.", A, C);
			$display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
		
	end
	
	//Test RSHI. 1110_xxxx
	aluControl = 16'b1110_1111_1010_0000;
	
	for(i = 0; i < 10; i = i+1)
	begin
		
		#10;
		A = $random(seed) % 65535;
		B = $unsigned($random(seed)) % 255;

		aluControl[11:8] = B[7:4];
		aluControl[3:0] = B[3:0];
		
		#10;
		
		passed = 1;		//Assume success.
		
		
		
		if(A >> B != C)		//If the result is incorrect:
		begin
			passed = 0;
		   $display("%h >> %h, is incorrect: %h.", A, B, C);
		end
		
		if(C == 0 && Flags != 5'b10000)		//If the flags are set incorrectly.
		begin
			passed = 0;
		   $display("%h >> %h, is incorrect: %h.", A, B, C);
			$display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
		end
		
		if(C != 0 && Flags != 5'b00000)		//If the flags are set incorrectly.
		begin
			passed = 0;
		   $display("%h >> %h, is incorrect: %h.", A, B, C);
			$display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
		
	end
	
	//Test ALSH.
	aluControl = 16'b0000_1111_1100_1111;
	
	for(i = 0; i < 10; i = i+1)
	begin
		
		#10;
		A = $random(seed) % 65535;
		B = $random(seed) % 65535;
		#10;
		
		passed = 1;		//Assume success.
		
		
		
		if(A << 1 != C)		//If the result is incorrect:
		begin
			passed = 0;
		   $display("%h LSH, is incorrect: %h.", A, C);
		end
		
		if(C == 0 && Flags != 5'b10000)		//If the flags are set incorrectly.
		begin
			passed = 0;
		   $display("%h LSH, is incorrect: %h.", A, C);
			$display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
		end
		
		if(C != 0 && Flags != 5'b00000)		//If the flags are set incorrectly.
		begin
			passed = 0;
		   $display("%h LSH, is incorrect: %h.", A, C);
			$display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
		
	end
	
	//Test ARSH.
	aluControl = 16'b0000_1111_1110_0000;
	
	for(i = 0; i < 10; i = i+1)
	begin
		
		#10;
		A = $random(seed) % 65535;
		B = $random(seed) % 65535;
		#10;
		
		passed = 1;		//Assume success.
		
		
		if(C == 0 && Flags != 5'b10000)		//If the flags are set incorrectly.
		begin
			passed = 0;
		   $display("%h ARSH, is incorrect: %h.", A, C);
			$display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
		end
		
		if(C != 0 && Flags != 5'b00000)		//If the flags are set incorrectly.
		begin
			passed = 0;
		   $display("%h ARSH, is incorrect: %h.", A, C);
			$display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
		end
		
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
		
	end
	
	//Test NOP.opcode
	aluControl = 16'b0000_0000_0000_0000;
	
	for(i = 0; i < 10; i = i+1)
	begin
		
		#10;
		A = $random(seed) % 65535;
		B = $random(seed) % 65535;
		#10;
		
		passed = 1;		//Assume success.

		
		
		if(Flags != 5'b00000)		//If the flags are set incorrectly.
		begin
			passed = 0;
		   $display("NOP has failed.");
			$display("Flags are incorrectly set: Z = %b, C = %b, F = %b, N = %b, L = %b", Flags[4], Flags[3], Flags[2], Flags[1], Flags [0]);
		end
		
		//Record pass/fail.
		if(passed == 0)
			numFail = numFail + 1;
		else
			numPass = numPass + 1;
		
	end
	
	
	//REPORT TOTALS
	$display("************************************************** ");
	$display("Num pass: %d", numPass);
	$display("Num fails: %d", numFail);
		
	end
	
	
      
endmodule

