extends Node
const EnemyBlueprint: PackedScene = preload("res://Scenes/enemy.tscn")

#signals
signal ReadyToUpdateEnemiesWithPlayerPos()
signal PlayerIsBeingHit()

var enemyList: Array[Area2D]
var maxEnemies = 5
var enemyRespawnTimeSecs = 2
var enemySizeScale = 0.5
var spawnGroundsX = Vector2i(0, 2016)
var spawnGroundsY = Vector2i(0, 2016)
@onready var enemySpawnTimer: Timer = $EnemySpawnTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	ReadyToUpdateEnemiesWithPlayerPos.emit()
	_checkForAndSpawnEnemy()


#for telling each enemy the player's position
func updateEnemyList(pos) -> void:
	for i in range(0, enemyList.size()):
		enemyList.get(i).updatePlayerPos(pos)
		
func _checkForAndSpawnEnemy():
	if (enemyList.size() < maxEnemies) && (enemySpawnTimer.is_stopped()):
		#create new enemy and start timer
		var newEnemy = EnemyBlueprint.instantiate()
		newEnemy.position = Vector2i(randi_range(spawnGroundsX.x, spawnGroundsX.y), randi_range(spawnGroundsY.x, spawnGroundsY.y))
		newEnemy.scale = Vector2(enemySizeScale, enemySizeScale)
		enemyList.append(newEnemy)
		add_child(newEnemy)
		enemySpawnTimer.start(enemyRespawnTimeSecs)
		
		#set signal up for new enemy if it has this signal (extra if statement is for potential crashes in the future)
		if newEnemy.has_signal("_enemyHittingPLayer"):
			newEnemy.HittingPlayer.connect(_enemyHittingPLayer)
	
func findEnemyNearestPlayer(position, rng):
	#loop through enemies and find shortest distance that is also in given range
	var closestEnemy = null
	#for each enemy alive
	for i in range(0, enemyList.size()):
		var currEnemyDist = enemyList.get(i).global_position.distance_to(position)
		#if they are within range
		if  currEnemyDist <= rng:
			#set first enemy within range
			if closestEnemy == null:
				closestEnemy= enemyList.get(i)
			#else, check if they are closer, and if so assign them as closest
			elif currEnemyDist < closestEnemy.global_position.distance_to(position):
				closestEnemy = enemyList.get(i)
	if (closestEnemy != null):
		return closestEnemy.global_position
	else:
		return null

func _enemyHittingPLayer(enmy, dmg):
	PlayerIsBeingHit.emit(enmy, dmg)
	
