class_name GemSoul
extends CharacterBody3D

signal soul_health
signal shatter

@onready var to_pos = $to_pos
@export var base_speed : float = 3

@export var max_health : int = 3
@export var health : int

# Timers. u get the drill
@onready var _invuln_timer = $_invuln_timer

# Sounds
@onready var _angel_damage = $_angel_damage

var _dir_to_cursor : Vector2
var _dir_gem : Vector3

var _leash_toggle : bool = false
var _invuln : bool = false

func _ready():
	health = max_health
	soul_health.emit(health)

func _physics_process(delta):
	if !Globals.can_move: return
	velocity = Vector3.ZERO
	_dir_to_cursor = Vector2(Globals.RayPos.x - global_position.x, Globals.RayPos.z - global_position.z)
	
	#if _dir_to_cursor == Vector2.ZERO: return
	_dir_gem = Vector3(_dir_to_cursor.x, 0, _dir_to_cursor.y)
	velocity = _dir_gem.normalized() * base_speed
	if _dir_to_cursor.length() < 0.2: 
		velocity = Vector3.ZERO
	move_and_slide()
	
	#to_pos.global_position.x = Globals.RayPos.x
	#to_pos.global_position.z = Globals.RayPos.z
	#global_position = lerp(global_position, to_pos.global_position, delta * base_speed)
	#global_position = global_position.lerp(to_pos.global_position, base_speed * delta)

func _input(event):
	if event is InputEventMouseButton:
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
		
		if event.button_index == 2:
			if event.pressed:
				print("m2 ^^")
				_leash_toggle = !_leash_toggle
				if _leash_toggle:
					_leash_flower()
				else:
					_unleash()
			## Release M2
			else:
				print("m2 released")

func _leash_flower():
	pass

func _unleash():
	pass

func gem_damage():
	if _invuln: return
	_angel_damage.play()
	if health > 0:
		health -= 1
	soul_health.emit(health, max_health)
	_start_invuln()
	if health == 0:
		gem_death()

func _start_invuln():
	_invuln = true
	_invuln_timer.start()

func gem_death():
	health = 0
	
	#print("uh oh u shld be dead")
	shatter.emit(self.global_position)
	queue_free()


func _on_hitbox_body_entered(body):
	if body is BossWheel:
		gem_damage()
		#if health > 1:
			#health -= 1
			#soul_health.emit(health, max_health)
		#else:
			#gem_death()


func _on__invuln_timer_timeout():
	_invuln = false
