`timescale  1ns/1ns
module buf1(
	input clk_buf1,
	input reset_buf1,
	input [31:0]ciclof_in,
	output reg [31:0] buf1_out
);
always @(posedge clk_buf1 or posedge reset_buf1)
	begin
		if(reset_buf1)
		begin
		buf1_out = 32'b0;
		end
		else
		begin
		buf1_out=ciclof_in;
		end
	end
endmodule
