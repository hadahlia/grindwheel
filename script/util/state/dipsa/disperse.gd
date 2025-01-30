extends State

@onready var state_machine = $".."

@onready var snake_den_scene = $"../.."

@onready var snake_animator = $"../../snake_animator"
@onready var den_spawns = $"../../den_spawns"

@onready var dipsa_body = $"../../dipsa_body"



func enter():
	var den_array = den_spawns.get_children()
	var rr : int = randi_range(0, 4)
		
	if dipsa_body:
		#snake_animator.stop()
		#snake_den_scene.snake_chase_point.global_position = den_array[rr].global_position
		snake_den_scene.is_animating_point = false
		snake_den_scene._set_target(den_array[rr].global_position)
		#if dipsa_body.segments[0].global_position == snake_den_scene.snake_point.global_position:
			#state_machine.states["emerge"].enter()
		get_tree().create_timer(5.0).timeout.connect(func() -> void:
			if dipsa_body._phase_two:
				
				#rebuild the snake with like 30 segments
				dipsa_body.set_phase_two()
				state_machine.states["hell"].enter()
				state_machine.current_state = state_machine.states["hell"]
				print("phase 2 wow")
			else:
			
				state_machine.states["emerge"].enter()
				state_machine.current_state = state_machine.states["emerge"])
		
		#dipsa_body.global_position = den_array[rr].global_position
		#snake_animator.play("den_emerge")

func physics_update(_dt: float):
	pass
