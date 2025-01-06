extends Control

@onready var label = $Label
var player : GrindWheel
#@onready var plyr = get_tree().get_first_node_in_group("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	#plyr.
	label.text = "charges: " + str(player._dash_charges) #"charges: 3"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_grindwheel_charge_spent(val: int)->void:
	label.text = "charges: " + str(val)
