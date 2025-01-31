extends State

@export var self_reference : BossWheel
#@onready var laser_machine = $"../../gun_/laser_machine"

@onready var laser_machine = $"../../laser_machine"
@onready var laser_idle = $"../../laser_idle"
@onready var gun_ = $"../../gun_"

#@onready var laser_direction_timer = $laser_direction_timer
@onready var laser_cooldown_timer = $laser_cooldown_timer

var target : Vector3

var fired : bool = false

var dir_clockwise : bool = false

var lase_mach : Node3D

func enter():
	target = get_tree().get_first_node_in_group("CenterPoint").global_position
	#fire_lasers()
	#laser_direction_timer.start()
	#lase_mach = laser_machine.duplicate()


func fire_lasers():
	
	#lase_mach = laser_machine.duplicate()
	#laser_machine.add_child(lase_mach)
	gun_.show()
	get_tree().create_timer(2.0).timeout.connect(func()->void:
		laser_machine.show()
		gun_.hide()
		#if laser_direction_timer.is_stopped():
			
		if laser_cooldown_timer.is_stopped():
			laser_cooldown_timer.start()
		for i in laser_machine.get_children():
			i.activation()
		fired = true
		_on_laser_direction_timer_timeout()
		laser_idle.play()
	)

func stop_lasers():
	#var a = laser_machine.duplicate()
	#laser_machine.queue_free()
	#laser_machine = a
	#lase_mach.queue_free()
	for i in laser_machine.get_children():
		i.deactivation()
	laser_machine.hide()
	#gun_.show()
	get_tree().create_timer(0.5).timeout.connect(func()->void:
		#laser_machine.hide()
		##gun_.hide()
		##laser_cooldown_timer.start()
		#
		fired = false
		#fire_lasers()
	)
	laser_idle.stop()
	
#func exit():
	#pass

#func update(_dt: float):
	#pass

func physics_update(_dt: float):
	if dir_clockwise:
		gun_.rotation.y -= deg_to_rad(30) * (_dt * 2)
		laser_machine.rotation.y -= deg_to_rad(30) * (_dt * 2)
	else:
		gun_.rotation.y += deg_to_rad(30) * (_dt * 2)
		laser_machine.rotation.y += deg_to_rad(30) * (_dt * 2)
	
	self_reference.global_position = self_reference.global_position.move_toward(target, 2 * _dt)
	
	if !fired and target.length() - self_reference.global_position.length() < 2:
		fire_lasers()



func _on_laser_direction_timer_timeout():
	dir_clockwise = !dir_clockwise
	


func _on_laser_cooldown_timer_timeout():
	#fired = false
	#if fired:
	stop_lasers()
	#else:
		#fire_lasers()
