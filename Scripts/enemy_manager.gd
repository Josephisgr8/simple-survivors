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
	updateEnemyList()
	#if we are not at max enemies and none are currently spawning
	if (enemyList.size() < maxEnemies) && (enemySpawnTimer.is_stopped()):
		var newEnemy = EnemyBlueprint.instantiate()
		#newEnemy.position = Vector2i(2016,2016)
		newEnemy.position = Vector2i(randi_range(spawnGroundsX.x, spawnGroundsX.y), randi_range(spawnGroundsY.x, spawnGroundsY.y))
		newEnemy.scale = Vector2(enemySizeScale, enemySizeScale)
		enemyList.append(newEnemy)
		add_child(newEnemy)
		enemySpawnTimer.start(enemyRespawnTimeSecs)

	updateEnemyList()
	
#for telling each enemy the player's position
func updateEnemyList() -> void:
	for i in range(0, enemyList.size()):
		enemyList.get(i).updatePlayer(player)
	
