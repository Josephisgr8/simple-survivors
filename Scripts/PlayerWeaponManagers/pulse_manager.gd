extends PlayerWeaponManagerBase
class_name PulseManager

var pulseBlueprint: PackedScene = preload("res://Scenes/PlayerWeapons/pulse.tscn")

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	projectileSpeed = 1
	castSpeed = 3
	projectileDamage = 2
	castRange = 1.5
	
	pass # Replace with function body.

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
	var newPulse: Pulse = pulseBlueprint.instantiate()
	
	newPulse.global_position = casterPosition
	newPulse.global_scale = Vector2(0,0)
	newPulse.maxRange = castRange * rangeMult * sizeMult
	newPulse.distTraveled = 0
	weaponList.append(newPulse)
	add_child(newPulse)
	
	newPulse.enemyHitWithWeapon.connect(_onEnemyHitWithWeapon)

func _onEnemyHitWithWeapon(enemy, weapon: Pulse):
	var totalDamage = projectileDamage * projectileDamageMult
	if enemy.has_method("damageTaken"):
		enemy.damageTaken(totalDamage, weapon)

func _updateWeaponLocation(prjSpd, prjSpdMlt, delta):
	for i in range(weaponList.size()-1 ,-1, -1):
		var cw: Pulse = weaponList.get(i) # current weapon
		var fs = prjSpd * prjSpdMlt * delta #final speed
		
		cw.global_scale = cw.global_scale + Vector2(fs,fs)
		cw.distTraveled += fs
		cw.setOpacity((cw.maxRange - cw.distTraveled) / cw.maxRange)
		#print(cw.global_scale, " , ", cw.distTraveled)
		if cw.distTraveled >= cw.maxRange:
			weaponList.remove_at(i)
			cw.queue_free()
