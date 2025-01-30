extends State

@onready var dipsa_body = $"../../dipsa_body"
@onready var snake_animator = $"../../snake_animator"


func enter():
	if dipsa_body:
		#dipsa_body.segments[0].global_position = den_array[rr].global_position
		snake_animator.play("hell")

#func update(_dt:float):
	#pass
