extends Area2D
class_name Boomerang

signal enemyHitWithWeapon

var enemiesHitList: Array[Area2D]
var flightDestination: Vector2
var bouncesRemaining: int
var isReturning: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemiesHitList = []
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for area in get_overlapping_areas():			#this is called instead of a signal because many times a boomerang will hit an enemy at the end of its trajectory and never
		if enemiesHitList.has(area):				#stop overlapping. This will then not signal that an enemy was hit.
			continue
		enemyHitWithWeapon.emit(area, self)
		enemiesHitList.append(area)
	#signal when hitting enemy
	pass
