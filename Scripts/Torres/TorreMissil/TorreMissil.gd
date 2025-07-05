extends TorreGenerica

func fazer_upgrade() -> void:
	super()
	
	if nivel_ugprade == 0:
		dano = 40
		frequencia_tiro.wait_time = 1.1
		permitido_upgrades = false
