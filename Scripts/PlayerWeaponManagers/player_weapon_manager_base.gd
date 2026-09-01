extends Node
class_name PlayerWeaponManagerBase

#signals for parent
signal WeaponReadyToFire(range)

#members to handle weapons
var weaponList: Array[Area2D]
var attackTimer: Timer = Timer.new()

#base stats
var projectileSpeed : float
var castSpeed : float
var projectileDamage : float
var castRange : float
var penetrationValue : int

#weapon multipliers
var projectileSpeedMult : float
var castSpeedMult : float
var projectileDamageMult : float
var rangeMult : float
var sizeMult : float
var penetrationValueMult : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attackTimer = _initAttackTimer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_updateWeaponLocation(projectileSpeed, projectileSpeedMult, delta)

func _initAttackTimer() -> Timer:
	var timer: Timer = Timer.new()
	timer.autostart = true
	timer.one_shot = false
	timer.timeout.connect(_on_weapon_attack_timer_timeout)
	add_child(timer)
	return timer
	
func _on_weapon_attack_timer_timeout() -> void:
	WeaponReadyToFire.emit(castRange * rangeMult)

#update Variables
func updateVariables(projSpdMult, cstSpdMult, dmgMult, rngMult, szMult) -> void:
	projectileSpeedMult = projSpdMult
	castSpeedMult = cstSpdMult
	projectileDamageMult = dmgMult
	rangeMult = rngMult
	sizeMult = szMult
	if (castSpeed/castSpeedMult) <= 0:
		print("stiop")
	attackTimer.wait_time = castSpeed / castSpeedMult

#functions to be overridden
func _onEnemyHitWithWeapon(_enemy, _weapon):
	assert(false, "Error: %s must override the _onEnemyHitWithWeapon function!" % get_script().resource_path.get_file())
func createWeapon(_fromPos: Vector2, _toPos: Vector2) -> void:
	assert(false, "Error: %s must override the createWeapon function!" % get_script().resource_path.get_file())
func _updateWeaponLocation(_prjSpd, _prjSpdMlt, _delta):
	assert(false, "Error: %s must override the _updateWeaponLocation function!" % get_script().resource_path.get_file())
