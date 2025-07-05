extends Node
class_name InimigosCache

enum PossiveisInimigos {
	TanqueCinza,
	TanqueVermelho
}

@export var inimigos : Array[PackedScene]

func pegar_inimigo_instancia(inimigo_idx: int) -> PackedScene:
	if inimigo_idx < 0 or inimigo_idx > inimigos.size():
		return null
		
	return inimigos[inimigo_idx]
