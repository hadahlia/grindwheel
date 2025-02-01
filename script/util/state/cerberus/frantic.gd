extends State


@export var cer2: SerbianWheel
@onready var timer = $"../Timer"

var player: CharacterBody3D
var center : Marker3D

var target_dir: Vector3

var is_center_target: bool = false

func enter():
	player = get_tree().get_first_node_in_group("Angel Gem")
	center = get_tree().get_first_node_in_group("CenterPoint")
	timer.start()
	

func physics_update(_dt: float):
	if !player or !cer2 or !center: return
	
	if is_center_target:
		target_dir = center.global_position - cer2.global_position
	else:
		target_dir = player.global_position - cer2.global_position
		
	if target_dir.length() > 8 and cer2.is_on_floor():
		cer2.set_direction(target_dir)
	
	if target_dir.length() < 6 and cer2.is_on_floor():
		cer2.set_direction(target_dir * -1)
	else:
		cer2.set_direction(Vector3.ZERO)


func _on_timer_timeout():
	is_center_target = !is_center_target
