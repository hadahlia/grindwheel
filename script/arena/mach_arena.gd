extends Node3D

signal call_death_screen

const explosion_vfx : PackedScene = preload("res://scenes/vfx/deathsplosion.tscn")

@export_node_path("GrindWheel") var player_ref_path
var player_ref : GrindWheel
@export_node_path("BossWheel") var boss_ref_path
var boss_ref: BossWheel

const BASEDMG : float = 4

func _ready():
	player_ref = get_node(player_ref_path)
	boss_ref = get_node(boss_ref_path)

func _on_grindwheel_die(pos: Vector3) -> void:
	var exp := explosion_vfx.instantiate()
	add_child(exp)
	exp.global_position = pos
	exp.explode()
	call_death_screen.emit()


func _on_opponent_wheel_boss_death(pos: Vector3) -> void:
	var exp := explosion_vfx.instantiate()
	add_child(exp)
	exp.global_position = pos
	exp.explode()

# hm. i want two spinners to damage eachother when they crash based on compared velocity magnitudes. an amt of damage should be distributed
func _on_player_bumped(player_vel: Vector3, boss_vel: Vector3, boss_dmg: float) -> void:
	var bvdmg := boss_vel.length() * 4
	var pvdmg := player_vel.length() * 2
	print("me: ", str(player_vel), "boss: ", str(boss_vel))
	var vel_diff := boss_vel - player_vel
	#if vel_diff < 1:
	#note make damage more exponential
	if player_vel.length() >= boss_vel.length():
		#bvdmg *= 0.5
		#bvdmg = boss_vel * 0.5
		player_ref._set_spin_damage(bvdmg - vel_diff.length())
		#pvdmg = player_vel * 2
		boss_ref._take_damage_once(vel_diff.length() + pvdmg)
		#boss_ref._invuln = true
		#boss_ref.timer
		print("player wins collision!")
		boss_ref.stunned = true
		boss_ref._stun_timer.start()
		Globals.can_move = false
		player_ref._stun_timer.start()
		#boss_ref._invuln_timer.start()
	else:
		#pvdmg *= 0.5
		#bvdmg = boss_vel * 3
		player_ref._set_spin_damage(vel_diff.length() * bvdmg)
		#player_ref._invuln = true
		#pvdmg = player_vel #* 0.2
		boss_ref._take_damage_once(pvdmg - vel_diff.length() )
		print("boss wins collision!!!")
		Globals.can_move = false
		player_ref._stun_timer.start()
		boss_ref.stunned = true
		boss_ref._stun_timer.start()
	
	#player_ref._invuln_timer.start()
	#player_ref._set_spin_damage(vel_diff.length() + bvdmg)
	#boss_ref._take_damage_once(vel_diff.length() + pvdmg)
	#player_vel *= vel_diff.normalized()
	#boss_vel *= vel_diff.normalized()
	#player_ref._take_damage()
	player_ref.velocity = boss_vel * 2#* vel_diff * 0.5
	boss_ref.velocity = player_vel * 0.8 #* vel_diff * 0.5
