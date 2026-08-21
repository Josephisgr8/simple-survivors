extends Resource
class_name PlayerStatsResource

#HUD signals
signal CurrentHPUpdated
signal MaxHPUpdated

#player stats
@export var speed := 200.0:
	set(value):
		speed = value
		
@export var speedMultiplier := 1.0:
	set(value):
		speedMultiplier = value
		
@export var maxHP := 10:
	set(value):
		maxHP = value
		MaxHPUpdated.emit()
		
@export var currHP := maxHP:
	set(value):
		currHP = value
		CurrentHPUpdated.emit()
		print("curr hp modified")
		
@export var invincibilityDurationSecs := 1.0:
	set(value):
		invincibilityDurationSecs = value
		
@export var currentXP: int = 0:
	set(value):
		currentXP = value
		
@export var xpToLevel: int = 10:
	set(value):
		xpToLevel = value
		
@export var xpPickupRange := 100.0:
	set(value):
		xpPickupRange = value
		
@export var currPlayerLevel: int = 1:
	set(value):
		currPlayerLevel = value
		
@export var antiSpawnRadius: float = 400:
	set(value):
		antiSpawnRadius = value



#stat multipliers
@export var damageMult := 1.0:
	set(value):
		damageMult = value
		
@export var rangeMult := 1.0:
	set(value):
		rangeMult = value
		
@export var castSpeedMult := 1.0:
	set(value):
		castSpeedMult = value
		
@export var sizeMult := 1.0:
	set(value):
		sizeMult = value
		
@export var projectileSpeedMult := 1.0:
	set(value):
		projectileSpeedMult = value
		
@export var xpMult := 1.0:
	set(value):
		xpMult = value
		
@export var xpToLevelMult := 1.5:
	set(value):
		xpToLevelMult = value
		
@export var xpPickupRangeMult := 1.0:
	set(value):
		xpPickupRangeMult = value
		
