extends Area2D
class_name PontoFinalInimigo

const GRUPO_NOME = "PONTO_FINAL_INIMIGO"

signal inimigo_atingiu_meta(dano: float)

func _ready() -> void:
	add_to_group(GRUPO_NOME)

func _on_area_entered(area: Area2D) -> void:
	if area is InimigoArea:
		area.chegou_ponto_final()
		inimigo_atingiu_meta.emit(area.dano_inimigo)
