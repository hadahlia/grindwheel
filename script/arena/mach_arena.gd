extends Node3D

signal uncall_death
signal call_death_screen
signal fade_out
signal call_fade
signal finally_fucking_start
#@onready var boss_spawn_pos = $SubViewportContainer/SubViewport/true_arena
@onready var true_arena = $SubViewportContainer/SubViewport/true_arena

@onready var pos_container = $SubViewportContainer/SubViewport/true_arena/pos_container


@onready var boss_pos_start = $SubViewportContainer/SubViewport/true_arena/boss_pos_start
@onready var player_pos_start = $SubViewportContainer/SubViewport/true_arena/player_pos_start
@onready var hole_spot = $SubViewportContainer/SubViewport/true_arena/hole_spot
#@onready var hole_spot = $SubViewportContainer/SubViewport/true_arena/hole_spot

@onready var gui = $gui
@onready var cammie = $SubViewportContainer/SubViewport/true_arena/visual_/cammie

var is_dead : bool = false
var once : bool = true
#player scene
const gem_scene = preload("res://scenes/angel_gem.tscn")
const dianthus_scene = preload("res://scenes/grindwheel.tscn")
const warp_hole = preload("res://scenes/god_hole.tscn")
const _3d_cursor = preload("res://scenes/3d_cursor.tscn")

#vfx scenes
const explosion_vfx : PackedScene = preload("res://scenes/vfx/deathsplosion.tscn")

#boss scenes
const dread_wheel : PackedScene = preload("res://scenes/opponent_wheel.tscn")

# refs to existing boss and player
#@export_node_path("GrindWheel") var player_ref_path
var gem_ref : GemSoul
#var player_ref : GrindWheel
#var dianthuses : Array
#@export_node_path("BossWheel") var boss_ref_path
var boss_ref: BossWheel
var cursor_ref: Node3D

const ray_len : float = 1000

const BASEDMG : float = 4

func _ready():
	fade_out.emit()
	#_start_round()
	pass

func _physics_process(_delta):
	if !cursor_ref : return
	#var mousepos = get_viewport().get_mouse_position()
	Globals.MousePos = get_viewport().get_mouse_position()
	var raycast = raycast_from_mouse(Globals.MousePos, 128)
	
	if raycast:
		Globals.RayPos = raycast.position
		cursor_ref.global_position = raycast.position
		#if abs(raycast.position.length() - player_ref.global_position.length()) > 2:
			#player_ref.look_at(Vector3(raycast.position.x, -0.8, raycast.position.z), Vector3.UP)
	#else:
		#Globals.RayPos = Vector3.ZERO
		#cursor_ref.global_position = Globals.OOB_POSITION

func _input(event):
	if !is_dead: return
	
	if Input.is_action_just_pressed("reset"):
		
		_on_trans_level()
	
	

func raycast_from_mouse(m_pos, collision_mask):
	var ray_start = cammie.project_ray_origin(m_pos)
	var ray_end = ray_start + cammie.project_ray_normal(m_pos) * ray_len
	var world3d : World3D = get_world_3d()
	var space_state = world3d.direct_space_state
	
	if space_state == null:
		return
	
	var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end, collision_mask)
	#query.collide_with_areas = true
	#query.hit_from_inside = true
	#query.hit_back_faces = true
	
	return space_state.intersect_ray(query)

func _start_round():
	
	
	spawn_cursor()
	spawn_gem()
	spawn_player()
	spawn_boss()
	
	fade_out.emit()
	#await get_tree().create_timer(1.0).timeout
	_get_spinner_reference()

func spawn_cursor():
	var vc := _3d_cursor.instantiate()
	true_arena.add_child(vc)
	vc.global_position = Globals.OOB_POSITION

func spawn_gem():
	is_dead = false
	uncall_death.emit()
	var g := gem_scene.instantiate()
	g.shatter.connect(_on_gem_die)
	true_arena.add_child(g)
	g.global_position = Vector3(player_pos_start.position.x, -3.8, player_pos_start.position.z)

func spawn_player():
	
	
	var index : float = 1
	for i in range(Globals.DianthusCount):
		var p := dianthus_scene.instantiate()
		var m := Marker3D.new()
		m.global_position = Vector3(0, -2.6, 1 + index)
		index+=2
		#p.bumped.connect(_on_player_bumped)
	#p.die.connect(_on_grindwheel_die)
	#p.charge_spent()
		pos_container.add_child(m)
		p.global_position = m.global_position
		true_arena.add_child(p)
		
	pass

func spawn_boss():
	match Globals.RoundCount:
		1:
			var bc := dread_wheel.instantiate()
			
			true_arena.add_child(bc)
			bc.boss_death.connect(_on_opponent_wheel_boss_death)
			bc.global_position = boss_pos_start.global_position
			gui._update_state_label(bc._state_transmit)
			gui._set_boss_name(" DREAD WHEEL ")
			#bc.boss_spawned.connect(_get_spinner_reference)

func spawn_hole():
	var hc := warp_hole.instantiate()
	
	hc.trans_level.connect(_on_trans_level)
	hc.global_position = hole_spot.global_position
	true_arena.add_child(hc)

func _on_trans_level():
	call_fade.emit()

func _get_spinner_reference():
	cursor_ref = get_tree().get_first_node_in_group("SparkleCursor")
	#player_ref = get_node(player_ref_path)
	#boss_ref = get_node(boss_ref_path)
	gem_ref = get_tree().get_first_node_in_group("Angel Gem")
	#player_ref = get_tree().get_first_node_in_group("Dianthus")
	#dianthuses = get_tree().get_nodes_in_group("Dianthus")
	boss_ref = get_tree().get_first_node_in_group("BossEnem")
	#gui.post_ready()



func _on_gem_die(pos: Vector3) -> void:
	cursor_ref.queue_free()
	spawn_explosion(pos)
	call_death_screen.emit()
	is_dead = true


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
#func _on_player_bumped(player_vel: Vector3, boss_vel: Vector3, _boss_dmg: float) -> void:
	#if !gem_ref or !boss_ref: _get_spinner_reference()
	#var bvdmg := boss_vel.length() * 4
	#var pvdmg := player_vel.length() * 2
	#print("me: ", str(player_vel), "boss: ", str(boss_vel))
	#var vel_diff := boss_vel - player_vel
	##if vel_diff < 1:
	##note make damage more exponential
	#if player_vel.length() >= boss_vel.length():
		##bvdmg *= 0.5
		##bvdmg = boss_vel * 0.5
		##player_ref._set_spin_damage(bvdmg + vel_diff.length())
		##pvdmg = player_vel * 2
		#boss_ref._take_damage_once(vel_diff.length() + pvdmg)
		##boss_ref._invuln = true
		##boss_ref.timer
		#print("player wins collision!")
		#
		#boss_ref.stunned = true
		#boss_ref._stun_timer.start()
		##Globals.can_move = false
		##player_ref._stun_timer.start()
		##boss_ref._invuln_timer.start()
	#else:
		##pvdmg *= 0.5
		##bvdmg = boss_vel * 3
		#player_ref._set_spin_damage(vel_diff.length() * bvdmg + _boss_dmg)
		##player_ref._invuln = true
		##pvdmg = player_vel #* 0.2
		#boss_ref._take_damage_once(pvdmg * 0.5 + vel_diff.length() )
		#print("boss wins collision!!!")
		#Globals.can_move = false
		#player_ref._stun_timer.start()
		#boss_ref.stunned = true
		#boss_ref._stun_timer.start()
	##player_ref.attack_sfx.play()
	##player_ref._invuln_timer.start()
	##player_ref._set_spin_damage(vel_diff.length() + bvdmg)
	##boss_ref._take_damage_once(vel_diff.length() + pvdmg)
	##player_vel *= vel_diff.normalized()
	##boss_vel *= vel_diff.normalized()
	##player_ref._take_damage()
	#
	##player_ref.velocity = boss_vel * 1.2#* vel_diff * 0.5
	#boss_ref.velocity = player_vel #* 0.8 #* vel_diff * 0.5

func destroy_actors():
	var sg = get_tree().get_first_node_in_group("Angel Gem")
	
	var bss = get_tree().get_first_node_in_group("BossEnem")
	if bss:
		bss.queue_free()
	
	var pp = get_tree().get_nodes_in_group("Dianthus")
	#var bp = get_tree().get_first_node_in_group("BossEnem")
	var hole = get_tree().get_first_node_in_group("Portal")
	if sg:
		sg.queue_free()
	for i in pp:
		i.queue_free()
	
	for c in pos_container.get_children():
		c.queue_free()
	#if pp :
		#pp.queue_free()
	if hole:
		hole.queue_free()

func _on_gui_cleanup():
	destroy_actors()
	await get_tree().create_timer(1.0).timeout
	
	#await get_tree().create_timer(2.0).timeout
	_start_round()
	#_get_spinner_reference()


func _on_gui_start_game():
	print("started :3:3:3")
	cammie._is_moving = true
	
	await get_tree().create_timer(3.0).timeout
	cammie._is_moving = false
	if once == true:
		finally_fucking_start.emit()
		once = false
	


func _on_finally_fucking_start():
	print("hiiiiiiiiiii")
	#_on_trans_level()
	_start_round()
