extends Node3D

@onready var proj_holder = $proj_holder

#var player_ref : GemSoul

func _on_timer_timeout():
	queue_free()

func _set_directions():
	var player_ref : GemSoul = get_tree().get_first_node_in_group("Angel Gem")
	if !player_ref: return
	for i in proj_holder.get_children():
		#if i is LightBullet:
		i.set_direction(player_ref.global_position)
