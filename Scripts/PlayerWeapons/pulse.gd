extends Area2D
class_name Pulse

signal enemyHitWithWeapon

var enemiesHitList: Array[Area2D]
var isReturning: bool
var maxRange: float
var distTraveled: float
#this weapon's travel distance is affected by both range and size
@onready var sprite_2d: Sprite2D = $Sprite2D

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
	##signal when hitting enemy
	pass

func setOpacity(val: float):
	sprite_2d.modulate.a = val
