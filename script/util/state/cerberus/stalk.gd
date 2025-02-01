extends State
#class_name Pursuit

@export var cer1: SerbianWheel
#@export var move_speed := 20
var player: CharacterBody3D

func enter():
	player = get_tree().get_first_node_in_group("Angel Gem")
	

func physics_update(_dt: float):
	if !player or !cer1: return
	var dir = player.global_position - cer1.global_position
	if dir.length() > 16 and cer1.is_on_floor():
		cer1.set_direction(dir)
	else:
		cer1.set_direction(Vector3.ZERO)
