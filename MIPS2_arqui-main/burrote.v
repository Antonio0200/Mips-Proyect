`timescale 1ns/1ns 
module burrote (
    input clk,
    input [31:0] instruccion,
    input [31:0] pc_plus4_out,
    input [31:0] dato_escribir,
    output reg salto_uc,
    output reg branch_uc,
    output reg mem_leer_uc,
    output reg mem_a_reg_uc,
    output reg mem_escribir_uc,
    output reg alu_fuente_uc,
    output reg [1:0] alu_operacion_uc,
    output reg [31:0] salida_corrimiento,   
    output reg [31:0] dr1_salida,
    output reg [31:0] dr2_salida,
    output reg [31:0] salida_ext,
    output reg [5:0] funct_out,
	output reg [31:0] pc_plus4_ID

);

wire u1, u2;  
wire [4:0] c1;
wire [31:0] jump_address;

unidad_control instb0(
    .codigo_operacion(instruccion[31:26]),
    .destino_reg(u1),
    .salto(salto_uc),
    .branch(branch_uc),
    .mem_leer(mem_leer_uc),
    .mem_a_reg(mem_a_reg_uc),
    .alu_operacion(alu_operacion_uc),
    .mem_escribir(mem_escribir_uc),
    .alu_fuente(alu_fuente_uc),
    .reg_escribir(u2)
);

corrimiento_izq2 instb1(
    .entrada_dato({6'b0, instruccion[25:0]}),
    .salida_dato(salida_corrimiento)
);

assign jump_address = {
    pc_plus4_out[31:28],
    salida_corrimiento[27:0]
};

multiuno instb2(
    .A(instruccion[20:16]),
    .B(instruccion[15:11]),
    .sel(u1),
    .S(c1)
);

bancoRegistros instb3(
    .clk(clk), 
    .reg_escribir(u2),
    .rs(instruccion[25:21]),
    .rt(instruccion[20:16]),
    .rd(c1),
    .dato_escribir(dato_escribir),
    .dr1(dr1_salida),
    .dr2(dr2_salida)
);

extension_signo instb4(
    .inmediato(instruccion[15:0]),
    .extendido(salida_ext)
);

always @(*) begin
    funct_out = instruccion[5:0];
	pc_plus4_ID = pc_plus4_out;
end

endmodule
