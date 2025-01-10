extends CharacterBody3D

@export var stats : WheelStats
@onready var spin_root = $spin_root

@onready var wheel_sfx = $wheel_sfx

var _grav : float = -20
var friction : float = -9

var wish_dir : Vector3 = Vector3.ZERO
var acceleration : Vector3 = Vector3.ZERO

func _ready():
	wheel_sfx.stream = stats.bump_sound
#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5
func visual_spin():
	spin_root.rotation.y += stats.rot_speed * stats.stability

func _physics_process(delta):
	if is_on_floor():
		#get_input()
		apply_friction(delta)
		#velocity.y -= fall_speed * delta
	acceleration.y = _grav
	visual_spin()
	#if !_dashing:
	if velocity.length() < 21:
		wheel_sfx.pitch_scale = 1 + randf_range(-0.35, 0.35)
		velocity += acceleration * delta
		#move_and_collide(velocity * delta)
		move_and_slide()
		#if _dashing:
			#dir_pointer.show()
			#_dashing = false
	else:
		var col = move_and_collide(velocity * delta)
		if col:
			
			wheel_sfx.play()
			wheel_sfx.pitch_scale += 0.2
			#data.bump_sound.play()
			velocity *= 0.68
			velocity = velocity.bounce(col.get_normal()) #* randf_range(0.85, 1.15)

func apply_friction(delta):
	if velocity.length() < 0.1 and acceleration.length() < 0.1:
		velocity.x = 0
		velocity.z = 0
		#acceleration = Vector3.ZERO
	var friction_force = velocity * friction * delta
	acceleration += friction_force

func get_direction():
	pass

func set_direction(_dir: Vector3) -> void:
	#if _dashing: return
	
	#var t_speed = _move_speed * delta
	acceleration = Vector3.ZERO
	#_input_vector = Input.get_vector("Left", "Right", "Up", "Down")
	
	wish_dir = _dir #.rotated(Vector3.UP, cam.rotation.z)
	
	acceleration = wish_dir * stats._movespeed
