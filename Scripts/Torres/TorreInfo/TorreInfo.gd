extends Resource
class_name TorreInfo

@export var nome: String = ""
@export_multiline var descricao: String = ""
@export var dano: float = 0.0
@export var frequencia_de_tiro: float = 0.0
@export var preco: int = 0
@export var textura: Texture2D = null
@export var cena: PackedScene = null

func _init(p_nome: String = "",
		   p_descricao: String = "",
		   p_dano: float = 1.0,
		   p_frequencia_de_tiro: float = 1.0,
		   p_textura: Texture2D = null,
		   p_cena: PackedScene = null,
		   p_preco: int = 0) -> void:
	
	nome = p_nome
	descricao = p_descricao
	dano = p_dano
	frequencia_de_tiro = p_frequencia_de_tiro
	textura = p_textura
	cena = p_cena
	preco = p_preco
	
func instanciar_torre() -> Node2D:
	if not cena:
		return null
		
	return cena.instantiate()
