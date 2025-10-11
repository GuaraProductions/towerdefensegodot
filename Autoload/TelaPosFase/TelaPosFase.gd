extends CanvasLayer
class_name TelaPosFase

signal pedido_para_resetar_fase()
signal pediu_para_sair_do_jogo()
signal ir_para_a_proxima_fase()

@onready var tela_vitoria: PanelContainer = %TelaVitoria
@onready var tela_game_over: PanelContainer = %TelaGameOver
@onready var proxima_fase: Button = %ProximaFase

func esconder_telas() -> void:
	tela_game_over.visible = false
	tela_vitoria.visible = false

func desativar_proxima_fase() -> void:
	proxima_fase.visible = false

func mostrar_game_over() -> void:
	get_tree().paused = true
	layer = 2
	tela_game_over.visible = true
	
func mostrar_voce_venceu() -> void:
	get_tree().paused = true
	layer = 2
	tela_vitoria.visible = true

func _on_proxima_fase_pressed() -> void:
	tela_vitoria.visible = false
	ir_para_a_proxima_fase.emit()

func _on_sair_pressed() -> void:
	tela_game_over.visible = false
	tela_vitoria.visible = false
	pediu_para_sair_do_jogo.emit()

func _on_tentar_novamente_pressed() -> void:
	tela_game_over.visible = false
	pedido_para_resetar_fase.emit()
