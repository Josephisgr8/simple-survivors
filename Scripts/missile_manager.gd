extends Node

#signals for parent
signal MissileReadyToFire(range)

#members to handle missiles
var missileList: Array[Area2D]
const MissileBlueprint: PackedScene = preload("res://Scenes/missile.tscn")

#missile base stats
var projectileSpeed = 200
var castSpeed = 1
var damage = 1
var castRange = 500

#missile multipliers
var projectileSpeedMult
var castSpeedMult
var damageMult
var rangeMult
var sizeMult


@onready var attackTimer: Timer = $MissileAttackTimer

#update Variables
func updateVariables(projSpdMult, cstSpdMult, dmgMult, rngMult, szMult) -> void:
	projectileSpeedMult = projSpdMult
	castSpeedMult = cstSpdMult
	damageMult = dmgMult
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
	
	#set rotation based off player's position and target's position
	newMissile.global_position = Vector2(xFromLoc, yFromLoc)
	newMissile.look_at(Vector2(xToLoc,yToLoc))
	newMissile.global_scale = newMissile.global_scale * sizeMult
	missileList.append(newMissile)
	add_child(newMissile)


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
