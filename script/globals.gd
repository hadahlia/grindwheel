extends Node

const OOB_POSITION : Vector3 = Vector3(-99999, -99999, -99999)

var can_move : bool = true

enum GameState { FIGHT, MENU1, MENU2, WORLDPEACE }
var superstate = GameState.MENU1

var RoundCount : int = 1
