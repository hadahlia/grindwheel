extends Node3D
class_name LightBullet

@export var bullet_speed : float = 20

# what if like i set an initial direction on spawn with a function
#var player_ref : GemSoul
var direction : Vector3


func bullet_destroy():
	queue_free()

#func _ready():
	#pass

func set_direction(dest: Vector3):
	#player_ref = get_tree().get_first_node_in_group("Angel Gem")
	#if player_ref:
		#direction = Vector3(player_ref.global_position.x - self.global_position.x, 0, player_ref.global_position.z - self.global_position.z)
	direction = Vector3(dest.x - self.global_position.x, 0, dest.z - self.global_position.z)

func _physics_process(delta):
	var vel : Vector3 = direction.normalized() * bullet_speed
	global_position += vel * delta
