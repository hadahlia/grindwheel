extends Node3D
class_name EndHole

signal end_game

@onready var trigger = $trigger


func heleport():
	end_game.emit()
	trigger.queue_free()
	#Globals.RoundCount += 1
	#trans_level.emit()
	#queue_free()
	#Globals.RoundCount += 1


func _on_trigger_body_shape_entered(body):
	if body is GemSoul:
		heleport()
