module VGA_Controller(clock, hSync, vSync, RED, BLUE, GREEN, vga_blank, vga_clock);

input clock;
output reg hSync = 1'b1;
output reg vSync = 1'b1;
output reg [7:0] RED;
output reg [7:0] BLUE;
output reg [7:0] GREEN;
output reg vga_blank = 1'b0;
output reg vga_clock;

reg q;
reg RGB;
reg slow_clock;

integer x_count = 0;
integer y_count = 0;

integer x_max = 800;
integer y_max = 521;

//50MHz -> 25MHz
always@(posedge clock)
	begin
		q <= ~q;
		slow_clock <= q;
		vga_clock <= slow_clock;
	end

always@(posedge slow_clock)
	begin
		//increment until 800
		if(x_count <= x_max)
			begin
			x_count <= x_count + 1;
			end
		//once we've reached the max, reset x
		else
			begin
			x_count <= 0;
			end
		//once we've reached the horizontal end
		if(x_count == x_max)
			begin
			//if we're not at the vertical end, increment y
			if(y_count <= y_max)
				begin
				y_count <= y_count + 1;
				end
			else
			//if we are at the vertical end, reset y
				begin
				y_count <= 0;
				end
			end
		
		//start displaying
		if((x_count > 0 && x_count < 640) && (y_count > 0 && y_count < 480))
			begin
			RED <= 8'b1111_1111;
			GREEN <= 8'b0000_0000;
			BLUE <= 8'b0000_0000;
			vga_blank <= 1'b1;
			end
		else
			begin
			vga_blank <= 1'b0;
			end
		//if we've reached the horizontal end, reset hSync
		if(x_count > 640 + 16 && x_count < 640 + 16 + 96)
			begin
			hSync <= 1'b0;
			end
		else
			begin
			hSync <= 1'b1;
			end
		//if we've reached the horizontal end and the vertical end, reset vSync and hSync
		if(y_count == 480 && x_count == x_max)
			begin
			vSync <= 1'b0;
			end
		else
			begin
			hSync <= 1'b1;
			end
	end
endmodule