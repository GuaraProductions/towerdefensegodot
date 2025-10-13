extends AnimatedSprite2D

@export var sound_effect : AudioStream
@export var blast_result : PackedScene

func tocar_animacao() -> void:
	frame = 0
	play("default")
	SoundManager.play_sound(sound_effect, "Sounds")

func _on_frame_changed() -> void:
	if frame == 12:
		print("spawn")
		var blast_result_instance = blast_result.instantiate()
		blast_result_instance.global_position = global_position
		get_parent().add_child(blast_result_instance)
