extends State

@onready var ramses_anims = $"../../../ramses_anims"
@onready var ramses_left = $"../.."
@onready var vomit_timer = $vomit_timer


func enter():
	ramses_left._health = ramses_left._max_health /2
	ramses_left.update_hand_health.emit(ramses_left._health, ramses_left._max_health)
	ramses_anims.play("sweep_left")
	get_tree().create_timer(0.6).timeout.connect(func()->void:
		vomit_timer.start()
	)
	#enable fucking spam

func physics_update(_dt: float)-> void:
	pass


func _on_vomit_timer_timeout():
	ramses_left.fire_projectiles()
