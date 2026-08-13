extends CharacterBody2D

#signals
signal ReadyForTarget(range)


#character stats
var speed := 200.0
var speedMultiplier := 1.0
var maxHP := 10
var currHP := maxHP
var invincibilityDurationSecs := 1.0

#attack stat multipliers
var damageMult := 1.0
var rangeMult := 1.0
var castSpeedMult := 1.0
var sizeMult := 1.0
var projectileSpeedMult := 1.0


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

	
	
	#old movement
	
	#var xdirection := Input.get_axis("Left", "Right")
	#
	#if xdirection:
		#
		##velocity.x = direction * speed
		#position.x += xdirection * speed * speedMultiplier * delta
		#print(global_position)
	#else:
		#position.x -= xdirection * speed * speedMultiplier * delta
		#
	#
	#var ydirection := Input.get_axis("Up", "Down")
	#if ydirection:
		##velocity.x = direction * speed
		#position.y += ydirection * speed * delta
	#else:
		#position.y -= ydirection * speed * delta

func was_hit(hitBy: Node, dmg: int) -> void:
	if (!isInvincible):
		currHP -= dmg
		print("player was hit, ", currHP, " HP remaining")
		isInvincible = true
		invTimer.start(invincibilityDurationSecs)
	


func _on_invincibility_timer_timeout() -> void:
	isInvincible = false
	
#missile methods
func _updateMissileManager() -> void:
	missile_manager.updateVariables(projectileSpeedMult, castSpeedMult, damageMult, rangeMult, sizeMult)
	
func _onMissileReadyToFire(rng):
	#scan the area in range, select an enemy, and fire at them
	ReadyForTarget.emit(rng)
	
	
func fireMissile(xLoc, yLoc):
	missile_manager.createMissile(global_position.x, global_position.y, xLoc, yLoc)
	
