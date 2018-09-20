module Mux_Two_One(muxEnable, register, immediate, out);

input muxEnable;
input [15:0] register, immediate; //will this sign extend immediate?
output reg [15:0] out;

always @(muxEnable, register, immediate)
begin

	case (muxEnable)

		1'b0:
					out = register;
		1'b1:
					out = immediate;
		default: 
					out = 16'b0000_0000_0000_0000;
	endcase
end

endmodule 