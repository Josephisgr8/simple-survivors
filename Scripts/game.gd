extends Node2D


var mapSize := 2016


@onready var player: Player = %Player
@onready var enemyManager: Node = %"Enemy Manager"
@onready var xpmanager: XP_Manager = $"XP Manager"
@onready var background: TileMapLayer = $Background

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.ReadyForTarget.connect(_onReadyForTarget)
	
	enemyManager.ReadyToUpdateEnemiesWithPlayerPos.connect(_onReadyToUpdateEnemiesWithPlayerPos)
	enemyManager.PlayerIsBeingHit.connect(_onPlayerIsBeingHit)
	enemyManager.EnemyDied.connect(_onEnemyDied)
	
	xpmanager.XP_Absorbed.connect(func(rawVal: int): player.gainXp(rawVal))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	xpmanager.updatePlayerInfo(player.global_position, player.xpPickupRange * player.xpPickupRangeMult)
	pass


func _onReadyForTarget(rng):
	#find loc of enemy nearest the player
	var closestEnemy = enemyManager.findEnemyNearestPlayer(player.global_position, rng)
	if closestEnemy == null:
		player.fireMissile(player.global_position.x, player.global_position.y)
	else:
		player.fireMissile(closestEnemy.x, closestEnemy.y)

func _onReadyToUpdateEnemiesWithPlayerPos():
	enemyManager.updateEnemyList(player.global_position, player.antiSpawnRadius)
	
func _onPlayerIsBeingHit(src, dmg):
	player.wasHit(src, dmg)
	
func _onEnemyDied(pos, xpval):
	xpmanager.spawnXP(pos, xpval)
