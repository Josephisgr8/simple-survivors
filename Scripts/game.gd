extends Node2D


var mapSize := 2016

const PLAYER_LEVEL_UP_MENU = preload("uid://dh61e7rw4y7p4")

@onready var player: Player = %Player
@onready var enemyManager: EnemyManager = %"Enemy Manager"
@onready var xpmanager: XP_Manager = $"XP Manager"
@onready var background: TileMapLayer = $Background

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.ReadyForTarget.connect(_onReadyForTarget)
	player.PlayerLeveledUp.connect(_onPlayerLeveledUp)
	player.PlayerDied.connect(_onPlayerDied)
	
	enemyManager.PlayerIsBeingHit.connect(_onPlayerIsBeingHit)
	enemyManager.EnemyDied.connect(_onEnemyDied)
	
	xpmanager.XP_Absorbed.connect(func(rawVal: int): player.gainXp(rawVal))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_updateManagers(player.global_position)
	pass


func _onReadyForTarget(rng):
	#find loc of enemy nearest the player
	var closestEnemy = enemyManager.findEnemyNearestTarget(rng)
	if closestEnemy == null:
		player.fireMissile(player.global_position)
	else:
		player.fireMissile(closestEnemy)

func _onPlayerLeveledUp():
	Engine.time_scale = 0
	var playerLevelMenu: PlayerLevelUpMenu = PLAYER_LEVEL_UP_MENU.instantiate()
	playerLevelMenu.LevelUpChoiceSelected.connect(_onLevelUpSelected)
	playerLevelMenu.playerStats = player.playerStats
	playerLevelMenu.addOptions()
	add_child(playerLevelMenu)
	playerLevelMenu.show()
	
func _onPlayerDied() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _onLevelUpSelected():
	Engine.time_scale = 1.0
	player.checkForAndLevelUp()
	
func _onPlayerIsBeingHit(src, dmg):
	player.wasHit(src, dmg)
	
func _onEnemyDied(pos, xpval):
	xpmanager.spawnXP(pos, xpval)

func _updateManagers(pos: Vector2):
	xpmanager.updateCollectorPosition(pos)
	enemyManager.updateTargetPosition(pos)
