extends Area2D
class_name Missile

#signal
signal enemyHitWithMissile(target)

var distTraveled: float
var penetrationValue: int
var flightDirection: Vector2
var enemiesHitList: Array[Area2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flightDirection = Vector2.from_angle(global_rotation)
	distTraveled = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#signal when hitting enemy
	pass
			
func _on_area_entered(area: Area2D) -> void:
	#with the collision mask, this will always be an enemy
	
	#if enemy already hit, don't count as hit
	if enemiesHitList.has(area):
		return
	enemyHitWithMissile.emit(area, self)
	enemiesHitList.append(area)
