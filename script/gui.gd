extends Control

signal start_game
signal cleanup

@onready var arena_gui = $arena_gui
@onready var stability_ui = $"arena_gui/Stability Gauge"
@onready var death = $death
@onready var flavortext = $death/flavortext
@onready var title_screen = $title_screen
@onready var ui_select = $title_screen/ui_select
@onready var title_music = $"../Sfx/title_music"


@onready var round_counter = $arena_gui/round_counter
@onready var boss_name = $arena_gui/boss_health/boss_name
@onready var values = $arena_gui/boss_health/values
@onready var boss_health = $arena_gui/boss_health


#@onready var boss_state_debug_label = $"arena_gui/boss state debug label"
@onready var boss_state_debug_label = $"arena_gui/state/boss state debug label"

#@onready var gem_health = $arena_gui/gem_health

@onready var round_0 = $round_0

@onready var spin_meter = $arena_gui/spin_meter
@onready var dash_charge_= $arena_gui/dash_charge_met



@onready var flash_timer = $"death/flash timer"

@onready var fade_anim = $fade/AnimationPlayer
@onready var title_anim = $title_screen/AnimationPlayer

var selected : bool = false
#@onready var label = $Label
#@onready var spin_meter = $spin_meter
#@onready var stability_ui = $"Stability Gauge"
#
#@onready var round_counter = $round_counter
#@onready var boss_health = $boss_health

var soul : GemSoul
var player : GrindWheel
var bossy : CharacterBody3D

var cerbman : CerberusMan
#var bossy : Node3D
#@onready var plyr = get_tree().get_first_node_in_group("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	#arena_gui.hide()
	pass

func post_ready():
	stability_ui.add_theme_color_override("font_color", Color(255,255,0,255))
	soul = get_tree().get_first_node_in_group("Angel Gem")
	if soul:
		soul.soul_health.connect(_update_gem_health)
		_update_gem_health(soul.health, soul.max_health)
	#player = get_tree().get_first_node_in_group("Player")
	#if player:
		#player.charge_spent.connect(_on_grindwheel_charge_spent)
		#player.update_spin.connect(_on_grindwheel_update_spin)
		#player.update_stability.connect(_on_wheel_update_stability)
		#_on_grindwheel_charge_spent(player._dash_charges)
		
	bossy = get_tree().get_first_node_in_group("BossEnem")
	cerbman = get_tree().get_first_node_in_group("Cerberus Manager")
	#var transmitted_hp: float = 0
	#var transmitted_max_hp: float = 0
	if bossy:
		bossy.update_health.connect(_on_bossl_update_health)
		#transmitted_max_hp = 
		#transmitted_hp = bossy._health
		boss_health.max_value = bossy._max_health
		#boss_health.max_value = bossy._health
		_on_bossl_update_health(bossy._health, bossy._max_health)
	
	if cerbman:
		cerbman.update_health.connect(_on_bossl_update_health)
		#transmitted_max_hp = 
		#transmitted_hp = cerbman.total_health
		boss_health.max_value = cerbman.max_health
		#boss_health.max_value = cerbman.max_health
		_on_bossl_update_health(cerbman.total_health, cerbman.max_health)
	
	#boss_health.max_value = transmitted_max_hp
	#_on_bossl_update_health(transmitted_hp, transmitted_max_hp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
func _update_gem_health(hp: int, max_hp: int) -> void:
	if hp < 2:
		stability_ui.add_theme_color_override("font_color", Color(255,0,0,255))
	stability_ui.text = "HP:" + str(hp) + "/" + str(max_hp)

func _update_state_label(state: String) -> void:
	boss_state_debug_label.text = state

func _set_boss_name(new_name: String) -> void:
	boss_name.text = new_name

#func _on_grindwheel_charge_spent(val: int)->void:
	#label.text = "charges: " + str(val)


func _on_grindwheel_update_spin(new_spin: float) -> void:
	spin_meter.value = new_spin

#func _hide_healthbar():
	#
#func _on_wheel_update_stability(new_val: int, max_val:int) -> void:
	
func _update_round() -> void:
	round_counter.text = "ROUND " + str(Globals.RoundCount) + "\nDIANTHUS " + str(Globals.DianthusCount)

func _on_bossl_update_health(_new_health: float, _max_health: float) -> void:
	#if !boss_health.visible: 
		#boss_health.hide()
		#return
	boss_health.value = _new_health
	
	
	values.text = str(_new_health) + "/" + str(_max_health)

#func _on_boss3_update_health(_new_health: float, _max_health: float) -> void:
	##if !boss_health.visible: 
		##boss_health.hide()
		##return
	#boss_health.value = _new_health
	#values.text = str(_new_health) + "/" + str(_max_health)
#@TODO update dash meter func

func _on_reset():
	flash_timer.stop()
	
	death.hide()
	arena_gui.show()
	

func _on_grindwheel_die():
	arena_gui.hide()
	death.show()
	flash_timer.start()


func _on_flash_timer_timeout():
	#death.visible = !death.visible
	flavortext.visible = !flavortext.visible


func _on_mach_arena_call_fade():
	fade_anim.play("fade_in")
	


func _on_mach_arena_fade_out():
	fade_anim.play("fade_trans")
	
	post_ready()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		cleanup.emit()


func _on_title_screen_gui_input(event):
	if event is InputEventMouseButton:
		print("Started")
		if !selected:
			ui_select.play()
			selected = true
		title_music.stop()
		title_anim.play("fade_title")
		start_game.emit()
		
func show_gui():
	arena_gui.show()
	boss_health.hide()
	if Globals.RoundCount == 0:
		round_0.show()
		
	else:
		round_0.hide()
	
		#boss_health.show()

func hide_text():
	round_0.hide()

func toggle_healthbar(yes: bool):
	if !yes:
		boss_health.hide()
		
	else:
		boss_health.show()

func _on_title_animation_finished(anim_name):
	if anim_name == "fade_title":
		title_screen.queue_free()
		
		


#func _on_mach_arena_fade_to_end():
	#pass # Replace with function body.
