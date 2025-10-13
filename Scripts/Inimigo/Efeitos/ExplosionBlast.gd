extends Sprite2D

@export var possible_sprites : Array[Texture2D] = []

func _ready() -> void:
	texture = possible_sprites.pick_random()
	scale = Vector2(randf_range(0.8, 1.2), randf_range(0.8, 1.2))
