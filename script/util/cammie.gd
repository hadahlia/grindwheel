extends Camera3D

var arena_position : Vector3 = Vector3(0, 55.5, 2.8)
#var arena_rotation_deg : Vector3 = Vector3(-90,0,0)

var _is_moving : bool = false

func _physics_process(delta):
	if !_is_moving: return
	position = position.lerp(arena_position, delta)
	rotation.x = lerp_angle(rotation.x, deg_to_rad(-90), delta)
	#if rotation.x == deg_to_rad(-90):
		#print("FUCK YEAH")
		#_is_moving = false
