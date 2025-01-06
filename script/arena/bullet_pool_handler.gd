extends Node3D

signal all_bullets_despawned
signal bullets_despawned_by_type

const BULLET_DIR_PATH : String = "res://scenes/bullet"

var idle_bullets : Dictionary = {}
var active_bullets : Dictionary = {}
var bullet_timer : Timer = Timer.new()

func _ready() -> void:
	bullet_timer.set_one_shot(true)
	add_child(bullet_timer)

func init_bullets(bullet_types_dict: Dictionary) -> void:
	var new_bullet: AnimatedSprite3D
	var bullet_scene: PackedScene
	for bullet_type in bullet_types_dict:
		if not idle_bullets.get(bullet_type, false):
			idle_bullets[bullet_type] = []
		var n_bullets = clamp(bullet_types_dict[bullet_type] - len(idle_bullets[bullet_type]), 0, 100)
		bullet_scene = load("%s/%s.tscn" % [BULLET_DIR_PATH, bullet_type.to_lower()])
		for _i in range(n_bullets):
			new_bullet = create_bullet(bullet_scene)
			idle_bullets[bullet_type].append(new_bullet.get_instance_id())

func clear_all_bullets() -> void:
	pass

func clear_active_bullets() -> void:
	pass

func clear_idle_bullets() -> void:
	pass

func despawn_active_bullets() -> void:
	pass

func despawn_active_bullets_by_type(bullet_type: String) -> void:
	pass

func get_available_bullets(bullet_type: String):
	pass

func remove_all_active_bullets() -> void:
	pass

func remove_active_bullet(bullet_type: String, bullet_id: int)-> void:
	pass

func create_bullet(bulletscene: PackedScene) -> AnimatedSprite3D:
	var bullet = bulletscene.instantiate()
	get_tree().get_root().add_child(bullet)
	#bullet.set_position(Globals.OOB_POSITION)
	return bullet

func shoot_bullet():
	pass

func spawn_bullet():
	pass
