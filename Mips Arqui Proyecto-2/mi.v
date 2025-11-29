`timescale 1ns/1ns
module mi(
input clk_mi,
input reset_mi,
output [31:0]salida_mi,
output [31:0]salida_mi2,
output [3:0]salida_mi3
);
wire [31:0] cablem1, cablem2, cablem3, cablem4;
wire [3:0] cablem5;

ciclo_fetch inst1m(
.clk(clk_mi),
.rst_tb(reset_mi),
.instruccion_fetch(cablem1)
);

buf1 inst2m(
.clk_buf1(clk_mi),
.reset_buf1(reset_mi),
.ciclof_in(cablem1),
.buf1_out(cablem2)
);

burrote inst3m(
.instruccion (cablem2),
.sel2(1'b0), 
.sel(1'b0),
.salida1(cablem3),
.salida2(cablem4),
.salida3(cablem5)
);

buf2 inst4m(
.clk_buf2(clk_mi),
.reset_buf2(reset_mi),
.deco_in(cablem3),
.deco_in2(cablem4),
.alu_func_in(cablem5),
. buf2_out(salida_mi),
. buf2_out2(salida_mi2),
.alu_func_out(salida_mi3)
);
endmodule 
