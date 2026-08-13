class_name PlayerState_Moving_Alive
extends PlayerState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update(delta):
	player.global_position += direction * player.speed * player.speedMultiplier * delta
	
func move(dir):
	direction = dir
	if direction == Vector2(0,0):
		changePlayerState.emit(PlayerState_Idle_Alive.new())
