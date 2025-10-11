extends Node

@export var musica_menu : AudioStream

@onready var seletor_de_fases: Control = $SeletorDeFases
@onready var menu_principal: Control = $MenuPrincipal
@onready var creditos: Control = $Creditos

func _ready() -> void:
	SoundManager.play_music(musica_menu, 1, "Music")
	menu_principal.visible = true
	seletor_de_fases.visible = false

func _on_jogar_pressed() -> void:
	GuiTransitions.go_to("SeletorDeFases")

func _on_voltar_pressed() -> void:
	GuiTransitions.go_to("MenuPrincipal")

func _on_creditos_voltar_pressed() -> void:
	GuiTransitions.go_to("MenuPrincipal")
	
func _on_sair_pressed() -> void:
	get_tree().quit()

func _on_go_to_creditos_pressed() -> void:
	GuiTransitions.go_to("Creditos")

func _on_opcoes_pressed() -> void:
	GuiTransitions.go_to("MasterOptionsMenu")

func _on_back_pressed() -> void:
	GuiTransitions.go_to("MenuPrincipal")
