extends Node

signal cur_state

@export var init_state : State
@export var phase_2_state : State

var current_state: State
var states : Dictionary = {}

func _ready():
	for c in get_children():
		if c is State:
			states[c.name.to_lower()] = c
			c.Transition.connect(on_child_transition)
	
	if init_state:
		init_state.enter()
		current_state = init_state
		cur_state.emit(str(current_state.name))

func _process(delta):
	if current_state:
		current_state.update(delta)
	#print("cur state: " + str(current_state) + "init state: " + str(init_state))

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
	cur_state.emit(str(current_state))
	print("state chaged yay")


#func _on_enter_phase_two():
	#current_state.Transition(pursuit, last_stand)


func _enter_phase_two():
	if phase_2_state:
		phase_2_state.enter()
		current_state = phase_2_state
		cur_state.emit(str(current_state))
	#current_state.Transition.emit(pursuit, last_stand)
