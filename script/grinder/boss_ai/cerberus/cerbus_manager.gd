class_name CerberusMan
extends Node3D

signal crb_intro_finish
signal all_dead_captain

signal forward_dead_wheel
signal update_health

@onready var wheel_holder = $wheel_holder

#@onready var cer_1 = $cer1
#@onready var cer_2 = $cer2
#@onready var cer_3 = $cer3
#var cer_1 : SerbianWheel
#var cer_2 : SerbianWheel
#var cer_3 : SerbianWheel
@onready var cer_1 = $cer1

#@onready var cer_1 = $wheel_holder/cer1
@onready var cer_2 = $wheel_holder/cer2
#@onready var cer_3 = $wheel_holder/cer3
@onready var cer_3 = $cer3


@onready var crbanim = $crbanim

var cer_hp_one : float
var cer_hp_two : float
var cer_hp_three : float

#var cer_hp_one_max : float
#var cer_hp_two_max : float
#var cer_hp_three_max : float

var tr_hp_1 : bool = false
var tr_hp_2 : bool = false
var tr_hp_3 : bool = false

var dead1 : bool = false
var dead2 : bool = false
var dead3 : bool = false

var total_health : float
var max_health : float = 100

func _ready():
	#max_health = cer_1._max_health
	
	
	crbanim.play("intro sequence")
	get_tree().create_timer(2.0).timeout.connect(func()->void:
		max_health_calc()
		#calculate_total_health()
		#update_health.emit(total_health, max_health)
		#total_health = max_health
	)
	
	#max_health_calc(cer_1._max_health)
	#update_health.emit(total_health, max_health)
	#total_health = max_health

func max_health_calc():
	#if !tr_hp_1 or !tr_hp_2 or !tr_hp_3: return
	#var tmp_health : float = 0
	##for i in 3:
	#tmp_health = max_health * 3
	#for w in wheel_holder.get_children():
		#tmp_health += w._max_health
	max_health = cer_1._max_health + cer_2._max_health + cer_3._max_health
	#max_health = max_h * 3
	#total_health = max_health
	#calculate_total_health()

#func _physics_process(delta):
	#if !Globals.can_move: return
	#wheel_holder.rotation.y -= deg_to_rad(30) * (delta * 2)
	#gun_laser_root

#func reduce_cerberus_health():
	#var spinners = get_tree().get_nodes_in_group("BossEnem")
	#for s in spinners:
		#s.health

func _on_crbanim_current_animation_changed(name):
	if name == "intro sequence":
		Globals.can_move = false


func _on_crbanim_animation_finished(anim_name):
	if anim_name == "intro sequence":
		#Globals.can_move = true
		cer_1.enable_hitbox()
		cer_2.enable_hitbox()
		cer_3.enable_hitbox()
		crb_intro_finish.emit()
		get_tree().create_timer(2.0).timeout.connect(func()->void:
			crbanim.play("asshole_rim")
		)

func end_fight():
	all_dead_captain.emit()

func count_dead():
	if !dead1 or !dead2 or !dead3: return
	end_fight()

func _on_cer_1_boss_death(pos: Vector3) -> void:
	dead1 = true
	forward_wheel_death(pos)
	#count_dead()


func _on_cer_2_boss_death(pos: Vector3) -> void:
	dead2 = true
	forward_wheel_death(pos)
	#count_dead()


func _on_cer_3_boss_death(pos: Vector3) -> void:
	dead3 = true
	forward_wheel_death(pos)
	

func forward_wheel_death(pos: Vector3) -> void:
	forward_dead_wheel.emit(pos)
	count_dead()


#func _on_cer_1_update_health():
	#pass # Replace with function body.
func calculate_total_health():
	#if !tr_hp_1 or !tr_hp_2 or !tr_hp_3: return
	total_health = cer_hp_one + cer_hp_two + cer_hp_three
	update_health.emit(total_health, max_health)

func _on_cer_update_health(hp: float, _max_hp: float) -> void:
	if !tr_hp_1:
		#cer_hp_one_max = max_hp
		tr_hp_1 = true
		#max_health_calc(_max_hp)
	cer_hp_one = hp
	
	calculate_total_health()


func _on_cer_2_update_serb_health(hp: float, _max_hp: float) -> void:
	if !tr_hp_2:
		#cer_hp_two_max = max_hp
		tr_hp_2 = true
		#max_health_calc()
	cer_hp_two = hp
	calculate_total_health()


func _on_cer_3_update_serb_health(hp: float, _max_hp: float) -> void:
	if !tr_hp_3:
		#cer_hp_two_max = max_hp
		tr_hp_3 = true
		max_health_calc()
	cer_hp_three = hp
	calculate_total_health()


#func _on_cer_1_boss_spawned(max_hp):
	#pass # Replace with function body.
