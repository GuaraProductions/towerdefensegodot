extends CanvasLayer

@onready var colunas: HBoxContainer = $Colunas

var mouse_entered_area : bool = false

var mouse_movement_vector : Vector2 = Vector2.ZERO
var _current_movement : Vector2 = Vector2.ZERO

var target_alpha: float = 0.5
var current_alpha: float = 0

func _process(_delta: float) -> void:

	mouse_movement_vector = _current_movement \
	 if mouse_entered_area else Vector2.ZERO
	colunas.modulate.a = lerpf(colunas.modulate.a, target_alpha if mouse_entered_area else 0.0, 0.05)

func _on_superior_esquerdo_mouse_entered() -> void:
	_current_movement = Vector2(-1,-1)
	mouse_entered_area = true

func _on_esquerdo_mouse_entered() -> void:
	_current_movement = Vector2.LEFT
	mouse_entered_area = true

func _on_inferior_esquerdo_mouse_entered() -> void:
	_current_movement = Vector2(-1,1)
	mouse_entered_area = true
	
func _on_topo_mouse_entered() -> void:
	_current_movement = Vector2.UP
	mouse_entered_area = true

func _on_inferior_mouse_entered() -> void:
	_current_movement = Vector2.DOWN
	mouse_entered_area = true

func _on_superior_direito_mouse_entered() -> void:
	_current_movement = Vector2(1,-1)
	mouse_entered_area = true

func _on_direito_mouse_entered() -> void:
	_current_movement = Vector2(1, 0)
	mouse_entered_area = true

func _on_inferior_direito_mouse_entered() -> void:
	_current_movement = Vector2(1,1)
	mouse_entered_area = true

func _mouse_exited_area() -> void:
	mouse_entered_area = false	
