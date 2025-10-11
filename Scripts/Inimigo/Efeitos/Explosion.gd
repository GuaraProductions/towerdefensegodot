extends AnimatedSprite2D

@export var sound_effect : AudioStream

func tocar_animacao() -> void:
	frame = 0
	play("default")
	SoundManager.play_sound(sound_effect, "Sounds")

func _on_animation_finished() -> void:
	pass
	#queue_free()
