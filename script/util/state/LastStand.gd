extends State

@export var self_reference : BossWheel
@onready var laser_machine = $"../../laser_machine"

var target : Vector3

func enter():
	laser_machine.show()
	for i in laser_machine.get_children():
		i.activation()
	
	target = get_tree().get_first_node_in_group("CenterPoint").global_position

#func exit():
	#pass

#func update(_dt: float):
	#pass

func physics_update(_dt: float):
	laser_machine.rotation.y += deg_to_rad(30) * _dt
	
	self_reference.global_position = lerp(self_reference.global_position, target, 2 * _dt)
