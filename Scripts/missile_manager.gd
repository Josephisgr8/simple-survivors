extends Node

#signals for parent
signal MissileReadyToFire(range)

#members to handle missiles
var missileList: Array[Area2D]
const MissileBlueprint: PackedScene = preload("res://Scenes/missile.tscn")

#missile base stats
var projectileSpeed = 350
var castSpeed = 2
var projectileDamage = 1
var castRange = 500
var penetrationValue = 1

#missile multipliers
var projectileSpeedMult = 1
var castSpeedMult = 1
var projectileDamageMult = 1
var rangeMult = 1
var sizeMult = 1
var penetrationValueMult = 1


@onready var attackTimer: Timer = $MissileAttackTimer

#update Variables
func updateVariables(projSpdMult, cstSpdMult, dmgMult, rngMult, szMult) -> void:
	projectileSpeedMult = projSpdMult
	castSpeedMult = cstSpdMult
	projectileDamageMult = dmgMult
	rangeMult = rngMult
	sizeMult = szMult
	attackTimer.wait_time = castSpeed * castSpeedMult


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	_updateMissileLocation(projectileSpeed, projectileSpeedMult, delta)
	pass


func createMissile(xFromLoc, yFromLoc, xToLoc, yToLoc) -> void:
	var newMissile = MissileBlueprint.instantiate()
	
	#set var values and add missile to list
	newMissile.global_position = Vector2(xFromLoc, yFromLoc)
	newMissile.look_at(Vector2(xToLoc,yToLoc))
	newMissile.global_scale = newMissile.global_scale * sizeMult
	newMissile.penetrationValue = penetrationValue * penetrationValueMult
	missileList.append(newMissile)
	add_child(newMissile)
	
	#set up signal for each new missile
	newMissile.enemyHitWithMissile.connect(_onEnemyHitWithMissile)


func _on_missile_attack_timer_timeout() -> void:
	MissileReadyToFire.emit(castRange * rangeMult)


func _updateMissileLocation(prjSpd, prjSpdMlt, delta):
	for i in range(missileList.size()-1 ,-1,  -1):
		var cm = missileList.get(i) # current missile
		var fs = prjSpd * prjSpdMlt * delta #final speed
		
		#move the mssile in it's direction
		cm.global_position += cm.flightDirection * fs
		
		#update the total distance traveled and check if it is max
		cm.distTraveled += fs
		if cm.distTraveled >= castRange * rangeMult:
			missileList.remove_at(i)
			cm.queue_free()


func _onEnemyHitWithMissile(enemy, missile):
	var totalDamage = projectileDamage * projectileDamageMult
	#double check for potential future crashes
	if enemy.has_method("damageTaken"):
		enemy.damageTaken(totalDamage, missile)
	
	#minus one penetration, and remove if none left
	missile.penetrationValue -= 1
	if missile.penetrationValue <= 0:
		missileList.remove_at(missileList.find(missile))
		missile.queue_free()
	
