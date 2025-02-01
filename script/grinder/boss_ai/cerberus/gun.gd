extends Node3D

@onready var cer_3 = $".."
@onready var shoot_timer = $shoot_timer

func _on_shoot_timer_timeout():
	cer_3.fire_projectiles()


func _on_crbanim_current_animation_changed(name):
	if name == "asshole_rim":
		shoot_timer.start()
