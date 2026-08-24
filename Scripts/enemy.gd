extends Area2D
class_name Enemy

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
var targetPosition: Vector2
var pushOffset: Vector2

@onready var collisionShape: CollisionShape2D = $CollisionShape2D
@onready var health_bar: ProgressBar = $HealthBar

func _ready() -> void:
	health_bar.visible = false

func _process(delta: float) -> void:
	#move
	var currPos = Vector2(global_position.x, global_position.y)
	var targetPos: Vector2 = targetPosition + (pushOffset * pushForce)
	global_position = currPos.move_toward(targetPos, enemySpeed * delta)
	
	#check if overlapping
	var overlappingAreas = get_overlapping_bodies()
	for area in overlappingAreas:
		if area is Player:
			HittingPlayer.emit(self, enemyDamage)

func updateTargetPosition(pos): #gets called every frame
	targetPosition = pos
	
func updateHealthBar():
	health_bar.max_value = enemyMaxHealth
	health_bar.value = enemyCurrentHealth

func updatePushOffset(offset: Vector2):
	pushOffset = offset
	
	
func damageTaken(dmg, src):
	health_bar.visible = true
	enemyCurrentHealth -= dmg
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
