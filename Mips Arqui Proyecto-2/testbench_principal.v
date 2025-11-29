`timescale 1ns/1ns
module testbench_principal;

reg clk_tb;
reg reset_tb;
wire [31:0] resultado_tb;

mips_pipeline dut(
    .clk(clk_tb),
    .reset(reset_tb),
    .resultado_final(resultado_tb)
);

initial begin
    clk_tb = 0;
    reset_tb = 1;
    #20 reset_tb = 0;
    
    #200 $display("Resultado final: %h", resultado_tb);
    $finish;
end

always #5 clk_tb = ~clk_tb;

endmodule
