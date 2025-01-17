extends Control

@onready var arena_gui = $arena_gui
@onready var round_counter = $arena_gui/round_counter
@onready var boss_health = $arena_gui/boss_health
@onready var label = $arena_gui/Label
@onready var stability_ui = $"arena_gui/Stability Gauge"
@onready var spin_meter = $arena_gui/spin_meter

@onready var death = $death
@onready var flash_timer = $"death/flash timer"


#@onready var label = $Label
#@onready var spin_meter = $spin_meter
#@onready var stability_ui = $"Stability Gauge"
#
#@onready var round_counter = $round_counter
#@onready var boss_health = $boss_health


var player : GrindWheel
var bossy : BossWheel
#@onready var plyr = get_tree().get_first_node_in_group("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	bossy = get_tree().get_first_node_in_group("BossEnem")
	boss_health.max_value = bossy._health
	#plyr.
	#label.text = "charges: " + str(player._dash_charges) #+ "\n STABILITY: " + str(player._stability) + "\n dash lvl: " + str(player._dash_lvl)#"charges: 3"
	_on_grindwheel_charge_spent(player._dash_charges)
	_on_wheel_update_stability(player._stability)
	_on_bossl_update_health(bossy._health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_grindwheel_charge_spent(val: int)->void:
	label.text = "charges: " + str(val)


func _on_grindwheel_update_spin(new_spin: float) -> void:
	spin_meter.value = new_spin


func _on_wheel_update_stability(new_val: int):
	if new_val < 4:
		stability_ui.add_theme_color_override("font_color", Color(255,0,0,255))
	stability_ui.text = "STABILITY:" + str(new_val)


func _on_bossl_update_health(_new_health: float) -> void:
	boss_health.value = _new_health


func _on_grindwheel_die():
	arena_gui.hide()
	death.show()
	flash_timer.start()


func _on_flash_timer_timeout():
	death.visible = !death.visible
