extends Node3D
class_name LightBullet

# what if like i set an initial direction on spawn with a function

func bullet_destroy():
	queue_free()
