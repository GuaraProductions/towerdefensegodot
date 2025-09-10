extends Area2D
class_name AreaSpawn

signal foi_clicado()

const NOME_GRUPO : String = "AreaSpawn"

var estrutura_spawnada : Node2D = null

func _ready() -> void:
	add_to_group(NOME_GRUPO)

func _on_mouse_entered() -> void:
	pass
	#print("mouse entrou")

func _on_mouse_exited() -> void:
	pass
	#print("mouse saiu")
	
func _input_event(_viewport: Viewport, 
				  event: InputEvent, 
				  _shape_idx: int) -> void:
					
	if event is InputEventMouseButton \
	 and event.button_index == MOUSE_BUTTON_RIGHT:
		foi_clicado.emit()

func spawnar_estrutura(torre: TorreInfo) -> void:
	estrutura_spawnada = torre.instanciar_torre()
	print("aqui?")
	add_child(estrutura_spawnada)
	
func despawnar_estrutura() -> void:
	if estrutura_spawnada:
		remove_child(estrutura_spawnada)
		estrutura_spawnada.queue_free()
		estrutura_spawnada = null
		
func recarregar_estrutura() -> void:
	if estrutura_spawnada and \
		estrutura_spawnada.has_method("recarregar_estrutura"):
			estrutura_spawnada.recarregar_estrutura()
	
func fazer_upgrade() -> void:
	if estrutura_spawnada and \
		estrutura_spawnada.has_method("fazer_upgrade"):
			estrutura_spawnada.fazer_upgrade()

func estrutura_get_preco_upgrade() -> int:
	if estrutura_spawnada and \
		"preco_upgrade" in estrutura_spawnada:
			return estrutura_spawnada.preco_upgrade

	return -1
	
func estrutura_get_preco_recarregar() -> int:
	if estrutura_spawnada and \
		"preco_recarregar" in estrutura_spawnada:
			return estrutura_spawnada.preco_recarregar

	return -1
