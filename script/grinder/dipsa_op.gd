class_name SnakeBoss
extends CharacterBody3D


signal boss_spawned

signal update_health
#signal output_damage
signal enter_phase_two
signal boss_death

# Snake Pieces
@onready var head_ = $head_
@onready var middle_ = $middle_
@onready var tail_ = $tail_


#@onready var state_machine = $state_machine
#@onready var state_machine = $state_machine

@export var stats : WheelStats
@onready var spin_root = $mesh_head/spinning_

# timers
@onready var _stun_timer = $_stun_timer
@onready var _invuln_timer = $_invuln_timer
@onready var _invuln_saw_time = $_invuln_saw_time


# SOUNDS
@onready var wheel_sfx = $wheel_sfx
#@onready var boss_slice_sfx = $weapon/boss_slice_sfx
@onready var attacked_sfx = $attacked_sfx


var _grav : float = -20
var friction : float = -24
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

#@TODO Dipsa is going to chase a point in space will be animated via the state machine (point represents the head) ^^

var Bait_Point : Marker3D

var segment_num : int = 10

var segments : Array = []
var distance : float = 8

var _slither_speed : float = 0

func _ready():
	wheel_sfx.stream = stats.bump_sound
	_dmg = stats.damage
	_max_health = stats.health + ((stats.health * Globals.RoundCount) * 0.5)
	_health = _max_health
	_slither_speed = stats._movespeed
	Bait_Point = get_tree().get_first_node_in_group("SnakeArrow")
	
	_build_snake()
	#segments[0] = head_
	#cur_state.emit(str(state_machine.current_state))
	#boss_spawned.emit()
#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5
func visual_spin():
	spin_root.rotation.y += stats.rot_speed * stats.stability

func _physics_process(delta):
	if !Bait_Point: return
	segments[0].global_position = segments[0].global_position.move_toward(Bait_Point.global_position, _slither_speed * delta)
	for i in range(segment_num-1):
			#if i == segment_num: break
		segments[i+1].global_position = _constrain_dist(segments[i+1].global_position, segments[i].global_position, distance) #
			
			#segments[i+1].look_at(segments[i-1])
	#var _slither_dir : Vector3 = Bait_Point.global_position - global_position
	_direction_chain()
	
	#velocity = _slither_dir.normalized() * _slither_speed
	#move_and_slide()
			#_direction_to_point(segments[i].global_position, segments[i+1].global_position)

func _direction_chain():
	var ind : int = 0
	for p in segments:
		#p.look_at(segments[i])
		
		if ind > 0:
			p.look_at(segments[ind-1].global_position)
		else:
			p.look_at(Bait_Point.global_position )
		ind += 1

func _direction_to_point(dest: Vector3, origin: Vector3) -> Vector3:
	var _dir = dest - origin
	return _dir.normalized()


	#if _phase_two: return
	#if is_on_floor():
		##get_input()
		#apply_friction(delta)
		
		#velocity.y -= fall_speed * delta
	#if saw_col:
		#_take_damage(delta)
	#acceleration.y = _grav
	#visual_spin()
	#if !_dashing:
	#if velocity.length() < 21:
		#wheel_sfx.pitch_scale = 1 + randf_range(-0.35, 0.35)
		#velocity += acceleration * delta
		##move_and_collide(velocity * delta)
		#move_and_slide()
		#if _dashing:
			#dir_pointer.show()
			#_dashing = false
	#else:
		#var col = move_and_collide(velocity * delta)
		#if col:
			#
			#wheel_sfx.play()
			#wheel_sfx.pitch_scale += 0.2
			##data.bump_sound.play()
			#velocity *= 0.48
			#velocity = velocity.bounce(col.get_normal()) #* randf_range(0.85, 1.15)

func _build_snake():
	for i in range(segment_num):
		var mid := middle_.duplicate()
		add_child(mid)
		segments.append(mid)
		#pass
	var crystals := get_tree().get_nodes_in_group("SnakeHealth")
	var calc_health = (_health / 2) / crystals.size()
	for c in crystals:
		c._piece_health = calc_health
	segments[0] = head_
	segments[-1] = tail_

func _constrain_dist(point: Vector3, anchor: Vector3, dist: float) -> Vector3:
	return ((point - anchor).normalized() * dist) + anchor

#func apply_friction(delta):
	#if velocity.length() < 0.1 and acceleration.length() < 0.1:
		#velocity.x = 0
		#velocity.z = 0
		##acceleration = Vector3.ZERO
	#var friction_force = velocity * friction * delta
	#acceleration += friction_force

#func get_direction():
	#pass

#func set_direction(_dir: Vector3) -> void:
	##if _dashing: return
	#if stunned: return
	#
	##var t_speed = _move_speed * delta
	#acceleration = Vector3.ZERO
	##_input_vector = Input.get_vector("Left", "Right", "Up", "Down")
	#
	#wish_dir = _dir #.rotated(Vector3.UP, cam.rotation.z)
	#
	#acceleration = wish_dir * stats._movespeed

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

#func _take_damage(delta: float) -> void:
	#if _invuln_saw: return
	#_health -= saw_damn * delta
	#update_health.emit(_health)
	#if _health <= 0:
		#_death()
	#_invuln_saw = true
	#_invuln_saw_time.start()

func _death():
	#var exp := explosion_scene.instantiate()
	#add_child(exp)
	#exp.explode()
	boss_death.emit(self.global_position)
	#@TODO an explosion death animation for every segment in order? :P
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


func _on_seg_hitbox_area_entered(area):
	var p = area.get_parent()
	if p is GrindWheel:
		#print("hit!")
		_take_damage_once(p._saw_dmg)


func _on_seg_hitbox_core_destroyed(_displace_hp: float) -> void:
	_take_damage_once(_displace_hp)
