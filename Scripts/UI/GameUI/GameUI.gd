extends CanvasLayer
class_name GameUI

@onready var fase_e_player: MarginContainer = $FaseEPlayer
@onready var vida_bar: ProgressBar = %VidaBar
@onready var wave_bar: ProgressBar = %WaveBar
@onready var dinheiro_label: Label = %DinheiroLabel

func _ready() -> void:
	resetar_interface()
	
func resetar_interface() -> void:
	fase_e_player.visible = true
	wave_bar.value = 0
	vida_bar.value = vida_bar.max_value
	layer = 1

func atualizar_dinheiro(dinheiro: int) -> void:
	dinheiro_label.text = "💲%d" % [dinheiro]
	print(dinheiro_label.text)

func configurar_tamanho_vida(vida_total: float) -> void:
	vida_bar.max_value = vida_total

func atualiza_vida(vida: float) -> void:
	vida_bar.value = vida
	
func configurar_tamanho_das_waves(wave_tempo_total: float) -> void:
	wave_bar.max_value = wave_tempo_total
	
func atualizar_status_wave(wave_status: float) -> void:
	wave_bar.value = wave_status
