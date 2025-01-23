class_name WheelStats
extends Resource

@export_range(0,20) var dash_cooldown := 8

@export_group("Spinner Data")
@export var _movespeed : float = 10
@export var damage : int = 5
#@export var spin : int = 100
@export var rot_speed : float = 10
@export var stability : int = 10
@export var dash_max_charge : int = 4

@export_group("Boss-Specific Data")
@export var health : float = 2000

@export_group("SFX")
@export var bump_sound : AudioStream
@export var hit_sound : AudioStream
#@export var max_pierce
