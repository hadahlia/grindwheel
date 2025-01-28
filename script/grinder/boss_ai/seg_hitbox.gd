extends Area3D

signal core_destroyed

@onready var weakpoint_ = $".."

var _piece_health : float = 20
var max_hp : float

func _ready():
	max_hp = _piece_health

func _damage_core(val: float) -> void:
	_piece_health -= val
	if _piece_health <= 0:
		fucking_die()
		weakpoint_.queue_free()

func fucking_die():
	core_destroyed.emit(max_hp)

func _on_area_entered(area):
	var p = area.get_parent()
	if p is GrindWheel:
		print("Yeowch!!!")
		#print("hit!")
		_damage_core(p._saw_dmg)
