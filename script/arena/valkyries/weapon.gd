extends Node3D

@export var stats : WeaponStats

#var bullet_scene : PackedScene = preload("res://scenes/proto/projectile.tscn")
var shoot_sfx

var is_cooldown := false
var cooldown_timer : Timer

func _ready():
	cooldown_timer = Timer.new()
	cooldown_timer.name = "shoot timer"
	cooldown_timer.wait_time = stats.fire_cooldown
	cooldown_timer.timeout.connect(_on_timer_finish)
	add_child(cooldown_timer)

#func _physics_process(delta: float) -> void:
	#if Input.is_action_pressed("Fire") && !is_cooldown:
		#var child_bullet : Bullet

func _on_timer_finish():
	is_cooldown = false
