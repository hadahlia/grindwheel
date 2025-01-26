extends Control

@onready var _bg = $TitleCardBG


func _process(delta):
	_bg.rotation_degrees += 10 * delta
