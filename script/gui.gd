extends Control

@onready var label = $Label
@onready var spin_meter = $spin_meter
@onready var stability_ui = $"Stability Gauge"


var player : GrindWheel
#@onready var plyr = get_tree().get_first_node_in_group("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	#plyr.
	#label.text = "charges: " + str(player._dash_charges) #+ "\n STABILITY: " + str(player._stability) + "\n dash lvl: " + str(player._dash_lvl)#"charges: 3"
	_on_grindwheel_charge_spent(player._dash_charges)
	_on_wheel_update_stability(player._stability)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_grindwheel_charge_spent(val: int)->void:
	label.text = "charges: " + str(val)


func _on_grindwheel_update_spin(new_spin: float) -> void:
	spin_meter.value = new_spin


func _on_wheel_update_stability(new_val: int):
	stability_ui.text = "STABILITY:" + str(new_val)
