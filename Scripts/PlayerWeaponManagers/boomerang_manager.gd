extends PlayerWeaponManagerBase
class_name BoomerangManager

var boomerangBlueprint: PackedScene = preload("uid://5my3assbdii2")

var numberOfBounces: int
var speedToRotationRatio: float

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	projectileSpeed = 300.0
	castSpeed = 4.0
	projectileDamage = 4
	castRange = 400.0
	numberOfBounces = 1
	speedToRotationRatio = 20.00
	
#required overrides
func updateVariables(stats: PlayerStatsResource) -> void:
	projectileSpeedMult = stats.getStat("playerProjectileSpeedMultiplier")
	castSpeedMult = stats.getStat("playerCastSpeedMultiplier")
	projectileDamageMult = stats.getStat("playerDamageMultiplier")
	rangeMult = stats.getStat("playerRangeMultiplier")
	sizeMult = stats.getStat("playerSizeMultiplier")
	attackTimer.wait_time = castSpeed / castSpeedMult
	if get_parent() == null:
		return
	casterPosition = get_parent().global_position

func createWeapon(fromPos: Vector2, toPos: Vector2) -> void:
	var newBoomerang: Boomerang = boomerangBlueprint.instantiate()
	
	newBoomerang.global_position = casterPosition
	newBoomerang.global_scale = newBoomerang.global_scale * sizeMult
	if closestTarget.call(castRange * rangeMult) == null:
		newBoomerang.flightDestination = Vector2.RIGHT * castRange * rangeMult
	else:
		newBoomerang.flightDestination = casterPosition + newBoomerang.global_position.direction_to(closestTarget.call(castRange * rangeMult)) * castRange * rangeMult
		print(newBoomerang.global_position.direction_to(closestTarget.call(castRange * rangeMult)))
	newBoomerang.bouncesRemaining = numberOfBounces
	newBoomerang.isReturning = false
	weaponList.append(newBoomerang)
	add_child(newBoomerang)
	
	newBoomerang.enemyHitWithWeapon.connect(_onEnemyHitWithWeapon)
	
	#set up signal for each new missile
	pass

func _onEnemyHitWithWeapon(enemy, weapon):
	var totalDamage = projectileDamage * projectileDamageMult
	if enemy.has_method("damageTaken"):
		enemy.damageTaken(totalDamage, weapon)
	
func _updateWeaponLocation(prjSpd, prjSpdMlt, delta):
	for i in range(weaponList.size()-1 ,-1,  -1):
		var cw: Boomerang = weaponList.get(i) # current weapon
		var fs: float = prjSpd * prjSpdMlt * delta #final speed
		
		#move the boomerang toward the target position, and rotate it
		_handleBoomerangMovement(cw, fs)
		#check for current destination and turn around, removing the boomerang if necessary
		_handleBoomerangBounce(cw, fs)

		if cw.bouncesRemaining <= 0:
			weaponList.remove_at(i)
			cw.queue_free()

func _handleBoomerangMovement(br: Boomerang, speed: float):
	if br.isReturning:
		br.global_position = br.global_position.move_toward(casterPosition, speed)
	else:
		br.global_position = br.global_position.move_toward(br.flightDestination, speed)
	br.global_rotation += speed / speedToRotationRatio
		
func _handleBoomerangBounce(br: Boomerang, stepDistance: float):
	if br.global_position == br.flightDestination:
		br.isReturning = true
		br.enemiesHitList.clear()
	if br.global_position.distance_squared_to(get_parent().global_position) <= stepDistance * stepDistance and br.isReturning:
		br.bouncesRemaining -= 1
		br.isReturning = false
		br.enemiesHitList.clear()
		if closestTarget.call(castRange * rangeMult) == null:
			br.flightDestination = closestTarget.call(castRange*rangeMult)
		else:
			br.flightDestination = Vector2.RIGHT * castRange * rangeMult
