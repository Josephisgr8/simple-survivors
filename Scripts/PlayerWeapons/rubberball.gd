extends Area2D
class_name RubberBall

signal enemyHitWithWeapon

var enemiesHitList: Array[Area2D]
var targetLocation: Vector2
var bouncesRemaining: int
var distTraveled: float
var maxDist: float

func _ready() -> void:
	distTraveled = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for area in get_overlapping_areas():
		if enemiesHitList.size() == 0:						#this is called instead of a signal because many times a rubberball will remain overlapped with it's previous target after
			pass											#hitting a new target
		elif area == enemiesHitList.get(enemiesHitList.size()-1):
			return
		enemiesHitList.append(area)
		enemyHitWithWeapon.emit(area, self)
	#signal when hitting enemy
	pass
