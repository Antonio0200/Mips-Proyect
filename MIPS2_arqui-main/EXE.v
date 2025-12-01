`timescale 1ns/1ns
module EXE (
    // Desde Buffer2 (ID/EX)
    input [31:0] pc_plus4_EX,
    input [31:0] dr1_EX,
    input [31:0] dr2_EX,
    input [31:0] inmediato_ext_EX,
    input [4:0]  rt_EX,
    input [4:0]  rd_EX,
    input [5:0]  funct_EX,

    // Controles desde ID/EX
    input reg_escribir_EX,
    input mem_a_reg_EX,
    input mem_escribir_EX,
    input mem_leer_EX,
    input branch_EX,
    input alu_fuente_EX,
    input [1:0] alu_operacion_EX,

    // Salidas hacia EX/MEM
    output [31:0] resultado_alu_EX_out,
    output [31:0] dr2_forward_EX_out,
    output [4:0]  registro_destino_EX_out,
    output branch_habilitado_EX_out,
    output [31:0] branch_target_EX_out,

    // Señales de control reenviadas hacia MEM
    output reg reg_escribir_MEM_ctrl,
    output reg mem_a_reg_MEM_ctrl,
    output reg mem_escribir_MEM_ctrl,
    output reg mem_leer_MEM_ctrl
);

    always @(*) begin
        reg_escribir_MEM_ctrl = reg_escribir_EX;
        mem_a_reg_MEM_ctrl    = mem_a_reg_EX;
        mem_escribir_MEM_ctrl = mem_escribir_EX;
        mem_leer_MEM_ctrl     = mem_leer_EX;
    end


    multiuno mux_regdst (
        .A(rt_EX),
        .B(rd_EX),
        .sel(alu_operacion_EX == 2'b10),
        .S(registro_destino_EX_out)
    );

    wire [31:0] entrada_b_alu;

    multidos mux_alusrc (
        .A2(dr2_EX),
        .B2(inmediato_ext_EX),
        .sel2(alu_fuente_EX),
        .S2(entrada_b_alu)
    );
	
    wire [3:0] control_alu_w;

    alu_control alu_ctrl (
        .operacion_alu(alu_operacion_EX),
        .funcion(funct_EX),
        .funcion_alu(control_alu_w)
    );

    wire cero_flag;

    alu alu_unit (
        .entrada_a(dr1_EX),
        .entrada_b(entrada_b_alu),
        .control_alu(control_alu_w),
        .resultado(resultado_alu_EX_out),
        .cero(cero_flag)
    );

    wire [31:0] immediate_shifted = inmediato_ext_EX << 2;

    sumador_branch sum_branch (
        .pc_mas_4(pc_plus4_EX),
        .sign_extend(immediate_shifted),
        .result_add(branch_target_EX_out)
    );

    and_zero and_branch (
        .branch(branch_EX),
        .cero(cero_flag),
        .branch_habilitado(branch_habilitado_EX_out)
    );


    assign dr2_forward_EX_out = dr2_EX;

endmodule
