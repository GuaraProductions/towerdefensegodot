extends Area2D
class_name InimigoArea

var dano_inimigo : float = 0.0

func tomou_dano(dano: float) -> void:
	get_parent().vida -= dano

func chegou_ponto_final() -> void:
	print("chegou ponto final")
	get_parent().queue_free()
