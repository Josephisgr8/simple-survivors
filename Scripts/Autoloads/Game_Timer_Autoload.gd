extends Node

#signals
signal EnemyDifficultyIncreaseTimeElapsed

var elapsedTime: float = 0

var enemyDifficultyIncreaseTimerSecs: float
var enemyDifficultyIncreaseTimer: float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsedTime += delta
	enemyDifficultyIncreaseTimer += delta
	_isEnemyDifficultyIncreaseTimerElapsed()

func onEnemyDifficultyIncreaseTimerSecs(secs: float):
	enemyDifficultyIncreaseTimerSecs = secs
	
func _isEnemyDifficultyIncreaseTimerElapsed() -> void:
	if enemyDifficultyIncreaseTimerSecs == null:	return
	if enemyDifficultyIncreaseTimer >= enemyDifficultyIncreaseTimerSecs:
		EnemyDifficultyIncreaseTimeElapsed.emit()
		enemyDifficultyIncreaseTimer -= enemyDifficultyIncreaseTimerSecs
	pass
