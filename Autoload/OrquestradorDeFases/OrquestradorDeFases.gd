extends Node

const MENU_PRINCIPAL : PackedScene = preload("res://Cenas/UI/MenuPrincipal/OrquestradorMenus.tscn")

@export_category("Debug")
@export var iniciar_fase_modo_teste: bool = false

@onready var game_ui: GameUI = $GameUI

var fase_atual : Fase = null

var indice_atual : int = -1
var todas_as_fases : Array[PackedScene] = []

func _ready() -> void:
	game_ui.visible = false

func iniciar_ciclo_de_fases(fase_indice: int, 
							n_todas_as_fases: Array[PackedScene]) -> void:

	todas_as_fases = n_todas_as_fases
	indice_atual = fase_indice

	if fase_indice < 0 or fase_indice >= todas_as_fases.size():
		printerr("Fase indice invalido!")
		_resetar_parametros()
		return

	get_tree().current_scene.queue_free()

	_comecar_fase()

func _on_game_ui_pedido_para_resetar_fase() -> void:
	if fase_atual:
		fase_atual.resetar_fase()

func _on_game_ui_pediu_para_sair_do_jogo() -> void:
	
	if not fase_atual:
		printerr("Nenhuma fase foi carregada!")
		return
		
	fase_atual.queue_free()
	fase_atual = null
	
	if not MENU_PRINCIPAL.can_instantiate():
		printerr("Menu principal nao esta configurado!")
	
	var menu_principal = MENU_PRINCIPAL.instantiate()
	
	menu_principal.tree_entered.connect(get_tree().set_current_scene.bind(menu_principal), CONNECT_ONE_SHOT)
	
	get_tree().root.add_child(menu_principal)

func _on_game_ui_ir_para_a_proxima_fase() -> void:
	
	indice_atual += 1
	
	_comecar_fase()
	
func _comecar_fase() -> void:
	
	if fase_atual:
		fase_atual.queue_free()
		fase_atual = null
	
	fase_atual = todas_as_fases[indice_atual].instantiate()
	
	fase_atual.tree_entered.connect(get_tree().set_current_scene.bind(fase_atual), CONNECT_ONE_SHOT)
	
	fase_atual.modo_teste = false
	get_tree().root.add_child(fase_atual)

	fase_atual.iniciar_fase(game_ui)
	
	game_ui.visible = true
	get_tree().paused = false
	game_ui.resetar_interface()
	
func _resetar_parametros() -> void:
	indice_atual = -1
	todas_as_fases = []
