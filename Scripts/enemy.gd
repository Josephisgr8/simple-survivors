extends Area2D

#signals
signal HittingPlayer()

var speed = 100.0
var speedMultiplier = 1
var damage = 1
var damageMultiplier = 1
var playerPos

#func _init() -> void:


func _process(delta: float) -> void:
	#move
	var currPos = Vector2(position.x, position.y)
	position = currPos.move_toward(playerPos, speed * speedMultiplier * delta)
	
	#check if overlapping
	var overlappingAreas = get_overlapping_areas()
	for area in overlappingAreas:
		if area.name == "Player":
			HittingPlayer.emit(self, damage * damageMultiplier)

func updatePlayerPos(pos):
	playerPos = pos
