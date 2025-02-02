extends Node3D
class_name RamsesManager

signal ramses_intro_finish
signal forward_dead_hand

signal both_dead
signal update_health

@onready var ramses_left = $ramses_left
@onready var ramses_right = $ramses_right
@onready var ramses_anim_point_l = $ramses_anim_point_l
@onready var ramses_anim_point_r = $ramses_anim_point_r

@onready var ramses_anims = $ramses_anims
@onready var state_timer_of_some_kind = $state_timer_of_some_kind

var hand_hp_l : float
var hand_hp_r : float

var hand_tr1 : bool = false
var hand_tr2 : bool = false

var l_hand_dead : bool = false
var r_hand_dead : bool = false

var total_health : float
var max_health : float

var is_animating : bool = false
var interp_speed : float = 120
var anim_target : Vector3

# ?????
func _ready():
	ramses_anims.play("ramses intro")
	
	get_tree().create_timer(2.0).timeout.connect(func()->void:
		max_health_calc()
		total_health = max_health
		update_health.emit(total_health, max_health)
	)

func _physics_process(delta):
	if !ramses_left and !ramses_right: return
	if is_animating:
		if ramses_left != null:
			ramses_left.global_position = ramses_left.global_position.move_toward(ramses_anim_point_l.global_position, delta * interp_speed)
		if ramses_right != null:
			ramses_right.global_position = ramses_right.global_position.move_toward(ramses_anim_point_r.global_position, delta * interp_speed)

#func set_animating():
	#is_animating = true
	#ramses_left.set_target(ramses_anim_point_l)
	#ramses_right.set_target(ramses_anim_point_r)

func max_health_calc():
	max_health = ramses_left._max_health + ramses_right._max_health
	#total_health = max_health

func total_health_calc():
	total_health = hand_hp_l + hand_hp_r
	update_health.emit(total_health, max_health)

func _on_ramses_anims_current_animation_changed(name):
	if name == "ramses intro":
		Globals.can_move = false
		is_animating = true
	if name == "clap":
		if ramses_left == null or ramses_right == null: return
		ramses_left.set_physics_process(false)
		ramses_left.rotation_degrees.y = 180
		
		ramses_right.set_physics_process(false)
		ramses_right.rotation_degrees.y = 0
		
		
	if name == "cookie cutter":
		if ramses_left != null:
			ramses_left.set_physics_process(true)
		if ramses_right != null:
			ramses_right.set_physics_process(true)
		#get_tree().create_timer(0.1).timeout.connect(func()->void:
			#
		#)
		
		#ramses_left.set_target(ramses_anim_point_l.global_position)
		#ramses_right.set_target(ramses_anim_point_r.global_position)

func end_battle():
	both_dead.emit()
	get_tree().create_timer(1.0).timeout.connect(func()->void:
		queue_free()
	)

func count_dead_hands():
	if !l_hand_dead or !r_hand_dead: return
	end_battle()

func _forward_hand_death(pos: Vector3) -> void:
	forward_dead_hand.emit(pos)
	count_dead_hands()
	state_timer_of_some_kind.stop()


func _left_update_hand_health(hp: float, _max_hp: float) -> void:
	if !hand_tr1:
		hand_tr1 = true
	hand_hp_l = hp
	total_health_calc()


func _right_update_hand_health(hp: float, _max_hp: float) -> void:
	hand_hp_r = hp
	if !hand_tr2:
		hand_tr2 = true
		max_health_calc()
	
	total_health_calc()


func _on_ramses_anims_animation_finished(anim_name):
	if anim_name == "ramses intro":
		ramses_intro_finish.emit()
		state_timer_of_some_kind.start()
		get_tree().create_timer(4.0).timeout.connect(func()->void:
			ramses_anims.play("cookie cutter")
		)
	if anim_name == "clap":
		#ramses_left.set_physics_process(true)
		#ramses_right.set_physics_process(true)
		ramses_anims.play("cookie cutter")
	if anim_name == "sweep_left":
		ramses_anims.play("sweep_right")
	if anim_name == "sweep_right":
		ramses_anims.play("sweep_left")
	#get_tree().create_timer(2.0).timeout.connect(func()->void:
		#ramses_anims.play("asshole_rim")
	#)


func _on_ramses_left_hand_dead(pos: Vector3) -> void:
	l_hand_dead = true
	_forward_hand_death(pos)
	if !r_hand_dead:
		ramses_right.set_phase_two()


func _on_ramses_right_hand_dead(pos: Vector3) -> void:
	r_hand_dead = true
	_forward_hand_death(pos)
	if !l_hand_dead:
		ramses_left.set_phase_two()


func _on_state_timer_of_some_kind_timeout():
	ramses_anims.play("clap")
