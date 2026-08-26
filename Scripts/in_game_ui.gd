extends Control

@export var playerStats: PlayerStatsResource

@onready var in_game_ui: Control = $"."
@onready var health_label: Label = $HealthLabel
@onready var xp_label: Label = $XpLabel
@onready var player_level_label: Label = $PlayerLevelLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerStats.PlayerStatUpdated.connect(_updateHUD)
	_updateHUD()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _updateHUD() -> void:
	health_label.text = str("Health: ", playerStats.getStat("playerCurrentHP"), "/", (ceili(playerStats.getStat("playerMaxHP") * playerStats.getStat("playerMaxHpMultiplier"))))
	xp_label.text = str("XP: ", ceili(playerStats.getStat("playerCurrentXP")), "/", ceili(playerStats.getStat("playerXpToLevel")))
	player_level_label.text = str("Level: ", playerStats.getStat("playerCurrentLevel"))
