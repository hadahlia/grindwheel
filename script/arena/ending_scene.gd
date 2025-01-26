extends Node3D

signal final_fade

@onready var ending_player = $ending_player


#func _ready():

func play_ending():
	ending_player.play("ending_scene")


func _on_ending_player_animation_finished(anim_name):
	if anim_name == "ending_scene":
		final_fade.emit()
