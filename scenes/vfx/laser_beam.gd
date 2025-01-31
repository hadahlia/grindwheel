extends Node3D

@onready var main_energy = $main_energy
@onready var little_energy = $little_energy
@onready var laser_crown = $laser_crown
@onready var collision_shape_3d = $death_area/CollisionShape3D

@onready var sparkles = $sparkles

#@onready var animation_player = $AnimationPlayer

func _ready():
	pass

func activation():
	main_energy.emitting = true
	little_energy.emitting = true
	laser_crown.emitting = true
	sparkles.emitting = true
	collision_shape_3d.disabled = false

func deactivation():
	#main_energy.emitting = false
	#little_energy.emitting = false
	#laser_crown.emitting = false
	#sparkles.emitting = false
	collision_shape_3d.disabled = true
#func _play_beam():
	#animation_player.play("Beam Effect")
