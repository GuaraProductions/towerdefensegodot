extends Node2D
class_name GerenciadorPopups

signal nova_acao(acao: int, area_spawn: AreaSpawn)

enum Acoes {
	ADICIONAR_TORRE,
	ADICIONAR_MUNICAO,
	REMOVER_TORRE,
	MELHORAR_TORRE,
	RECARREGAR_TORRE
}

@onready var popup_menu: PopupMenu = %PopupMenu

var fase : Fase
var area_selecionada

func _ready() -> void:
	
	fase = get_parent()
	
	popup_menu.visible = false

	var areas_spawn = get_tree().get_nodes_in_group(AreaSpawn.NOME_GRUPO)
	
	for area_spawn in areas_spawn:
		
		area_spawn.foi_clicado.connect(_area_spawn_foi_clicado.bind(area_spawn))
		
func _area_spawn_foi_clicado(area: AreaSpawn) -> void:
	
	print("_area_spawn_foi_clicado")
	
	popup_menu.clear(true)
	area_selecionada = area
	
	var mouse_position = get_viewport().get_mouse_position()
	
	_construir_popup(area.estrutura_spawnada)
	
	popup_menu.position = mouse_position
	popup_menu.visible = true
		
func _construir_popup(estrutura: Node2D) -> void:
	
	if not estrutura:
		popup_menu.add_item("Adicionar torre", Acoes.ADICIONAR_TORRE)
		return

	popup_menu.add_item("Adicionar Munição", Acoes.ADICIONAR_MUNICAO)
	var index = popup_menu.get_item_index(Acoes.ADICIONAR_MUNICAO)
	popup_menu.set_item_disabled(index, not estrutura.pode_recarregar(fase.carteira))

	popup_menu.add_item("Remover Torre", Acoes.REMOVER_TORRE)
	
	popup_menu.add_item("Melhorar Torre", Acoes.MELHORAR_TORRE)
	
	index = popup_menu.get_item_index(Acoes.MELHORAR_TORRE)
	popup_menu.set_item_disabled(index, not estrutura.pode_fazer_upgrade(fase.carteira))

func _on_popup_menu_id_pressed(id: int) -> void:
	nova_acao.emit(id, area_selecionada)
