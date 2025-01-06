extends Control

@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = "charges: 3"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_grindwheel_charge_spent(val: int)->void:
	label.text = "charges: " + str(val)
