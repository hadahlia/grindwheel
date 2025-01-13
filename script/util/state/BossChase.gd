extends State
class_name Pursuit

@export var enem: CharacterBody3D
@export var move_speed := 20
var player: CharacterBody3D

func enter():
	player = get_tree().get_first_node_in_group("Player")

func physics_update(_dt: float):
	if !player or !enem: return
	var dir = player.global_position - enem.global_position
	#print(str(dir))
	if dir.length() > 5:
		enem.set_direction(dir)
		#enem.velocity = dir.normalized() * move_speed
	else:
		enem.set_direction(Vector3.ZERO)
	#enem.move_and_slide()
