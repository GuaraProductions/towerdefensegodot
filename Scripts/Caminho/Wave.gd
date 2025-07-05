extends Resource
class_name Wave

@export var delay_inicial : float = 0
@export var spawns_inimigo : Array[SpawnInimigo] = []

var duracao : float = -1 : get = _get_duracao

func _get_duracao() -> float:
	if duracao == -1:
		calcular_duracao_total()
	
	return duracao

func _init(p_delay_inicial:float = 0.0, 
			p_spawns_inimigo : Array[SpawnInimigo] = []) -> void:
	delay_inicial = p_delay_inicial
	spawns_inimigo = p_spawns_inimigo
	
func calcular_duracao_total() -> void:
	duracao = 0
	for spawn in spawns_inimigo:
		duracao += spawn.duracao

func _to_string() -> String:
	return "[Wave]: spawns_inimigo: %s\nduracao: %d" % [spawns_inimigo, duracao]
