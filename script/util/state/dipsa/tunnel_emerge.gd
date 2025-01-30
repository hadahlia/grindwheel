extends State


@onready var snake_den_scene = $"../.."

@onready var snake_animator = $"../../snake_animator"
@onready var den_spawns = $"../../den_spawns"

@onready var dipsa_body = $"../../dipsa_body"



func enter():
	var den_array = den_spawns.get_children()
	var rr : int = randi_range(0, 4)
		
	if dipsa_body:
		#dipsa_body.segments[0].global_position = den_array[rr].global_position
		snake_animator.play("den_emerge")
#
#func physics_update(_dt: float):
	#pass
