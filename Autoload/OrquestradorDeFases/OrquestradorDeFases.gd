extends Node

const MENU_PRINCIPAL : PackedScene = preload("res://Cenas/UI/MenuPrincipal/OrquestradorMenus.tscn")

@export var musica_da_fase: AudioStream
@export var musica_vitoria: AudioStream

@export_category("Debug")
@export var iniciar_fase_modo_teste: bool = false

@onready var game_ui: GameUI = $GameUI
@onready var tela_pos_fase: CanvasLayer = %TelaPosFase

var fase_atual : Fase = null

var indice_atual : int = -1
var todas_as_fases : Array[PackedScene] = []

func _ready() -> void:
	game_ui.visible = false
	tela_pos_fase.visible = false
	tela_pos_fase.esconder_telas()

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

func _pedido_para_resetar_fase() -> void:
	tela_pos_fase.visible = false
	if fase_atual:
		fase_atual.resetar_fase()

func _pediu_para_sair_do_jogo() -> void:
	tela_pos_fase.visible = false
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

func _ir_para_a_proxima_fase() -> void:
	tela_pos_fase.visible = false	
	indice_atual += 1
	
	_comecar_fase()
	
func _comecar_fase() -> void:
	
	SoundManager.play_music(musica_da_fase, 2, "Music")
	
	if fase_atual:
		fase_atual.queue_free()
		fase_atual = null
	
	fase_atual = todas_as_fases[indice_atual].instantiate()
	
	fase_atual.tree_entered.connect(get_tree().set_current_scene.bind(fase_atual), CONNECT_ONE_SHOT)
	fase_atual.fase_acabou.connect(fase_atual_acabou)
	
	fase_atual.modo_teste = false
	get_tree().root.add_child(fase_atual)

	fase_atual.iniciar_fase(game_ui)
	
	game_ui.visible = true
	get_tree().paused = false
	game_ui.resetar_interface()
	
func fase_atual_acabou(resultado: Fase.FimFase) -> void:
	tela_pos_fase.visible = true
	match resultado:
		Fase.FimFase.VENCEU:
			SoundManager.play_music(musica_vitoria, 5, "Music")
			if fases_acabou():
				tela_pos_fase.desativar_proxima_fase()
			
			tela_pos_fase.mostrar_voce_venceu()
		Fase.FimFase.PERDEU:
			tela_pos_fase.mostrar_game_over()
		_:
			pass
	
func fases_acabou() -> bool:
	return indice_atual >= todas_as_fases.size()
	
func _resetar_parametros() -> void:
	indice_atual = -1
	todas_as_fases = []
