extends Area3D

signal core_destroyed

@onready var weakpoint_ = $".."
@onready var gem_anims = $"../gem_anims"
#@onready var mesh_ = $"../../mesh_"
#@onready var mesh_broken = $"../../mesh_broken"
@onready var mesh_ = $"../.."
@onready var mesh_broken = $"../../../mesh_broken"

@onready var _invuln_timer = $"../../../../_invuln_timer"
@onready var dipsa_body = $"../../../.."


var _piece_health : float = 20
var max_hp : float

var invuln: bool = false

func _ready():
	max_hp = _piece_health + ((_piece_health * Globals.RoundCount) * 0.2)

func _set_max_hp(val: float) -> void:
	_piece_health = val
	max_hp = _piece_health

func delete_triggers():
	mesh_broken.show()
	mesh_.hide()
	mesh_.queue_free()
	#self.queue_free()

#func start_invuln():
	#invuln = true
	#_invuln_timer.start()

func _damage_core(val: float) -> void:
	if dipsa_body._invuln: return
	_piece_health -= val
	core_destroyed.emit(val)
	if _piece_health <= 0:
		fucking_die()
	
	
		#gem_anims.play("die")
		
		#weakpoint_.queue_free()

func fucking_die():
	core_destroyed.emit(10)
	delete_triggers()

func _on_area_entered(area):
	var p = area.get_parent()
	if p is GrindWheel:
		#print("Yeowch!!!")
		#print("hit!")
		_damage_core(p._saw_dmg)


func _on__invuln_timer_timeout():
	invuln = false
