extends State

@export var self_reference : CharacterBody3D
#@onready var laser_machine = $"../../gun_/laser_machine"
@onready var gun_laser_root = $"../../gun_laser_root"

#@onready var laser_machine = $"../../laser_machine"
@onready var laser_idle = $"../../laser_idle"
@onready var gun_ = $"../../gun_laser_root/gun_"

#@onready var laser_direction_timer = $laser_direction_timer
@onready var laser_cooldown_timer = $laser_cooldown_timer

var laser_machine_scene : PackedScene = preload("res://scenes/boss1/laser_machine.tscn")
var laser_machine : Node3D

var target : Vector3

var fired : bool = false

var dir_clockwise : bool = false

#var lase_mach : Node3D

var laser_exists : bool = false

func enter():
	target = get_tree().get_first_node_in_group("CenterPoint").global_position
	self_reference.set_physics_process(false)
	get_tree().create_timer(1.0).timeout.connect(func()->void:
		fire_lasers()
	)
	
	#laser_direction_timer.start()
	#laser_machine = laser_machine_a.duplicate()
	#self_reference.add_child(laser_machine)

#func create_laser():
	#if laser_machine: return
	#laser_machine = laser_machine_scene.instantiate()
	#gun_laser_root.add_child(laser_machine)
	#laser_machine.hide()

func fire_lasers():
	if laser_exists or fired: return
	laser_machine = laser_machine_scene.instantiate()
	gun_laser_root.add_child(laser_machine)
	laser_exists = true
	laser_machine.hide()
	#if !laser_machine:
		#laser_machine = laser_machine_scene.instantiate()
		#self_reference.add_child(laser_machine)
	#lase_mach = laser_machine.duplicate()
	#laser_machine.add_child(lase_mach)
	gun_.show()
	get_tree().create_timer(3.0).timeout.connect(func()->void:
		#if laser_machine:
		laser_machine.show()
		gun_.hide()
		#if laser_direction_timer.is_stopped():
			
		#if laser_cooldown_timer.is_stopped():
			#laser_cooldown_timer.start()
		for i in laser_machine.get_children():
			i.activation()
		laser_cooldown_timer.start()
		
		
		laser_idle.play()
	)

func stop_lasers():
	#var a = laser_machine.duplicate()
	#call_deferred(laser_machine.free)
	#laser_machine.call_deferred("free")
	#if laser_machine:
		#laser_machine.call_deferred("free")
	#laser_machine = a
	#lase_mach.queue_free()
	
	#for i in laser_machine.get_children():
		#i.deactivation()
		#i.queue_free()
	#
	#laser_machine.queue_free()
	#laser_machine.hide()
	gun_.show()
	
	
	laser_idle.stop()
	get_tree().create_timer(2.0).timeout.connect(func()->void:
		##laser_machine.hide()
		###gun_.hide()
		###laser_cooldown_timer.start()
		##
		#laser_machine = laser_machine_a.duplicate()
		#self_reference.add_child(laser_machine)
		fired = false
		fire_lasers()
	)
	
	
#func exit():
	#pass

#func update(_dt: float):
	#pass

func physics_update(_dt: float):
	#if !laser_machine: return
	if dir_clockwise:
		self_reference.rotation.y -= deg_to_rad(30) * (_dt * 2)
		#laser_machine.rotation.y -= deg_to_rad(30) * (_dt * 2)
	else:
		self_reference.rotation.y += deg_to_rad(30) * (_dt * 2)
		#laser_machine.rotation.y += deg_to_rad(30) * (_dt * 2)
	
	self_reference.global_position = self_reference.global_position.move_toward(target, 10 * _dt)
	
	#if !fired and target.length() - self_reference.global_position.length() < 3:
		#fire_lasers()



func _on_laser_direction_timer_timeout():
	if dir_clockwise:
		dir_clockwise = false
	else:
		dir_clockwise = true
	#dir_clockwise = !dir_clockwise
	


func _on_laser_cooldown_timer_timeout():
	if laser_exists:
		laser_machine.queue_free()
		_on_laser_direction_timer_timeout()
		laser_exists = false
	fired = true
	#if fired:
	stop_lasers()
	
	#else:
		#fire_lasers()
