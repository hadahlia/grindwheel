class_name GemSoul
extends CharacterBody3D

signal soul_health
signal shatter


@onready var gem_anims = $gem_anims

@onready var to_pos = $to_pos
@onready var pivot = $pivot

@export var base_rot_speed : float = 10
@export var base_speed : float = 3
@export var orbit_scale : float = 8

@export var max_health : int = 3
@export var health : int

# Timers. u get the drill
@onready var _invuln_timer = $_invuln_timer

# Sounds
@onready var _angel_damage = $_angel_damage
@onready var _angel_blip = $_angel_blip

var _dir_to_cursor : Vector2
var _dir_gem : Vector3

var _leash_toggle : bool = false
var _invuln : bool = false
var _orbit_right : bool = false

func _ready():
	max_health = Globals.GemMaxHP
	health = max_health
	soul_health.emit(health, max_health)
	Globals.OrbitMode = _leash_toggle
	if Globals.RoundCount == 0:
		Globals.can_move = false

func _angel_spin(delta: float):
	if !_leash_toggle: return
	if _orbit_right:
		pivot.rotation.y -= base_rot_speed * delta
	else:
		pivot.rotation.y += base_rot_speed * delta

func _physics_process(delta):
	if !Globals.can_move: return
	velocity = Vector3.ZERO
	_dir_to_cursor = Vector2(Globals.RayPos.x - global_position.x, Globals.RayPos.z - global_position.z)
	
	_angel_spin(delta)
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
				#print("m2 ^^")
				_leash_toggle = !_leash_toggle
				#print(" :3 leash status: ",_leash_toggle)
				if _leash_toggle:
					_leash_flower()
				else:
					_unleash()
			## Release M2
			else:
				pass
				#print("m2 released")
	
	if Input.is_action_just_pressed("switch dir"):
		_orbit_right = !_orbit_right

func _setup_orbit():
	
	#var ret_array : PackedVector3Array
	var coord = pivot.getCoordinates()
	var n = Node3D.new()
	for x in coord:
		pivot.add_child(n)
		n.position = x
		#ret_array.append(n.global_position)
	

func _leash_flower():
	

	#var coordarray : Array = pivot.getCoordinates()
	var dt := get_tree().get_nodes_in_group("Dianthus")
	#var nc = pivot.get_children()
	if !dt: return
	pivot.setItems(Globals.DianthusCount)
	pivot.setScale(orbit_scale)
	pivot.generateXZ()
	var coord = pivot.getCoordinates()
	
	var id : int = 0
	for i in dt:
		i.reparent(pivot)
		i.col.disabled = true
		#i.position = coord[id]
		i.orbit_pos = coord[id]
		i.spin_sfx.stop()
		i._saw_dmg *= 0.5
		#pivot.add_child(i)
		
		id += 1
	
	Globals.OrbitMode = true
	_angel_blip.play()

func _unleash():
	Globals.OrbitMode = false
	var dt := get_tree().get_nodes_in_group("Dianthus")
	if !dt: return
	#var coord = pivot.getCoordinates()
	for i in dt:
		var nd : Vector3 = Vector3( i.global_position.x - self.global_position.x,0,i.global_position.z - self.global_position.z)
		i.col.disabled = false
		i.reparent(get_parent())
		
		i._is_idle = false
		i._dir = nd
		i.spin_sfx.play()
		i._saw_dmg *= 2
		
		

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
	gem_anims.play("hurt soul")

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


func _on_hitbox_area_entered(area):
	gem_damage()


func _on_stuck_spawn_timer_timeout():
	Globals.can_move = true
