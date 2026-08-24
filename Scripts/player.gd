extends CharacterBody2D
class_name Player

#signals
signal ReadyForTarget(range)


#character stats import
@export var playerStats: PlayerStatsResource


#player flags
var isInvincible := false


@onready var invTimer: Timer = $invincibilityTimer
@onready var missile_manager: Node = $"Missile Manager"
@onready var player_state_manager: Node = $PlayerStateManager

func _ready() -> void:
	_updateMissileManager()
	missile_manager.MissileReadyToFire.connect(_onMissileReadyToFire)

	
#for processing non-physics logic
func _process(delta: float) -> void:
	_updateMissileManager()
	
	var movementDirection = Input.get_vector("Left", "Right", "Up", "Down")
	player_state_manager.move(movementDirection)
	

func wasHit(hitBy: Node, dmg: int) -> void:
	if (!isInvincible):
		playerStats.currHP -= dmg
		isInvincible = true
		invTimer.start(playerStats.invincibilityDurationSecs)


func _on_invincibility_timer_timeout() -> void:
	isInvincible = false
	
#missile methods
func _updateMissileManager() -> void:
	missile_manager.updateVariables(playerStats.projectileSpeedMult, playerStats.castSpeedMult, playerStats.damageMult, playerStats.rangeMult, playerStats.sizeMult)
	
func _onMissileReadyToFire(rng):
	#scan the area in range, select an enemy, and fire at them
	ReadyForTarget.emit(rng)
	
func _checkForAndLevelUp() -> void:
	if playerStats.currentXP >= playerStats.xpToLevel:
		print("Leveled up!")
		playerStats.currPlayerLevel += 1
		playerStats.currentXP = playerStats.currentXP - playerStats.xpToLevel
		playerStats.xpToLevel = playerStats.xpToLevel * playerStats.xpToLevelMult
		_checkForAndLevelUp() #This is so that multiple levels can be gained at once, if the xp is collected.
	
func gainXp(val: int):
	playerStats.currentXP += val * playerStats.xpMult
	_checkForAndLevelUp()
	
func fireMissile(pos: Vector2):
	missile_manager.createMissile(global_position, pos)


#GETTERS AND SETTERS AS NEEDED

func getXpPickupRange() -> float:
	return playerStats.xpPickupRange
	
func getXpPickupRangeMult() -> float:
	return playerStats.xpPickupRangeMult
	
func getAntiSpawnRadius() -> float:
	return playerStats.antiSpawnRadius

func getSpeed() -> float:
	return playerStats.speed
	
func getSpeedMult() -> float:
	return playerStats.speedMultiplier
