extends Node3D

signal call_death_screen
signal fade_out
signal call_fade

#@onready var boss_spawn_pos = $SubViewportContainer/SubViewport/true_arena
@onready var true_arena = $SubViewportContainer/SubViewport/true_arena

@onready var boss_pos_start = $SubViewportContainer/SubViewport/true_arena/boss_pos_start
@onready var player_pos_start = $SubViewportContainer/SubViewport/true_arena/player_pos_start
@onready var hole_spot = $SubViewportContainer/SubViewport/true_arena/hole_spot

@onready var gui = $gui
@onready var cammie = $SubViewportContainer/SubViewport/true_arena/visual_/cammie


#player scene
const player_scene = preload("res://scenes/grindwheel.tscn")
const warp_hole = preload("res://scenes/god_hole.tscn")
const _3d_cursor = preload("res://scenes/3d_cursor.tscn")

#vfx scenes
const explosion_vfx : PackedScene = preload("res://scenes/vfx/deathsplosion.tscn")

#boss scenes
const dread_wheel : PackedScene = preload("res://scenes/opponent_wheel.tscn")

# refs to existing boss and player
#@export_node_path("GrindWheel") var player_ref_path
var player_ref : GrindWheel
#@export_node_path("BossWheel") var boss_ref_path
var boss_ref: BossWheel
var cursor_ref: Node3D

const ray_len : float = 1000

const BASEDMG : float = 4

func _ready():
	_start_round()
	cursor_ref = get_tree().get_first_node_in_group("SparkleCursor")
	_get_spinner_reference()

func _physics_process(_delta):
	if !cursor_ref: return
	#var mousepos = get_viewport().get_mouse_position()
	Globals.MousePos = get_viewport().get_mouse_position()
	
	var raycast = raycast_from_mouse(Globals.MousePos, 1)
	
	if raycast:
		Globals.RayPos = raycast.position
		cursor_ref.global_position = raycast.position
		if player_ref:
			player_ref.look_at(Vector3(raycast.position.x, -1, raycast.position.z), Vector3.UP)
	else:
		Globals.RayPos = Vector3.ZERO
		cursor_ref.global_position = Globals.OOB_POSITION
	
	

func raycast_from_mouse(m_pos, collision_mask):
	var ray_start = cammie.project_ray_origin(m_pos)
	var ray_end = ray_start + cammie.project_ray_normal(m_pos) * ray_len
	var world3d : World3D = get_world_3d()
	var space_state = world3d.direct_space_state
	
	if space_state == null:
		return
	
	var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end, collision_mask)
	query.collide_with_areas = true
	
	return space_state.intersect_ray(query)

func _start_round():
	spawn_cursor()
	spawn_player()
	spawn_boss()
	
	fade_out.emit()
	#await get_tree().create_timer(1.0).timeout
	#_get_spinner_reference()

func spawn_cursor():
	var vc := _3d_cursor.instantiate()
	true_arena.add_child(vc)
	vc.global_position = Globals.OOB_POSITION

func spawn_player():
	var p := player_scene.instantiate()
	p.bumped.connect(_on_player_bumped)
	p.die.connect(_on_grindwheel_die)
	#p.charge_spent()
	true_arena.add_child(p)
	p.global_position = player_pos_start.global_position

func spawn_boss():
	match Globals.RoundCount:
		1:
			var bc := dread_wheel.instantiate()
			
			true_arena.add_child(bc)
			bc.boss_death.connect(_on_opponent_wheel_boss_death)
			bc.global_position = boss_pos_start.global_position
			#bc.boss_spawned.connect(_get_spinner_reference)

func spawn_hole():
	var hc := warp_hole.instantiate()
	
	hc.trans_level.connect(_on_trans_level)
	hc.global_position = hole_spot.global_position
	true_arena.add_child(hc)

func _on_trans_level():
	call_fade.emit()

func _get_spinner_reference():
	#player_ref = get_node(player_ref_path)
	#boss_ref = get_node(boss_ref_path)
	player_ref = get_tree().get_first_node_in_group("Player")
	boss_ref = get_tree().get_first_node_in_group("BossEnem")
	#gui.post_ready()

func _on_grindwheel_die(pos: Vector3) -> void:
	cursor_ref.queue_free()
	spawn_explosion(pos)
	call_death_screen.emit()


func _on_opponent_wheel_boss_death(pos: Vector3) -> void:
	spawn_explosion(pos)
	spawn_hole()
	#Globals.superstate = Globals.GameState.WORLDPEACE

func spawn_explosion(pos: Vector3) -> void:
	var expl := explosion_vfx.instantiate()
	add_child(expl)
	expl.global_position = pos
	expl.explode()
# hm. i want two spinners to damage eachother when they crash based on compared velocity magnitudes. an amt of damage should be distributed
func _on_player_bumped(player_vel: Vector3, boss_vel: Vector3, _boss_dmg: float) -> void:
	if !player_ref or !boss_ref: _get_spinner_reference()
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
		#Globals.can_move = false
		#player_ref._stun_timer.start()
		#boss_ref._invuln_timer.start()
	else:
		#pvdmg *= 0.5
		#bvdmg = boss_vel * 3
		player_ref._set_spin_damage(vel_diff.length() * bvdmg + _boss_dmg)
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
	player_ref.velocity = boss_vel * 1.2#* vel_diff * 0.5
	boss_ref.velocity = player_vel * 0.8 #* vel_diff * 0.5
