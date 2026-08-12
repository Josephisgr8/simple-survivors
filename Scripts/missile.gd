extends Area2D

#signal
signal enemyHitWithMissile(target)

var distTraveled
var penetrationValue
var flightDirection: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flightDirection = Vector2.from_angle(global_rotation)
	distTraveled = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#signal when hitting enemy
	pass
	#var overlappingAreas = get_overlapping_areas()
	#for area in overlappingAreas:
		#if area.name == "Enemy":
			#enemyHitWithMissile.emit(area)
			
func _on_area_entered(area: Area2D) -> void:
	#with the collision mask, this will always be an enemy
	enemyHitWithMissile.emit(area, self)
