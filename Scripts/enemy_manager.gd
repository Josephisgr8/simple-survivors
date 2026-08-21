extends Node
class_name EnemyManager

const EnemyBlueprint: PackedScene = preload("res://Scenes/enemy.tscn")

#signals
signal PlayerIsBeingHit()
signal EnemyDied()
signal EnemyDifficultyIncreaseTimerSecs(secs)

var enemyList: Array[Area2D]
var maxEnemies := 5
var enemyRespawnTimeSecs := 1.0
var nonSpawnPositions: Dictionary[Vector2, float]
var spawnPositionMaxDist: float = 1000
var maxNumberOfEnemySpawnAttempts = 5
var enemyPushoffForce := 3
var enemyDifficultyIncreaseTimerSecs := 10.0
var enemyDifficultyIncreaseScale := 0.05
var spawnGroundsX: Vector2i = Vector2i(0, 2016)
var spawnGroundsY: Vector2i = Vector2i(0, 2016)


#enemy stats
var enemySpeed := 100.0
var enemyDamage := 1
var enemyMaxHealth := 5
var xpValue := 1.0

#enemy stat multipliers
var enemySizeScale := 0.3
var enemySpeedMultiplier := 1.0
var enemyDamageMultiplier := 1.0
var enemyMaxHealthMult := 1.0
var xpValueMult := 1.0


@onready var enemySpawnTimer: Timer = $EnemySpawnTimer

@export var targetStats: PlayerStatsResource
var targetPosition: Vector2 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_instance_valid(GameTimerAutoload):
		EnemyDifficultyIncreaseTimerSecs.connect(GameTimerAutoload.onEnemyDifficultyIncreaseTimerSecs)
		GameTimerAutoload.EnemyDifficultyIncreaseTimeElapsed.connect(_onEnemyDifficultyIncreaseTimeElapsed)
	EnemyDifficultyIncreaseTimerSecs.emit(enemyDifficultyIncreaseTimerSecs)
	pass # Replace with function body.


func _process(delta: float) -> void:
	_checkForAndSpawnEnemy()
	updateEnemyList()


#for telling each enemy the player's position
func updateEnemyList() -> void:
	#update nonspawnlocation so enemied dont spawn near player
	nonSpawnPositions.clear()
	nonSpawnPositions[targetPosition] = targetStats.antiSpawnRadius * targetStats.antiSpawnRadius
	for enemy in enemyList:
		enemy.updateTargetPosition(targetPosition)
		#also get and set push vector
		var pushOffset: Vector2 = Vector2(0,0)
		var scaledRadius: float = enemy.collisionShape.shape.radius * enemySizeScale
		var minDistance: float = scaledRadius * enemyPushoffForce
		for enemy2 in enemyList:
			if enemy == enemy2:
				continue
			var dist: float = enemy.global_position.distance_to(enemy2.global_position)
			if dist <= minDistance and dist > 0.0: #prevent division by 0
				var pushDirection: Vector2 = (enemy.global_position - enemy2.global_position) / dist
				var overlapAmountPercent: float = 1.0 - (dist / minDistance) # how much enemies are in each others bubble
				pushOffset += pushDirection * (overlapAmountPercent * minDistance)
		enemy.updatePushOffset(pushOffset)
		
func _onEnemyDifficultyIncreaseTimeElapsed():
	
	enemySizeScale += (enemySizeScale * enemyDifficultyIncreaseScale)
	enemySpeedMultiplier += (enemySpeedMultiplier * enemyDifficultyIncreaseScale)
	enemyDamageMultiplier += (enemyDamageMultiplier * enemyDifficultyIncreaseScale)
	enemyMaxHealthMult += (enemyMaxHealthMult * enemyDifficultyIncreaseScale)
	xpValueMult += (xpValueMult * enemyDifficultyIncreaseScale)
	

func findEnemyNearestTarget(rng):
	#loop through enemies and find shortest distance that is also in given range
	var closestEnemy = null
	#for each enemy alive
	for i in range(0, enemyList.size()):
		var currEnemyDist = enemyList.get(i).global_position.distance_to(targetPosition)
		#if they are within range
		if  currEnemyDist <= rng:
			#set first enemy within range
			if closestEnemy == null:
				closestEnemy= enemyList.get(i)
			#else, check if they are closer, and if so assign them as closest
			elif currEnemyDist < closestEnemy.global_position.distance_to(targetPosition):
				closestEnemy = enemyList.get(i)
	if (closestEnemy != null):
		return closestEnemy.global_position
	else:
		return null

func _enemyHittingPLayer(enmy, dmg):
	PlayerIsBeingHit.emit(enmy, dmg)
	

func _onEnemyDied(enemy):	
	EnemyDied.emit(enemy.global_position, enemy.xpValue)
	enemyList.erase(enemy)
	enemy.queue_free()

func _isPositionSpawnable(pos: Vector2) -> bool:
	for position in nonSpawnPositions:
		if pos.distance_squared_to(position) < nonSpawnPositions[position]:
			return false
	return true

func _getValidSpawnPosition(attempts: int):
	for i in range(attempts):
			#pick a random spawnAnchor
			if nonSpawnPositions.is_empty(): return null
			var spawnAnchorPosition: Vector2 = nonSpawnPositions.keys()[randi_range(0, nonSpawnPositions.size()-1)]
			#pick random angle/dist from spawnAnchor and set as position
			var angleFromSpawnAnchor: float = randf() * 2 * PI
			var distSqurFromSpawnAnchor: float = randf_range(nonSpawnPositions[spawnAnchorPosition], spawnPositionMaxDist * spawnPositionMaxDist)
			var newEnemyPosition: Vector2 = spawnAnchorPosition + (Vector2.from_angle(angleFromSpawnAnchor) * sqrt(distSqurFromSpawnAnchor))
			#check if valid
			if _isPositionSpawnable(newEnemyPosition):
				return newEnemyPosition
	return null
	
func _checkForAndSpawnEnemy():
	if (enemyList.size() < maxEnemies) && (enemySpawnTimer.is_stopped()):
		#create new enemy and set stats
		var newEnemy: Enemy = EnemyBlueprint.instantiate()
		var newEnemyPosition: Variant = _getValidSpawnPosition(maxNumberOfEnemySpawnAttempts)
		if (newEnemyPosition == null):
			return
		
		newEnemy.global_position = newEnemyPosition
		newEnemy.global_scale = Vector2(enemySizeScale, enemySizeScale)
		newEnemy.setStats(enemySpeed * enemySpeedMultiplier, enemyDamage * enemyDamageMultiplier, enemyMaxHealth * enemyMaxHealthMult, xpValue * xpValueMult)
		
		#add enemy to list and start timer for next enemy
		enemyList.append(newEnemy)
		add_child(newEnemy)
		enemySpawnTimer.start(enemyRespawnTimeSecs)
		
		#set signal up for new enemy if it has this signal (extra if statement is for potential crashes in the future)
		if newEnemy.has_signal("HittingPlayer"):
			newEnemy.HittingPlayer.connect(_enemyHittingPLayer)
		if newEnemy.has_signal("EnemyDied"):
			newEnemy.EnemyDied.connect(_onEnemyDied)
			
func updateTargetPosition(pos: Vector2):
	targetPosition = pos
