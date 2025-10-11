extends Node
class_name SignalSoundEvent

@export var signal_name : String 
@export var sound_effect : AudioStream
@export var override_bus : String = "Master"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent : Node = get_parent()
	if not parent:
		return
		
	parent.ready.connect(_parent_ready.bind(parent))

func _parent_ready(parent: Node) -> void:
	parent.connect(signal_name, _event_happened)
	
func _event_happened(...args) -> void:
	SoundManager.play_sound(sound_effect, override_bus)
	
