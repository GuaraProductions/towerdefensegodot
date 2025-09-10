extends Resource
class_name SpawnInimigo

## Tempo exato onde o spawn do inimigo vai comecar, 
## esse tempo eh relativo ao tempo inicial da wave
@export var duracao : float = 0.0
@export var quantidade : int = 1
@export var possiveis_inimigos : Array[InimigosCache.PossiveisInimigos]

var spawnar_continuamente: bool : get = _get_spawnar_continuamente
var intervalo_entre_spawns: float : get = _intervalo_entre_spawns

var restante: int = -1

func _get_spawnar_continuamente() -> bool:
	return quantidade > 1
	
func _intervalo_entre_spawns() -> float:
	return duracao / quantidade

func _init(p_duracao : float = 0.0, 
		   p_quantidade : int = 0,
		   p_possiveis_inimigos : Array[InimigosCache.PossiveisInimigos] = []) -> void:
	duracao = p_duracao
	quantidade = p_quantidade
	possiveis_inimigos = p_possiveis_inimigos

func pegar_inimigo_aleatorio() -> InimigosCache.PossiveisInimigos:
	
	if restante == -1:
		restante = quantidade
	
	if restante < 1:
		return InimigosCache.PossiveisInimigos.NaoDefinido
		
	restante -= 1
	return possiveis_inimigos.pick_random()

func pode_spawnar() -> bool:
	return restante >= 1

func _to_string() -> String:
	return "[SpawnInimigo]: duracao: %s\nquantidade: %d\n possiveis_inimigos: %s" % \
	 [str(duracao).pad_decimals(2), quantidade, str(possiveis_inimigos)]
