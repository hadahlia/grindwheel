extends Node

const OOB_POSITION : Vector3 = Vector3(-99999, 0.8, -99999)

var can_move : bool = true

enum GameState { FIGHT, MENU1, MENU2, WORLDPEACE }
var superstate = GameState.MENU1

var RoundCount : int = 1

var OrbitMode : bool = false
var DianthusCount : int = 16

var MousePos : Vector2
var RayPos : Vector3
