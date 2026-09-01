extends CharacterBody2D
class_name Player

#signals
signal ReadyForTarget(range)
signal PlayerLeveledUp
signal PlayerDied


#character stats import
@export var playerStats: PlayerStatsResource


#player flags
var isInvincible := false


@onready var invTimer: Timer = $invincibilityTimer
var missile_manager: MissileManager
#@onready var missile_manager: Node = $"Missile Manager"
@onready var player_state_manager: Node = $PlayerStateManager

func _ready() -> void:
	missile_manager = MissileManager.new()
	_updateMissileManager()
	missile_manager.WeaponReadyToFire.connect(_onMissileReadyToFire)
	playerStats.setStat("playerCurrentHP", int(playerStats.getStat("playerMaxHP") * playerStats.getStat("playerMaxHpMultiplier")))
	add_child(missile_manager)
	
#for processing non-physics logic
func _process(delta: float) -> void:
	_updateMissileManager()
	
	var movementDirection = Input.get_vector("Left", "Right", "Up", "Down")
	player_state_manager.move(movementDirection)
	

func wasHit(hitBy: Node, dmg: int) -> void:
	if (!isInvincible):
		playerStats.setStat("playerCurrentHP", playerStats.getStat("playerCurrentHP") - dmg)
		if (playerStats.getStat("playerCurrentHP") <= 0):
			PlayerDied.emit()
			return
		isInvincible = true
		invTimer.start(playerStats.getStat("playerInvincibilityDurationSecs"))


func _on_invincibility_timer_timeout() -> void:
	isInvincible = false
	
#missile methods
func _updateMissileManager() -> void:
	missile_manager.updateVariables(playerStats.getStat("playerProjectileSpeedMultiplier"), playerStats.getStat("playerCastSpeedMultiplier"), playerStats.getStat("playerDamageMultiplier"), playerStats.getStat("playerRangeMultiplier"), playerStats.getStat("playerSizeMultiplier"))
	
func _onMissileReadyToFire(rng):
	#scan the area in range, select an enemy, and fire at them
	ReadyForTarget.emit(rng)
	
func checkForAndLevelUp() -> void:
	if playerStats.getStat("playerCurrentXP") >= playerStats.getStat("playerXpToLevel"):
		playerStats.setStat("playerCurrentLevel", playerStats.getStat("playerCurrentLevel") + 1)
		playerStats.setStat("playerCurrentXP", playerStats.getStat("playerCurrentXP") - playerStats.getStat("playerXpToLevel"))
		playerStats.setStat("playerXpToLevel", playerStats.getStat("playerXpToLevel") * playerStats.getStat("playerXpToLevelMultiplier"))
		PlayerLeveledUp.emit()
	
func gainXp(val: int):
	playerStats.setStat("playerCurrentXP", playerStats.getStat("playerCurrentXP") + playerStats.getStat("playerXpGainMultiplier") * val)
	checkForAndLevelUp()
	
func fireMissile(pos: Vector2):
	missile_manager.createWeapon(global_position, pos)
