extends CanvasLayer
class_name GameUI

signal pedido_para_resetar_fase()
signal pediu_para_sair_do_jogo()
signal ir_para_a_proxima_fase()

@onready var fase_e_player: MarginContainer = $FaseEPlayer
@onready var vida_bar: ProgressBar = %VidaBar
@onready var wave_bar: ProgressBar = %WaveBar
@onready var tela_game_over: PanelContainer = $TelaGameOver
@onready var dinheiro_label: Label = %DinheiroLabel
@onready var tela_vitoria: PanelContainer = $TelaVitoria

func _ready() -> void:
	resetar_interface()
	
func resetar_interface() -> void:
	fase_e_player.visible = true
	tela_game_over.visible = false
	tela_vitoria.visible = false
	wave_bar.value = 0
	vida_bar.value = vida_bar.max_value
	layer = 1

func atualizar_dinheiro(dinheiro: int) -> void:
	dinheiro_label.text = "Dinheiro: %d" % [dinheiro]
	print(dinheiro_label.text)

func configurar_tamanho_vida(vida_total: float) -> void:
	vida_bar.max_value = vida_total

func atualiza_vida(vida: float) -> void:
	vida_bar.value = vida

func mostrar_game_over() -> void:
	get_tree().paused = true
	layer = 2
	fase_e_player.visible = false
	tela_game_over.visible = true
	
func mostrar_voce_venceu() -> void:
	get_tree().paused = true
	layer = 2
	fase_e_player.visible = false
	tela_vitoria.visible = true
	
func configurar_tamanho_das_waves(wave_tempo_total: float) -> void:
	wave_bar.max_value = wave_tempo_total
	
func atualizar_status_wave(wave_status: float) -> void:
	wave_bar.value = wave_status

func _on_tentar_novamente_pressed() -> void:
	layer = 1
	fase_e_player.visible = true
	tela_game_over.visible = false
	get_tree().paused = false
	pedido_para_resetar_fase.emit()

func _on_sair_pressed() -> void:
	get_tree().paused = false
	pediu_para_sair_do_jogo.emit()

func _on_proxima_fase_pressed() -> void:
	ir_para_a_proxima_fase.emit()
