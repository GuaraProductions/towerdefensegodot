extends Node

enum TesteTela {
	Desativado,
	GameOver,
	Vitoria
}

@export var teste_tela : TesteTela = TesteTela.Desativado
@onready var tela_pos_fase: TelaPosFase = %TelaPosFase

func _ready() -> void:

	if teste_tela == TesteTela.GameOver:
		tela_pos_fase.mostrar_game_over()
	elif teste_tela == TesteTela.Vitoria:
		tela_pos_fase.mostrar_game_over()
		

func _on_tela_pos_fase_ir_para_a_proxima_fase() -> void:
	print("_on_tela_pos_fase_ir_para_a_proxima_fase")

func _on_tela_pos_fase_pedido_para_resetar_fase() -> void:
	print("_on_tela_pos_fase_pedido_para_resetar_fase")

func _on_tela_pos_fase_pediu_para_sair_do_jogo() -> void:
	print("_on_tela_pos_fase_pediu_para_sair_do_jogo")
