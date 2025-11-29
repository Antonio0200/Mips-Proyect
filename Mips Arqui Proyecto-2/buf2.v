`timescale  1ns/1ns
module buf2(
	input clk_buf2,
	input reset_buf2,
	input [31:0]deco_in,
	input [31:0]deco_in2,
	input [3:0] alu_func_in,
	output reg [31:0] buf2_out,
	output reg [31:0] buf2_out2,
	output reg [3:0] alu_func_out
);
always @(posedge clk_buf2 or posedge reset_buf2)
	begin
		if(reset_buf2)
		begin
		buf2_out = 32'b0;
		buf2_out2= 32'b0;
		alu_func_out= 4'b0;
		end
		else
		begin
		buf2_out=deco_in;
		buf2_out2=deco_in2;
		alu_func_out= alu_func_in;
		end
	end
endmodule
