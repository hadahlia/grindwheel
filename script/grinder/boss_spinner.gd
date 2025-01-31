class_name BossWheel
extends CharacterBody3D

signal dread_intro_finish
signal boss_spawned

signal update_health
#signal output_damage
signal enter_phase_two
signal boss_death

var bullets_spawn_scene : PackedScene = preload("res://scenes/bullet/bullets_scene.tscn")
var bullets_ref : Node3D

#@onready var state_machine = $state_machine
@onready var state_machine = $state_machine
@onready var dread_anims = $dread_anims
#@onready var col_body = $col_body
@onready var hurt_radius = $hurt_ball/hurt_radius

@export var stats : WheelStats
@onready var spin_root = $spin_root

# timers
@onready var _stun_timer = $_stun_timer
@onready var _invuln_timer = $_invuln_timer
@onready var _invuln_saw_time = $_invuln_saw_time


# SOUNDS
@onready var wheel_sfx = $wheel_sfx
#@onready var boss_slice_sfx = $weapon/boss_slice_sfx
@onready var attacked_sfx = $attacked_sfx

#@onready var gun_ = $gun_laser_root/gun_
@onready var gun_laser_root = $gun_laser_root

var _grav : float = -20
var friction : float = -9
var _dmg : int

var wish_dir : Vector3 = Vector3.ZERO
var acceleration : Vector3 = Vector3.ZERO

var _stability : int
var _health : float
var _max_health : float = 1000

var _state_transmit : String = ""

var _phase_two : bool = false

var stunned : bool = false
var saw_col : bool = false
var _invuln : bool = false
var _invuln_saw : bool = false
var saw_damn : float = 0

#@TODO make phase 1 bullet hell, make phase 2 harder

func _ready():
	wheel_sfx.stream = stats.bump_sound
	_dmg = stats.damage
	_max_health = stats.health + ((stats.health * Globals.RoundCount) * 0.5)
	_health = _max_health
	
	dread_anims.play("dread_intro")
	bullets_ref = bullets_spawn_scene.instantiate()
	#cur_state.emit(str(state_machine.current_state))
	#boss_spawned.emit()
#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5
func visual_spin():
	spin_root.rotation.y += stats.rot_speed * stats.stability

func _physics_process(delta):
	if _phase_two or !Globals.can_move: return
	if is_on_floor():
		#get_input()
		apply_friction(delta)
		
		#velocity.y -= fall_speed * delta
	#if saw_col:
		#_take_damage(delta)
	acceleration.y = _grav
	visual_spin()
	#if !_dashing:
	if velocity.length() < 35:
		
		velocity += acceleration * delta
		#move_and_collide(velocity * delta)
		move_and_slide()
		#if _dashing:
			#dir_pointer.show()
			#_dashing = false
	else:
		var col = move_and_collide(velocity * delta)
		if col:
			
			wheel_sfx.pitch_scale = 1 + randf_range(-0.35, 0.35)
			wheel_sfx.play()
			
			get_tree().create_timer(0.1).timeout.connect(func()->void:
				fire_projectiles()
			)
			#wheel_sfx.pitch_scale += 0.2
			#data.bump_sound.play()
			#velocity *= 0.48
			velocity = velocity.bounce(col.get_normal()) #* randf_range(0.85, 1.15)

func fire_projectiles():
	var bullets_ref2 := bullets_spawn_scene.instantiate()
	
	get_parent().add_child(bullets_ref2)
	bullets_ref2.global_position = self.global_position
	bullets_ref2._set_directions()
	

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
	if stunned: return
	
	#var t_speed = _move_speed * delta
	acceleration = Vector3.ZERO
	#_input_vector = Input.get_vector("Left", "Right", "Up", "Down")
	
	wish_dir = _dir #.rotated(Vector3.UP, cam.rotation.z)
	
	acceleration = wish_dir * stats._movespeed

func _take_damage_once(val: float) -> void:
	if _invuln: return
	attacked_sfx.play()
	_health -= val
	if _health < (_max_health / 2):
		_phase_two = true
		enter_phase_two.emit()
	update_health.emit(_health, _max_health)
	if _health <= 0:
		_death()
	_invuln = true
	_invuln_timer.start()

func _take_damage(delta: float) -> void:
	if _invuln_saw: return
	_health -= saw_damn * delta
	update_health.emit(_health)
	if _health <= 0:
		_death()
	_invuln_saw = true
	_invuln_saw_time.start()

func _death():
	#var exp := explosion_scene.instantiate()
	#add_child(exp)
	#exp.explode()
	boss_death.emit(self.global_position)
	queue_free()

#func _on_weapon_area_entered(area):
	##boss_slice_sfx.play()
	##velocity *= -1
	#output_damage.emit(_dmg, velocity)


#func _on_weapon_area_exited(area):
	#boss_slice_sfx.stop()
	#output_damage.emit(0)


func _on_grindwheel_saw_damage(_pass_dmg: float) -> void:
	if _pass_dmg > 0:
		saw_col = true
	else:
		saw_col = false
	saw_damn = _pass_dmg


func _on__stun_timer_timeout():
	stunned = false


func _on__invuln_timer_timeout():
	_invuln = false


func _on__invuln_saw_time_timeout():
	_invuln_saw = false


func _on_state_machine_cur_state(state: String):
	_state_transmit = state


func _on_hurt_ball_area_entered(area):
	var p = area.get_parent()
	if p is GrindWheel:
		#print("hit!")
		_take_damage_once(p._saw_dmg)
		#if p.velocity == Vector3.ZERO:
			#p.velocity = self.velocity


func _on_dread_anims_current_animation_changed(name):
	if name == "dread_intro":
		Globals.can_move = false


func _on_dread_anims_animation_finished(anim_name):
	if anim_name == "dread_intro":
		Globals.can_move = true
		hurt_radius.disabled = false
		dread_intro_finish.emit()


func _on_laser_cooldown_timer_timeout():
	pass # Replace with function body.
