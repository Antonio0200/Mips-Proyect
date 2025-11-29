`timescale 1ns/1ns
module mips_pipeline(
    input clk,
    input reset,
    output [31:0] resultado_final
);

// === WIRES ENTRE ETAPAS ===
// IF
wire [31:0] pc_actual, instruccion_actual;

// IF/ID
wire [31:0] if_id_instruccion;

// ID
wire [31:0] id_read_data1, id_read_data2, id_immediato_ext;
wire [3:0] id_alu_control;
wire [4:0] id_rt, id_rd;
wire [5:0] id_opcode, id_funct;

// ID/EX
wire [31:0] ex_read_data1, ex_read_data2, ex_immediato_ext;
wire [3:0] ex_alu_control;
wire [4:0] ex_rt, ex_rd;
wire [5:0] ex_opcode, ex_funct;

// EX
wire [31:0] ex_alu_result;
wire ex_zero;

// EX/MEM
wire [31:0] mem_alu_result, mem_write_data;
wire [4:0] mem_write_reg;
wire mem_zero;

// MEM
wire [31:0] mem_read_data;

// MEM/WB
wire [31:0] wb_alu_result, wb_mem_read_data;
wire [4:0] wb_write_reg;

// WB
wire [31:0] wb_write_data;

// === SEÑALES DE CONTROL ===
wire destino_reg, branch, mem_leer, mem_a_reg;
wire [1:0] alu_op;
wire mem_escribir, alu_fuente, reg_escribir, salto;

// === ETAPA IF ===
ciclo_fetch inst_fetch(
    .clk(clk),
    .rst_tb(reset),
    .instruccion_fetch(instruccion_actual)
);

// === BUFFER IF/ID ===
buf1 if_id_buffer(
    .clk_buf1(clk),
    .reset_buf1(reset),
    .ciclof_in(instruccion_actual),
    .buf1_out(if_id_instruccion)
);

// === UNIDAD DE CONTROL ===
unidad_control control_principal(
    .codigo_operacion(if_id_instruccion[31:26]),
    .destino_reg(destino_reg),
    .branch(branch),
    .mem_leer(mem_leer),
    .mem_a_reg(mem_a_reg),
    .alu_operacion(alu_op),
    .mem_escribir(mem_escribir),
    .alu_fuente(alu_fuente),
    .reg_escribir(reg_escribir),
    .salto(salto)
);

// === ETAPA ID ===
burrote inst_decode(
    .clk(clk),
    .instruccion(if_id_instruccion),
    .reg_escribir(reg_escribir),
    .registro_escribir(wb_write_reg),
    .dato_escribir(wb_write_data),
    .destino_reg(destino_reg),
    .alu_fuente(alu_fuente),
    .alu_op(alu_op),
    .mem_escribir(mem_escribir),
    .mem_leer(mem_leer),
    .mem_a_reg(mem_a_reg),
    .branch(branch),
    .salto(salto),
    .salida1(id_read_data1),
    .salida2(id_read_data2),
    .salida3(id_alu_control),
    .inmediato_ext(id_immediato_ext),
    .rt_salida(id_rt),
    .rd_salida(id_rd),
    .opcode_salida(id_opcode),
    .funct_salida(id_funct)
);

// === BUFFER ID/EX ===
buf_id_ex id_ex_buffer(
    .clk(clk),
    .reset(reset),
    // Señales de control
    .id_alu_op(alu_op),
    .id_alu_fuente(alu_fuente),
    .id_destino_reg(destino_reg),
    .id_mem_escribir(mem_escribir),
    .id_mem_leer(mem_leer),
    .id_mem_a_reg(mem_a_reg),
    .id_reg_escribir(reg_escribir),
    // Datos
    .id_pc_plus_4(32'b0), // Por ahora cero
    .id_read_data1(id_read_data1),
    .id_read_data2(id_read_data2),
    .id_sign_extend(id_immediato_ext),
    .id_rt(id_rt),
    .id_rd(id_rd),
    .id_funct(id_funct),
    // Salidas
    .ex_alu_op(),
    .ex_alu_fuente(),
    .ex_destino_reg(),
    .ex_mem_escribir(),
    .ex_mem_leer(),
    .ex_mem_a_reg(),
    .ex_reg_escribir(),
    .ex_pc_plus_4(),
    .ex_read_data1(ex_read_data1),
    .ex_read_data2(ex_read_data2),
    .ex_sign_extend(ex_immediato_ext),
    .ex_rt(ex_rt),
    .ex_rd(ex_rd),
    .ex_funct(ex_funct)
);

// === ETAPA EX ===
alu inst_alu(
    .entrada_a(ex_read_data1),
    .entrada_b(ex_read_data2),
    .control_alu(ex_alu_control),
    .resultado(ex_alu_result),
    .cero(ex_zero)
);

// === BUFFER EX/MEM ===
buf_ex_mem ex_mem_buffer(
    .clk(clk),
    .reset(reset),
    // Entradas
    .ex_alu_result(ex_alu_result),
    .ex_write_data(ex_read_data2),
    .ex_write_reg(ex_rd),
    .ex_zero(ex_zero),
    // Salidas
    .mem_alu_result(mem_alu_result),
    .mem_write_data(mem_write_data),
    .mem_write_reg(mem_write_reg),
    .mem_zero(mem_zero)
);

// === ETAPA MEM ===
memoria_datos inst_memoria_datos(
    .clk(clk),
    .mem_escribir(mem_escribir),
    .mem_leer(mem_leer),
    .direccion(mem_alu_result),
    .dato_escribir(mem_write_data),
    .dato_leer(mem_read_data)
);

// === BUFFER MEM/WB ===
buf_mem_wb mem_wb_buffer(
    .clk(clk),
    .reset(reset),
    // Entradas
    .mem_alu_result(mem_alu_result),
    .mem_read_data(mem_read_data),
    .mem_write_reg(mem_write_reg),
    // Salidas
    .wb_alu_result(wb_alu_result),
    .wb_mem_read_data(wb_mem_read_data),
    .wb_write_reg(wb_write_reg)
);

// === ETAPA WB ===
mux_32bits wb_mux(
    .sel(mem_a_reg),
    .entrada_a(wb_alu_result),
    .entrada_b(wb_mem_read_data),
    .salida(wb_write_data)
);

assign resultado_final = wb_alu_result;

endmodule
