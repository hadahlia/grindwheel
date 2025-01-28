class_name GrindWheel
extends CharacterBody3D

#@export_node_path("Control") var gui_path
#@onready var gui = $"../gui"
#signal charge_spent
#signal update_spin
#signal update_stability
signal die

#signal saw_damage
signal bumped
#@onready var gui_hook : Control = get_

var explosion_scene : PackedScene = preload("res://scenes/vfx/deathsplosion.tscn")

@onready var mesh_body = $mesh_body
@onready var col = $col

#@onready var verlet_rope = $VerletRope
#@onready var rope_target = $rope_target

@onready var spin_root = $mesh_body/spin_root
@onready var blade_root = $mesh_body/spinner_blade

#@onready var arrow_g = $arrow_pointer
#@onready var dir_pointer = $dir_pointer

# SOUNDS
@onready var wheel_sfx = $wheel_sfx
#@onready var attack_sfx = $attack_sfx
@onready var lvl_sfx = $lvl_sfx
@onready var stability_sfx = $stability_sfx
@onready var damage_sfx = $damage_sfx
@onready var spin_sfx = $spin_sfx


# --- timers ---
@onready var _dash_recharge = $_dash_recharge
@onready var _spin_charge = $_spin_charge
#@onready var _invuln_timer = $_invuln_timer
#@onready var _stun_timer = $_stun_timer
#@onready var _get_col_back = $_get_col_back


@export var data : WheelStats

var _grav : float = -20
var _input_vector : Vector2 = Vector2.ZERO
var _move_speed : float = 36
var _dash_speed : float = 0
var _dash_max_speed : float = 80
#var rotation_speed : float = 10

var _dashing : bool = false
var _dash_charges : int 
var _dash_lvl : int = 0
#var _dash_timer : float = 0.5
var _dir : Vector3 = Vector3.ZERO

var _stability : int
var _spin_meter : float = 460
var _spin_decay : float = 0
var _spin_scalar : float = -12
var _max_spin_meter : float = 800
#var _max_stability : int
var _saw_dmg : float
var _invuln : bool = false

var _leash_toggle : bool = false
var _is_idle : bool = true

#var fall_speed : float = 75
var friction : float = -9

var acceleration : Vector3 = Vector3.ZERO
#var deceleration : float = 10

#var orbit_god : CircleGenerator
var orbit_pos : Vector3


func _ready():
	if data:
		_move_speed = data._movespeed
		#_dash_charges = data.dash_max_charge
		#_dash_recharge.wait_time = data.dash_cooldown
		_stability = data.stability
		_saw_dmg = Globals.DianthusDamage
	
	wheel_sfx.stream = data.bump_sound

#func find_god():
	#orbit_god = get_tree().get_first_node_in_group("Orbit Point")
	#if orbit_god:
		#orbit_god.


func _spinny():
	spin_root.rotation.y += (data.rot_speed * _stability)
	blade_root.rotation.y += _stability * 0.5 #+ data.damage)
	
	#if velocity == Vector3.ZERO: return
	#safe_look_at(mesh_body, self.position + _dir.normalized())
	#safe_look_at(dir_pointer, self.position + _dir)
	#safe_look_at(arrow_g, self.position + velocity)

func _set_direction(new_dir: Vector3) -> void:
	_dir = new_dir

func _physics_process(delta):
	#if _spin_meter <= 40 or _spin_meter >= 780:
		#_take_damage()
		#_spin_meter = 460
	if Globals.OrbitMode: 
		
		#position = lerp(self.position, orbit_pos, 4 * delta)
		velocity = Vector3.ZERO
		position = position.move_toward(orbit_pos, _move_speed * delta)
		#position.lerp(get_parent().position,  * delta)
		return
	#if _leash_toggle:
		#_connect_leash()
	
	#velocity.y = _grav
	#acceleration.y = _grav
	#if is_on_floor() and !_is_idle:
		#acceleration.y = 0
		#get_direction()
		#apply_friction(delta)
		#_spin_meter += _spin_scalar * delta
		#_spin_meter -= _spin_decay * delta
		#update_spin.emit(_spin_meter)
		
	
	
	_spinny()
	wheel_sfx.pitch_scale = 1 + randf_range(-0.35, 0.35)
	if velocity.length() < 21:
		
		
		velocity = _dir.normalized() * _move_speed #acceleration * delta
		#velocity += acceleration * delta
		#move_and_collide(velocity * delta)
		move_and_slide()
		#if _dashing:
			##dir_pointer.show()
			#_dashing = false
			
	else:
		var col = move_and_collide(velocity * delta)
		if col:
			#_take_damage()
			#_death()
			wheel_sfx.play()
			wheel_sfx.pitch_scale += 0.2
			#velocity *= 0.8
			#_dir = _dir.bounce(col.get_normal())
			#_dir *=-1
			velocity = velocity.bounce(col.get_normal()) #* randf_range(0.85, 1.15)
			
			#_dash_speed -= 10
			#
			#if _dash_speed <= 40:
				##dir_pointer.show()
				#_dashing = false
				
			#print("dash speed " + str(_dash_speed))

#func _input(event):
	#if _dashing: return #or _dir == Vector3.ZERO
	
	#if event.is_action_pressed("Spin Dash"):
		#print("yayyy")[
	#print("input is running")
	#if event is InputEventMouseButton:
		#print("event is InputEventMouseButton")
		
		# Press Dash
		#if event.button_index == 1:
			#if event.pressed:
				#print("m1 ^^")
				#_dash_lvl = 0
				#_spin_scalar = 60
				#lvl_sfx.pitch_scale = randf_range(1, 1.2)
				#_move_speed = 0
				##if _spin_charge.is_stopped():
				#_spin_charge.start()
				
			# Release Dash
			#else:
				#print("m1 released")
				#_spin_scalar = -12
				#_move_speed = data._movespeed
				#_spin_charge.stop()
				#match _dash_lvl:
					#0:
						#_dash_speed = 8
					#1:
						#_dash_speed = 30
						#_dash_charges -= 1
					#2:
						#_dash_speed = 50
						#_dash_charges -= 1
					#3:
						#_dash_speed = _dash_max_speed
						#_dash_charges -= 1
				#_dash_lvl = 0
				#
				#_dashing = true
				##dir_pointer.hide()
				#
				#if _dash_recharge.is_stopped():
					#_dash_recharge.start()
				#
				#charge_spent.emit(_dash_charges)
				#velocity = _dir.normalized() * _dash_speed
		
		# Press M2 / TODO LEASH MECHANIC 
		# after a breather, i am going to fire a grappling hook from my cursor to the dianthus.
		# holding m2 will set the tether, clicking m2 will toggle the tether
		
		#if event.button_index == 2:
			#if event.pressed:
				##print("m2 ^^")
				#_leash_toggle = !_leash_toggle
				#if _leash_toggle:
					#print("Leash Activated!")
					#_connect_leash()
				#else:
					#print("Leash Deactivated!")
					#_disconnect_leash()
			## Release M2
			#else:
				#print("m2 released")
	
	#if Input.is_action_just_pressed("Spin Dash"):
		#print("spin just pressed")
		#_dash_lvl = 0
		#_spin_scalar = 60
		#lvl_sfx.pitch_scale = randf_range(1, 1.2)
		#
		#_move_speed = 0
		#
	#
	#if Input.is_action_pressed("Spin Dash"):
		#print("spin pressed")
		#if _spin_charge.is_stopped():
			#_spin_charge.start()
	#
	#if Input.is_action_just_released("Spin Dash"):
		#print("this one will never be found")
		#_spin_scalar = -12
		#_move_speed = data._movespeed
		#_spin_charge.stop()
		#match _dash_lvl:
			#0:
				#_dash_speed = 8
			#1:
				#_dash_speed = 30
				#_dash_charges -= 1
			#2:
				#_dash_speed = 50
				#_dash_charges -= 1
			#3:
				#_dash_speed = _dash_max_speed
				#_dash_charges -= 1
		#_dash_lvl = 0
		#
		#_dashing = true
		##dir_pointer.hide()
		#
		#if _dash_recharge.is_stopped():
			#_dash_recharge.start()
		#
		#charge_spent.emit(_dash_charges)
		#velocity = _dir.normalized() * _dash_speed

#func _unhandled_input(event):
	#if _dashing or _dir == Vector3.ZERO: return
	#
	#if event is InputEventMouseButton:
		#if event.button_index == 1:
			#if event.pressed:
				#print("m1 ^^")
			#else:
				#print("m1 released")
		#if event.button_index == 2:
			#if event.pressed:
				#print("m2 ^^")
			#else:
				#print("m2 released")

#func _connect_leash():
	#if !Globals.RayPos: return
	#var cursor : Node3D = get_tree().get_first_node_in_group("SparkleCursor")
	#self.reparent(cursor)
	#if !cursor: _disconnect_leash()
	#verlet_rope.AttachStart = true
	#verlet_rope.RopeLength = _dir.length()
	#verlet_rope.AttachEnd = cursor
	#pass

#func _disconnect_leash():
	#pass
	#verlet_rope.AttachStart = false
	#verlet_rope.AttachEnd = rope_target
	#_leash_toggle = false

func apply_friction(delta):
	if velocity.length() < 0.1 and acceleration.length() < 0.1:
		velocity.x = 0
		velocity.z = 0
		#acceleration = Vector3.ZERO
	var friction_force = velocity * friction * delta
	acceleration += friction_force

func get_direction():
	#acceleration = Vector3.ZERO
	#var _fuck_name : Vector3 = Globals.RayPos - self.global_position
	#if _dir == Vector3.ZERO:
		#_dir = Vector3(0, 0,-1)#.rotated(Vector3.UP, cam.rotation.z)
	#acceleration = _dir.normalized() * _move_speed
	pass
	velocity = _dir.normalized() * _move_speed
	#look_at(Globals.RayPos, Vector3.UP)

func get_input():
	if _dashing: return
	
	#var t_speed = _move_speed * delta
	acceleration = Vector3.ZERO
	
	#_input_vector = Input.get_vector("Left", "Right", "Up", "Down")
	#_input_vector = Input.get_vector(Globals.RayPos.x, Globals.RayPos.z)
	#if Globals.RayPos > Vector3.ZERO:
		#_dir = Globals.RayPos - self.global_position
	#else:
		#_dir = self.global_position
	acceleration = _dir.normalized() * _move_speed
	#if _leash_toggle:
		#_get_input_leashed()
	#velocity = _dir * t_speed

func _get_input_leashed():
	#var move_orbit
	#var move_dist
	#position
	#acceleration.x += acceleration.z
	#acceleration.z = 0
	#velocity.x += velocity.z
	velocity.z = 0
	
	velocity = velocity.rotated(Vector3.UP, get_rotation().y)
	#return acceleration.rotated(Vector3.UP, get_rotation().y)
	#acceleration.x =

# this is take spin damage
func _set_spin_damage(dmg_val: float) -> void:
	#_spin_decay = dmg_val
	#_spin_scalar
	if _invuln: return
	
	_spin_meter -= dmg_val
	#_start_invuln()
	#wheel_sfx.stream = data.bump_sound

# take stability damage
#func _take_damage():
	#stability_sfx.play()
	#_stability -= 1
	#update_stability.emit(_stability)
	##_start_invuln()
	#if _stability <= 0: 
		#_death()

func _death():
	#var exp := explosion_scene.instantiate()
	#add_child(exp)
	#exp.explode()
	die.emit(self.global_position)
	queue_free()

#util i found online for dealing with annoying error
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


#func _on__dash_recharge_timeout():
	#if _dash_charges >= data.dash_max_charge: return  
	#_dash_charges += 1
	#charge_spent.emit(_dash_charges)


#func _on__spin_charge_timeout():
	#if _dash_lvl == 3 or _dash_charges == 0: 
		#print("dash lvl is 3")
		#
		##_spin_charge.stop()
		#return
	#
	#lvl_sfx.pitch_scale += 0.4
	#lvl_sfx.play()      
	#_dash_lvl += 1
	#print("charge proc: ", _dash_lvl)


#func _on_hitbox_area_entered(area):
	#if area is BossWheel:
	#_take_damage()
	#area.get_parent()
	#if area == get_tree().get_first_node_in_group("BossEnem"):
		#pass
	#_take_spin_damage()


func _on_opponent_wheel_output_damage(dmg_val: float, in_vel: Vector3) -> void:
	#velocity *= -1
	var vel_calc : float = abs(in_vel.x) + abs(in_vel.z)
	if velocity < in_vel:
		vel_calc *= 1.8
	#var compare_vel := velocity 
		#* 0.5
	dmg_val += vel_calc
	#var vel_cz : float = in_vel.z
	#dmg_val *= 
	_set_spin_damage(dmg_val)


#func _on_killsaw_area_entered(area):
	#saw_damage.emit(_saw_dmg)


#func _on_killsaw_area_exited(area):
	#saw_damage.emit(0)

#func _on_bump_radius_body_entered(body):
	#if body is BossWheel:
		#attack_sfx.play()
		#wheel_sfx.stream = data.hit_sound
		#wheel_sfx.play()
		#wheel_sfx.stream = data.bump_sound
		#print("body is bosswheel")
		#bumped.emit(self.velocity, body.velocity, body._dmg)
	#else:
		#print("body not bosswheel :c")

#func _on__stun_timer_timeout():
	#Globals.can_move = true
	#velocity = Vector3.ZERO

#
#func _on_bump_radius_area_entered(area):
	#if area is BossWheel or SnakeBoss:
		#var a := get_tree().get_first_node_in_group("BossEnem")
		#velocity = a.velocity
		#if velocity == Vector3.ZERO:
		#velocity = area.velocity


#func _on__get_col_back_timeout():
	#col.disabled = false
