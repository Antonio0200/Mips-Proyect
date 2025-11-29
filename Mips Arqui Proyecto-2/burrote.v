`timescale 1ns/1ns 
module burrote (
    input clk,
    input [31:0] instruccion,
    input reg_escribir,
    input [4:0] registro_escribir,
    input [31:0] dato_escribir,
    input destino_reg,
    input alu_fuente,
    input [1:0] alu_op,
    input mem_escribir,
    input mem_leer,
    input mem_a_reg,
    input branch,
    input salto,
    output reg [31:0] salida1,
    output reg [31:0] salida2,	
    output reg [3:0] salida3,
    output reg [31:0] inmediato_ext,
    output reg [4:0] rt_salida,
    output reg [4:0] rd_salida,
    output reg [5:0] opcode_salida,
    output reg [5:0] funct_salida
);

wire [31:0] c1;
wire [4:0] c2;
wire [31:0] dr1_internal;
wire [3:0] alu_func_internal;
wire [31:0] salida2_int;
wire [31:0] extendido;

multiuno instb1(
    .A(instruccion[20:16]),
    .B(instruccion[15:11]),
    .sel(destino_reg),
    .S(c2)
);

bancoRegistros instb2(
    .clk(clk),
    .reg_escribir(reg_escribir),
    .rs(instruccion[25:21]),
    .rt(instruccion[20:16]),
    .rd(registro_escribir),
    .dato_escribir(dato_escribir),
    .dr1(dr1_internal),
    .dr2(c1)
);

multidos instb3(
    .A2(c1),
    .B2(extendido),
    .sel2(alu_fuente),
    .S2(salida2_int)
);

extension_signo instb5(
    .inmediato(instruccion[15:0]),
    .extendido(extendido)
);

alu_control instb4 (
    .operacion_alu(alu_op),
    .funcion(instruccion[5:0]),
    .funcion_alu(alu_func_internal)
);

always @(*) begin
    salida1 = dr1_internal;
    salida2 = salida2_int;
    salida3 = alu_func_internal;
    inmediato_ext = extendido;
    rt_salida = instruccion[20:16];
    rd_salida = instruccion[15:11];
    opcode_salida = instruccion[31:26];
    funct_salida = instruccion[5:0];
end

endmodule
