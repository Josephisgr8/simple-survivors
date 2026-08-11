extends Node2D




@onready var player: CharacterBody2D = %Player
@onready var enemyManager: Node = %"Enemy Manager"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.ReadyForTarget.connect(_onReadyForTarget)
	enemyManager.ReadyToUpdateEnemiesWithPlayerPos.connect(_onReadyToUpdateEnemiesWithPlayerPos)
	enemyManager.PlayerIsBeingHit.connect(_onPlayerIsBeingHit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _onReadyForTarget(rng):
	#find loc of enemy nearest the player
	var closestEnemy = enemyManager.findEnemyNearestPlayer(player.global_position, rng)
	if closestEnemy == null:
		player.fireMissile(player.global_position.x, player.global_position.y)
	else:
		player.fireMissile(closestEnemy.x, closestEnemy.y)

func _onReadyToUpdateEnemiesWithPlayerPos():
	enemyManager.updateEnemyList(player.global_position)
	
func _onPlayerIsBeingHit(src, dmg):
	player.wasHit(src, dmg)
