extends Control

@export var playerStats: PlayerStatsResource

@onready var in_game_ui: Control = $"."
@onready var health_label: Label = $HealthLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerStats.CurrentHPUpdated.connect(_updateHUD)
	_updateHUD()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _updateHUD() -> void:
	health_label.text = str("Health: ", playerStats.currHP, "/", playerStats.maxHP) 
