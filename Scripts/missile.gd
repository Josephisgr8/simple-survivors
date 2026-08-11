extends Area2D

var distTraveled
var flightDirection: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#flightDirection = Vector2.from_angle(global_rotation + deg_to_rad(-90))
	flightDirection = Vector2.from_angle(global_rotation)
	distTraveled = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
