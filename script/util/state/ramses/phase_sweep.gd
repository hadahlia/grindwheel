extends State

@onready var ramses_anims = $"../../../ramses_anims"
@onready var ramses_right = $"../.."
#@onready var laser_beam = $laser_beam
@onready var laser_cooldown = $laser_cooldown
@onready var laser_sustain = $laser_sustain
@onready var laser_idle = $"../../../laser_idle"

var laser_scene : PackedScene = preload("res://scenes/vfx/laser_beam.tscn")
var laser_machine : Node3D

func enter():
	ramses_right._health = ramses_right._max_health /2
	ramses_right.update_hand_health.emit(ramses_right._health, ramses_right._max_health)
	ramses_right.set_physics_process(false)
	ramses_right.rotation_degrees = Vector3(-90,-90,0)
	ramses_anims.play("sweep_right")
	laser_cooldown.start()
	#laser_beam.show()
	#laser_beam.activation()
	#enable laser

func physics_update(_dt: float)-> void:
	pass

func fire_laser():
	#if laser_machine == null
	laser_machine = laser_scene.instantiate()
	laser_idle.play()
	ramses_right.add_child(laser_machine)
	laser_machine.transform.origin = Vector3(3,0,0)
	laser_machine.rotation_degrees.y = 90
	laser_machine.rotation_degrees.z = 90
	laser_machine.activation()
	
	laser_sustain.start()

func free_laser():
	get_tree().create_timer(0.1).timeout.connect(func()->void:
		laser_machine.queue_free()
		laser_idle.stop()
	)
	
	#laser_cooldown.start()

func _on_laser_cooldown_timeout():
	fire_laser()


func _on_laser_sustain_timeout():
	free_laser()


func _on_ramses_anims_animation_finished(anim_name):
	if anim_name == "sweep_left" or anim_name == "sweep_right":
		laser_cooldown.start()
