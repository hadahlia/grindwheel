extends State


@export var cer2: SerbianWheel
@onready var timer = $"../Timer"
#@onready var timer = $"../Timer"

#var player: CharacterBody3D
#var center : Marker3D

var target_dir: Vector3

var is_center_target: bool = false

func enter():
	#player = get_tree().get_first_node_in_group("Angel Gem")
	#center = get_tree().get_first_node_in_group("CenterPoint")
	timer.start()
	

func physics_update(_dt: float):
	if !cer2: return
	
	#if is_center_target:
		#target_dir = center.global_position - cer2.global_position
	#else:
		#target_dir = player.global_position - cer2.global_position
		#
	if target_dir.length() > 5 and cer2.is_on_floor():
		cer2.set_direction(target_dir)
	else:
		cer2.set_direction(Vector3.ZERO)



func _on_timer_timeout():
	var tr := get_tree().get_nodes_in_group("Tri Points")
	var rng = randi_range(1,3)
	target_dir = Vector3(tr[rng-1].global_position.x - cer2.global_position.x,0,tr[rng-1].global_position.z - cer2.global_position.z)
	
		
	#is_center_target = !is_center_target
