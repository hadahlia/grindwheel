extends Node3D

@onready var state_machine = $state_machine

@onready var snake_animator = $snake_animator


func _ready():
	snake_animator.play("circle_test")
