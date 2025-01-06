extends CharacterBody3D

@export var stats : WheelStats
@onready var spin_root = $spin_root

#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5
func visual_spin():
	spin_root.rotation.y += stats.rot_speed * stats.stability

func _physics_process(delta):
	visual_spin()
	move_and_slide()
