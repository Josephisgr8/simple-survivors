class_name PlayerState_Idle_Alive
extends PlayerState


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _init() -> void:
	print("idle now init")
	
func move(dir):
	direction = dir
	if direction != Vector2(0,0):
		changePlayerState.emit(PlayerState_Moving_Alive.new())
