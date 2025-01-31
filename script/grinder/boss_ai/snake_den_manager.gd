extends Node3D

signal intro_finish

signal snake_death

@onready var dipsa_spawn = $dipsa_spawn
@onready var dipsa_body = $dipsa_body


@onready var state_machine = $state_machine
@onready var snake_point_animated = $snake_point_animated
@onready var snake_chase_point = $snake_chase_point
#@onready var snake_point = $snake_point

# SFX
@onready var snake_idle = $dipsa_body/snake_idle

# Animation / State Tools
@onready var snake_animator = $snake_animator
@onready var state_timer = $state_timer

#var tunnel_id : int = 0

var chase_point_speed : float = 100

var target_pos : Vector3

var is_animating_point : bool = false

func _ready():
	_set_target(snake_point_animated.global_position)
	snake_animator.play("flight intro")
	dipsa_body.enter_phase_two.connect(_on_dipsa_phase_trans)
	#snake_idle.play()
	#_set_target(snake_point_animated.global_position)
	#target_pos = snake_point_animated.global_position

func kill_state_timer():
	state_timer.queue_free()

func _on_dipsa_phase_trans():
	
	if !state_timer: return
	if state_timer.is_stopped():
		state_timer.start()
		state_timer.timeout.disconnect(_on_state_timer_timeout)
		state_timer.timeout.connect(kill_state_timer)
	pass
	
	#state_timer.stop()
	
	#
	#state_machine.states["den_emerge"].enter()
	#state_machine.current_state = state_machine.states["den_emerge"]
	#dipsa_body.queue_free()
	#var dipsa_p2 := SnakeBoss.new()
	#dipsa_p2.name = "dipsa_body"
	#dipsa_p2._phase_two = true
	#add_child(dipsa_p2)
	#dipsa_body.duplicate()

#func spawn_dipsa():
	#var d : SnakeBoss = get_tree().get_first_node_in_group("BossEnem")
	#if d:
		#d.global_position = dipsa_spawn.global_position
	#pass
#func _on_snake_animator_animation_changed(old_name, new_name):
	#if new_name == "flight intro":
		#Globals.can_move = false
	#if old_name == "flight intro":
		#Globals.can_move = true
func _set_target(tar: Vector3)->void:
	target_pos = tar

func _physics_process(delta):
	#if !snake_chase_point: return
	if is_animating_point:
		_set_target(snake_point_animated.global_position)
	snake_chase_point.global_position = snake_chase_point.global_position.move_toward(target_pos, chase_point_speed * delta)

func _on_snake_animator_current_animation_changed(name):
	if name == "flight intro":
		is_animating_point = true
		Globals.can_move = false
	if name == "den_emerge":
		is_animating_point = true
		state_timer.start()
	if name == "hell":
		is_animating_point = true


func _on_snake_animator_animation_finished(anim_name):
	if anim_name == "flight intro":
		#Globals.can_move = true
		
		intro_finish.emit()
		#state_timer.start()
		
	if anim_name == "den_emerge":
		
		snake_animator.play("circle_test")
		
	
	if anim_name == "dispersal":
		state_machine.states["disperse"].enter()
		#state_timer.start()
	


func _on_state_timer_timeout():
	
	snake_animator.play("dispersal")
	#state_timer.stop()


#func _on_dipsa_body_boss_death():
	#


func _on_dipsa_body_boss_death() -> void:
	snake_idle.queue_free()
	#snake_death.emit(position)
