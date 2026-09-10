extends PlayerWeaponManagerBase
class_name MissileManager

#members to handle missiles
var missileBlueprint: PackedScene = preload("uid://bh3a2sclamoua")


func _init() -> void:
	#missile base stats
	projectileSpeed = 250.0
	castSpeed = 1.5
	projectileDamage = 2
	castRange = 450.0
	penetrationValue = 1


#required overrides
func updateVariables(stats: PlayerStatsResource) -> void:
	projectileSpeedMult = stats.getStat("playerProjectileSpeedMultiplier")
	castSpeedMult = stats.getStat("playerCastSpeedMultiplier")
	projectileDamageMult = stats.getStat("playerDamageMultiplier")
	rangeMult = stats.getStat("playerRangeMultiplier")
	sizeMult = stats.getStat("playerSizeMultiplier")
	penetrationValueMult = stats.getStat("playerProjectilePenetrationMultiplier")
	attackTimer.wait_time = castSpeed / castSpeedMult
	if get_parent() == null:
		return
	casterPosition = get_parent().global_position

func createWeapon(fromPos: Vector2, toPos: Vector2) -> void:
	var newMissile = missileBlueprint.instantiate()
	
	#set var values and add missile to list
	newMissile.global_position = casterPosition
	if closestTarget.call(casterPosition, castRange * rangeMult) == null:
		newMissile.look_at(Vector2.RIGHT)
	else:
		newMissile.look_at(closestTarget.call(casterPosition, castRange * rangeMult))
	newMissile.global_scale = newMissile.global_scale * sizeMult
	newMissile.penetrationValue = penetrationValue * penetrationValueMult
	weaponList.append(newMissile)
	
	add_child(newMissile)
	
	#set up signal for each new missile
	newMissile.enemyHitWithWeapon.connect(_onEnemyHitWithWeapon)


func _onEnemyHitWithWeapon(enemy, missile):
	var totalDamage = projectileDamage * projectileDamageMult
	#double check for potential future crashes
	if enemy.has_method("damageTaken"):
		enemy.damageTaken(totalDamage, missile)
	
	#minus one penetration, and remove if none left
	missile.penetrationValue -= 1
	if missile.penetrationValue <= 0:
		weaponList.remove_at(weaponList.find(missile))
		missile.queue_free()

func _updateWeaponLocation(prjSpd, prjSpdMlt, delta):
	for i in range(weaponList.size()-1 ,-1,  -1):
		var cw = weaponList.get(i) # current weapon
		var fs = prjSpd * prjSpdMlt * delta #final speed
		
		#move the mssile in it's direction
		cw.global_position += cw.flightDirection * fs

		#update the total distance traveled and check if it is max
		cw.distTraveled += fs
		if cw.distTraveled >= castRange * rangeMult:
			weaponList.remove_at(i)
			cw.queue_free()
