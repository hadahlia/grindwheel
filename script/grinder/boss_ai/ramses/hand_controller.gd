extends CharacterBody3D

signal update_hand_health
signal enter_phase_two
signal hand_dead

var bullets_spawn_scene : PackedScene = preload("res://scenes/bullet/bullets_scene.tscn")
var bullets_ref : Node3D
@onready var eye_gun = $spin_y/eye_gun

@onready var spin_y = $spin_y
@onready var mesh_ = $spin_y/mesh_

@onready var attacked_sfx = $attacked_sfx
@onready var _invuln_timer = $_invuln_timer

#@onready var mesh_ = $mesh_

@export var base_hand_speed : float = 20

@export var _max_health : float = 140

var _health : float

var want_dir : Vector3 = Vector3.ZERO

var _invuln : bool = false

var _phase_two : bool = false

@export var is_right: bool = false

func _ready():
	#_max_health = stats.health + ((stats.health * Globals.RoundCount) * 0.2)
	_max_health = _max_health + ((_max_health * Globals.RoundCount) * 0.2)
	_health = _max_health
	
	get_tree().create_timer(0.5).timeout.connect(func()->void:
		update_hand_health.emit(_health, _max_health)
	)

func spin_that_guy(_dt: float) -> void:
	if is_right:
		#mesh_.rotation.x += deg_to_rad(45) * _dt * 2
		self.rotation.y += deg_to_rad(30) * _dt * 2
	else:
		#mesh_.rotation.x -= deg_to_rad(45) * _dt * 2
		self.rotation.y -= deg_to_rad(30) * _dt * 2

func _physics_process(delta):
	if !Globals.can_move: return
	spin_that_guy(delta)
	velocity = want_dir.normalized() * base_hand_speed
	move_and_slide()


func set_target(target_p: Vector3) -> void:
	want_dir = Vector3(target_p.x - global_position.x,0,target_p.z - global_position.z)


func _take_damage_once(val: float) -> void:
	if _invuln: return
	attacked_sfx.play()
	_health -= val
	#if _health < (_max_health / 2):
		#_phase_two = true
		#enter_phase_two.emit()
	if _health <= 0:
		_death()
	update_hand_health.emit(_health, _max_health)
	_invuln = true
	_invuln_timer.start()

func set_phase_two():
	_phase_two = true
	enter_phase_two.emit()

func _death():
	_health = 0
	update_hand_health.emit(_health, _max_health)
	hand_dead.emit(self.global_position)
	get_tree().create_timer(0.5).timeout.connect(func()->void:
		queue_free()
	)

func fire_projectiles():
	var bullets_ref2 := bullets_spawn_scene.instantiate()
	
	get_parent().add_child(bullets_ref2)
	bullets_ref2.global_position = eye_gun.global_position
	bullets_ref2._set_directions()

func _on_hitbox_area_entered(area):
	var p = area.get_parent()
	if p is GrindWheel:
		_take_damage_once(p._saw_dmg)


func _on__invuln_timer_timeout():
	_invuln = false


#func _on_hitbox_body_entered(body):
	#if body is GrindWheel:
		#_take_damage_once(body._saw_dmg)
