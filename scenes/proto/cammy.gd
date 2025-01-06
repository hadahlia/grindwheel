extends Camera2D

#@onready var follow_target := $cam_target
@export_node_path("CharacterBody2D") var target_path
var follow_speed : float = 10
var target

# Called when the node enters the scene tree for the first time.
func _ready():
	if target_path:
		target = get_node(target_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#var lerp_x : float = lerpf(self.position.x, follow_target.position.x, follow_speed * delta)
	#var lerp_y : float = lerpf(self.position.y, follow_target.position.y, follow_speed * delta)
	position = lerp(position, target.position, follow_speed * delta)
