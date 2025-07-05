extends PathFollow2D
class_name Inimigo

signal assassinado()

const GRUPO_NOME := "Inimigo"
const VIDA_MAXIMO := 100.0

@onready var barra_de_vida : ProgressBar = %BarraDeVida
@onready var sprite : Sprite2D = %Sprite

@export var velocidade : float = 55.0
@export var rotacao_velocidade : float = 15.0
@export var vida : float = VIDA_MAXIMO : set = tomou_dano
@export var dano : float = 5
@export var recompensa_dinheiro := 10
@onready var area: InimigoArea = $Area

var diminuidor_de_vida : float = 0.0
var diminuidor_step : float = 0.15

var modo_teste : bool = false

func _ready() -> void:
	add_to_group(GRUPO_NOME)
	barra_de_vida.value = vida
	area.dano_inimigo = dano
	
	if modo_teste:
		progress_ratio = 0.85
		dano = 100
		area.dano_inimigo = dano

func get_recompensa() -> int:
	return recompensa_dinheiro

func tomou_dano(nova_vida: float) -> void:

	barra_de_vida.value = nova_vida
	vida = nova_vida

	if vida <= 0:
		assassinado.emit()
		queue_free()

func _physics_process(delta: float) -> void:
	_atualizar_angulo(delta)
	
func _atualizar_angulo(delta: float) -> void:
	var posicao_antes = global_position
	progress += velocidade * delta
	var posicao_depois = global_position
	
	var angulo_direcao = _calcular_angulo(posicao_antes, posicao_depois)
	sprite.rotation = \
	 lerp_angle(sprite.rotation, angulo_direcao, rotacao_velocidade * delta)

func _calcular_angulo(posicao1: Vector2, 
					  posicao2: Vector2) -> float:

	var direcao = (posicao2 - posicao1).normalized()
	
	return direcao.angle()
