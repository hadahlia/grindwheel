class_name Valkyrie
extends CharacterBody3D

#@export_node_path("Camera3D") var cam_path

var _input : Vector2 = Vector2.ZERO

var _move_speed : float = 300

var rotation_dir : float = 0

#var cam

#func _ready():
	#if cam_path:
		#cam = get_node(cam_path)

func get_input(delta):
	var t_speed = _move_speed * delta
	_input = Input.get_vector("Left", "Right", "Down", "Up")
	var _dir := Vector3(_input.x, _input.y, 0)#.rotated(Vector3.UP, cam.rotation.z)
	velocity = _dir * t_speed
	#velocity.z = 0
	#velocity = velocity.rotated(Vector3.UP, cam.rotation.y)

func _physics_process(delta):
	get_input(delta)
	move_and_slide()
