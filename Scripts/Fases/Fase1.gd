extends Node2D
class_name Fase

enum FimFase {
	PERDEU,
	VENCEU
}

signal fase_acabou(fim_fase_estado: FimFase)

@export_category("Propriedades da fase")
@export var DINHEIRO_MAXIMO : int = 500
@export var modo_teste: bool = false

@export_category("Jogador")
@export var vida_inicial : float = 100 
@export var dinheiro_inicial : int = 50 

@export_category("Nós necessários")
@export var camera_player: CharacterBody2D 
@export var caminho_inimigos: CaminhoInimigos
@export var game_ui: GameUI
@export var movimento_camera: CanvasLayer
@export var gerenciador_popups : GerenciadorPopups
@export var opcoes_de_torres: JanelaOpcoesDeTorres
@export var cache_torres: CacheTorres
@export var blast_node : Node2D


var vida : float : set = _set_vida
var carteira: int : set = _set_carteira

var ponto_inicial_player : Vector2

func _ready() -> void:
	
	if modo_teste:
		iniciar_fase()
	elif game_ui:
		game_ui.queue_free()
		game_ui = null

func _set_vida(n_vida: float) -> void:
	vida = n_vida
	game_ui.atualiza_vida(vida)
	
	if vida <= 0:
		movimento_camera.visible = false
		SoundManager.stop_music(5)
		fase_acabou.emit(FimFase.PERDEU)
	
func _set_carteira(n_carteira: int) -> void:
	carteira = clamp(n_carteira,0, DINHEIRO_MAXIMO)
	game_ui.atualizar_dinheiro(carteira)
	
func _get_vida() -> float:
	return vida

func iniciar_fase(n_game_ui : GameUI = null) -> void:
	
	if not modo_teste:
		game_ui = n_game_ui
		
	carteira = dinheiro_inicial
	vida = vida_inicial
	
	opcoes_de_torres.configurar_opcoes_de_torres(cache_torres.torres_disponíveis)
	
	if not gerenciador_popups.nova_acao.is_connected(_acao_popup_solicitada):
		gerenciador_popups.nova_acao.connect(_acao_popup_solicitada)
	
	vida = vida_inicial
	ponto_inicial_player = camera_player.global_position

	game_ui.configurar_tamanho_vida(vida_inicial)
	game_ui.configurar_tamanho_das_waves(caminho_inimigos.get_waves_tempo_total())
	caminho_inimigos.progresso_wave_avancou.connect(game_ui.atualizar_status_wave)
	caminho_inimigos.fase_terminou.connect(_fase_terminou)
	caminho_inimigos.inimigo_morreu.connect(_inimigo_morreu)

	var pontos_finais = get_tree().get_nodes_in_group(PontoFinalInimigo.GRUPO_NOME)
	
	for ponto in pontos_finais:
		var _err = ponto.inimigo_atingiu_meta.connect(_inimigo_atingiu_meta)
	
func _acao_popup_solicitada(acao: int, area: AreaSpawn) -> void:
	
	match acao:
		GerenciadorPopups.Acoes.ADICIONAR_TORRE:
			opcoes_de_torres.configurar_opcoes_de_torres_disponiveis(carteira)
			
			opcoes_de_torres.popup_centered()
			
			var torre_escolhida : TorreInfo = \
			 await opcoes_de_torres.torre_escolhida
			
			if not torre_escolhida:
				return
				
			if torre_escolhida.preco > carteira:
				return
				
			carteira -= torre_escolhida.preco
			area.spawnar_estrutura(torre_escolhida)
			
		GerenciadorPopups.Acoes.REMOVER_TORRE:
			area.despawnar_estrutura()
			
		GerenciadorPopups.Acoes.MELHORAR_TORRE:
			
			var preco_upgrade = area.estrutura_get_preco_upgrade()
			
			if preco_upgrade > carteira:
				return
				
			carteira -= preco_upgrade
			
			area.fazer_upgrade()
			
		GerenciadorPopups.Acoes.ADICIONAR_MUNICAO:
			
			var preco_recarregar = area.estrutura_get_preco_recarregar()
			
			if preco_recarregar > carteira:
				return
				
			carteira -= preco_recarregar
			
			area.recarregar_estrutura()
	
func _fase_terminou() -> void:
	
	SoundManager.stop_music(5)
	
	await get_tree().create_timer(5).timeout
	
	fase_acabou.emit(FimFase.VENCEU)
	
func resetar_fase() -> void:
	
	carteira = dinheiro_inicial
	vida = vida_inicial
	
	movimento_camera.visible = true
	camera_player.global_position = ponto_inicial_player
	
	caminho_inimigos.resetar_waves()
	
func _inimigo_atingiu_meta(dano: float) -> void:
	vida -= dano
	
func _inimigo_morreu(recompensa: int) -> void:
	carteira += recompensa

func spawn_blast(blast: Node2D) -> void:
	blast_node.add_child(blast)
