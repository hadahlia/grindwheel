extends Node3D
class_name WarpHole

signal trans_level

@onready var trigger = $trigger


func teleport():
	Globals.RoundCount += 1
	trans_level.emit()
	trigger.queue_free()
	#queue_free()
	#Globals.RoundCount += 1


func _on_trigger_body_shape_entered(body):
	if body is GemSoul:
		teleport()
