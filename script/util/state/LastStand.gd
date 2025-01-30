extends State

@export var self_reference : BossWheel
@onready var laser_machine = $"../../laser_machine"
@onready var laser_idle = $"../../laser_idle"



var target : Vector3

var fired : bool = false

func enter():
	target = get_tree().get_first_node_in_group("CenterPoint").global_position


func fire_lasers():
	await get_tree().create_timer(1.5).timeout
	laser_machine.show()
	for i in laser_machine.get_children():
		i.activation()
	fired = true
	
#func exit():
	#pass

#func update(_dt: float):
	#pass

func physics_update(_dt: float):
	laser_machine.rotation.y += deg_to_rad(30) * (_dt * 2)
	
	self_reference.global_position = lerp(self_reference.global_position, target, 2 * _dt)
	
	if !fired and target.length() - self_reference.global_position.length() < 0.01:
		fire_lasers()
		laser_idle.play()
