module VGA_Controller(input clock, output reg hSync, vSync, output reg [7:0] RED);

reg q;
reg slow_clock;

integer x_count = 0;
integer y_count = 0;

integer x_max = 800;
integer y_max = 521;

//Initialize sync
hSync = 1'b1;
vSync = 1'b1;


//50MHz -> 25MHz
always@(posedge clock)
	q <= ~q;
	slow_clock <= q;
end

always@(posedge slow_clock)
	//increment until 800
	if(x_count <= xmax)
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
		RGB <= 8'b1111_1111;
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
























//	if(count == 4)
//		begin
//		if(clockCount > (PULSEWIDTH + BACKPORCH) && clockCount < (SYNCPULSE - FRONTPORCH - BACKPORCH - PULSEWIDTH))
//			begin
//			//print out pixels
//			end
//		end
//	else
//		begin c w
//		clockCount <= clockCount + 1;
//		end
//	else
//		begin
//		count <= count + 1;
//		end
endmodule