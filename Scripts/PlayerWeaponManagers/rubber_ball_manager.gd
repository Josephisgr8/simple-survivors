extends PlayerWeaponManagerBase
class_name RubberBallManager

var rubberballBlueprint: PackedScene = preload("uid://cl7fon6wom1vf")

var numberOfBounces: int
var bounceRange: float
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	projectileSpeed = 500.0
	castSpeed = 4.0
	projectileDamage = 0.5
	castRange = 500.0
	numberOfBounces = 4
	bounceRange = 250.0

#functions to be overridden
func updateVariables(stats: PlayerStatsResource):
	projectileSpeedMult = stats.getStat("playerProjectileSpeedMultiplier")
	castSpeedMult = stats.getStat("playerCastSpeedMultiplier")
	projectileDamageMult = stats.getStat("playerDamageMultiplier")
	rangeMult = stats.getStat("playerRangeMultiplier")
	sizeMult = stats.getStat("playerSizeMultiplier")
	attackTimer.wait_time = castSpeed / castSpeedMult
	if get_parent() == null:
		return
	casterPosition = get_parent().global_position

func createWeapon(_fromPos: Vector2, _toPos: Vector2) -> void:
	var newRubberball: RubberBall = rubberballBlueprint.instantiate()
	
	newRubberball.global_position = casterPosition
	newRubberball.global_scale = newRubberball.global_scale * sizeMult
	if closestTarget.call(casterPosition, castRange * rangeMult) == null:
		newRubberball.queue_free()
		return
	else:
		newRubberball.targetLocation = newRubberball.global_position + newRubberball.global_position.direction_to(closestTarget.call(casterPosition, castRange * rangeMult)) * castRange * rangeMult
	newRubberball.bouncesRemaining = numberOfBounces
	newRubberball.maxDist = castRange * rangeMult
	weaponList.append(newRubberball)
	add_child(newRubberball)
	
	newRubberball.enemyHitWithWeapon.connect(_onEnemyHitWithWeapon)
	

func _onEnemyHitWithWeapon(enemy, weapon: RubberBall):
	var totalDamage = projectileDamage * projectileDamageMult
	if enemy.has_method("damageTaken"):
		enemy.damageTaken(totalDamage, weapon)
	if closestTarget.call(weapon.global_position, bounceRange * rangeMult, [weapon.enemiesHitList.get(weapon.enemiesHitList.size()-1)]) == null:
		weaponList.erase(weapon)
		weapon.queue_free()
		return

	weapon.targetLocation = weapon.global_position + weapon.global_position.direction_to(closestTarget.call(weapon.global_position, bounceRange * rangeMult, [weapon.enemiesHitList.get(weapon.enemiesHitList.size()-1)])) * bounceRange * rangeMult
	weapon.bouncesRemaining -= 1
	weapon.distTraveled = 0
	weapon.maxDist = bounceRange * rangeMult

func _updateWeaponLocation(prjSpd, prjSpdMlt, delta):
	for i in range(weaponList.size()-1 ,-1, -1):
		var cw: RubberBall = weaponList.get(i) # current weapon
		var fs = prjSpd * prjSpdMlt * delta #final speed
		
		cw.global_position = cw.global_position.move_toward(cw.targetLocation, fs)
		cw.distTraveled += fs

		if cw.bouncesRemaining < 0 or cw.distTraveled >= cw.maxDist:
			weaponList.remove_at(i)
			cw.queue_free()
