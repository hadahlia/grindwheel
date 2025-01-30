extends Area3D

signal core_destroyed

@onready var weakpoint_ = $".."
@onready var gem_anims = $"../gem_anims"
#@onready var mesh_ = $"../../mesh_"
#@onready var mesh_broken = $"../../mesh_broken"
@onready var mesh_ = $"../.."
@onready var mesh_broken = $"../../../mesh_broken"


var _piece_health : float = 20
var max_hp : float

func _ready():
	max_hp = _piece_health + ((_piece_health * Globals.RoundCount) * 0.2)

func _set_max_hp(val: float) -> void:
	_piece_health = val
	max_hp = _piece_health

func delete_triggers():
	mesh_broken.show()
	mesh_.hide()
	self.queue_free()

func _damage_core(val: float) -> void:
	
	_piece_health -= val
	core_destroyed.emit(val)
	if _piece_health <= 0:
		fucking_die()
		
		#gem_anims.play("die")
		
		#weakpoint_.queue_free()

func fucking_die():
	#core_destroyed.emit(max_hp)
	delete_triggers()

func _on_area_entered(area):
	var p = area.get_parent()
	if p is GrindWheel:
		print("Yeowch!!!")
		#print("hit!")
		_damage_core(p._saw_dmg)
