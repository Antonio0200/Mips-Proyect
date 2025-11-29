`timescale 1ns/1ns
module corrimiento_izq2(
    input [31:0] entrada_dato,
    output reg [31:0] salida_dato
);

always @(*) begin
    salida_dato = {entrada_dato[29:0], 2'b00};
end

endmodule
