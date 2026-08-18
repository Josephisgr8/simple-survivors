extends Sprite2D

var xpValue: int #This is the total xp value of the orb, and is used to increase the size of the orb.


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func resize(baseScale, addScale) -> void:
	var totScale: float = (xpValue * addScale) + baseScale
	global_scale = Vector2(totScale, totScale)
