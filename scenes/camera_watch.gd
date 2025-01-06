extends Camera3D

@export_node_path("CharacterBody3D") var look_target_path
var look_target
# Called when the node enters the scene tree for the first time.
func _ready():
	if look_target_path:
		look_target = get_node(look_target_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	self.look_at(look_target.position)
