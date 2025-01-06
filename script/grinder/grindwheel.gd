class_name GrindWheel
extends CharacterBody3D

#@export_node_path("Control") var gui_path
#@onready var gui = $"../gui"
signal charge_spent
#@onready var gui_hook : Control = get_

@onready var spin_root = $spin_root
@onready var arrow_g = $arrow_pointer
@onready var wheel_sfx = $wheel_sfx

@export var data : WheelStats

var _grav : float = -20
var _input_vector : Vector2 = Vector2.ZERO
var _move_speed : float = 10
var _dash_speed : float = 0
var _dash_max_speed : float = 50
var rotation_speed : float = 10

var _dashing : bool = false
var _dash_charges : int = 3
#var _dash_timer : float = 0.5
var _dir : Vector3 = Vector3.ZERO


#var fall_speed : float = 75
var friction : float = -9

var acceleration : Vector3 = Vector3.ZERO
#var deceleration : float = 10

func _ready():
	#charge_spent.emit(_dash_charges)
	#if gui:
		#gui.
		#gui_hook = get_node(gui_path)
		
	wheel_sfx.stream = data.bump_sound
	#_dash_timer.set_one_shot(true)
	#add_child(_dash_timer)

func _spinny():
	if velocity == Vector3.ZERO: return
	spin_root.rotation.y += rotation_speed * data.stability
	#print("rot: " + str(spin_root.rotation.y) + "deg: " + str(arrow_g.rotation_degrees.y))
	#if spin_root.get_rotation_degrees() < -90:
		#spin_root.set_rotation_degrees(360)
	#arrow_g.rotation.y = atan2(velocity.x,velocity.z)
	#if arrow_g. != self.position + Vector3(_input.x, 0, _input.y):
	#if _dir > 0.1:
	#if _dir.length() > 0:
	#arrow_g.look_at(self.position + _dir, Vector3.UP)
	#arrow_g.rotation.y = velocity.
	safe_look_at(arrow_g, self.position + velocity)

func _physics_process(delta):
	if is_on_floor():
		get_input()
		apply_friction(delta)
		#velocity.y -= fall_speed * delta
	acceleration.y = _grav
	_spinny()
	#if !_dashing:
	if velocity.length() < 18:
		velocity += acceleration * delta
		#move_and_collide(velocity * delta)
		move_and_slide()
	else:
		var col = move_and_collide(velocity * delta)
		if col:
			
			wheel_sfx.play()
			wheel_sfx.pitch_scale += 0.2
			#data.bump_sound.play()
			velocity *= 0.8
			velocity = velocity.bounce(col.get_normal())
			
			_dash_speed -= 10
			if _dash_speed <= 20:
				_dashing = false
			
			print("dash speed " + str(_dash_speed))
	#print("accel: " + str(acceleration))
	#move_and_collide(velocity * delta)

func _input(_event):
	if _dashing or _dir == Vector3.ZERO: return
	if Input.is_action_just_pressed("Spin Dash") and _dash_charges > 0:#&& _can_dash:
		_dash_speed = _dash_max_speed
		_dashing = true
		_dash_charges -= 1
		charge_spent.emit(_dash_charges)
		velocity = _dir * _dash_speed
		#await(get_tree().create_timer())
		#acceleration.x = _input_vector.x * _dash_speed
		#acceleration.z = _input_vector.y * _dash_speed

func apply_friction(delta):
	if velocity.length() < 0.1 and acceleration.length() < 0.1:
		velocity.x = 0
		velocity.z = 0
		#acceleration = Vector3.ZERO
	var friction_force = velocity * friction * delta
	acceleration += friction_force

func get_input():
	if _dashing: return
	
	#var t_speed = _move_speed * delta
	acceleration = Vector3.ZERO
	_input_vector = Input.get_vector("Left", "Right", "Up", "Down")
	
	_dir = Vector3(_input_vector.x, 0, _input_vector.y)#.rotated(Vector3.UP, cam.rotation.z)
	
	acceleration = _dir * _move_speed
	#velocity = _dir * t_speed

func safe_look_at(node : Node3D, target : Vector3) -> void:
	var origin : Vector3 = node.global_transform.origin
	var v_z := (origin - target).normalized()

	# Just return if at same position
	if origin == target:
		return

	# Find an up vector that we can rotate around
	var up := Vector3.ZERO
	for entry in [Vector3.UP, Vector3.RIGHT, Vector3.BACK]:
		var v_x : Vector3 = entry.cross(v_z).normalized()
		if v_x.length() != 0:
			up = entry
			break

	# Look at the target
	if up != Vector3.ZERO:
		node.look_at(target, up)
