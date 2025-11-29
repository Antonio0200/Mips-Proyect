`timescale 1ns/1ns
module memoria_instrucciones(
	input [7:0] dir,
	output reg [31:0] inst
);
reg [7:0] memoria [0:255]; 

initial
	begin
	memoria[0] = 8'b00010010; 
        memoria[1] = 8'b00110100; 
        memoria[2] = 8'b01010110; 
        memoria[3] = 8'b01111000; 
	memoria[4] = 8'b10101010; 
        memoria[5] = 8'b10111011; 
        memoria[6] = 8'b11001100; 
        memoria[7] = 8'b11011101; 
	end

always @*
	begin
	inst = {memoria[dir], memoria[dir+1], memoria[dir+2], memoria[dir+3]};
	end
endmodule
