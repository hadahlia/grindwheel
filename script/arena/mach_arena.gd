extends Node3D

const explosion_vfx : PackedScene = preload("res://scenes/vfx/deathsplosion.tscn")

func _on_grindwheel_die(pos: Vector3) -> void:
	var exp := explosion_vfx.instantiate()
	add_child(exp)
	exp.global_position = pos
	exp.explode()
