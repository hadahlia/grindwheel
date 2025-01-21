extends Control

signal cleanup

@onready var arena_gui = $arena_gui
@onready var stability_ui = $"arena_gui/Stability Gauge"
@onready var death = $death

@onready var round_counter = $arena_gui/round_counter

@onready var boss_health = $arena_gui/boss_health
@onready var boss_name = $arena_gui/boss_name
@onready var boss_state_debug_label = $"arena_gui/boss state debug label"


@onready var label = $arena_gui/Label

@onready var spin_meter = $arena_gui/spin_meter
@onready var dash_charge_= $arena_gui/dash_charge_met



@onready var flash_timer = $"death/flash timer"

@onready var fade_anim = $fade/AnimationPlayer

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
	pass

func post_ready():
	stability_ui.add_theme_color_override("font_color", Color(255,255,0,255))
	player = get_tree().get_first_node_in_group("Player")
	player.charge_spent.connect(_on_grindwheel_charge_spent)
	player.update_spin.connect(_on_grindwheel_update_spin)
	player.update_stability.connect(_on_wheel_update_stability)
	bossy = get_tree().get_first_node_in_group("BossEnem")
	bossy.update_health.connect(_on_bossl_update_health)
	boss_health.max_value = bossy._health
	dash_charge_.value = 0
	_on_grindwheel_charge_spent(player._dash_charges)
	_on_wheel_update_stability(player._stability)
	_on_bossl_update_health(bossy._health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
func _update_state_label(state: String) -> void:
	boss_state_debug_label.text = state

func _set_boss_name(new_name: String) -> void:
	boss_name.text = new_name

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

#@TODO update dash meter func

func _on_grindwheel_die():
	arena_gui.hide()
	death.show()
	flash_timer.start()


func _on_flash_timer_timeout():
	death.visible = !death.visible


func _on_mach_arena_call_fade():
	fade_anim.play("fade_in")
	


func _on_mach_arena_fade_out():
	fade_anim.play("fade_trans")
	post_ready()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		cleanup.emit()
