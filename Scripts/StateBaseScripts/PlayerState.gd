class_name PlayerState
extends Node

#signals
signal changePlayerState(state: PlayerState)

var player: CharacterBody2D #This is ok for the same reason as in the PlayerStateManager
var direction := Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update(delta: float) -> void:
	pass
	
func startState() -> void:
	pass
	
func changeState(newState) -> void:
	changePlayerState.emit(newState)
	pass
	
func move(dir):
	pass
