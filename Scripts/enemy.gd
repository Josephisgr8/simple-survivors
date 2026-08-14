extends Area2D

#signals
signal HittingPlayer()
signal EnemyDied()

const pushForce := 1

#stats
var enemySpeed: float
var enemyDamage: int
var enemyMaxHealth: int
var enemyCurrentHealth: int
var xpValue: float

#vars
var playerPos: Vector2
var pushOffset: Vector2

@onready var collisionShape: CollisionShape2D = $CollisionShape2D

#func _init() -> void:


func _process(delta: float) -> void:
	#move
	var currPos = Vector2(global_position.x, global_position.y)
	var targetPos: Vector2 = playerPos + (pushOffset * pushForce)
	global_position = currPos.move_toward(targetPos, enemySpeed * delta)
	
	#check if overlapping
	var overlappingAreas = get_overlapping_areas()
	for area in overlappingAreas:
		if area.name == "Player":
			HittingPlayer.emit(self, enemyDamage)

func updatePlayerPos(pos): #gets called every frame
	playerPos = pos
	
func updatePushOffset(offset: Vector2):
	pushOffset = offset
	
	
func damageTaken(dmg, src):
	enemyCurrentHealth -= dmg
	print(enemyCurrentHealth, "/", enemyMaxHealth)
	if (enemyCurrentHealth <= 0):
		_enemyDie()
	
func setStats(spd, dmg, mxhlth, xpval):
	enemySpeed = spd
	enemyDamage = dmg
	enemyMaxHealth = mxhlth
	enemyCurrentHealth = enemyMaxHealth
	xpValue = xpval
	
func _enemyDie():
	EnemyDied.emit(self)
