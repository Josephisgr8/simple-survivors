extends Node2D




@onready var player: CharacterBody2D = %Player
@onready var enemyManager: Node = %"Enemy Manager"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.ReadyForTarget.connect(_findEnemyClosestToPlayer)
	#Engine.time_scale = 0.25


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _findEnemyClosestToPlayer(range):
	#find loc of enemy nearest the player
	print("finding enemy nearest player")
	var closestEnemy = enemyManager.findEnemyNearestPlayer(player.global_position, range)
	if closestEnemy == null:
		print("couldnt find")
		player.fireMissile(player.global_position.x, player.global_position.y)
	else:
		player.fireMissile(closestEnemy.x, closestEnemy.y)
		print("found enemy")
