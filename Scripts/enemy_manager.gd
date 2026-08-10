extends Node
const EnemyBlueprint: PackedScene = preload("res://Scenes/enemy.tscn")


var enemyList: Array[Area2D]
var maxEnemies = 5
var enemyRespawnTimeSecs = 2
var enemySizeScale = 0.5
var spawnGroundsX = Vector2i(0, 2016)
var spawnGroundsY = Vector2i(0, 2016)
@onready var enemySpawnTimer: Timer = $EnemySpawnTimer
@onready var player: CharacterBody2D = %Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_updateEnemyList()
	#if we are not at max enemies and none are currently spawning
	if (enemyList.size() < maxEnemies) && (enemySpawnTimer.is_stopped()):
		var newEnemy = EnemyBlueprint.instantiate()
		#newEnemy.position = Vector2i(2016,2016)
		newEnemy.position = Vector2i(randi_range(spawnGroundsX.x, spawnGroundsX.y), randi_range(spawnGroundsY.x, spawnGroundsY.y))
		newEnemy.scale = Vector2(enemySizeScale, enemySizeScale)
		enemyList.append(newEnemy)
		add_child(newEnemy)
		enemySpawnTimer.start(enemyRespawnTimeSecs)
	
#for telling each enemy the player's position
func _updateEnemyList() -> void:
	for i in range(0, enemyList.size()):
		enemyList.get(i).updatePlayer(player)
	
func findEnemyNearestPlayer(position, range):
	#loop through enemies and find shortest distance that is also in given range
	var closestEnemy
	#for each enemy alive
	for i in range(0, enemyList.size()):
		var currEnemyDist = enemyList.get(i).global_position.distance_to(position)
		#if they are within range
		if  currEnemyDist <= range:
			#set first enemy within range
			if closestEnemy == null:
				closestEnemy= enemyList.get(i)
				print("assigned initial closest enemy")
				print(i)
			#else, check if they are closer, and if so assign them as closest
			elif currEnemyDist < closestEnemy.global_position.distance_to(position):
				closestEnemy = enemyList.get(i)
	if (closestEnemy != null):
		return closestEnemy.global_position
	else:
		return null
