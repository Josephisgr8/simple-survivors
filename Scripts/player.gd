extends CharacterBody2D
class_name Player

#signals
signal PlayerLeveledUp
signal PlayerDied


#character stats import
@export var playerStats: PlayerStatsResource


#player flags
var isInvincible := false


@onready var invTimer: Timer = $invincibilityTimer
var weapon_managers: Array[PlayerWeaponManagerBase] = []
@onready var player_state_manager: Node = $PlayerStateManager


func _ready() -> void:
	#weapon_managers.append(MissileManager.new())
	#weapon_managers.append(BoomerangManager.new())
	#weapon_managers.append(RubberBallManager.new())
	weapon_managers.append(PulseManager.new())
	_updateMissileManager()
	playerStats.setStat("playerCurrentHP", int(playerStats.getStat("playerMaxHP") * playerStats.getStat("playerMaxHpMultiplier")))
	for mg: PlayerWeaponManagerBase in weapon_managers:
		add_child(mg)
	
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
	
	
func connectWeaponManagersToClosestTargetSource(findNearestTarget: Callable):
	for mg: PlayerWeaponManagerBase in weapon_managers:
		mg.closestTarget = findNearestTarget

#missile methods
func _updateMissileManager() -> void:
	for mg: PlayerWeaponManagerBase in weapon_managers:
		mg.updateVariables(playerStats)
	
	
func checkForAndLevelUp() -> void:
	if playerStats.getStat("playerCurrentXP") >= playerStats.getStat("playerXpToLevel"):
		playerStats.setStat("playerCurrentLevel", playerStats.getStat("playerCurrentLevel") + 1)
		playerStats.setStat("playerCurrentXP", playerStats.getStat("playerCurrentXP") - playerStats.getStat("playerXpToLevel"))
		playerStats.setStat("playerXpToLevel", playerStats.getStat("playerXpToLevel") * playerStats.getStat("playerXpToLevelMultiplier"))
		PlayerLeveledUp.emit()
	
func gainXp(val: float):
	playerStats.setStat("playerCurrentXP", playerStats.getStat("playerCurrentXP") + playerStats.getStat("playerXpGainMultiplier") * val)
	checkForAndLevelUp()
	
