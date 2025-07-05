extends Node2D
class_name TorreGenerica

@export_category("Nodes")
@export var raycast : RayCast2D
@export var barra_de_progresso_municao : ProgressBar
@export var node_textura_upgrade : Sprite2D
@export var area_detector_inimigos : Area2D

@export_category("Características")
@export var rotacao_velocidade : float = 15.0
@export var tempo_espera : float = 0.7
@export var municao_inicial : int = 100
@export var municao_maxima : int = 500
@export var texturas_upgrade : Array[Texture2D] = []
@export var preco_upgrade : float = 25
@export var dano := 15.5

var municao := 50

var inimigos : Array[Area2D] = []
var inimigo_atual : Area2D = null

var pronta_pra_atirar : bool = true

var frequencia_tiro : Timer = null

var nivel_ugprade : int

var permitido_upgrades : bool

func _ready() -> void:
	nivel_ugprade = -1
	permitido_upgrades = true
	municao = municao_inicial
	
	barra_de_progresso_municao.max_value = municao_maxima
	barra_de_progresso_municao.value = municao_inicial
	
	frequencia_tiro = Timer.new()
	frequencia_tiro.wait_time = tempo_espera
	frequencia_tiro.timeout.connect(_on_frequencia_de_tiro_timeout)
	add_child(frequencia_tiro)
	
	area_detector_inimigos.area_entered.connect(_on_detector_inimigos_area_entered)
	area_detector_inimigos.area_exited.connect(_on_detector_inimigos_area_exited)

func _process(delta: float) -> void:
	
	if inimigos.size() == 0:
		return
	
	_olhar_para_inimigo(delta)
	
	if pronta_pra_atirar and municao > 0:
		_atirar()
	
func fazer_upgrade() -> void:
	nivel_ugprade += 1
	
	node_textura_upgrade.texture = texturas_upgrade[nivel_ugprade]
	
func pode_fazer_upgrades() -> bool:
	return permitido_upgrades
	
func _atirar() -> void:
	pronta_pra_atirar = false
	municao -= 1
	barra_de_progresso_municao.value -= 1
	
	inimigo_atual.tomou_dano(dano)
	print("atirou")
	frequencia_tiro.start()

func _olhar_para_inimigo(delta: float) -> void:
	var angulo_pro_inimigo = _calcular_angulo(global_position, inimigo_atual.global_position)
	raycast.rotation = \
	lerp_angle(raycast.rotation, angulo_pro_inimigo, rotacao_velocidade * delta)

func _calcular_angulo(posicao1: Vector2, 
					  posicao2: Vector2) -> float:

	var direcao = (posicao2 - posicao1).normalized()
	
	return direcao.angle()

func _on_detector_inimigos_area_entered(area: Area2D) -> void:
	if area not in inimigos:
		inimigos.append(area)
	inimigo_atual = inimigos[0]

func _on_detector_inimigos_area_exited(area: Area2D) -> void:
	inimigos.erase(area)
	if inimigos.size() != 0:
		inimigo_atual = inimigos[0]

func _on_frequencia_de_tiro_timeout() -> void:
	print("pronto!")
	pronta_pra_atirar = true
	frequencia_tiro.stop()
