extends Path2D
class_name CaminhoInimigos

signal inimigo_spawnou()
signal inimigo_morreu(inimigo)
signal progresso_wave_avancou(tempo: float)
signal terminou_wave()
signal fase_terminou()

var tempo_inicial_waves : Array[float] = []

@export var waves : Array[Wave] = []
@export var inimigos_cache : InimigosCache
@export var modo_teste : bool = false

var tempo_atual : float = 0.0
var tempo_total : float = 0.0
var sub_wave_atual : int = -1
var wave_atual : int = -1

var spawn_de_inimigos_atual : SpawnInimigo

var timers_spawn : Array[Timer]

var terminou_waves : bool = false
var terminou_spawn_sub_wave : bool = false

func _ready() -> void:
	
	var tempo_acumulado : float = 0.0
	
	for wave in waves:
		
		#print("wave: ", wave)
		tempo_acumulado += wave.delay_inicial
		tempo_inicial_waves.append(tempo_acumulado)
		tempo_acumulado += wave.duracao

	tempo_total = tempo_acumulado
	
	#print("tempo_total: ", tempo_total)
	#print("tempo_inicial_waves: ", tempo_inicial_waves)

func resetar_waves() -> void:
	set_physics_process(false)
	
	get_tree().call_group(Inimigo.GRUPO_NOME, "queue_free")
	
	tempo_atual = 0
	sub_wave_atual = -1
	wave_atual = -1
	spawn_de_inimigos_atual = null
	terminou_waves = false
	terminou_spawn_sub_wave = false
	
	_remover_timers()
	set_physics_process(true)

func get_waves_tempo_total() -> float:
	return tempo_total

func _physics_process(delta: float) -> void:
	tempo_atual += delta
	progresso_wave_avancou.emit(tempo_atual)
	
	if tempo_atual >= tempo_total:
		if get_child_count() == 0:
			fase_terminou.emit()
			set_physics_process(false)
	
	if wave_atual == -1:
		_gerenciar_inicio_da_fase()
		return
		
	elif wave_atual < waves.size():
		_gerenciar_spawn_inimigos()
	
func _spawnar_novo_inimigo(timer: Timer) -> void:
	
	var inimigo_idx = spawn_de_inimigos_atual.pegar_inimigo_aleatorio()
	var inimigo_spawnar = inimigos_cache.pegar_inimigo_instancia(inimigo_idx)
	
	if not inimigo_spawnar:
		timer.timeout.disconnect(_spawnar_novo_inimigo)
		timers_spawn.erase(timer)
		timer.queue_free()
		return
	
	var inimigo_instancia = inimigo_spawnar.instantiate()
	inimigo_instancia.modo_teste = modo_teste
	
	inimigo_instancia.assassinado.connect(_inimigo_morreu.bind(inimigo_instancia))
	
	add_child.call_deferred(inimigo_instancia)
	#print("adicionou inimigo, tempo: ", tempo_atual)
	#print(_to_string())
	timer.start()
	inimigo_spawnou.emit()
	
func _gerenciar_spawn_inimigos() -> void:
	if not spawn_de_inimigos_atual:
		return

	#print("wave: ", wave_atual)
	#print("sub wave:", sub_wave_atual)
	if _ainda_esta_em_sub_wave():
			
		if spawn_de_inimigos_atual.spawnar_continuamente:
			terminou_spawn_sub_wave = true

			var timer_spawn_atual : Timer = Timer.new()
			
			timer_spawn_atual.wait_time = spawn_de_inimigos_atual.intervalo_entre_spawns
			timer_spawn_atual.timeout.connect(_spawnar_novo_inimigo.bind(timer_spawn_atual))
			
			add_child(timer_spawn_atual)
			
			timers_spawn.append(timer_spawn_atual)
			
			timer_spawn_atual.start()
		
		else:
			
			var inimigo_idx = spawn_de_inimigos_atual.pegar_inimigo_aleatorio()
			
			if inimigo_idx == InimigosCache.PossiveisInimigos.NaoDefinido:
				return
			
			var inimigo_spawnar = inimigos_cache.pegar_inimigo_instancia(inimigo_idx)
			
			if not inimigo_spawnar:
				printerr("Inimigo não configurado!")
				return

			var inimigo_instancia = inimigo_spawnar.instantiate()
			inimigo_instancia.modo_teste = modo_teste
			
			inimigo_instancia.assassinado.connect(_inimigo_morreu.bind(inimigo_instancia))
			
			add_child.call_deferred(inimigo_instancia)
			#print("adicionou inimigo, tempo: ", tempo_atual)
			#print(_to_string())
			inimigo_spawnou.emit()
			
	elif _sub_wave_acabou():
		
		_remover_timers()
		terminou_spawn_sub_wave = false
		
		sub_wave_atual += 1
		if _fim_da_wave_atual():
			wave_atual += 1
			_resetar_parametros_da_wave()
		else:
			spawn_de_inimigos_atual = waves[wave_atual].spawns_inimigo[sub_wave_atual]
		
	
func _gerenciar_inicio_da_fase() -> void:
	if wave_atual == -1:
		if tempo_atual >= tempo_inicial_waves[0]:
			wave_atual += 1
			_resetar_parametros_da_wave()
			
func _ainda_esta_em_sub_wave() -> bool:
	return tempo_atual < spawn_de_inimigos_atual.duracao + tempo_inicial_waves[wave_atual] and \
	not terminou_spawn_sub_wave

func _sub_wave_acabou() -> bool:
	return tempo_atual >= spawn_de_inimigos_atual.duracao + tempo_inicial_waves[wave_atual]

func _fim_da_wave_atual() -> bool:
	return sub_wave_atual >= waves[wave_atual].spawns_inimigo.size()

func _resetar_parametros_da_wave() -> void:
	sub_wave_atual = 0
	
	if wave_atual >= waves.size():
		terminou_wave.emit()
		terminou_waves = true
	else:
		spawn_de_inimigos_atual = waves[wave_atual].spawns_inimigo[sub_wave_atual]
			
func _remover_timers() -> void:
	
	for timer in timers_spawn:
		
		if not timer:
			continue
		
		timer.stop()
		
		if timer.timeout.is_connected(_spawnar_novo_inimigo):
			timer.timeout.disconnect(_spawnar_novo_inimigo)
		
		if timer.is_inside_tree():
			remove_child(timer)
			
		timer.queue_free()

func _inimigo_morreu(inimigo) -> void:
	if inimigo.has_method("get_recompensa"):
		inimigo_morreu.emit(inimigo.get_recompensa())

func _to_string() -> String:
	return "Wave: %d\nSubWaveAtual: %d\nTempo: %s" % [wave_atual+1, sub_wave_atual+1, str(tempo_atual).pad_decimals(2)]
