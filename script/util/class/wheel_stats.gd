class_name WheelStats
extends Resource

@export_range(0,5) var dash_cooldown := 0.5

@export_group("Spinner Data")
@export var speed := 200.0
@export var damage : int = 5
@export var spin : int = 100
@export var stability : int = 10

@export_group("SFX")
@export var bump_sound : AudioStream
#@export var max_pierce
