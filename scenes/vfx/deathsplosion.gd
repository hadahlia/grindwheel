extends Node3D

@onready var debris = $debris
@onready var fire = $fire
@onready var smoke = $smoke
@onready var splosion_sound = $splosion_sound

func explode():
	debris.emitting = true
	smoke.emitting = true
	fire.emitting = true
	splosion_sound.play()
	await get_tree().create_timer(2.0).timeout
	queue_free()
