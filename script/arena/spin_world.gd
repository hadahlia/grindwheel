extends Node3D

@onready var world_env = $WorldEnvironment

#@export_node_path("CharacterBody3D") var plyr_path
#@onready var cammy = $cammy
var plyr

var rotation_speed : float = 60
var rot_dir : float = 0

#func _ready():
	#if plyr_path:
		#plyr = get_node(plyr_path)
#func _input(event):
	#if event == Input.get_axis("RotLeft","RotRight"):
		#
	#pass
func get_spin():
	rot_dir = Input.get_axis("RotLeft", "RotRight")
	# spin_dir 

func _physics_process(delta):
	
	get_spin()
	world_env.environment.sky_rotation = rotation
	rotation_degrees.z += rot_dir * (rotation_speed * delta)
	#rotate_z()
