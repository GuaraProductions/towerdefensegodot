extends Control

@export var fases_possiveis: Array[PackedScene] = []
@export var botao: PackedScene
@onready var fases: GridContainer = %Fases

func _ready() -> void:
	
	var indice : int = 1
	for fase in fases_possiveis:
		
		var button : Button = botao.instantiate()
		
		button.text = str(indice)
		button.pressed.connect(_iniciar_fases.bind(indice - 1))
		
		indice += 1
		
		fases.add_child(button)
		
func _iniciar_fases(fase_indice: int) -> void:
	OrquestradorDeFases.iniciar_ciclo_de_fases(fase_indice, fases_possiveis)
