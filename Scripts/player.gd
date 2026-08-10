extends CharacterBody2D


var speed = 200.0
var speedMultiplier = 1
var invincibilityDurationSecs = 1
var maxHP = 10
var currHP = maxHP
var isInvincible = false

@onready var invTimer: Timer = $invincibilityTimer

#func _init() -> void:

func _physics_process(delta: float) -> void:
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var xdirection := Input.get_axis("Left", "Right")
	if xdirection:
		#velocity.x = direction * speed
		position.x += xdirection * speed * speedMultiplier * delta
	else:
		position.x -= xdirection * speed * speedMultiplier * delta
		
	var ydirection := Input.get_axis("Up", "Down")
	if ydirection:
		#velocity.x = direction * speed
		position.y += ydirection * speed * delta
	else:
		position.y -= ydirection * speed * delta

	move_and_slide()

func was_hit(hitBy: Node, dmg: int) -> void:
	if (!isInvincible):
		currHP -= dmg
		print("player was hit, " + str(currHP) + " HP remaining")
		isInvincible = true
		invTimer.start(invincibilityDurationSecs)
	


func _on_invincibility_timer_timeout() -> void:
	isInvincible = false
