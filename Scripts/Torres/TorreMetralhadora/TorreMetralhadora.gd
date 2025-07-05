extends TorreGenerica


func fazer_upgrade() -> void:
	super()
	
	if nivel_ugprade == 0:
		dano = 17.5
		frequencia_tiro.wait_time = 0.4
		permitido_upgrades = false
