extends Node3D

signal spawn_dianthus
signal upgrade_selected

#@onready var spinner_pickup_sfx = $spinner_upgrade_trig/spinner_pickup_sfx
#@onready var health_pickup_sfx = $health_upgrade_trig/health_pickup_sfx

@onready var spinner_upgrade_trig = $spinner_upgrade_trig

@onready var health_upgrade_trig = $health_upgrade_trig


#uh fuck. anyway upgrade player then delete yourself thx
func _ready():
	if Globals.RoundCount == 0:
		health_upgrade_trig.queue_free()
		spinner_upgrade_trig.position.x += 5

func _upgrade_chosen(health: bool) -> void:
	queue_free()
	upgrade_selected.emit(health)

func _on_health_upgrade_trig_body_entered(body):
	if body is GemSoul:
		Globals.GemMaxHP += 1
		body.max_health = Globals.GemMaxHP
		body.soul_health.emit(body.health, body.max_health)
		#health_pickup_sfx.play()
		_upgrade_chosen(true)


func _on_spinner_upgrade_trig_body_entered(body):
	if body is GemSoul:
		Globals.DianthusCount += 1
		spawn_dianthus.emit()
		#spinner_pickup_sfx.play()
		_upgrade_chosen(false)
