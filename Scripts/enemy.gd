extends Area2D

#signals
signal HittingPlayer()
signal EnemyDied()

#stats
var enemySpeed: float
var enemyDamage: int
var enemyMaxHealth: int
var enemyCurrentHealth: int

#vars
var playerPos: Vector2

#func _init() -> void:


func _process(delta: float) -> void:
	#move
	var currPos = Vector2(global_position.x, global_position.y)
	global_position = currPos.move_toward(playerPos, enemySpeed * delta)
	
	#check if overlapping
	var overlappingAreas = get_overlapping_areas()
	for area in overlappingAreas:
		if area.name == "Player":
			HittingPlayer.emit(self, enemyDamage)

func updatePlayerPos(pos):
	playerPos = pos
	
func damageTaken(dmg, src):
	enemyCurrentHealth -= dmg
	print(enemyCurrentHealth, "/", enemyMaxHealth)
	if (enemyCurrentHealth <= 0):
		EnemyDied.emit(self)
	
func setStats(spd, dmg, mxhlth):
	enemySpeed = spd
	enemyDamage = dmg
	enemyMaxHealth = mxhlth
	enemyCurrentHealth = enemyMaxHealth
