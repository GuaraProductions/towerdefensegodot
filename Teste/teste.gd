extends Node

@export var minhas_wave : Array[Wave] = []
@export var spawns_inimigos : Array[SpawnInimigo] = []

class Player:
	var Nome
	var Vida
	var Stamina
	var Mana
	var Velocidade

	func _init(Nome, Vida, Stamina, Mana, Velocidade):
		self.Nome = Nome
		self.Vida = Vida
		self.Stamina = Stamina
		self.Velocidade = Velocidade
		
	func _to_string() -> String:
		return "[Player] nome: %s" % Nome

func _ready():
	var Lacoste = Player.new("Lacoste", 523, 12, 32, 32)
	Lacoste.Nome = "Lacoste"
	Lacoste.Vida = 100
	Lacoste.Stamina = 50
	Lacoste.Mana = 50
	Lacoste.Velocidade = 5

	var Shark = Player.new("Shark", 15, 233, 1233, 323)
	Shark.Nome = 'Shark'
	Shark.Vida = 120
	Shark.Stamina = 70
	Shark.Mana = 40
	Shark.Velocidade = 3

	print(Lacoste)
	print(Shark)
