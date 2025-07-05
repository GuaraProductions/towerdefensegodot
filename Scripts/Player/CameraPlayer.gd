extends CharacterBody2D

@export var speed: float = 500.0              
@export var fator_zoom : float = 1.1
@export var zoom_limite_inferior : float = 1
@export var zoom_limite_superior : float = 1.68

@onready var limite_inf_dir : Marker2D = %LimiteInferiorDireito
@onready var limite_sup_esq : Marker2D = %LimiteSuperiorEsquerdo

@onready var camera : Camera2D = $Camera2D

@export var controller : CanvasLayer

func _ready() -> void:
	camera.limit_bottom = limite_inf_dir.global_position.y
	camera.limit_left = limite_sup_esq.global_position.x
	camera.limit_right = limite_inf_dir.global_position.x
	camera.limit_top = limite_sup_esq.global_position.y

func _process(delta):
	var dir = controller.mouse_movement_vector
	if dir != Vector2.ZERO:
		velocity = dir * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
	
func _unhandled_input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.zoom.x = clamp(camera.zoom.x * fator_zoom, zoom_limite_inferior, zoom_limite_superior)
			camera.zoom.y = clamp(camera.zoom.y * fator_zoom, zoom_limite_inferior, zoom_limite_superior)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.zoom.x = clamp(camera.zoom.x / fator_zoom, zoom_limite_inferior, zoom_limite_superior)
			camera.zoom.y = clamp(camera.zoom.y / fator_zoom, zoom_limite_inferior, zoom_limite_superior)
		
	
