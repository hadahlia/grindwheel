extends Node3D
class_name WarpHole

signal trans_level

func teleport():
	trans_level.emit()
	#queue_free()
	#Globals.RoundCount += 1


func _on_trigger_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is GemSoul:
		teleport()
